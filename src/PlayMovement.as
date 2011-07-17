package
{
	import flare.core.Pivot3D;
	import flare.system.*;
	import flare.utils.*;
	
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import org.casalib.util.StageReference;

	public class PlayMovement {
		
		private var _player:Pivot3D;
		private var _playerBase:Player;	
		private var keyArray:Array;
		
		public function PlayMovement(player:Player)
		{
			keyArray = [];
			keyArray["up"] = 0;
			keyArray["down"] = 0;
			keyArray["left"] = 0;
			keyArray["right"] = 0;
			_playerBase = player;
			_player = player.player;
			StageReference.getStage().addEventListener(KeyboardEvent.KEY_UP, playIdle);	
		
			
		}
		
		public function forward():void{
			
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
			
			if((keyArray["up"] + keyArray["down"] + keyArray["right"]+ keyArray["left"]) == 0){
				trace("all movment is false");
				runIdle();	
			}
			
		}
		
		
		public function runIdle():void{
			trace("run idle");
			
			_player.frameSpeed = .1;
			_player.playLabel( "idle" );			
		}
	}//end Class
}//end Package