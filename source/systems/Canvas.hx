package systems;

import entities.Sprite;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.KeyboardEvent;
import nape.geom.Vec2;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import systems.Canvas;
import systems.Input;
import systems.Physics;
import systems.Timestep;

/** Canvas holds the main game sprite which manages the top-level game loop **/
class Canvas extends openfl.display.Sprite
{
	public static var main:Canvas;
	
	/** Create a new canvas with the physics simulation and time stepping **/
	public function new(gravity:Vec2, fps:Float = 60.0) 
	{
		super();
		
		Lib.current.stage.scaleMode = StageScaleMode.EXACT_FIT;
		Lib.current.stage.frameRate = fps;
        
		Physics.create(gravity);
		
		Timestep.type 		= Timestep.discrete;
		Timestep.integrate 	= Physics.integrate;
		Timestep.phys 		= phys;
		Timestep.draw 		= draw;
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, 	   update);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP,   Input.onKeyUp);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, Input.onKeyDown);
		
		Lib.current.stage.addChild(this);
		
		new Simulation();
	}
	
	/** Update is called once per frame before drawing **/
    public function update(e:Event):Void
    {
		Timestep.update();
    }
	
	/** Called by update before physics integration according to the step function **/
	public function phys():Void
	{
		for (body in Physics.space.bodies)
		{
			if (body.userData.entity != null)
				body.userData.entity.phys();
		}
	}
	
	/** Called once per frame before drawing **/
	public function draw():Void
	{
		for (body in Physics.space.bodies)
		{
			if (body.userData.entity != null)
				body.userData.entity.draw();
		}
	}
}