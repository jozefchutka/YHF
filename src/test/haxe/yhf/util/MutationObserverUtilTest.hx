package yhf.util;

import js.Browser;

import massive.munit.Assert;

class MutationObserverUtilTest
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
	public function fixedInsertBefore_emptyRefChild_handlesJustLikeNative():Void
	{
		var a = Browser.document.createDivElement();
		var b = Browser.document.createDivElement();
		var c = Browser.document.createDivElement();
		a.insertBefore(b, null);
		a.insertBefore(c, null);

		Assert.areEqual(a.firstChild, b);
		Assert.areEqual(a.firstChild.nextSibling, c);

		MutationObserverUtil.fix();
		var a = Browser.document.createDivElement();
		var b = Browser.document.createDivElement();
		var c = Browser.document.createDivElement();
		a.insertBefore(b, null);
		a.insertBefore(c, null);

		Assert.areEqual(a.firstChild, b);
		Assert.areEqual(a.firstChild.nextSibling, c);
	}
}