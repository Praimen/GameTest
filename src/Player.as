package{
	import flare.collisions.SphereCollision;
	import flare.core.*;
	
	import flash.geom.Vector3D;

	public class Player extends Pivot3D	{
		
		private var _player:Pivot3D;
		private var collisions:SphereCollision;
		
		private var animSpeed:Number = 1.5;
		private var moveSpeed:Number = 20;
		private var rotationSpeed:Number = 3;
		private var moveControl:PlayMovement;
		public function Player(player:Pivot3D)	{
			
			_player = player;
			_player.x = 850
			collisions = new SphereCollision( _player, 50, new Vector3D( 0, 50, 0 ) ); 
			moveControl = new PlayMovement(this);
			addAnimations();			
		}
		
		private function addAnimations():void{			
			_player.addLabel( "run", 1, 40 );
			_player.addLabel( "idle", 50, 60 );
			// for smooth animation when the frameSpeed property is less than 1.
			_player.animationPrecision = true;	
			
		}
		
		public function addCollisions(collisionObject:Pivot3D):void{			
			collisions.addCollisionWith( collisionObject );			
		}
		
		public function addPlayerMovement():void{
			moveControl.move();
		}
		
		public function initAnim():void{
			moveControl.runIdle();
		}
		
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