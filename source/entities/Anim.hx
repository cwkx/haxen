package entities;

import entities.Entity;
import flash.display.BitmapData;
import openfl.Assets;
import spritesheet.AnimatedSprite;
import spritesheet.data.BehaviorData;
import spritesheet.importers.BitmapImporter;
import spritesheet.Spritesheet;
import systems.Canvas;
import systems.Serialize;
import systems.Timestep;

/** Serializable **/
private class Data
{
	public var spritesheet:String = "assets/art/spritesheet.png";
	public var columns:Int = 9;
	public var rows:Int = 9;
	public var tileWidth:Int = 200;
	public var tileHeight:Int = 100;
	public var smooth:Bool = false;
	public var animations:Array<Animation> = new Array<Animation>();
	public var play:String = null;
	
	public function new() {}
}

/** Serializable **/
private class Animation
{
	public var name:String = "animation name";
	public var frames:Array<Int> = [0];
	public var loop:Bool = true;
	public var fps:Int = 20;
	public var originX:Float = 0.0;
	public var originY:Float = 0.0;
	
	public function new() {}
}

/** An anim is a physical animated visual entity for key-frame animation stored in a spritesheet. **/
class Anim extends Entity
{
	public var sprite:AnimatedSprite;
	public var data:Data;
	
	/** Creates an instance of the animation entity **/
	override public function init()
	{
		super.init();
	
		if (Serialize.fromJson(base.json, data) == false)
		{
			data = new Data();
			trace("Error parsing json, using default:\n" + Serialize.toJson(data));
		}
		
		var a:Animation = new Animation();
			a.name = "test";
			a.frames = [for (i in 0 ... 76) i];
		data.animations.push(a);
		data.play = "test";
		
		// Load Spritesheet Source
		var bitmap:BitmapData = Assets.getBitmapData(data.spritesheet);
		
		// Parse Spritesheet
		var spritesheet:Spritesheet = BitmapImporter.create(bitmap, data.columns, data.rows, data.tileWidth, data.tileHeight);

		for (a in data.animations)
			spritesheet.addBehavior(new BehaviorData(a.name, a.frames, a.loop, a.fps, a.originX, a.originY));

		sprite = new AnimatedSprite(spritesheet, data.smooth);
		
		sprite.showBehavior(data.play);
		
		// Todo: canvas layers, addChildAt() in draw if layer index changed, or sprite groups?
		Canvas.main.addChild(sprite);
	}
	
	/** Only gets called for contributing anim instances **/
	override public function draw()
	{
		super.draw();
		
		sprite.update(Timestep.ms);
		
		sprite.x = body.position.x;
		sprite.y = body.position.y;
		
		if (body.allowRotation)
			sprite.rotation = body.rotation * 57.295779513082320876798;
	}
	
	/** Cleanup **/
	override public function kill()
	{
		super.kill();
		
		for (a in data.animations)
			 a.frames = null;

		data.animations = null;
		data = null;
	}
}