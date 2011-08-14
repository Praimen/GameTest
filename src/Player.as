package{
	import com.smartfoxserver.v2.entities.User;
	
	import flare.collisions.SphereCollision;
	import flare.core.*;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class Player extends Pivot3D	{
		
		private var _player:Pivot3D;
		private var collisions:SphereCollision;
		private var _user:String;
		private var _clientServer:Server;
		
		private var playerPos:Vector3D ;
		
		private var animSpeed:Number = 1.5;
		private var moveSpeed:Number = 20;
		private var rotationSpeed:Number = 3;
		private var playerMovement:PlayMovement;
		public function Player(playerObject:Pivot3D,clientServer:Server, user1:User)	{
			_user = user1.name;
			_player = playerObject;
			_clientServer = clientServer;
			playerPos = new Vector3D(850,0,0);
			this.player.x = playerPos.x;
			this.player.y = playerPos.y;
			this.player.z = playerPos.z;
			
			this.player.name = _user;					
			
			collisions = new SphereCollision( player, 50, new Vector3D( 0, 50, 0 ) ); 
			playerMovement = new PlayMovement(this, _clientServer);
			addAnimations();			
		}
		
		private function addAnimations():void{			
			player.addLabel( "run", 1, 40 );
			player.addLabel( "idle", 50, 60 );
			// for smooth animation when the frameSpeed property is less than 1.
			player.animationPrecision = true;	
			
		}
		
		public function addCollisions(collisionObject:Pivot3D):void{			
			collisions.addCollisionWith( collisionObject );			
		}
		
		public function move():void{
			
			playerMovement.move();
		}
		
		public function initAnim():void{
			playerMovement.runIdle();
		}
		
		/*public function currentPosition():Vector3D{
			this.playerPos.x = Number(_user.getVariable(_clientServer.PLAYER_X).getIntValue());
			this.playerPos.y = Number(_user.getVariable(_clientServer.PLAYER_Y).getIntValue());
			this.playerPos.z = Number(_user.getVariable(_clientServer.PLAYER_Z).getIntValue());
			
			return playerPos;
		}*/
///////////////////////////////////getters and setters///////////////////////////////////		
		public function get player():Pivot3D{
			return _player;
		}
		
		public function set animationSpeed(value:Number):void{
			animSpeed = value;			
		}
		
		public function get animationSpeed():Number{
			return animSpeed;			
		}
		
		public function set movementSpeed(value:Number):void{
			moveSpeed = value;
		}
		
		public function get movementSpeed():Number{			
			return moveSpeed;
		}
		
		public function set turningSpeed(value:Number):void{
			rotationSpeed = value;
		}
		
		public function get turningSpeed():Number{
			return rotationSpeed;
		}
		
		public function get collision():SphereCollision{
			return collisions;
		}
		
	}//end Class
}//end Package