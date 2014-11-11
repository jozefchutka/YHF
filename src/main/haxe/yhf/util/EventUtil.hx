package yhf.util;

import js.html.CustomEvent;
import js.Browser;

class EventUtil
{
	public static function create(type:String, canBubble:Bool=true, cancelable:Bool=true, detail:Dynamic=null):CustomEvent
	{
		var result:CustomEvent = cast Browser.document.createEvent("CustomEvent");
		result.initCustomEvent(type, canBubble, cancelable, detail);
		return result;
	}
}
