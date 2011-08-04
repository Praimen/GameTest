package  {
	
	import flash.display.Sprite;
	import org.casalib.util.StageReference;

	[SWF(backgroundColor="#666666", frameRate="60", width="750", height="750")]
	public class Flare2 extends Sprite{
		
		private var server:Server;
		private var client:Client;		

		public function Flare2(){			
			
			stage.quality = "medium";
			//used to access stage from outside Document Class with out passing references
			StageReference.setStage(this.stage);
			server = new Server();
			client = new Client(server);
			addChild(client);
		}
		
	}//End Package
}//End Class
