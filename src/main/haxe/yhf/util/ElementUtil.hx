package yhf.util;

import js.html.Element;

class ElementUtil
{
	public static function addClassName(element:Element, className:String)
	{
		if(element.className == "")
		{
			element.className = className;
			return;
		}

		var names = element.className.split(" ");
		if(Lambda.indexOf(names, className) != -1)
			return;

		names.push(className);
		element.className = names.join(" ");
	}

	public static function removeClassName(element:Element, className:String)
	{
		if(element.className == "")
			return;

		var names = element.className.split(" ");
		if(Lambda.indexOf(names, className) == -1)
			return;

		names.remove(className);
		element.className = names.join(" ");
	}
}
