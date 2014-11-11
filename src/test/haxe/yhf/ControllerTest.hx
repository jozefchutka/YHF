package yhf;

import haxe.Timer;

import js.html.CustomEvent;
import js.html.DivElement;
import js.html.Node;
import js.html.Text;
import js.Browser;

import massive.munit.async.AsyncFactory;
import massive.munit.Assert;

import yhf.enums.Event;
import yhf.Controller;

class ControllerTest
{
	@BeforeClass
	public function beforeClass():Void
	{
	}

	@AfterClass
	public function afterClass():Void
	{
	}

	@Before
	public function setup():Void
	{
	}

	@After
	public function tearDown():Void
	{
	}

	function createDiv():Controller<DivElement>
	{
		return new Controller<DivElement>(Browser.document.createDivElement());
	}

	function createText(data:String):Controller<Text>
	{
		return new Controller<Text>(Browser.document.createTextNode(data));
	}

	@Test
	public function childNodeAdded_usingAppendChild_flushed():Void
	{
		var a = createDiv();
		var b = createDiv();
		var c = createDiv();
		var d = createDiv();
		var addedChildren:Array<Node> = [];

		a.observe = true;
		a.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			addedChildren.push(cast event.detail);
		});
		b.node.appendChild(c.node);
		a.node.appendChild(b.node);
		a.flushObserver();
		Assert.areEqual(2, addedChildren.length);
		Assert.areEqual(b.node, addedChildren[0]);
		Assert.areEqual(c.node, addedChildren[1]);

		b.node.appendChild(d.node);
		a.flushObserver();
		Assert.areEqual(3, addedChildren.length);
		Assert.areEqual(b.node, addedChildren[0]);
		Assert.areEqual(c.node, addedChildren[1]);
		Assert.areEqual(d.node, addedChildren[2]);
	}

	@AsyncTest
	public function childNodeAdded_usingAppendChild(factory:AsyncFactory):Void
	{
		var completed = false;
		Timer.delay(factory.createHandler(this, function(){Assert.areEqual(true, completed);}, 200), 100);
	
		var a = createDiv();
		var b = createDiv();
		var c = createDiv();
		var d = createDiv();
		var addedChildren:Array<Node> = [];

		a.observe = true;
		a.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			addedChildren.push(cast event.detail);
		});
		b.node.appendChild(c.node);
		a.node.appendChild(b.node);
	
		Timer.delay(function(){
			Assert.areEqual(2, addedChildren.length);
			Assert.areEqual(b.node, addedChildren[0]);
			Assert.areEqual(c.node, addedChildren[1]);
			
			b.node.appendChild(d.node);

			Timer.delay(function(){
				Assert.areEqual(3, addedChildren.length);
				Assert.areEqual(b.node, addedChildren[0]);
				Assert.areEqual(c.node, addedChildren[1]);
				Assert.areEqual(d.node, addedChildren[2]);

				completed = true;
			}, 10);
		}, 10);
	}

	@Test
	public function childNodeReadded_usingAppendChild_flushed():Void
	{
		var a = createDiv();
		var b = createDiv();
		var c = createDiv();
		var d = createDiv();
		var events:Array<{type:String, node:Node}> = [];

		a.observe = true;
		a.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			events.push({type:"added", node:cast event.detail});
		});
		a.addListener(Event.CHILD_REMOVED, function(event:CustomEvent)
		{
			events.push({type:"removed", node:cast event.detail});
		});
		a.node.appendChild(b.node);
		a.flushObserver();
		Assert.areEqual(1, events.length);
		Assert.areEqual("added", events[0].type);
		Assert.areEqual(b.node, events[0].node);

		a.node.appendChild(b.node);
		a.flushObserver();
		Assert.areEqual(true, events.length == 1  || events.length == 3);
		Assert.areEqual("added", events[0].type);
		Assert.areEqual(b.node, events[0].node);
		
		// firefox, ie11
		if(events.length == 3)
		{
			Assert.areEqual("removed", events[1].type);
			Assert.areEqual(b.node, events[1].node);
			Assert.areEqual("added", events[2].type);
			Assert.areEqual(b.node, events[2].node);
		}
		
		events = [];
		a.node.appendChild(c.node);
		a.flushObserver();
		Assert.areEqual(1, events.length);
		Assert.areEqual("added", events[0].type);
		Assert.areEqual(c.node, events[0].node);

		events = [];
		b.node.appendChild(c.node);
		a.flushObserver();
		Assert.areEqual(2, events.length);
		Assert.areEqual("removed", events[0].type);
		Assert.areEqual(c.node, events[0].node);
		Assert.areEqual("added", events[1].type);
		Assert.areEqual(c.node, events[1].node);

		events = [];
		c.node.appendChild(d.node);
		a.flushObserver();
		Assert.areEqual(1, events.length);
		Assert.areEqual("added", events[0].type);
		Assert.areEqual(d.node, events[0].node);

		events = [];
		a.node.appendChild(c.node);
		a.flushObserver();
		Assert.areEqual(4, events.length);
		Assert.areEqual("removed", events[0].type);
		Assert.areEqual(c.node, events[0].node);
		Assert.areEqual("removed", events[1].type);
		Assert.areEqual(d.node, events[1].node);
		Assert.areEqual("added", events[2].type);
		Assert.areEqual(c.node, events[2].node);
		Assert.areEqual("added", events[3].type);
		Assert.areEqual(d.node, events[3].node);
	}

	@AsyncTest
	public function childNodeReadded_usingAppendChild(factory:AsyncFactory):Void
	{
		var completed = false;
		Timer.delay(factory.createHandler(this, function(){Assert.areEqual(true, completed);}, 200), 100);
	
		var a = createDiv();
		var b = createDiv();
		var c = createDiv();
		var d = createDiv();
		var events:Array<{type:String, node:Node}> = [];

		a.observe = true;
		a.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			events.push({type:"added", node:cast event.detail});
		});
		a.addListener(Event.CHILD_REMOVED, function(event:CustomEvent)
		{
			events.push({type:"removed", node:cast event.detail});
		});
		a.node.appendChild(b.node);
		
		Timer.delay(function(){
			a.flushObserver();
			Assert.areEqual(1, events.length);
			Assert.areEqual("added", events[0].type);
			Assert.areEqual(b.node, events[0].node);
	
			a.node.appendChild(b.node);
			
			Timer.delay(function()
			{
				Assert.areEqual(true, events.length == 1  || events.length == 3);
				Assert.areEqual("added", events[0].type);
				Assert.areEqual(b.node, events[0].node);

				// firefox, ie11
				if(events.length == 3)
				{
					Assert.areEqual("removed", events[1].type);
					Assert.areEqual(b.node, events[1].node);
					Assert.areEqual("added", events[2].type);
					Assert.areEqual(b.node, events[2].node);
				}

				events = [];
				a.node.appendChild(c.node);
				
				Timer.delay(function(){
					Assert.areEqual(1, events.length);
					Assert.areEqual("added", events[0].type);
					Assert.areEqual(c.node, events[0].node);

					events = [];
					b.node.appendChild(c.node);
					
					Timer.delay(function(){
						Assert.areEqual(2, events.length);
						Assert.areEqual("removed", events[0].type);
						Assert.areEqual(c.node, events[0].node);
						Assert.areEqual("added", events[1].type);
						Assert.areEqual(c.node, events[1].node);

						events = [];
						c.node.appendChild(d.node);
						
						Timer.delay(function(){
							Assert.areEqual(1, events.length);
							Assert.areEqual("added", events[0].type);
							Assert.areEqual(d.node, events[0].node);

							events = [];
							a.node.appendChild(c.node);
							
							Timer.delay(function(){
								Assert.areEqual(4, events.length);
								Assert.areEqual("removed", events[0].type);
								Assert.areEqual(c.node, events[0].node);
								Assert.areEqual("removed", events[1].type);
								Assert.areEqual(d.node, events[1].node);
								Assert.areEqual("added", events[2].type);
								Assert.areEqual(c.node, events[2].node);
								Assert.areEqual("added", events[3].type);
								Assert.areEqual(d.node, events[3].node);

								completed = true;
							}, 10);
						}, 10);
					}, 10);
				}, 10);
			}, 10);
		}, 10);
	}
	
	@Test
	public function childNodeAdded_usingInsertBefore_flushed():Void
	{
		var a = createDiv();
		var b = createDiv();
		var c = createDiv();
		var d = createDiv();
		var e = createDiv();
		var events:Array<{type:String, node:Node}> = [];

		a.node.appendChild(e.node);
		b.node.appendChild(c.node);
		a.observe = true;
		a.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			events.push({type:"added", node:cast event.detail});
		});
		a.addListener(Event.CHILD_REMOVED, function(event:CustomEvent)
		{
			events.push({type:"removed", node:cast event.detail});
		});

		a.node.insertBefore(b.node, e.node);
		a.flushObserver();
		Assert.areEqual(2, events.length);
		Assert.areEqual("added", events[0].type);
		Assert.areEqual(b.node, events[0].node);
		Assert.areEqual("added", events[1].type);
		Assert.areEqual(c.node, events[1].node);

		b.node.insertBefore(d.node, c.node);
		a.flushObserver();
		Assert.areEqual(3, events.length);
		Assert.areEqual("added", events[0].type);
		Assert.areEqual(b.node, events[0].node);
		Assert.areEqual("added", events[1].type);
		Assert.areEqual(c.node, events[1].node);
		Assert.areEqual("added", events[2].type);
		Assert.areEqual(d.node, events[2].node);

		events = [];
		b.node.insertBefore(d.node, d.node);
		a.flushObserver();
		Assert.areEqual(true, events.length == 0 || events.length == 2);

		// firefox, ie11
		if(events.length == 2)
		{
			Assert.areEqual("removed", events[0].type);
			Assert.areEqual(d.node, events[0].node);
			Assert.areEqual("added", events[1].type);
			Assert.areEqual(d.node, events[1].node);
		}
	}

	@AsyncTest
	public function childNodeAdded_usingInsertBefore(factory:AsyncFactory):Void
	{
		var completed = false;
		Timer.delay(factory.createHandler(this, function(){Assert.areEqual(true, completed);}, 200), 100);
	
		var a = createDiv();
		var b = createDiv();
		var c = createDiv();
		var d = createDiv();
		var e = createDiv();
		var events:Array<{type:String, node:Node}> = [];

		a.node.appendChild(e.node);
		b.node.appendChild(c.node);
		a.observe = true;
		a.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			events.push({type:"added", node:cast event.detail});
		});
		a.addListener(Event.CHILD_REMOVED, function(event:CustomEvent)
		{
			events.push({type:"removed", node:cast event.detail});
		});

		a.node.insertBefore(b.node, e.node);
		Timer.delay(function(){
			Assert.areEqual(2, events.length);
			Assert.areEqual("added", events[0].type);
			Assert.areEqual(b.node, events[0].node);
			Assert.areEqual("added", events[1].type);
			Assert.areEqual(c.node, events[1].node);

			b.node.insertBefore(d.node, c.node);

			Timer.delay(function(){
				Assert.areEqual(3, events.length);
				Assert.areEqual("added", events[0].type);
				Assert.areEqual(b.node, events[0].node);
				Assert.areEqual("added", events[1].type);
				Assert.areEqual(c.node, events[1].node);
				Assert.areEqual("added", events[2].type);
				Assert.areEqual(d.node, events[2].node);

				events = [];
				b.node.insertBefore(d.node, d.node);

				Timer.delay(function(){
					Assert.areEqual(true, events.length == 0 || events.length == 2);

					// firefox, ie11
					if(events.length == 2)
					{
						Assert.areEqual("removed", events[0].type);
						Assert.areEqual(d.node, events[0].node);
						Assert.areEqual("added", events[1].type);
						Assert.areEqual(d.node, events[1].node);
					}
					
					completed = true;
				}, 10);
			}, 10);
		}, 10);
	}

	@Test
	public function childNodeReadded_usingInsertBefore_flushed():Void
	{
		var a = createDiv();
		var b = createDiv();
		var c = createDiv();
		var d = createDiv();
		var e = createDiv();
		var events:Array<{type:String, node:Node}> = [];

		a.node.appendChild(b.node);
		b.node.appendChild(c.node);
		d.node.appendChild(e.node);
		a.observe = true;
		a.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			events.push({type:"added", node:cast event.detail});
		});
		a.addListener(Event.CHILD_REMOVED, function(event:CustomEvent)
		{
			events.push({type:"removed", node:cast event.detail});
		});

		a.node.insertBefore(d.node, b.node);
		a.flushObserver();
		Assert.areEqual(2, events.length);
		Assert.areEqual("added", events[0].type);
		Assert.areEqual(d.node, events[0].node);
		Assert.areEqual("added", events[1].type);
		Assert.areEqual(e.node, events[1].node);

		events = [];
		a.node.insertBefore(d.node, b.node);
		a.flushObserver();
		Assert.areEqual(true, events.length == 0 || events.length == 4);
		
		// firefox, ie11
		if(events.length == 4)
		{
			Assert.areEqual("removed", events[0].type);
			Assert.areEqual(d.node, events[0].node);
			Assert.areEqual("removed", events[1].type);
			Assert.areEqual(e.node, events[1].node);
			Assert.areEqual("added", events[2].type);
			Assert.areEqual(d.node, events[2].node);
			Assert.areEqual("added", events[3].type);
			Assert.areEqual(e.node, events[3].node);
		}

		events = [];
		b.node.insertBefore(d.node, c.node);
		a.flushObserver();
		Assert.areEqual(4, events.length);
		Assert.areEqual("removed", events[0].type);
		Assert.areEqual(d.node, events[0].node);
		Assert.areEqual("removed", events[1].type);
		Assert.areEqual(e.node, events[1].node);
		Assert.areEqual("added", events[2].type);
		Assert.areEqual(d.node, events[2].node);
		Assert.areEqual("added", events[3].type);
		Assert.areEqual(e.node, events[3].node);

		events = [];
		b.node.insertBefore(c.node, d.node);
		a.flushObserver();
		Assert.areEqual(2, events.length);
		Assert.areEqual("removed", events[0].type);
		Assert.areEqual(c.node, events[0].node);
		Assert.areEqual("added", events[1].type);
		Assert.areEqual(c.node, events[1].node);
	}

	@AsyncTest
	public function childNodeReadded_usingInsertBefore(factory:AsyncFactory):Void
	{
		var completed = false;
		Timer.delay(factory.createHandler(this, function(){Assert.areEqual(true, completed);}, 200), 100);
	
		var a = createDiv();
		var b = createDiv();
		var c = createDiv();
		var d = createDiv();
		var e = createDiv();
		var events:Array<{type:String, node:Node}> = [];

		a.node.appendChild(b.node);
		b.node.appendChild(c.node);
		d.node.appendChild(e.node);
		a.observe = true;
		a.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			events.push({type:"added", node:cast event.detail});
		});
		a.addListener(Event.CHILD_REMOVED, function(event:CustomEvent)
		{
			events.push({type:"removed", node:cast event.detail});
		});

		a.node.insertBefore(d.node, b.node);

		Timer.delay(function(){
			Assert.areEqual(2, events.length);
			Assert.areEqual("added", events[0].type);
			Assert.areEqual(d.node, events[0].node);
			Assert.areEqual("added", events[1].type);
			Assert.areEqual(e.node, events[1].node);

			events = [];
			a.node.insertBefore(d.node, b.node);

			Timer.delay(function(){
				Assert.areEqual(true, events.length == 0 || events.length == 4);

				// firefox, ie11
				if(events.length == 4)
				{
					Assert.areEqual("removed", events[0].type);
					Assert.areEqual(d.node, events[0].node);
					Assert.areEqual("removed", events[1].type);
					Assert.areEqual(e.node, events[1].node);
					Assert.areEqual("added", events[2].type);
					Assert.areEqual(d.node, events[2].node);
					Assert.areEqual("added", events[3].type);
					Assert.areEqual(e.node, events[3].node);
				}

				events = [];
				b.node.insertBefore(d.node, c.node);

				Timer.delay(function(){
					Assert.areEqual(4, events.length);
					Assert.areEqual("removed", events[0].type);
					Assert.areEqual(d.node, events[0].node);
					Assert.areEqual("removed", events[1].type);
					Assert.areEqual(e.node, events[1].node);
					Assert.areEqual("added", events[2].type);
					Assert.areEqual(d.node, events[2].node);
					Assert.areEqual("added", events[3].type);
					Assert.areEqual(e.node, events[3].node);

					events = [];
					b.node.insertBefore(c.node, d.node);

					Timer.delay(function(){
						Assert.areEqual(2, events.length);
						Assert.areEqual("removed", events[0].type);
						Assert.areEqual(c.node, events[0].node);
						Assert.areEqual("added", events[1].type);
						Assert.areEqual(c.node, events[1].node);
						
						completed = true;
					}, 10);
				}, 10);
			}, 10);
		}, 10);
	}
	
	@Test
	public function addedToObserver_usingAppendChild_flushed():Void
	{
		var a = createDiv();
		var b = createDiv();
		var c = createDiv();
		var d = createDiv();
		var addedToObserver:Array<{child:Node, observer:Node}> = [];

		a.observe = true;
		b.addListener(Event.ADDED_TO_OBSERVER, function(event:CustomEvent)
		{
			addedToObserver.push({child:cast event.currentTarget, observer:cast event.detail});
		});
		c.addListener(Event.ADDED_TO_OBSERVER, function(event:CustomEvent)
		{
			addedToObserver.push({child:cast event.currentTarget, observer:cast event.detail});
		});
		d.addListener(Event.ADDED_TO_OBSERVER, function(event:CustomEvent)
		{
			addedToObserver.push({child:cast event.currentTarget, observer:cast event.detail});
		});
		b.node.appendChild(c.node);
		a.node.appendChild(b.node);
		a.flushObserver();
		Assert.areEqual(2, addedToObserver.length);
		Assert.areEqual(a.node, addedToObserver[0].observer);
		Assert.areEqual(b.node, addedToObserver[0].child);
		Assert.areEqual(a.node, addedToObserver[1].observer);
		Assert.areEqual(c.node, addedToObserver[1].child);

		b.node.appendChild(d.node);
		a.flushObserver();
		Assert.areEqual(3, addedToObserver.length);
		Assert.areEqual(a.node, addedToObserver[0].observer);
		Assert.areEqual(b.node, addedToObserver[0].child);
		Assert.areEqual(a.node, addedToObserver[1].observer);
		Assert.areEqual(c.node, addedToObserver[1].child);
		Assert.areEqual(a.node, addedToObserver[2].observer);
		Assert.areEqual(d.node, addedToObserver[2].child);
	}

	@AsyncTest
	public function addedToObserver_usingAppendChild(factory:AsyncFactory):Void
	{
		// increased time for slow IE9 on vaio 
		var completed = false;
		Timer.delay(factory.createHandler(this, function(){Assert.areEqual(true, completed);}, 350), 300);
	
		var a = createDiv();
		var b = createDiv();
		var c = createDiv();
		var d = createDiv();
		var addedToObserver:Array<{child:Node, observer:Node}> = [];

		a.observe = true;
		b.addListener(Event.ADDED_TO_OBSERVER, function(event:CustomEvent)
		{
			addedToObserver.push({child:cast event.currentTarget, observer:cast event.detail});
		});
		c.addListener(Event.ADDED_TO_OBSERVER, function(event:CustomEvent)
		{
			addedToObserver.push({child:cast event.currentTarget, observer:cast event.detail});
		});
		d.addListener(Event.ADDED_TO_OBSERVER, function(event:CustomEvent)
		{
			addedToObserver.push({child:cast event.currentTarget, observer:cast event.detail});
		});
		b.node.appendChild(c.node);
		a.node.appendChild(b.node);

		Timer.delay(function(){
			Assert.areEqual(2, addedToObserver.length);
			Assert.areEqual(a.node, addedToObserver[0].observer);
			Assert.areEqual(b.node, addedToObserver[0].child);
			Assert.areEqual(a.node, addedToObserver[1].observer);
			Assert.areEqual(c.node, addedToObserver[1].child);

			b.node.appendChild(d.node);
			
			Timer.delay(function(){
				Assert.areEqual(3, addedToObserver.length);
				Assert.areEqual(a.node, addedToObserver[0].observer);
				Assert.areEqual(b.node, addedToObserver[0].child);
				Assert.areEqual(a.node, addedToObserver[1].observer);
				Assert.areEqual(c.node, addedToObserver[1].child);
				Assert.areEqual(a.node, addedToObserver[2].observer);
				Assert.areEqual(d.node, addedToObserver[2].child);

				completed = true;
			}, 10);
		}, 10);
	}
	
	@Test
	public function childNodeRemoved_usingRemoveChild_flushed():Void
	{
		var a = createDiv();
		var b = createDiv();
		var c = createDiv();
		var d = createDiv();
		var removedChildren:Array<Node> = [];

		a.observe = true;
		a.addListener(Event.CHILD_REMOVED, function(event:CustomEvent)
		{
			removedChildren.push(cast event.detail);
		});
		b.node.appendChild(c.node);
		a.node.appendChild(b.node);
		b.node.appendChild(d.node);
		a.flushObserver();

		b.node.removeChild(d.node);
		a.flushObserver();
		Assert.areEqual(1, removedChildren.length);
		Assert.areEqual(d.node, removedChildren[0]);

		a.node.removeChild(b.node);
		a.flushObserver();
		Assert.areEqual(3, removedChildren.length);
		Assert.areEqual(d.node, removedChildren[0]);
		Assert.areEqual(b.node, removedChildren[1]);
		Assert.areEqual(c.node, removedChildren[2]);
	}

	@AsyncTest
	public function childNodeRemoved_usingRemoveChild(factory:AsyncFactory):Void
	{
		var completed = false;
		Timer.delay(factory.createHandler(this, function(){Assert.areEqual(true, completed);}, 200), 100);
	
		var a = createDiv();
		var b = createDiv();
		var c = createDiv();
		var d = createDiv();
		var removedChildren:Array<Node> = [];

		a.observe = true;
		a.addListener(Event.CHILD_REMOVED, function(event:CustomEvent)
		{
			removedChildren.push(cast event.detail);
		});
		b.node.appendChild(c.node);
		a.node.appendChild(b.node);
		b.node.appendChild(d.node);

		Timer.delay(function(){
			b.node.removeChild(d.node);

			Timer.delay(function(){
				Assert.areEqual(1, removedChildren.length);
				Assert.areEqual(d.node, removedChildren[0]);

				a.node.removeChild(b.node);

				Timer.delay(function(){
					Assert.areEqual(3, removedChildren.length);
					Assert.areEqual(d.node, removedChildren[0]);
					Assert.areEqual(b.node, removedChildren[1]);
					Assert.areEqual(c.node, removedChildren[2]);
					
					completed = true;
				}, 10);
			}, 10);
		}, 10);
	}
	
	@Test
	public function removedFromObserver_usingRemoveChild_flushed():Void
	{
		var a = createDiv();
		var b = createDiv();
		var c = createDiv();
		var d = createDiv();
		var removedFromObserver:Array<{child:Node, observer:Node}> = [];

		a.observe = true;
		b.addListener(Event.REMOVED_FROM_OBSERVER, function(event:CustomEvent)
		{
			removedFromObserver.push({child:cast event.currentTarget, observer:cast event.detail});
		});
		c.addListener(Event.REMOVED_FROM_OBSERVER, function(event:CustomEvent)
		{
			removedFromObserver.push({child:cast event.currentTarget, observer:cast event.detail});
		});
		d.addListener(Event.REMOVED_FROM_OBSERVER, function(event:CustomEvent)
		{
			removedFromObserver.push({child:cast event.currentTarget, observer:cast event.detail});
		});
		b.node.appendChild(c.node);
		a.node.appendChild(b.node);
		b.node.appendChild(d.node);
		a.flushObserver();

		b.node.removeChild(d.node);
		a.flushObserver();
		Assert.areEqual(1, removedFromObserver.length);
		Assert.areEqual(a.node, removedFromObserver[0].observer);
		Assert.areEqual(d.node, removedFromObserver[0].child);

		a.node.removeChild(b.node);
		a.flushObserver();
		Assert.areEqual(3, removedFromObserver.length);
		Assert.areEqual(a.node, removedFromObserver[0].observer);
		Assert.areEqual(d.node, removedFromObserver[0].child);
		Assert.areEqual(a.node, removedFromObserver[1].observer);
		Assert.areEqual(b.node, removedFromObserver[1].child);
		Assert.areEqual(a.node, removedFromObserver[2].observer);
		Assert.areEqual(c.node, removedFromObserver[2].child);
	}

	@AsyncTest
	public function removedFromObserver_usingRemoveChild(factory:AsyncFactory):Void
	{
		var completed = false;
		Timer.delay(factory.createHandler(this, function(){Assert.areEqual(true, completed);}, 200), 100);

		var a = createDiv();
		var b = createDiv();
		var c = createDiv();
		var d = createDiv();
		var removedFromObserver:Array<{child:Node, observer:Node}> = [];

		a.observe = true;
		b.addListener(Event.REMOVED_FROM_OBSERVER, function(event:CustomEvent)
		{
			removedFromObserver.push({child:cast event.currentTarget, observer:cast event.detail});
		});
		c.addListener(Event.REMOVED_FROM_OBSERVER, function(event:CustomEvent)
		{
			removedFromObserver.push({child:cast event.currentTarget, observer:cast event.detail});
		});
		d.addListener(Event.REMOVED_FROM_OBSERVER, function(event:CustomEvent)
		{
			removedFromObserver.push({child:cast event.currentTarget, observer:cast event.detail});
		});
		b.node.appendChild(c.node);
		a.node.appendChild(b.node);
		b.node.appendChild(d.node);

		Timer.delay(function(){
			b.node.removeChild(d.node);

			Timer.delay(function(){
				Assert.areEqual(1, removedFromObserver.length);
				Assert.areEqual(a.node, removedFromObserver[0].observer);
				Assert.areEqual(d.node, removedFromObserver[0].child);

				a.node.removeChild(b.node);

				Timer.delay(function(){
					Assert.areEqual(3, removedFromObserver.length);
					Assert.areEqual(a.node, removedFromObserver[0].observer);
					Assert.areEqual(d.node, removedFromObserver[0].child);
					Assert.areEqual(a.node, removedFromObserver[1].observer);
					Assert.areEqual(b.node, removedFromObserver[1].child);
					Assert.areEqual(a.node, removedFromObserver[2].observer);
					Assert.areEqual(c.node, removedFromObserver[2].child);
					
					completed = true;
				}, 10);
			}, 10);
		}, 10);
	}
	
	@Test
	public function childNodeAddedAndRemoved_forTextNode_flushed():Void
	{
		var a = createDiv();
		var text = createText("sample text");
		var events:Array<{type:String, node:Node}> = [];

		a.observe = true;
		a.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			events.push({type:"added", node:cast event.detail});
		});
		a.addListener(Event.CHILD_REMOVED, function(event:CustomEvent)
		{
			events.push({type:"removed", node:cast event.detail});
		});
		
		a.node.appendChild(text.node);
		a.flushObserver();
		Assert.areEqual(1, events.length);
		Assert.areEqual("added", events[0].type);
		Assert.areEqual(text.node, events[0].node);

		events = [];
		a.node.removeChild(text.node);
		a.flushObserver();
		Assert.areEqual(true, events.length == 1 || events.length == 2);
		Assert.areEqual("removed", events[0].type);
		Assert.areEqual(text.node, events[0].node);

		// IE11 known issue, Text node removed is observed twice
		if(events.length == 2)
		{
			Assert.areEqual("removed", events[1].type);
			Assert.areEqual(text.node, events[1].node);
		}
	}

	@AsyncTest
	public function childNodeAddedAndRemoved_forTextNode(factory:AsyncFactory):Void
	{
		var completed = false;
		Timer.delay(factory.createHandler(this, function(){Assert.areEqual(true, completed);}, 200), 100);

		var a = createDiv();
		var text = createText("sample text");
		var events:Array<{type:String, node:Node}> = [];

		a.observe = true;
		a.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			events.push({type:"added", node:cast event.detail});
		});
		a.addListener(Event.CHILD_REMOVED, function(event:CustomEvent)
		{
			events.push({type:"removed", node:cast event.detail});
		});

		a.node.appendChild(text.node);

		Timer.delay(function(){
			Assert.areEqual(1, events.length);
			Assert.areEqual("added", events[0].type);
			Assert.areEqual(text.node, events[0].node);

			events = [];
			a.node.removeChild(text.node);

			Timer.delay(function(){
				Assert.areEqual(true, events.length == 1 || events.length == 2);
				Assert.areEqual("removed", events[0].type);
				Assert.areEqual(text.node, events[0].node);

				// IE11 known issue, Text node removed is observed twice
				if(events.length == 2)
				{
					Assert.areEqual("removed", events[1].type);
					Assert.areEqual(text.node, events[1].node);
				}
				
				completed = true;
			}, 10);
		}, 10);
	}
	
	@Test
	public function childNodeAddedAndRemoved_usingReplaceChild_flushed():Void
	{
		var a = createDiv();
		var b = createDiv();
		var c = createDiv();
		var d = createDiv();
		var e = createDiv();
		var events:Array<{type:String, node:Node}> = [];

		a.node.appendChild(b.node);
		b.node.appendChild(d.node);
		c.node.appendChild(e.node);
		a.observe = true;
		a.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			events.push({type:"added", node:cast event.detail});
		});
		a.addListener(Event.CHILD_REMOVED, function(event:CustomEvent)
		{
			events.push({type:"removed", node:cast event.detail});
		});

		a.node.replaceChild(c.node, b.node);
		a.flushObserver();
		Assert.areEqual(4, events.length);
		Assert.areEqual("added", events[0].type);
		Assert.areEqual(c.node, events[0].node);
		Assert.areEqual("added", events[1].type);
		Assert.areEqual(e.node, events[1].node);
		Assert.areEqual("removed", events[2].type);
		Assert.areEqual(b.node, events[2].node);
		Assert.areEqual("removed", events[3].type);
		Assert.areEqual(d.node, events[3].node);

		events = [];
		c.node.replaceChild(b.node, e.node);
		a.flushObserver();
		Assert.areEqual(3, events.length);
		Assert.areEqual("added", events[0].type);
		Assert.areEqual(b.node, events[0].node);
		Assert.areEqual("added", events[1].type);
		Assert.areEqual(d.node, events[1].node);
		Assert.areEqual("removed", events[2].type);
		Assert.areEqual(e.node, events[2].node);

		events = [];
		c.node.replaceChild(b.node, b.node);
		a.flushObserver();
		Assert.areEqual(true, events.length == 0 || events.length == 4);

		// firefox, ie11
		if(events.length == 4)
		{
			// firefox
			if(events[0].type == "removed")
			{
				Assert.areEqual("removed", events[0].type);
				Assert.areEqual(b.node, events[0].node);
				Assert.areEqual("removed", events[1].type);
				Assert.areEqual(d.node, events[1].node);
				Assert.areEqual("added", events[2].type);
				Assert.areEqual(b.node, events[2].node);
				Assert.areEqual("added", events[3].type);
				Assert.areEqual(d.node, events[3].node);
			}

			// ie11
			else if(events[0].type == "added")
			{
				Assert.areEqual("added", events[0].type);
				Assert.areEqual(b.node, events[0].node);
				Assert.areEqual("added", events[1].type);
				Assert.areEqual(d.node, events[1].node);
				Assert.areEqual("removed", events[2].type);
				Assert.areEqual(b.node, events[2].node);
				Assert.areEqual("removed", events[3].type);
				Assert.areEqual(d.node, events[3].node);
			}
		}
	}

	@AsyncTest
	public function childNodeAddedAndRemoved_usingReplaceChild(factory:AsyncFactory):Void
	{
		var completed = false;
		Timer.delay(factory.createHandler(this, function(){Assert.areEqual(true, completed);}, 200), 100);

		var a = createDiv();
		var b = createDiv();
		var c = createDiv();
		var d = createDiv();
		var e = createDiv();
		var events:Array<{type:String, node:Node}> = [];

		a.node.appendChild(b.node);
		b.node.appendChild(d.node);
		c.node.appendChild(e.node);
		a.observe = true;
		a.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			events.push({type:"added", node:cast event.detail});
		});
		a.addListener(Event.CHILD_REMOVED, function(event:CustomEvent)
		{
			events.push({type:"removed", node:cast event.detail});
		});

		a.node.replaceChild(c.node, b.node);

		Timer.delay(function(){
			Assert.areEqual(4, events.length);
			Assert.areEqual("added", events[0].type);
			Assert.areEqual(c.node, events[0].node);
			Assert.areEqual("added", events[1].type);
			Assert.areEqual(e.node, events[1].node);
			Assert.areEqual("removed", events[2].type);
			Assert.areEqual(b.node, events[2].node);
			Assert.areEqual("removed", events[3].type);
			Assert.areEqual(d.node, events[3].node);

			events = [];
			c.node.replaceChild(b.node, e.node);

			Timer.delay(function(){
				Assert.areEqual(3, events.length);
				Assert.areEqual("added", events[0].type);
				Assert.areEqual(b.node, events[0].node);
				Assert.areEqual("added", events[1].type);
				Assert.areEqual(d.node, events[1].node);
				Assert.areEqual("removed", events[2].type);
				Assert.areEqual(e.node, events[2].node);

				events = [];
				c.node.replaceChild(b.node, b.node);

				Timer.delay(function(){
					Assert.areEqual(true, events.length == 0 || events.length == 4);

					// firefox, ie11
					if(events.length == 4)
					{
						// firefox
						if(events[0].type == "removed")
						{
							Assert.areEqual("removed", events[0].type);
							Assert.areEqual(b.node, events[0].node);
							Assert.areEqual("removed", events[1].type);
							Assert.areEqual(d.node, events[1].node);
							Assert.areEqual("added", events[2].type);
							Assert.areEqual(b.node, events[2].node);
							Assert.areEqual("added", events[3].type);
							Assert.areEqual(d.node, events[3].node);
						}

							// ie11
						else if(events[0].type == "added")
						{
							Assert.areEqual("added", events[0].type);
							Assert.areEqual(b.node, events[0].node);
							Assert.areEqual("added", events[1].type);
							Assert.areEqual(d.node, events[1].node);
							Assert.areEqual("removed", events[2].type);
							Assert.areEqual(b.node, events[2].node);
							Assert.areEqual("removed", events[3].type);
							Assert.areEqual(d.node, events[3].node);
						}
					}
					
					completed = true;
				}, 10);
			}, 10);
		}, 10);
	}
	
	@Test
	public function appendChildException_flushed():Void
	{
		var a = createDiv();
		var events:Array<{type:String, node:Node}> = [];
		var exception:Bool = false;
		a.observe = true;
		a.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			events.push({type:"added", node:cast event.detail});
		});
		try
		{
			a.node.appendChild(a.node);
		}
		catch(error:Dynamic)
		{
			exception = true;
		}
		a.flushObserver();
		Assert.areEqual(0, events.length);
		Assert.areEqual(true, exception);
	}

	@AsyncTest
	public function appendChildException(factory:AsyncFactory):Void
	{
		var completed = false;
		Timer.delay(factory.createHandler(this, function(){Assert.areEqual(true, completed);}, 200), 100);

		var a = createDiv();
		var events:Array<{type:String, node:Node}> = [];
		var exception:Bool = false;
		a.observe = true;
		a.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			events.push({type:"added", node:cast event.detail});
		});
		try
		{
			a.node.appendChild(a.node);
		}
		catch(error:Dynamic)
		{
			exception = true;
		}

		Timer.delay(function(){
			Assert.areEqual(0, events.length);
			Assert.areEqual(true, exception);
			
			completed = true;
		}, 10);
	}
	
	@Test
	public function removeChildException_flushed():Void
	{
		var a = createDiv();
		var b = createDiv();
		var events:Array<{type:String, node:Node}> = [];
		var exception:Bool = false;
		a.observe = true;
		a.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			events.push({type:"added", node:cast event.detail});
		});
		a.addListener(Event.CHILD_REMOVED, function(event:CustomEvent)
		{
			events.push({type:"removed", node:cast event.detail});
		});
		try
		{
			a.node.removeChild(a.node);
		}
		catch(error:Dynamic)
		{
			exception = true;
		}
		a.flushObserver();
		Assert.areEqual(0, events.length);
		Assert.areEqual(true, exception);
		
		exception = false;
		try
		{
			a.node.removeChild(b.node);
		}
		catch(error:Dynamic)
		{
			exception = true;
		}
		a.flushObserver();
		Assert.areEqual(0, events.length);
		Assert.areEqual(true, exception);

		exception = false;
		try
		{
			b.node.removeChild(a.node);
		}
		catch(error:Dynamic)
		{
			exception = true;
		}
		a.flushObserver();
		Assert.areEqual(0, events.length);
		Assert.areEqual(true, exception);
	}

	@AsyncTest
	public function removeChildException(factory:AsyncFactory):Void
	{
		var completed = false;
		Timer.delay(factory.createHandler(this, function(){Assert.areEqual(true, completed);}, 200), 100);

		var a = createDiv();
		var b = createDiv();
		var events:Array<{type:String, node:Node}> = [];
		var exception:Bool = false;
		a.observe = true;
		a.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			events.push({type:"added", node:cast event.detail});
		});
		a.addListener(Event.CHILD_REMOVED, function(event:CustomEvent)
		{
			events.push({type:"removed", node:cast event.detail});
		});
		try
		{
			a.node.removeChild(a.node);
		}
		catch(error:Dynamic)
		{
			exception = true;
		}
		Timer.delay(function(){
			Assert.areEqual(0, events.length);
			Assert.areEqual(true, exception);

			exception = false;
			try
			{
				a.node.removeChild(b.node);
			}
			catch(error:Dynamic)
			{
				exception = true;
			}

			Timer.delay(function(){
				Assert.areEqual(0, events.length);
				Assert.areEqual(true, exception);

				exception = false;
				try
				{
					b.node.removeChild(a.node);
				}
				catch(error:Dynamic)
				{
					exception = true;
				}

				Timer.delay(function(){
					Assert.areEqual(0, events.length);
					Assert.areEqual(true, exception);
					
					completed = true;
				}, 10);
			}, 10);
		}, 10);
	}
	
	@Test
	public function insertBeforeException_flushed():Void
	{
		var a = createDiv();
		var b = createDiv();
		var c = createDiv();
		var d = createDiv();
		var events:Array<{type:String, node:Node}> = [];
		var exception:Bool = false;
		a.node.appendChild(b.node);
		a.node.appendChild(d.node);
		a.observe = true;
		a.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			events.push({type:"added", node:cast event.detail});
		});
		a.addListener(Event.CHILD_REMOVED, function(event:CustomEvent)
		{
			events.push({type:"removed", node:cast event.detail});
		});
		try
		{
			a.node.insertBefore(a.node, a.node);
		}
		catch(error:Dynamic)
		{
			exception = true;
		}
		a.flushObserver();
		Assert.areEqual(0, events.length);
		Assert.areEqual(true, exception);

		exception = false;
		try
		{
			a.node.insertBefore(a.node, c.node);
		}
		catch(error:Dynamic)
		{
			exception = true;
		}
		a.flushObserver();
		Assert.areEqual(0, events.length);
		Assert.areEqual(true, exception);

		exception = false;
		try
		{
			a.node.insertBefore(c.node, c.node);
		}
		catch(error:Dynamic)
		{
			exception = true;
		}
		a.flushObserver();
		Assert.areEqual(0, events.length);
		Assert.areEqual(true, exception);

		exception = false;
		try
		{
			a.node.insertBefore(c.node, a.node);
		}
		catch(error:Dynamic)
		{
			exception = true;
		}
		a.flushObserver();
		Assert.areEqual(0, events.length);
		Assert.areEqual(true, exception);
	}

	@AsyncTest
	public function insertBeforeException(factory:AsyncFactory):Void
	{
		var completed = false;
		Timer.delay(factory.createHandler(this, function(){Assert.areEqual(true, completed);}, 200), 100);

		var a = createDiv();
		var b = createDiv();
		var c = createDiv();
		var d = createDiv();
		var events:Array<{type:String, node:Node}> = [];
		var exception:Bool = false;
		a.node.appendChild(b.node);
		a.node.appendChild(d.node);
		a.observe = true;
		a.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			events.push({type:"added", node:cast event.detail});
		});
		a.addListener(Event.CHILD_REMOVED, function(event:CustomEvent)
		{
			events.push({type:"removed", node:cast event.detail});
		});
		try
		{
			a.node.insertBefore(a.node, a.node);
		}
		catch(error:Dynamic)
		{
			exception = true;
		}

		Timer.delay(function(){
			Assert.areEqual(0, events.length);
			Assert.areEqual(true, exception);

			exception = false;
			try
			{
				a.node.insertBefore(a.node, c.node);
			}
			catch(error:Dynamic)
			{
				exception = true;
			}

			Timer.delay(function(){
				Assert.areEqual(0, events.length);
				Assert.areEqual(true, exception);

				exception = false;
				try
				{
					a.node.insertBefore(c.node, c.node);
				}
				catch(error:Dynamic)
				{
					exception = true;
				}

				Timer.delay(function(){
					Assert.areEqual(0, events.length);
					Assert.areEqual(true, exception);

					exception = false;
					try
					{
						a.node.insertBefore(c.node, a.node);
					}
					catch(error:Dynamic)
					{
						exception = true;
					}

					Timer.delay(function(){
						Assert.areEqual(0, events.length);
						Assert.areEqual(true, exception);
						
						completed = true;
					}, 10);
				}, 10);
			}, 10);
		}, 10);
	}

	@Test
	public function replaceChildException_flushed():Void
	{
		var a = createDiv();
		var b = createDiv();
		var c = createDiv();
		var events:Array<{type:String, node:Node}> = [];
		a.node.appendChild(b.node);
		a.observe = true;
		a.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			events.push({type:"added", node:cast event.detail});
		});
		a.addListener(Event.CHILD_REMOVED, function(event:CustomEvent)
		{
			events.push({type:"removed", node:cast event.detail});
		});
		try
		{
			a.node.replaceChild(a.node, a.node);
		}
		catch(error:Dynamic){}
		a.flushObserver();
		Assert.areEqual(0, events.length);

		try
		{
			a.node.replaceChild(a.node, c.node);
		}
		catch(error:Dynamic){}
		a.flushObserver();
		Assert.areEqual(0, events.length);

		try
		{
			a.node.replaceChild(c.node, c.node);
		}
		catch(error:Dynamic){}
		a.flushObserver();
		Assert.areEqual(0, events.length);

		try
		{
			a.node.replaceChild(c.node, a.node);
		}
		catch(error:Dynamic){}
		a.flushObserver();
		Assert.areEqual(0, events.length);
	}

	@AsyncTest
	public function replaceChildException(factory:AsyncFactory):Void
	{
		var completed = false;
		Timer.delay(factory.createHandler(this, function(){Assert.areEqual(true, completed);}, 200), 100);

		var a = createDiv();
		var b = createDiv();
		var c = createDiv();
		var events:Array<{type:String, node:Node}> = [];
		a.node.appendChild(b.node);
		a.observe = true;
		a.addListener(Event.CHILD_ADDED, function(event:CustomEvent)
		{
			events.push({type:"added", node:cast event.detail});
		});
		a.addListener(Event.CHILD_REMOVED, function(event:CustomEvent)
		{
			events.push({type:"removed", node:cast event.detail});
		});
		try
		{
			a.node.replaceChild(a.node, a.node);
		}
		catch(error:Dynamic){}

		Timer.delay(function(){
			Assert.areEqual(0, events.length);

			try
			{
				a.node.replaceChild(a.node, c.node);
			}
			catch(error:Dynamic){}

			Timer.delay(function(){
				Assert.areEqual(0, events.length);

				try
				{
					a.node.replaceChild(c.node, c.node);
				}
				catch(error:Dynamic){}
				
				Timer.delay(function(){
					Assert.areEqual(0, events.length);

					try
					{
						a.node.replaceChild(c.node, a.node);
					}
					catch(error:Dynamic){}

					Timer.delay(function(){
						Assert.areEqual(0, events.length);
						
						completed = true;
					}, 10);
				}, 10);
			}, 10);
		}, 10);
	}
}