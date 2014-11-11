package yhf;

import js.html.EventListener;
import js.html.Node;
import js.html.MutationEvent;
import js.html.MutationObserver;
import js.html.MutationObserverInit;
import js.html.MutationRecord;

import yhf.enums.Event;
import yhf.util.EventTargetUtil;
import yhf.util.EventUtil;
import yhf.util.MutationObserverUtil;

class Controller<TNode:Node>
{
	public static var CONTROLLER_FIELD:String = "controller";

	public var node(default, null):TNode;
	public var observe(default, set):Bool;
	
	var observer:MutationObserver;

	public function new(node:TNode)
	{
		this.node = node;
		Reflect.setField(node, CONTROLLER_FIELD, this);
	}

	function set_observe(value:Bool):Bool
	{
		if(observe != value)
		{
			if(observe)
				disposeObserver();
			observe = value;
			if(observe)
				createObserver();
		}
		
		return observe;
	}

	public static function getController(node:Node):Controller<Dynamic>
	{
		return Reflect.field(node, CONTROLLER_FIELD);
	}

	public function dispose():Void
	{
		observe = false;
		Reflect.deleteField(node, CONTROLLER_FIELD);
		node = null;
	}

	/**
	 * MutationObservers are fired asynchronously but 'soon', which means they fire before other things in the queue, 
	 * such as layout, paint, or triggered events.
	 * 
	 * This ameliorates the loss of synchrony, because you don't have to worry about screen flashing or other bad 
	 * things happening before your observer gets a chance to react.
	 * 
	 * In developer notes, they talk about an 'end-of-microtask' timing model.
	 * 
	 * With flushObserver() call, all observer events in queue will be processed immediately.
	 **/
	public function flushObserver():Void
	{
		if(observer != null)
			onMutationsObserved(observer.takeRecords());
	}
	
	public function addListener(type:String, listener:EventListener, ?useCapture:Bool):Void
	{
		EventTargetUtil.addListener(node, type, listener, useCapture);
	}

	public function removeListener(type:String, listener:EventListener, ?useCapture:Bool):Void
	{
		EventTargetUtil.removeListener(node, type, listener, useCapture);
	}

	public function dispatch(event:js.html.Event):Bool
	{
		return EventTargetUtil.dispatch(node, event);
	}

	function createObserver():Void
	{
		if(MutationObserverUtil.isAvailable)
		{
			var options:MutationObserverInit = {childList:true, subtree:true};
			observer = new MutationObserver(onMutationsObserved);
			observer.observe(node, options);
		}
		else
		{
			MutationObserverUtil.fix();
			addListener(MutationObserverUtil.EVENT_TYPE_DOM_NODE_INSERTED, onDomNodeInserted);
			addListener(MutationObserverUtil.EVENT_TYPE_DOM_NODE_REMOVED, onDomNodeRemoved);
		}
	}

	function disposeObserver():Void
	{
		if(observer != null)
		{
			observer.disconnect();
			observer = null;
		}

		removeListener(MutationObserverUtil.EVENT_TYPE_DOM_NODE_INSERTED, onDomNodeInserted);
		removeListener(MutationObserverUtil.EVENT_TYPE_DOM_NODE_REMOVED, onDomNodeRemoved);
	}

	function nodeAdded(node:Node, added:Array<Node>=null):Void
	{
		if(added != null)
			added.push(node);
		dispatch(EventUtil.create(Event.CHILD_ADDED, false, false, node));
		EventTargetUtil.dispatch(node, EventUtil.create(Event.ADDED_TO_OBSERVER, false, false, this.node));
		for(child in node.childNodes)
			nodeAdded(child, added);
	}

	function nodeRemoved(node:Node):Void
	{
		dispatch(EventUtil.create(Event.CHILD_REMOVED, false, false, node));
		EventTargetUtil.dispatch(node, EventUtil.create(Event.REMOVED_FROM_OBSERVER, false, false, this.node));
		for(child in node.childNodes)
			nodeRemoved(child);
	}
	
	/**
	 * There is some unexpected behavior observed in chrome. The number of mutation records (nodes added) is different
	 * when observer is flushed manualy. Without a manual flushing there seems to be some additional entries in the 
	 * list and by calling recursive nodeAdded() on each node would actualy handle some of these twice.
	 **/
	function mutationObserved(mutation:MutationRecord, added:Array<Node>):Void
	{
		for(node in mutation.addedNodes)
			if(Lambda.indexOf(added, node) == -1)
				nodeAdded(node, added);
		for(node in mutation.removedNodes)
			nodeRemoved(node);
	}

	function onMutationsObserved(mutations:Array<MutationRecord>):Void
	{
		var added:Array<Node> = [];
		for(mutation in mutations)
			mutationObserved(mutation, added);
	}

	function onDomNodeInserted(event:MutationEvent):Void
	{
		if(event.target != node)
			nodeAdded(cast event.target);
	}

	function onDomNodeRemoved(event:MutationEvent):Void
	{
		if(event.target != node)
			nodeRemoved(cast event.target);
	}
}