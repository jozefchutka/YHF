package js.html;

/**
 * MutationObserverInit is an object which can specify the following properties:
 * 
 * NOTE: At the very least, childList, attributes, or characterData must be set to true. Otherwise, 
 * "An invalid or illegal string was specified" error is thrown.
 **/

typedef MutationObserverInit = 
{
	/**
	 * Set to true if additions and removals of the target node's child elements (including text nodes) are to be observed.
	 **/
	@:optional var childList:Bool;
	
	/**
	 * Set to true if mutations to target's attributes are to be observed.
	 **/
	@:optional var attributes:Bool;

	/**
	 * Set to true if mutations to target's data are to be observed.
	 **/
	@:optional var characterData:Bool;

	/**
	 * Set to true if mutations to not just target, but also target's descendants are to be observed.
	 **/
	@:optional var subtree:Bool;

	/**
	 * Set to true if attributes is set to true and target's attribute value before the mutation needs to be recorded.
	 **/
	@:optional var attributeOldValue:Bool;

	/**
	 * Set to true if characterData is set to true and target's data before the mutation needs to be recorded.
	 **/
	@:optional var characterDataOldValue:Bool;

	/**
	 * Set to an array of attribute local names (without namespace) if not all attribute mutations need to be observed.
	 **/
	@:optional var attributeFilter:Array<String>;
}