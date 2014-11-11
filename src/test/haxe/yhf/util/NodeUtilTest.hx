package yhf.util;

import js.html.StyleElement;
import js.html.Node;
import js.html.Element;
import js.html.DivElement;
import js.Browser;

import massive.munit.Assert;

class NodeUtilTest
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

	@Test
	public function createdElement_isExpectedType():Void
	{
		var div = Browser.document.createDivElement();
		Assert.areEqual(true, NodeUtil.is(div, DivElement));
		Assert.areEqual(true, NodeUtil.is(div, Element));
		Assert.areEqual(true, NodeUtil.is(div, Node));

		var style = Browser.document.createStyleElement();
		Assert.areEqual(true, NodeUtil.is(style, StyleElement));
		Assert.areEqual(true, NodeUtil.is(style, Element));
		Assert.areEqual(true, NodeUtil.is(style, Node));
		Assert.areEqual(false, NodeUtil.is(style, DivElement));
	}
}