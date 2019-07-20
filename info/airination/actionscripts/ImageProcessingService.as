package info.airination.actionscripts
{
	import flash.net.*;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.rpc.events.*;
	import mx.rpc.http.mxml.*;

	public class ImageProcessingService
	{

		private static var _instance:ImageProcessingService;
		private var _imageCtrlUrl:String;
		private var _serverRootUrl:String;
		private var _imageRootDir:String = "";
		[Bindable] public var imageRootUrl:String = "";

		
		public static function get instance():ImageProcessingService
		{
			if(!_instance){
				_instance = new ImageProcessingService();
			}
			
			return _instance;
		}

		public function ImageProcessingService()
		{
			_imageCtrlUrl = mx.core.FlexGlobals.topLevelApplication._webUrl + "images/ImageCtrl.cfm"
			_serverRootUrl = mx.core.FlexGlobals.topLevelApplication._serverUrl;
		}

		
		public function get imageRootDir():String {
			return _imageRootDir;
		}
		
		public function getImageRootDir(document:Object): void {
			var http:HTTPService = new HTTPService();
			http.url = _imageCtrlUrl + "?mode=getImageRootDir";
			http.addEventListener(ResultEvent.RESULT,
				function(e:ResultEvent):void
				{
					// for coldfusion output bug
					var pattern:RegExp = new RegExp("\r\n","g");
					var s:String = e.result.toString();
					s = s.replace(pattern,"");
					_imageRootDir = s;
				}
			);
			http.addEventListener(FaultEvent.FAULT,
				function(e:FaultEvent):void
				{
					/*Alert.show(e.fault.message,"Service error", 4, document as Sprite);*/
					openErrorDialog(e.fault.message,"Service error");
				}
			);
			http.send();
		}
		
		public function getImageRootUrl(document:Object): void {
			var http:HTTPService = new HTTPService();
			http.url = _imageCtrlUrl + "?mode=getImageRootUrl";
			http.addEventListener(ResultEvent.RESULT,
				function(e:ResultEvent):void
				{
					// for coldfusion output bug
					var pattern:RegExp = new RegExp("\r\n","g");
					var s:String = e.result.toString();
					s = s.replace(pattern,"");
					if(s.substr(0,1) != "/"){
						s = "/" + s;
					}
					imageRootUrl = _serverRootUrl + s;
				}
			);
			http.addEventListener(FaultEvent.FAULT,
				function(e:FaultEvent):void
				{
					/*Alert.show(e.fault.message,"Service error", 4, document as Sprite);*/
					openErrorDialog(e.fault.message,"Service error");
				}
			);
			http.send();
			
			getImageRootDir(document);
		}
		
		public function uploadImage(f:FileReference): void {
			var req:URLRequest = new URLRequest(_imageCtrlUrl + "?mode=uploadImage");
			req.method = URLRequestMethod.POST;
			f.upload(req,"tempImage");
		}
		
		public function deleteTempImage(fileName:String): void {
			var http:HTTPService = new HTTPService();
			http.url = _imageCtrlUrl + "?mode=deleteTempImage";
			http.method = URLRequestMethod.POST;
			http.resultFormat = "text";
			http.addEventListener(ResultEvent.RESULT,
				function(e:ResultEvent):void
				{
					// do nothing
				}
			);
			http.addEventListener(FaultEvent.FAULT,
				function(e:FaultEvent):void
				{
					// do nothing
				}
			);
			var args:Object = new Object();
			args.fileName = fileName;
			
			http.send(args);
		}
		
		public function tempImageToReal(fileName:String, result:Function, document:Object): void {
			var http:HTTPService = new HTTPService();
			http.url = _imageCtrlUrl + "?mode=tempImageToReal";
			http.method = URLRequestMethod.POST;
			http.resultFormat = "text";
			http.addEventListener(ResultEvent.RESULT,
				function(e:ResultEvent):void
				{
					// for coldfusion output bug
					var pattern:RegExp = new RegExp("\r\n","g");
					var s:String = e.result.toString();
					s = s.replace(pattern,"");
					result(s);
				}
			);
			http.addEventListener(FaultEvent.FAULT,
				function(e:FaultEvent):void
				{
					/*Alert.show(e.fault.message,"Service error", 4, document as Sprite);*/
					openErrorDialog(e.fault.message,"Service error");
				}
			);
			var args:Object = new Object();
			args.fileName = fileName;
			
			http.send(args);
		}
		
		public function deleteRealImage(fileName:String): void {
			var http:HTTPService = new HTTPService();
			http.url = _imageCtrlUrl + "?mode=deleteRealImage";
			http.method = URLRequestMethod.POST;
			http.resultFormat = "text";
			http.addEventListener(ResultEvent.RESULT,
				function(e:ResultEvent):void
				{
					// do nothing
				}
			);
			http.addEventListener(FaultEvent.FAULT,
				function(e:FaultEvent):void
				{
					// do nothing
				}
			);
			var args:Object = new Object();
			args.fileName = fileName;
			
			http.send(args);
		}
		
		private function openErrorDialog(message:String, title:String): void {
			Alert.show(message, title);
		}
	}
}