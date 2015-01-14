package entities;

import haxe.ds.StringMap;

class Node extends Entity
{
	public var name:String = "Node";
	public var parent:Node = null;
	public var children:StringMap<Node>;
	
	// add warning, could not add child, name already exists!
}