package systems;

import entities.Entity;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.callbacks.PreCallback;
import nape.callbacks.PreFlag;
import nape.callbacks.PreListener;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import openfl.Lib;
import systems.Physics.Callbacks;

/** Handle the logic of activating and updating entities within the simulation region. **/
class Simulation
{
	public var inner:Body;
	public var outer:Body;
	
	private var enter:InteractionListener;
	private var exit:InteractionListener;
	
	public function new() 
	{
		Physics.space.clear();
		
		var innerBounds = Vec2.get(320 / 3, 240 / 3);
		var outerBounds = Vec2.get(640 / 3, 480 / 3);
			
		// innerBounds = Vec2(Lib.current.stage.width, Lib.current.stage.height);
		// outerBounds = innerBounds.mul(2.0);
		
		inner = new Body(BodyType.KINEMATIC);
		outer = new Body(BodyType.KINEMATIC);
		inner.shapes.add(new Polygon(Polygon.rect(0, 0, innerBounds.x, innerBounds.y)));
		outer.shapes.add(new Polygon(Polygon.rect(0, 0, outerBounds.x, outerBounds.y)));
		inner.shapes.at(0).sensorEnabled = true;
		outer.shapes.at(0).sensorEnabled = true;
		
		var innerType = new CbType();
		var outerType = new CbType();
			inner.cbTypes.add(innerType);
			outer.cbTypes.add(outerType);
			inner.space = Physics.space;
			outer.space = Physics.space;
			
		enter = new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, innerType, Callbacks.base, 	baseEnter);
		exit  = new InteractionListener(CbEvent.END,   InteractionType.SENSOR, outerType, Callbacks.entity, entityExit);
		
		Physics.space.listeners.add(enter);
		Physics.space.listeners.add(exit);
		Physics.space.listeners.add(new PreListener(InteractionType.COLLISION, Callbacks.oneway, CbType.ANY_BODY, oneWay));
	}
	
	/** Precallback to handle one-way collision, such as one-way platforms **/
	private function oneWay(cb:PreCallback):PreFlag
	{
		if ((cb.arbiter.collisionArbiter.normal.y >= 0.0) != cb.swapped)
			return PreFlag.IGNORE;
		else
			return PreFlag.ACCEPT;
	}
	
	/** Base enters the simulation **/
	private function baseEnter(cb:InteractionCallback)
	{
		var body:Body = cb.int2.castBody;
		var base:Base = body.userData.base;
		
		if (base == null)
		{
			trace("Error: A non-base entered the simulation region! (check the CbTypes)");
			return;
		}
		
		if (base.entity == null)
		{
			var entity:Entity = Type.createInstance(Type.resolveClass("entities."+base.type), []);
				entity.body = new Body(BodyType.DYNAMIC);
				entity.body.cbTypes.add(Callbacks.entity);
				entity.body.space = Physics.space;
				entity.body.userData.entity = entity;
			
			entity.base = base;
			base.entity = entity;
			
			entity.init();
		}		
	}
	
	/** Entity instance leaves the simulation **/
	private function entityExit(cb:InteractionCallback)
	{
		var body:Body = cb.int2.castBody;
		var entity:Entity = body.userData.entity;
		
		if (entity == null)
		{
			trace("Error: A non-entity exited the simulation region! (check the CbTypes)");
			return;
		}
		
		// Remove and unreference
		entity.kill();
		Physics.space.bodies.remove(body);
		entity.base.body.userData.entity = null;
		body = null;
	}
}
