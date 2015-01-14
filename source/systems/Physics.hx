package systems;

import nape.callbacks.CbType;
import nape.geom.Vec2;
import nape.space.Space;

/** Details the main physics space **/
class Physics
{
	public static var space:Space;
	public static var velIterations:Int = 10;
	public static var posIterations:Int = 10;
	
	public static function create(gravity:Vec2)
	{
		space = new Space(gravity);
	}
	
	public static function integrate(dt:Float)
	{
		space.step(dt, velIterations, posIterations);
	}
}

/** Callbacks help filter out physical interaction types **/
class Callbacks
{
	public static var base	:CbType = new CbType(); // Bases that enter the simultation region
	public static var entity:CbType = new CbType();	// Entity types that exit the simulation region
	public static var oneway:CbType = new CbType();	// Callback for oneway platforms (e.g. feet)
}