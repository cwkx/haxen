package entities;

import entities.Entity;
import haxe.Json;
import nape.geom.Vec2;
import nape.shape.Polygon;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.Lib;
import systems.Canvas;
import systems.Serialize;

/** A sprite is a physical non-animated visual entity. **/
class Sprite extends Entity
{
	public var sprite:openfl.display.Sprite;
	public var data:SpriteData;
	
	/** Create the sprite instance **/
	override public function init()
	{
		super.init();
		
		if (Serialize.fromJson(base.json, data) == false)
		{
			data = new SpriteData();
			trace("Error parsing json, using default:\n" + Serialize.toJson(data));
		}
		
		sprite = new openfl.display.Sprite();
		
		var bitmap = new Bitmap (Assets.getBitmapData(data.sprite));
			bitmap.smoothing = data.smooth;
		
		sprite.addChild(bitmap);
		
		body.shapes.add(new Polygon(Polygon.rect(data.x, data.y, data.w, data.h)));
		body.allowMovement = data.moveable;
		body.allowRotation = data.rotatable;
		
		Canvas.main.addChild(sprite);
	}
	
	/** Only gets called for contributing sprites **/
	override public function draw()
	{
		super.draw();
		
		sprite.x = body.position.x;
		sprite.y = body.position.y;
		
		if (body.allowRotation)
			sprite.rotation = body.rotation * 57.295779513082320876798;
	}
	
	/** Cleanup **/
	override public function kill()
	{
		super.kill();
		data = null;
	}
}

/** Serializable sprite data **/
class SpriteData extends EntityData
{
	public var sprite:String = "assets/art/openfl.png";
	public var smooth:Bool = true;
	public var rotatable:Bool = true;
	public var moveable:Bool = true;
	
	public function new() { super(); }
}