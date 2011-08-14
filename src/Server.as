package{
	
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.*;
	import com.smartfoxserver.v2.entities.data.*;
	import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
	import com.smartfoxserver.v2.exceptions.SFSError;
	import com.smartfoxserver.v2.requests.*;
	
	import flash.events.*;
	import flash.geom.Vector3D;
	import flash.system.*;
	
	
	public class Server extends EventDispatcher	{
		
		public var sfs:SmartFox;
		private var user:User;
		private var userName:String
		private var space:String = "\n"
		private var _client:Client;
		private var _serverPlayers:Array;
		
		public const PLAYER_X:String = "playerX";
		public const PLAYER_Y:String = "playerY";
		public const PLAYER_Z:String = "playerZ";
		
		private var playerPos:Vector3D = new Vector3D(0,0,0);
		
		private var statusTxt:String;
		
		public function Server(){
			_serverPlayers = [];			
			sfs = new SmartFox();
				
		}
		
		public function connectToServer():void{			
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
				
				var request:LoginRequest = new LoginRequest("","","SimpleChat");
				
				sfs.send(request);
			}else{
				statusTxt = "connection failed"+ space;
			}
		}
		
		private function onRoomAdded(sfEvt:SFSEvent):void{			
			var settings:RoomSettings = new RoomSettings("Game Test");
			settings.maxUsers = 40;
			settings.isGame = true;				
			sfs.send(new CreateRoomRequest(settings));
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
		
	
		public function joinRoom(sfEvt:SFSEvent):void{			
			var joinRoom:Room = sfEvt.params.room;
			this.userClient.user = user;
			for each (var u:User in joinRoom.userList){
				
				serverPlayers.push(this.userClient);
			}
				
				//this.userClient.clientText(u.name + "'s Array length: " + serverPlayers.length);
			
			for each (var c:Client in serverPlayers){	
				var cUser:User = c.user;
				c.clientText("join "+ joinRoom.name);
				//c.clientText(c.user.name + "'s Array length: " + serverPlayers.length);
				c.addUserPlayer();
				c.loadPlayerCamera();
				c.addEvent();
			}
			
			
			
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
		
		public function get smartFox():SmartFox{
			return sfs;
		}
		
		public function get serverInstance():Server{
			return this;
		}
		
		public function set userClient(value:Client):void{
			_client = value;
			
		}
		
		public function get userClient():Client{
			return _client;
		}
		
		public function get serverPlayers():Array{
			return _serverPlayers
		}
		
		
		
	}//end Class
}//end Package