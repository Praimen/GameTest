package
{
	
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.*;
	import com.smartfoxserver.v2.entities.data.*;
	import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
	import com.smartfoxserver.v2.exceptions.SFSError;
	import com.smartfoxserver.v2.requests.*;
	
	import flare.basic.*;
	import flare.collisions.*;
	import flare.core.*;
	import flare.primitives.*;
	import flare.system.*;
	import flare.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.TextField;
	import flash.utils.*;
	
	import org.casalib.util.StageReference;
	
	public class Client extends Sprite
	{
		private var scene:Scene3D;
		private var view3D:Viewer3D;
		private var worldTexture:WorldTexture;
		
		private var biped:Pivot3D;
		
		private var userPlayer:Player;
		private var ret:String = "\n"
		private var clientPlayer:Pivot3D;
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
		private var _server:Server ;
		private var _user:User;
		
		public var statusTxt:TextField;
		
		
		public function Client(singleServe:Server){
			_server = singleServe; 
			
			
			
			view3D = new Viewer3D( this );	
			
			// creates the scene.
			scene = view3D;
			
				
			// define progress and complete events.
			scene.addEventListener( Scene3D.PROGRESS_EVENT, progressEvent );			
			scene.addEventListener( Scene3D.COMPLETE_EVENT, completeEvent );
			
			
						
			Device3D.smoothMaterials = true;		
			
			biped = scene.addChildFromFile( "draken_run_labels.f3d" );			
			level = scene.addChildFromFile( "tavern.f3d" );			
			worldTexture = new WorldTexture(view3D);
			addCamera();
			//addLight();
			//addShadow();
			addStatusText();			
		}
		
		private function addLight():void{
			light = new Light3D( "", Light3D.POINT_LIGHT );
			light.x = 10500;//Math.sin( getTimer() / 1000 ) * 200;
			light.z = 8050;
			light.y = 4050;	
			Device3D.defaultLight = light;
		}
		
		private function addCamera():void{
			scene.camera.fieldOfView = 100;
			scene.camera.far = .5;
		}
		
		private function addShadow():void{
			plane = new ShadowPlane( "shadowmap", scene, light, 4300, 4300, 256, 256 );
			plane.blur = 3;
			plane.setPriority( -1000.0 );
			plane.alpha = 0.1;			
			scene.addChild(plane);
		}
		
		public function addStatusText():void{
			statusTxt = new TextField();			
			statusTxt.width = 300;
			statusTxt.height = 150;
			statusTxt.x = 0;
			statusTxt.y = StageReference.getStage().stageHeight - statusTxt.height;
			statusTxt.multiline = true;	
			statusTxt.wordWrap = true;
			statusTxt.background = true;
			statusTxt.scrollV = 0; 
			statusTxt.backgroundColor = 0xFFFFFF;
			
		}
		
		public function addPlayers():void{			
			//biped.getChildByName("draken");
			for each(var serverUser:User in _server.serverPlayers){
				
				userPlayer = new Player(biped.clone(),server,serverUser);
				userPlayer.player.name = serverUser.name;
				userPlayer.initAnim();
				userPlayer.addCollisions(level);			
				clientPlayer = userPlayer.player;
				scene.addChild(clientPlayer);
			}
		}
		
		private function progressEvent(e:Event):void {
			// ...
		}
		
		private function completeEvent(e:Event):void 
		{
			trace("World SkyBox")
			//build Skybox
			
			worldTexture.initSkyBox();
			scene.addChild( worldTexture.texture );	
			
			clearExtraMesh();
			
			//output scene information 			
			//Pivot3DUtils.traceInfo( scene ); 
			//reset scene for proper scaling and collision detection		
			Pivot3DUtils.resetXForm( level );			
			
			//buggy allows for correct placement of character on Z-plane
			Debug3D.drawAxis( scene, 0, false );				
			
			addChild(statusTxt);
			// begin update the scene.	
			
			_server.connectToServer();
		}
		
		
		
		public function addEvent():void{		
			_server.smartFox.addEventListener(SFSEvent.USER_VARIABLES_UPDATE, onUserVarsUpdate)
			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
		}
		
		public function loadPlayerCamera():void{
			Pivot3DUtils.setPositionWithReference( scene.camera, 0, 300, 1000, clientPlayer, 0.1 );				
			// orientate the camera to player position.
			Pivot3DUtils.lookAtWithReference( scene.camera, 0, 200, 0, clientPlayer );
			//adding camera collisions
			//rCollisions = new SphereCollision(scene.camera,50); 
			//rCollisions.addCollisionWith( level );
		}
		
		private function onUserVarsUpdate(evt:SFSEvent):void{
			//var changedVars:Array = evt.params.changedVars as Array;
			var user:User = evt.params.user as User;
			var userName:String = user.name;
			var clientPlayer:Pivot3D = userPlayer.player;
			var userVars:Array = user.getVariables();
				
			
				this.clientText(clientPlayer.name + "is Equal to" + userName + ret);
				this.clientText("Event Target: " + evt.target + "userVars: " + userVars);
				/*clientPlayer.x = */this.clientText("player X"+ Number(user.getVariable(_server.PLAYER_X).getIntValue()));
				/*clientPlayer.y = */this.clientText("player Y"+Number(user.getVariable(_server.PLAYER_Y).getIntValue()));
				/*clientPlayer.z = */this.clientText("player Z"+Number(user.getVariable(_server.PLAYER_Z).getIntValue()));
			
			
		}
		
		private function updateEvent(e:Event):void{
			scene.canvas.clear();
			//add player movement logic
			userPlayer.move();			
			// once we moved the player, we test for collisions		
			userPlayer.collision.slider();
			//rCollisions.slider();			
			if(Input3D.mouseDown == 0){
				// set the camera position relative to the player.	
				Pivot3DUtils.setPositionWithReference( scene.camera, 0, 300, 1000, clientPlayer, 0.1 );				
				// orientate the camera to player position.
				Pivot3DUtils.lookAtWithReference( scene.camera, 0, 200, 0, clientPlayer );
			}else{
				Pivot3DUtils.lookAtWithReference( scene.camera, 0, 200, 0, clientPlayer );
			}			
		}
		
		
		
		private function updatePlayer(tEvt:TimerEvent):void{			
			
		}
		
		private function clearExtraMesh():void{
			var trashMesh:Mesh3D = biped.getChildByName("Cylinder03") as Mesh3D;				
			trashMesh.clear();
			trashMesh = biped.getChildByName("Object01")as Mesh3D;
			trashMesh.clear();
			trashMesh = biped.getChildByName("Object02")as Mesh3D;
			trashMesh.clear();
			trashMesh = biped.getChildByName("Cylinder08")as Mesh3D;
			trashMesh.clear();
		}
		
		public function clientText(message:*):void{
			statusTxt.text = (String(message));
			//statusTxt.appendText(String(message));
		}
		
		
		/////////////////////////////getter and setter//////////////////////////
		public function get server():Server{
			return _server;
		}
		
		public function set userName(value:User):void{			
			_user = value;
		}
		
		public function get userClient():Client{
			return this;
		}
		
	
		
		
		  
		
	}//End Class
}//End Package