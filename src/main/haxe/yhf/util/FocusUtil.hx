package yhf.util;

import js.html.Element;
import js.html.FocusEvent;
import js.Browser;

class FocusUtil
{
	public static var focusedElement(get, set):Element;

	static function get_focusedElement():Element
	{
		return Browser.document.activeElement;
	}

	/**
	 * Elements with undefined tabIndex can not be focused. Undefined tabIndex will pretend to have value -1,
	 * but that might need to be manualy reassigned so the element would be focusable.
	 * -1 focusable from script only
	 * 0..n focusable by TAB
	 **/
	static function set_focusedElement(value:Element):Element
	{
		if(value.tabIndex <= 0)
			value.tabIndex = value.tabIndex;
		value.focus();
		return value;
	}

	public static function addFocusListener(callback:FocusEvent->Void)
	{
		Browser.document.body.addEventListener("focus", callback, true);
	}

	public static function removeFocusListener(callback:FocusEvent->Void)
	{
		Browser.document.body.removeEventListener("focus", callback, true);
	}

	public static function addBlurListener(callback:FocusEvent->Void)
	{
		Browser.document.body.addEventListener("blur", callback, true);
	}

	public static function removeBlurListener(callback:FocusEvent->Void)
	{
		Browser.document.body.removeEventListener("blur", callback, true);
	}
}
