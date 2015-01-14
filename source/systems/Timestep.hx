package systems;

import openfl.Lib;

/** Precise time steps via type = fixed, varying, bounded, or discrete deltas. **/
class Timestep
{
	// Time elapsed since last frame
	public static var ms:Int = 0;
	public static var delta:Float = 0.0;
	
	// Custom mapping functions
	public static dynamic function type		(frame:Float, dt:Float) {} // Map the step type
	public static dynamic function phys		() {} // Map the code called before integration
	public static dynamic function integrate(dt:Float) {} // Map the physics integration
	public static dynamic function draw		() {} // Map the code called before drawing
	
	// Internal data (accBuffer stays around delta so there's no floating point issues)
	private static var prvTime :Int   = 0;
	private static var accBuff :Float = 0.0;
	
	/** Basic fixed time step: slows down but stable **/
	public static inline function fixed(frame:Float, dt:Float):Void
	{
		integrate(dt);
	}
	
	/** Basic varying time step: unstable physics **/
	public static inline function variable(frame:Float, dt:Float):Void
	{
		integrate(frame * 0.001);
	}
	
	/** Bounded varying timestep: never pass a delta greater than some maximum: good **/
	public static inline function bounded(frame:Float, dt:Float):Void
	{
		while (frame > 0.0)
		{
			var deltaTime:Float = Math.min(frame * 0.001, dt);
			integrate(deltaTime);
			frame -= deltaTime * 1000.0;
		}
	}
	
	/** Ensure discrete fixed time steps (recommended) **/
	public static inline function discrete(frame:Float, dt:Float):Void
	{
		accBuff += frame; // this then gets reduced
		
		var o:Float = dt * 1000.0;
		
		while (0.001 * accBuff >= dt)
		{
			integrate(dt);
			accBuff -= o; // reduced here
		}
	}
	
	/** Updates the timestep and calls the mapped functions **/
	public static function update():Void
	{
		var time:Int = Lib.getTimer();
		var dt:Float = 1.0 / Lib.current.stage.frameRate;

		ms = time - prvTime;
		delta = 0.001 * ms;
		prvTime = time;
		
		phys();
		type(ms, dt);
		draw();
	}
}