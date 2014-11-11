package yhf.util;

import js.html.Element;
import js.Browser;

class CssUtil
{
	public static function applyStyle(css:String)
	{
		var style = Browser.document.createStyleElement();
		style.type = "text/css";
		style.appendChild(Browser.document.createTextNode(css));

		Browser.document.head.appendChild(style);
	}

	public static function getStyle(element:Element, property:String):Dynamic
	{
		return Reflect.getProperty(Browser.document.defaultView.getComputedStyle(element, null), property);
	}
}
