package entities;

import entities.Entity;
import haxe.Json;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.Lib;
import systems.Canvas;
import systems.Serialize;

/** Serializable **/
private class Data
{
	public var sprite:String = "assets/art/openfl.png";
	public var smooth:Bool = true;
	
	public function new() {}
}

/** A sprite is a physical non-animated visual entity. **/
class Sprite extends Entity
{
	public var sprite:openfl.display.Sprite;
	public var data:Data;
	
	/** Create the sprite instance **/
	override public function init()
	{
		super.init();
		
		if (Serialize.fromJson(base.json, data) == false)
		{
			data = new Data();
			trace("Error parsing json, using default:\n" + Serialize.toJson(data));
		}
		
		sprite = new flash.display.Sprite();
		
		var bitmap = new Bitmap (Assets.getBitmapData(data.sprite));
			bitmap.smoothing = data.smooth;
		
		sprite.addChild(bitmap);
		
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