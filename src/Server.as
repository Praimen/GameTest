package{
	
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.*;
	import com.smartfoxserver.v2.entities.data.*;
	import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
	import com.smartfoxserver.v2.exceptions.SFSError;
	import com.smartfoxserver.v2.requests.*;
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Vector3D;
	import flash.system.*;
	import flash.text.*;
	
	public class Server	{
		
		public var sfs:SmartFox;
		private var user:User;
		private var userName:String
		private var space:String = "\n"
		
		public const PLAYER_X:String = "playerX";
		public const PLAYER_Y:String = "playerY";
		public const PLAYER_Z:String = "playerZ";
		
		private var playerPos:Vector3D = new Vector3D(0,0,0);
		
		private var statusTxt:String;
		
		public function Server(){
						
			sfs = new SmartFox();
			startApp();			
		}
		
		private function startApp():void{			
			loadEvents();
		}
		
		private function loadEvents():void{			
			
			statusTxt = "init"+ space;
			
			sfs.addEventListener(SFSEvent.ROOM_ADD, onLogin);
			sfs.addEventListener(SFSEvent.ROOM_CREATION_ERROR, onRoomCreationError);			
			sfs.addEventListener(SFSEvent.CONFIG_LOAD_SUCCESS, onConfigLoadSuccess);
			sfs.addEventListener(SFSEvent.CONFIG_LOAD_FAILURE, onConfigLoadFailure);
			sfs.addEventListener(SFSEvent.CONNECTION, onConnect);
			sfs.addEventListener(SFSEvent.CONNECTION_LOST, onConnectionLost);
			sfs.addEventListener(SFSEvent.LOGIN, onLogin);
			sfs.addEventListener(SFSEvent.ROOM_JOIN, joinRoom);
			sfs.addEventListener(SFSEvent.ROOM_JOIN_ERROR, onRoomAdded);
			sfs.addEventListener(SFSEvent.USER_VARIABLES_UPDATE, onUserVarsUpdate)
			sfs.addEventListener(IOErrorEvent.IO_ERROR, socketError);
			sfs.addEventListener(SecurityErrorEvent.SECURITY_ERROR, connectError);
			
			loadConnect();			
		}			
		
		private function loadConnect():void{			
			sfs.loadConfig("http://www.forgegraphics.com/smartfox/config.xml");		
		}
		
		private function onConfigLoadSuccess(evt:SFSEvent):void	{
			statusTxt = "XML loaded Attempting Server!: "  + sfs.config.host + ":" + sfs.config.port + space;
		}		
		
		
		public function onConnect(sfEvt:SFSEvent):void{
			statusTxt = "connectStatus" + String(sfEvt.params.success)+ space;
			if(sfEvt.params.success){
				statusTxt = "connection made to:"+  sfs.config.host + ":" + sfs.config.port + space;
				
				var request:LoginRequest = new LoginRequest("","","SimpleChat",null);
				
				sfs.send(request);
			}else{
				statusTxt = "connection failed"+ space;
			}
		}
		
		
		private function onLogin(sfEvt:SFSEvent):void{					
			
			var joinRoom:JoinRoomRequest = new JoinRoomRequest("Game Test");
			
			if(sfEvt.params.user != null){
				user = User(sfEvt.params.user);
				
				userName = user.name;
				statusTxt = "UserName: " + userName + space;	
				
								
			}
			
			try{
				sfs.send(joinRoom);
			}catch(e:Error){					
				statusTxt = "could not join room "+  space;
			}
			
		}		
		
		private function onRoomAdded(sfEvt:SFSEvent):void{			
			var settings:RoomSettings = new RoomSettings("Game Test");
			settings.maxUsers = 40;
			settings.isGame = true;				
			sfs.send(new CreateRoomRequest(settings));
		}
		
		public function joinRoom(sfEvt:SFSEvent):void{			
			var joinRoom:Room = sfEvt.params.room;			
			statusTxt = "join "+ joinRoom.name + space;
			statusTxt = userName + " has joined "+ joinRoom.name+ space;
			//statusTxt = userName + " PLAYER_X = "+user.getVariable(PLAYER_Z).getIntValue();
			
			
		}
		
		private function onUserVarsUpdate(evt:SFSEvent):void{
			//var changedVars:Array = evt.params.changedVars as Array;
			//var user:User = evt.params.user as User;
			var userVars:Array = user.getVariables()
			//trace(userName + " PLAYER_X = "+ user.getVariable(PLAYER_X).getIntValue());
			trace("user Variables "+user.getVariable(PLAYER_X).getIntValue());
		}
		
		
		///////////////////////////////////////////////ERRORS HANDLERS ////////////////////////////////////		
		private function connectError(evt:SecurityErrorEvent):void{
			statusTxt = "flash security error";
		}
		
		private function socketError(evt:IOErrorEvent):void{
			statusTxt = "flash socket error";
		}
		private function onConfigLoadFailure(evt:SFSEvent):void
		{
			statusTxt = "Config load failure!!!";
		}
		
		private function onConnectionLost(sfEvt:SFSEvent):void{
			statusTxt ="disconnecting"+ space;
			
		}	
		
		private function onRoomCreationError(sfEvt:SFSEvent):void{			
			trace("room found but you cannot join");
		}
		
		
		//////////////getter setter/////////////////////////////////
		public function get output():String{
			return statusTxt;
		}
		
		
		
	}//end Class
}//end Package