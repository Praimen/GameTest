package{
	import flare.basic.*;
	import flare.primitives.*;

	public class WorldTexture{
		
		private var scene:Scene3D;
		private var _sky:SkyBox
		private var _folderLoc:String;
		
		public function WorldTexture(viewer:Viewer3D, folderLoc:String="sky_folder"){
			
			scene = viewer;
			_folderLoc = folderLoc;
			scene.addTextureFromFile( _folderLoc+"/front.png" );
			scene.addTextureFromFile( _folderLoc+"/back.png" );
			scene.addTextureFromFile( _folderLoc+"/left.png" );
			scene.addTextureFromFile( _folderLoc+"/right.png" );
			scene.addTextureFromFile( _folderLoc+"/top.png" );
			scene.addTextureFromFile( _folderLoc+"/bottom.png" );
			
			
		}
		
		public function initSkyBox():void{			
			_sky = new SkyBox( "skyMesh", _folderLoc, "png", 0 ) ;
		}
		
		
		public function get texture():SkyBox{
			return _sky
		}
	}//End Class
}//End Package