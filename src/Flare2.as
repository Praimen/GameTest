package  {
	import flare.basic.*;
	import flare.collisions.*;
	import flare.core.*;
	import flare.primitives.*;
	import flare.system.*;
	import flare.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	import org.casalib.util.StageReference;
    

	[SWF(backgroundColor="#FFFFFF", frameRate="60", width="600", height="600")]
	public class Flare2 extends Sprite{
		private var scene:Scene3D;
		private var view3D:Viewer3D;
		private var worldTexture:WorldTexture;
		private var biped:Pivot3D;
		private var player1:Player;
		private var draken:Pivot3D;
		private var character:Pivot3D;
		private var active:Boolean = true;
		private var level:Pivot3D;
		
		private var rCollisions:SphereCollision;
			
		private var moving:Boolean = false;
		private var mouse:MouseCollision;
		
		private var plane:ShadowPlane;
		private var light:Light3D;
		
		private var debug:Boolean = true;
		private var levelTest:Boolean = true;

		public function Flare2(){			
			
			stage.quality = "medium"
			StageReference.setStage(this.stage);
	
			view3D = new Viewer3D( this );
			
			// creates the scene.
			scene = view3D
			// define progress and complete events.
			scene.addEventListener( Scene3D.PROGRESS_EVENT, progressEvent );			
			scene.addEventListener( Scene3D.COMPLETE_EVENT, completeEvent );
			
			worldTexture = new WorldTexture(view3D);
			Device3D.smoothMaterials = true;		
			
			biped = scene.addChildFromFile( "draken_run_labels.f3d" );			
			level = scene.addChildFromFile( "tavern.f3d" );
			
			light = new Light3D( "", Light3D.DIRECTIONAL_LIGHT );
			Device3D.defaultLight = light;
			
			
			plane = new ShadowPlane( "shadowmap", scene, light, 4300, 4300, 512, 512 );
			plane.setPriority( -200 );
			plane.alpha = 0.2;
			scene.addChild( plane );	
			
			scene.camera.fieldOfView = 100;
			// loads the animated character.				
		}
		
		private function progressEvent(e:Event):void {
			// ...
		}
		
		private function completeEvent(e:Event):void 
		{
			worldTexture.initSkyBox();
			scene.addChild( worldTexture.texture );			
			biped.getChildByName("draken");
			player1 = new Player(biped);
			player1.initAnim(45);
			player1.addCollisions(level);
			draken = player1.player;
			
			//adding camera collisions
			rCollisions = new SphereCollision(scene.camera,50); 
			rCollisions.addCollisionWith( level );
			
			if (levelTest){
				Pivot3DUtils.traceInfo( scene ); 
				Pivot3DUtils.resetXForm( level );				
				
				light.x = 500;//Math.sin( getTimer() / 1000 ) * 200;
				light.z = 550;//Math.cos( getTimer() / 1500 ) * 200;
				light.y = 1050;								            
			
			}
			
			if (debug){
				// force Debug3D to draw over all objects.
				//Debug3D.priority = Number.MAX_VALUE;
				/*mouse = new MouseCollision( scene.camera, scene.canvas );           
				mouse.addCollisionWith( level );
				mouse.addCollisionWith( biped );*/
				// draw Debug3D axis.
				Debug3D.drawAxis( scene, 0, false );
				
				// we only need to test in render event, but we can test also in update event.
				//scene.addEventListener( Scene3D.RENDER_EVENT, renderEvent );
			}			
		
			// begin update the scene.			
			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
		}		
		
		
		private function renderEvent(e:Event):void 	{
			// remove Debug3D data.
			Debug3D.removeBoundingBox( scene, true );
			Debug3D.removePoly( scene, true );
								
			// get mouse collision.
		/*	if ( mouse.test( Input3D.mouseX, Input3D.mouseY ) )
			{	
				// get collision data.
				var info:CollisionInfo = mouse.data[ 0 ];
				
				// draw Debug3D data.
				Debug3D.priority = 1;
				Debug3D.drawBoundingBox( info.mesh );
				Debug3D.drawPoly( info.mesh, info.poly );
			}*/
		}

		
		private function updateEvent(e:Event):void{
			
			player1.addPlayerMovement();		
		
			// once we moved the player, we test for collisions
			if(levelTest){
				player1.collision.slider();
				rCollisions.slider();
			}
			
			// set the camera position relative to the player.	
			Pivot3DUtils.setPositionWithReference( scene.camera, 0, 300, 1000, draken, 0.1 );				
			
			
			// orientate the camera to player position.
			Pivot3DUtils.lookAtWithReference( scene.camera, 0, 200, 0, draken );
		
		}
		
		
	}//End Package
}//End Class
