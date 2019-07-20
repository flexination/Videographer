package info.airination.actionscripts
{ 
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	
	public class CameraStream extends Sprite {
		
		public static const DEFAULT_CAMERA_WIDTH : Number = 320;
		public static const DEFAULT_CAMERA_HEIGHT : Number = 240;
		public static const DEFAULT_CAMERA_FPS : Number = 30;
		
		private var video:Video;
		private var camera:Camera;
		
		public var _cameraWidth : Number;
		public var _cameraHeight : Number;
		public var blnActive:Boolean = false;
		
		public function CameraStream() { 
			
			camera = Camera.getCamera();
			camera.addEventListener(ActivityEvent.ACTIVITY, onActive);
			
			_cameraWidth = DEFAULT_CAMERA_WIDTH;
			_cameraHeight = DEFAULT_CAMERA_HEIGHT;
			
			if(camera != null) {  
				camera.setMode(_cameraWidth, _cameraHeight, DEFAULT_CAMERA_FPS)
				video = new Video(camera.width, camera.height);
				video.attachCamera(camera);
				addChild(video);   
			}
			else {  Security.showSettings(SecurityPanel.CAMERA)
				trace("What are you waiting for? Go get a camera. :-)");  
			}
		}
		
		public function getSnapshotBitmapData():BitmapData 
		{ 
			var snapshot:BitmapData = new BitmapData(_cameraWidth, _cameraHeight);
			
			snapshot.draw(video,new Matrix());  
			return snapshot;
		}
		
		public function getSnapshot():Bitmap 
		{  
			var bitmap : Bitmap = new Bitmap(getSnapshotBitmapData());
			return bitmap;
		}
		
		private function onActive(event:ActivityEvent): void {
			blnActive = true;
		}
	}
} 