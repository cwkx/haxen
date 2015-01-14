package entities;

import nape.phys.Body;
import systems.Base;

/** An entity is a physical instance of a base. **/
class Entity
{	
	// The physical body and a mapping to the parent base
	public var body:Body;
	public var base:Base;
	
	/** Init the entity instance and optionally load from base.json **/
	public function init() {}
	
	/** Called before the physics integration **/
	public function phys() {}
	
	/** Called before drawing **/
	public function draw() {}
	
	/** Remove the instance data and optionally save to base.json **/
	public function kill() {}
	
	/** Never override this - always use init() instead **/
	private function new() {}
}