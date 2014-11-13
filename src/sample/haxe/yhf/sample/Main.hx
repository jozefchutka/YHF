package yhf.sample;

import js.html.FocusEvent;
import js.html.Element;
import yhf.util.CssUtil;
import yhf.util.FocusUtil;
import js.html.BodyElement;
import js.html.CustomEvent;
import yhf.enums.Event;
import js.html.DivElement;
import js.Browser;

import yhf.Controller;

class Main
{
	public static function main()
	{
		new Main();
	}

	function new()
	{
		Browser.window.addEventListener("load", onWindowLoad);
	}
	
	function onWindowLoad(event:Dynamic)
	{
		init();
	}
	
	function init()
	{
		CssUtil.applyStyle("div:focused {border:1px solid red;}");
	
		var bodyController = new Controller<BodyElement>(cast Browser.document.body);
		bodyController.observe = true;
		bodyController.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			//trace("child added", event.detail.id, Controller.getController(event.detail) != null);
		});
		bodyController.addListener(Event.CHILD_REMOVED, function(event:CustomEvent)
		{
			//trace("child removed", event.detail.id);
		});
		
		var a = Browser.document.createDivElement();
		a.tabIndex = 1;
		a.innerHTML = "a";
		a.id = "a";
		
		var b = Browser.document.createDivElement();
		b.tabIndex = 2;
		b.innerHTML = "b";
		b.id = "b";

		var c = Browser.document.createDivElement();
		c.tabIndex = 3;
		c.innerHTML = "c";
		var cController = new Controller<Element>(c);
		cController.node.id = "c";

		a.appendChild(b);
		b.appendChild(c);
		Browser.document.body.appendChild(a);
		
		FocusUtil.addFocusListener(onFocused);
		FocusUtil.addBlurListener(onBlured);
	}

	function onFocused(event:FocusEvent)
	{
		var target:Dynamic = event.target;
		trace("onFocused", target.id);
	}

	function onBlured(event:FocusEvent)
	{
		var target:Dynamic = event.target;
		trace("onBlured", target.id);
	}
}
