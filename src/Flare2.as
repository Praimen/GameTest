// Class Main.as
package  
{
	import flare.basic.*;
	import flare.collisions.*;
	import flare.core.*;
	import flare.system.*;
	import flare.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*; 

	
	public class Flare2 extends Sprite
	{
		private var scene:Scene3D;
		private var biped:Pivot3D;
		private var active:Boolean = true;
		private var level:Pivot3D;
		private var collisions:SphereCollision;
		private var translationSpeed:Number = 10;
		private var rotationSpeed:Number = 3;
		private var runSpeed:Number = 1.5;
		private var keyArray:Array;		
		private var moving:Boolean = false;
		private var mouse:MouseCollision;
		
		private var levelTest:Boolean = true;

		public function Flare2() 
		{
			keyArray = [];
			keyArray["up"] = 0;
			keyArray["down"] = 0;
			keyArray["left"] = 0;
			keyArray["right"] = 0;
			
			stage.quality = "medium"
			
			// creates the scene.
			scene = new Viewer3D( this );
			
			// define progress and complete events.
			scene.addEventListener( Scene3D.PROGRESS_EVENT, progressEvent );			
			scene.addEventListener( Scene3D.COMPLETE_EVENT, completeEvent );			
			
			// loads the animated character.
			if (levelTest){
				level = scene.addChildFromFile( "tavern.f3d" );
				
			}
			scene.addChildFromFile( "draken_run_labels.f3d" );
			stage.addEventListener(KeyboardEvent.KEY_UP, playIdle);
			
			
		}
		
		private function progressEvent(e:Event):void 
		{
			// ...
		}
		
		private function completeEvent(e:Event):void 
		{
			
			//level.scaleX = level.scaleY = level.scaleZ = 0.50;
			level.getChildByName("tavern").rotateZ(90);
			biped = scene.getChildByName( "draken_run_labels.f3d" );
			//biped.scaleX = biped.scaleY = biped.scaleZ = 0.25;
			biped.y = 0;
			biped.x = 300;
			// Resets 3d object scales and rotations. This method must not be used with objects that include animations.
			 
			// Trace imported info for the scene	
			//Pivot3DUtils.traceInfo( scene ); 
			
			// add some labels. ( the labels also can be defined in 3DMax ).
			biped.addLabel( "run", 1, 40 );
			biped.addLabel( "idle", 45, 60 );
			if (levelTest){
				Pivot3DUtils.resetXForm( level )
				collisions = new SphereCollision( biped, 50, new Vector3D( 0, 50, 0 ) ); 
				collisions.addCollisionWith( level );
				
				mouse = new MouseCollision( scene.camera, scene.canvas );           
				mouse.addCollisionWith( level );
				mouse.addCollisionWith( biped );
				            
				 // force Debug3D to draw over all objects.
				Debug3D.priority = Number.MAX_VALUE;
				             
				// draw Debug3D axis.
				Debug3D.drawAxis( scene, 5, true );
				             
				// we only need to test in render event, but we can test also in update event.
				scene.addEventListener( Scene3D.RENDER_EVENT, renderEvent );
			}
			
			// for smooth animation when the frameSpeed property is less than 1.
			biped.animationPrecision = true;
			biped.gotoAndStop(45);
			// begin update the scene.
			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
		}
		
		
		private function renderEvent(e:Event):void 
		{
			// remove Debug3D data.
			Debug3D.removeBoundingBox( scene, true )
			Debug3D.removePoly( scene, true )
			
			// get mouse collision.
			if ( mouse.test( Input3D.mouseX, Input3D.mouseY ) )
			{	
				// get collision data.
				var info:CollisionInfo = mouse.data[ 0 ]
				
				// draw Debug3D data.
				Debug3D.priority = 1
				Debug3D.drawBoundingBox( info.mesh )
				Debug3D.drawPoly( info.mesh, info.poly )
			}
		}

		
		private function playIdle(kEvt:KeyboardEvent):void{
			trace("key code: "+ kEvt.keyCode);
			
			
			switch(kEvt.keyCode){			
				case 87: 
					keyArray["up"] = 0;
					trace("87:" + keyArray["up"]);
					break;
				case 83: 
					keyArray["down"] = 0;				
					trace("83:" + keyArray["down"]);
					break;
				case 68: 
					keyArray["right"] = 0;
					trace("68:" + keyArray["right"]);
					break;
				case 65: 
					keyArray["left"] = 0; 
					trace("65:" + keyArray["left"]);
					break;			
			}
			
			
			trace("list of key array:"+"\n UP: "+keyArray["up"]+"\n DOWN: "+keyArray["down"]+"\n RIGHT: "+keyArray["right"]+"\n LEFT: "+keyArray["left"]);
			
			if(keyArray["up"] == 0 && keyArray["down"] == 0 && keyArray["right"] == 0 && keyArray["left"] == 0){
				trace("all movment is false");
				runIdle();	
			}
			
		}
		
		
		
		
		private function runIdle():void{
			trace("run idle");
			biped.frameSpeed = .1;
			biped.playLabel( "idle" );			
		}
		
		private function updateEvent(e:Event):void{
			
			
			if(Input3D.keyHit( Input3D.W ) || 
				Input3D.keyHit( Input3D.S ) || 
				Input3D.keyHit( Input3D.D ) ||
				Input3D.keyHit( Input3D.A ) ){
				
				biped.playLabel( "run" ) ;			
			}
			
			
			if (Input3D.keyDown( Input3D.W )){
				
				keyArray["up"]=1;
				biped.frameSpeed = runSpeed;
				biped.translateZ( -12 ) ;					
			} 
			
			
			if (Input3D.keyDown( Input3D.S )){
				keyArray["down"]=1;
				biped.frameSpeed = runSpeed;
				biped.translateZ( 12 ) ;					
			}			
			
		        
			if (Input3D.keyDown( Input3D.D )){
				keyArray["right"]=1;
				 biped.frameSpeed = runSpeed;
				 biped.rotateY( 4 ) ;				
			}	
			
			
			if (Input3D.keyDown( Input3D.A )){
				keyArray["left"]=1;
				biped.frameSpeed = runSpeed;
				biped.rotateY( -4 ) ;				
			}					
			
		
		
			// once we moved the player, we test for collisions
			if(levelTest){
				collisions.slider();
			}
			
			
			// set the camera position relative to the player.	
			Pivot3DUtils.setPositionWithReference( scene.camera, 0, 100, 600, biped, 0.1 );	
				
			// orientate the camera to player position.
			Pivot3DUtils.lookAtWithReference( scene.camera, 0, 100, 0, biped );
			
		
		}
		
		
	}//End Package
}//End Class
