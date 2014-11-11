package yhf.util;

import js.Browser;

import massive.munit.Assert;

class CssUtilTest
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
	public function applyStyle_affects_getStyle():Void
	{
		CssUtil.applyStyle("body {border: 1px solid red;}");
		var color = CssUtil.getStyle(Browser.document.body, "borderTopColor");
		Assert.areEqual("rgb(255, 0, 0)", color);
	}
}