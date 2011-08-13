package
{
	import com.smartfoxserver.v2.*;
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.*;
	import com.smartfoxserver.v2.entities.data.*;
	import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
	import com.smartfoxserver.v2.exceptions.SFSError;
	import com.smartfoxserver.v2.requests.*;
	
	import flare.core.Pivot3D;
	import flare.system.*;
	import flare.utils.*;
	
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.casalib.util.StageReference;

	public class PlayMovement {
		
		private var _player:Pivot3D;
		private var _playerBase:Player;	
		private var keyArray:Array;
		private var _server:Server;
		
		private var intervalTimer:Timer = new Timer(200);
		
		public function PlayMovement(player:Player, clientServer:Server)
		{
			_server = clientServer;
			
			keyArray = [];
			keyArray["up"] = 0;
			keyArray["down"] = 0;
			keyArray["left"] = 0;
			keyArray["right"] = 0;
			_playerBase = player;
			_player = player.player;
			StageReference.getStage().addEventListener(KeyboardEvent.KEY_UP, playIdle);	
			intervalTimer.addEventListener(TimerEvent.TIMER,updateServer);
			intervalTimer.start();
			
			
		}
		
		public function forward():void{
			//all of the playerBase animationSpeed and movement Speeds need to be reversed so that player pulls information
			//fromt this class and the classe is not dependant on playerBase
			if (Input3D.keyDown( Input3D.W )){
				keyArray["up"]=1;
				_player.frameSpeed = _playerBase.animationSpeed ;
				_player.translateZ( -_playerBase.movementSpeed  ) ;	
				
			}	
		}
		
		public function backward():void{
			
			if (Input3D.keyDown( Input3D.S )){
				keyArray["down"]=1;
				_player.frameSpeed = _playerBase.animationSpeed ;
				_player.translateZ( _playerBase.movementSpeed  ) ;						
			}	
		}
		
		public function right():void{		
			if (Input3D.keyDown( Input3D.D )){
				keyArray["right"]=1;
				_player.frameSpeed = _playerBase.animationSpeed ;
				_player.rotateY( _playerBase.movementSpeed/3  ) ;				
			}	
		}
		
		public function left():void{			
			if (Input3D.keyDown( Input3D.A )){
				keyArray["left"]=1;
				_player.frameSpeed = _playerBase.animationSpeed ;
				_player.rotateY( -_playerBase.movementSpeed/3 ) ;
			}
		}
		
		
		
		public function move():void{
			if(Input3D.keyHit( Input3D.W ) || 
				Input3D.keyHit( Input3D.S ) || 
				Input3D.keyHit( Input3D.D ) ||
				Input3D.keyHit( Input3D.A ) ){				
				_player.playLabel( "run" ) ;				
				
			}
			
			forward();
			right();
			left();
			backward();
			
		}
		
		private function playIdle(kEvt:KeyboardEvent):void{
			//trace("key code: "+ kEvt.keyCode);
			
			
			switch(kEvt.keyCode){			
				case 87: 
					keyArray["up"] = 0;
					//trace("87:" + keyArray["up"]);
					break;
				case 83: 
					keyArray["down"] = 0;				
					//trace("83:" + keyArray["down"]);
					break;
				case 68: 
					keyArray["right"] = 0;
					//trace("68:" + keyArray["right"]);
					break;
				case 65: 
					keyArray["left"] = 0; 
					//trace("65:" + keyArray["left"]);
					break;			
			}
			
			
			//trace("list of key array:"+"\n UP: "+keyArray["up"]+"\n DOWN: "+keyArray["down"]+"\n RIGHT: "+keyArray["right"]+"\n LEFT: "+keyArray["left"]);
			
			if((keyArray["up"] + keyArray["down"] + keyArray["right"]+ keyArray["left"]) == 0){
				//trace("all movment is false");
				runIdle();	
			}
			
		}
		
		private function updateServer(timerEvt:TimerEvent):void{	
			var posVars:Array = new Array()
				
			posVars.push(new SFSUserVariable(_server.PLAYER_X, int(_player.x)));
			posVars.push(new SFSUserVariable(_server.PLAYER_Y, int(_player.y)));	
			posVars.push(new SFSUserVariable(_server.PLAYER_Z, int(_player.z)));			
			_server.sfs.send(new SetUserVariablesRequest(posVars));
		}
		
		public function runIdle():void{
			//trace("run idle");
			
			_player.frameSpeed = .1;
			_player.playLabel( "idle" );			
		}
	}//end Class
}//end Package