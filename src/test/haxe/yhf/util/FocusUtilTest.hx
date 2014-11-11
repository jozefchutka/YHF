package yhf.util;

import js.Browser;

import massive.munit.Assert;

class FocusUtilTest
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
	public function focusedElement_getterAndSetter():Void
	{
		var a = Browser.document.createDivElement();
		Browser.document.body.appendChild(a);
		FocusUtil.focusedElement = a;
		Assert.areEqual(a, FocusUtil.focusedElement);
	}

	@Test
	public function focusedElement_hasFocusAttribute():Void
	{
		CssUtil.applyStyle("div:focus {border: 1px solid red;}");

		var a = Browser.document.createDivElement();
		Browser.document.body.appendChild(a);
		FocusUtil.focusedElement = a;

		var color = CssUtil.getStyle(a, "borderTopColor");
		Assert.areEqual("rgb(255, 0, 0)", color);
	}
}