package systems;

import entities.Entity;
import nape.phys.Body;
import nape.shape.Polygon;
import openfl.geom.Rectangle;
import systems.Physics;

/** Defines a physical entity in the game world (the static base). **/
class Base
{
	// The physical body and a mapping to the child entity.
	public var body:Body;
	public var entity:Entity;
	public var type:String;	  // Type, e.g. "Anim", "Tiled"
	public var json:String;	  // Instance attributes for saving in JSON format

	/** Constructs a new base body **/
	public function new(type:String, json:String) 
	{
		body = new Body();
		body.space = Physics.space;
		body.cbTypes.add(Callbacks.base);
		body.userData.base = this;
		
		this.type = type;
		this.json = json;
		
		var rect:Rectangle = bounds();
		body.shapes.add(new Polygon(Polygon.rect(0.0, 0.0, rect.width, rect.height)));
		body.position.x = rect.x;
		body.position.y = rect.y;
		rect = null;
	}
	
	/** Gets the bounds from the entities json data **/
	public inline function bounds():Rectangle
	{
		var rect:Rectangle = new Rectangle(0.0, 0.0, 16.0, 16.0);
		var data:Dynamic = new EntityData();
		Serialize.fromJson(json, data);
		try
		{
			rect.x = data.x;
			rect.y = data.y;
			rect.width = data.w;
			rect.height = data.h;
		}
		return rect;
	}
}