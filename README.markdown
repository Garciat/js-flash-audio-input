Data passed to the dataCallback is in the form of an array of floats ranging between -1 and 1.
Your callback will be called many times as the output buffer is filled and needs to flush.

Flash object methods:

Set the callback for status messages:

	setStatusCallback(callbackName:String):void

Set the callback for data messages:

	setDataCallback(callbackName:String):void

(Callbacks must be placed in the <window> object (global namespace))

Get an array of input device names:

	getInputArray():Array

Updates the array of device names:

	updateInputArray():void

Selects an input device to work with:

	selectInput(index:int=-1):void

("index" is the array index corresponding to a device in the getInputArray() array)

Requests the client for audio input permission:

	askPermission():void

_The following methods must be called -after- having selected an input device with selectInput()_

Returns a boolean determining if the client has allowed access to the device:

	getPermissionState():Boolean

Returns the name of the enabled device:

	getInputName():String

Returns the index corressponding to a the current device's position in the getInputArray() array:

	getInputIndex():int

Sets the device gain level (0-100; 50 is 1x multiplier):

	setGainLevel(gain:Number):void

Returns the active device's gain level:

	getGainLevel():Number

Sets the sample rate (5, 8, 11, 16, 22 or 44; value is in kHz):

	setSampleRate(rate:int):void

Returns the sample rate:

	getSampleRate():int

Enables/disables echo suppression:

	setUseEchoSuppression(enable:Boolean):void

Returns a boolean determining whether echo suppression is turned on or off:

	getUseEchoSuppression():Boolean

Returns the activity level the device is detecting (0-100):

	getActivityLevel():Number

Returns a boolean determining whether the object is recording or not:

	isRecording():Boolean

Starts the recording process:

	recordStart():void

Stops recording:

	recordStop():void
