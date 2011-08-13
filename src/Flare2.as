package  {
	
	import flash.display.Sprite;
	
	import org.casalib.util.StageReference;

	[SWF(backgroundColor="#666666", frameRate="60", width="750", height="600")]
	public class Flare2 extends Sprite{
		
		
		private var client:Client;	
		private var server:Server;	

		public function Flare2(){			
			
			stage.quality = "medium";
			//used to access stage from outside Document Class with out passing references
			StageReference.setStage(this.stage);
			server = new Server()
			client = new Client(server.serverInstance);			
			addChild(client);
		}
		
	}//End Package
}//End Class
