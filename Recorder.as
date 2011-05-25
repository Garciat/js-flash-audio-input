package {
	import flash.display.Sprite;

	import flash.external.ExternalInterface;
	
	import flash.media.Microphone;
	import flash.system.Security;
	
	import flash.events.SampleDataEvent;
	
	import flash.utils.ByteArray;
	
	public class Recorder extends Sprite {
		// Properties
		public var mic:Microphone;
		
		public var recording:Boolean = false;
		
		public var inputArray:Array;
		
		public var jsDataCallback:String;
		public var jsStatusCallback:String;
		
		// Constructor
		public function Recorder() {
			if (ExternalInterface.available) {
				ExternalInterface.addCallback("setStatusCallback", setStatusCallback);
				ExternalInterface.addCallback("setDataCallback", setDataCallback);
				
				ExternalInterface.addCallback("getInputArray", getInputArray);
				ExternalInterface.addCallback("updateInputArray", updateInputArray);
				
				ExternalInterface.addCallback("selectInput", selectInput);
				ExternalInterface.addCallback("getInputName", getInputName);
				ExternalInterface.addCallback("getInputIndex", getInputIndex);
				
				ExternalInterface.addCallback("askPermission", askPermission);
				ExternalInterface.addCallback("getPermissionState", getPermissionState);
				
				ExternalInterface.addCallback("setGainLevel", setGainLevel);
				ExternalInterface.addCallback("getGainLevel", getGainLevel);
				ExternalInterface.addCallback("setSampleRate", setSampleRate);
				ExternalInterface.addCallback("getSampleRate", getSampleRate);
				ExternalInterface.addCallback("setUseEchoSuppression", setUseEchoSuppression);
				ExternalInterface.addCallback("getUseEchoSuppression", getUseEchoSuppression);
				
				ExternalInterface.addCallback("getActivityLevel", getActivityLevel);
				ExternalInterface.addCallback("isRecording", isRecording);
				
				ExternalInterface.addCallback("recordStart", recordStart);
				ExternalInterface.addCallback("recordStop", recordStop);
			}
		}
		
		// JS Methods
		public function setStatusCallback(callbackName:String):void {
			this.jsStatusCallback = callbackName;
		}
		
		public function setDataCallback(callbackName:String):void {
			this.jsDataCallback = callbackName;
		}
		
		public function getInputArray():Array {
			if (!this.inputArray) {
				this.updateInputArray();
			}
			
			return this.inputArray;
		}
		
		public function updateInputArray():void {
			this.inputArray = Microphone.names;
		}
		
		public function selectInput(index:int=-1):void {
			this.mic = Microphone.getMicrophone(index);
			
			if (this.mic != null) {
				this.mic.setSilenceLevel(0);
				this.mic.rate = 44;
				this.mic.gain = 50;
			}
		}
		
		public function askPermission():void {
			Security.showSettings("privacy");
		}
		
		// Requires selected input
		public function getPermissionState():Boolean {
			return this.mic.muted;
		}
		
		// Requires selected input
		public function getInputName():String {
			return this.mic.name;
		}
		
		// Requires selected input
		public function getInputIndex():int {
			return this.mic.index;
		}
		
		// Requires selected input
		public function setGainLevel(gain:Number):void {
			this.mic.gain = gain;
		}
		
		// Requires selected input
		public function getGainLevel():Number {
			return this.mic.gain;
		}
		
		// Requires selected input
		public function setSampleRate(rate:int):void {
			this.mic.rate = rate;
		}
		
		// Requires selected input
		public function getSampleRate():int {
			return this.mic.rate;
		}
		
		// Requires selected input
		public function setUseEchoSuppression(enable:Boolean):void {
			this.mic.setUseEchoSuppression(enable);
		}
		
		// Requires selected input
		public function getUseEchoSuppression():Boolean {
			return this.mic.useEchoSuppression;
		}
		
		// Requires selected input
		public function getActivityLevel():Number {
			return this.mic.activityLevel;
		}
		
		// Requires selected input
		public function isRecording():Boolean {
			return this.recording;
		}
		
		// Requires selected input
		public function recordStart():void {
			if (!this.recording) {
				if (this.jsStatusCallback) {
					ExternalInterface.call(this.jsStatusCallback, 'record-start');
				}
			
				this.recording = true;
				this.mic.addEventListener(SampleDataEvent.SAMPLE_DATA, dataHandler);
			}
		}
		
		// Requires selected input
		public function recordStop():void {
			if (this.recording) {
				if (this.jsStatusCallback) {
					ExternalInterface.call(this.jsStatusCallback, 'record-stop');
				}
			
				this.recording = false;
				this.mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, dataHandler);
			}
		}
		
		// Internal methods
		private function dataHandler(event:SampleDataEvent):void {
			var sampleArray:Array = new Array();
			
			while (event.data.bytesAvailable) {
				sampleArray.push(event.data.readFloat());
			}
			
			ExternalInterface.call(this.jsDataCallback, sampleArray);
		}
	}
}
