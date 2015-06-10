YHF provides core support for HTML applications, including DOM manipulation events, focus management, CSS tools and others.

# Example
```haxe
import js.html.BodyElement;
import js.html.CustomEvent;
import js.html.Node;
import js.Browser;
import yhf.enums.Event;
import yhf.Controller;

var body = Browser.document.body;
var root = new Controller<BodyElement>(body);
root.observe = true;
root.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
{
	var node:Node = cast event.detail;
	var controller = Controller.getController(node);
	if(controller != null)
		trace("Div element with controller added.");
});

var div1 = Browser.document.createDivElement();
body.appendChild(div1);

var div2 = Browser.document.createDivElement();
var div1Controller = new Controller<DivElement>(div2);
div1.appendChild(div2);
```

# Support
- IE9+
- Chrome
- FireFox
- Safari