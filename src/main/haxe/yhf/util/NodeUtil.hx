package yhf.util;

import js.html.Node;

class NodeUtil
{
	/**
	 * In some browsers (IE), Std.is(node, constructor) would just not work.
	 **/
	public static function is(node:Node, constructor:Class<Node>)
	{
		return untyped __js__("node instanceof constructor");
	}
}
