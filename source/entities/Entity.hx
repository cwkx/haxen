package entities;

import nape.geom.Vec2;
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

/** Serializable data for all entities **/
class EntityData
{
	public var x:Float = 0.0;
	public var y:Float = 0.0;
	public var w:Float = 16.0;
	public var h:Float = 16.0;
	
	public function new() {}
}