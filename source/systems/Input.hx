package systems;

import openfl.events.KeyboardEvent;

/** A wrapper around different input classes. **/
class Input
{
	public static var keys:Array<Bool> = new Array<Bool>();
	
	public static function onKeyUp	(e:KeyboardEvent):Void { keys[e.keyCode] = false; }	
	public static function onKeyDown(e:KeyboardEvent):Void { keys[e.keyCode] = true;  }
}