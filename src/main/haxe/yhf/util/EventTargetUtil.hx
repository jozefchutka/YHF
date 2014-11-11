package yhf.util;

import js.html.Event;
import js.html.EventListener;
import js.html.EventTarget;

class EventTargetUtil
{
	public static function addListener(eventTarget:EventTarget, type:String, listener:EventListener, ?useCapture:Bool)
	{
		eventTarget.addEventListener(type, listener, useCapture);
	}

	public static function removeListener(eventTarget:EventTarget, type:String, listener:EventListener, ?useCapture:Bool)
	{
		eventTarget.removeEventListener(type, listener, useCapture);
	}

	public static function dispatch(eventTarget:EventTarget, event:Event):Bool
	{
		return eventTarget.dispatchEvent(event);
	}
}
