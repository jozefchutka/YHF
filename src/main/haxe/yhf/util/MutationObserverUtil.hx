package yhf.util;

import js.html.Node;
import js.Browser;

class MutationObserverUtil
{
	inline public static var EVENT_TYPE_DOM_NODE_INSERTED:String = "YHF-DOMNodeInserted";
	inline public static var EVENT_TYPE_DOM_NODE_REMOVED:String = "YHF-DOMNodeRemoved";

	public static var isAvailable(get, never):Bool;

	static var fixed:Bool;

	static var nativeAppendChild:Dynamic;
	static var nativeInsertBefore:Dynamic;
	static var nativeRemoveChild:Dynamic;
	static var nativeReplaceChild:Dynamic;

	static function get_isAvailable():Bool
	{
		var window:Dynamic = Browser.window;
		return window.MutationObserver != null;
	}

	public static function fix():Void
	{
		if(fixed)
			return;

		fixed = true;
		untyped nativeAppendChild = Node.prototype.appendChild;
		untyped Node.prototype.appendChild = fixedAppendChild;

		untyped nativeInsertBefore = Node.prototype.insertBefore;
		untyped Node.prototype.insertBefore = fixedInsertBefore;

		untyped nativeRemoveChild = Node.prototype.removeChild;
		untyped Node.prototype.removeChild = fixedRemoveChild;

		untyped nativeReplaceChild = Node.prototype.replaceChild;
		untyped Node.prototype.replaceChild = fixedReplaceChild;
	}

	static function fixedAppendChild(newChild:Node):Void
	{
		var scope:Node = untyped __js__("this");
		var oldParent = newChild.parentNode;
		Reflect.callMethod(scope, nativeAppendChild, [newChild]);
		if(oldParent != scope && oldParent != null)
			EventTargetUtil.dispatch(newChild, EventUtil.create(EVENT_TYPE_DOM_NODE_REMOVED, true, true, newChild));
		if(oldParent != scope)
			EventTargetUtil.dispatch(newChild, EventUtil.create(EVENT_TYPE_DOM_NODE_INSERTED, true, true, newChild));
	}

	static function fixedInsertBefore(newChild:Node, refChild:Node):Void
	{
		var scope:Node = untyped __js__("this");
		var oldParent = newChild.parentNode;
		var oldSibling = newChild.nextSibling;
		var refParent = refChild == null ? null : refChild.parentNode;
		Reflect.callMethod(scope, nativeInsertBefore, [newChild, refChild]);
		if(oldSibling != refChild && newChild != refChild && oldParent != null)
			EventTargetUtil.dispatch(newChild, EventUtil.create(EVENT_TYPE_DOM_NODE_REMOVED, true, true, newChild));
		if(oldSibling != refChild && newChild != refChild)
			EventTargetUtil.dispatch(newChild, EventUtil.create(EVENT_TYPE_DOM_NODE_INSERTED, true, true, newChild));
	}

	static function fixedRemoveChild(oldChild:Node):Void
	{
		var scope:Node = untyped __js__("this");
		if(scope == oldChild.parentNode)
			EventTargetUtil.dispatch(oldChild, EventUtil.create(EVENT_TYPE_DOM_NODE_REMOVED, true, true, oldChild));
		Reflect.callMethod(scope, nativeRemoveChild, [oldChild]);
	}

	static function fixedReplaceChild(newChild:Node, oldChild:Node):Void
	{
		if(newChild == oldChild)
			return;
		var scope:Node = untyped __js__("this");
		scope.insertBefore(newChild, oldChild);
		scope.removeChild(oldChild);
	}
}