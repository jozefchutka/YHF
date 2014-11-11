package js.html;

/**
 * https://developer.mozilla.org/en-US/docs/Web/API/FocusEvent
 **/
@:native("FocusEvent")
extern class FocusEvent extends UIEvent
{
	var relatedTarget(default, null):Dynamic;
}
