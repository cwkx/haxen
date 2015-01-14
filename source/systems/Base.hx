package systems;

import entities.Entity;
import nape.phys.Body;
import systems.Physics;

/** Defines a physical entity in the game world (the static base). **/
class Base
{
	// The physical body and a mapping to the child entity.
	public var body:Body;
	public var entity:Entity;
	public var type:String;	  // Type, e.g. "Anim", "Tiled"
	public var json:String;	  // Instance attributes for saving in JSON format

	public function new() 
	{
		body = new Body();
		body.space = Physics.space;
		body.cbTypes.add(Callbacks.base);
		body.userData.base = this;
	}
}