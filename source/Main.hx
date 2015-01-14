package;

import motion.Actuate;
import motion.easing.Elastic;
import nape.geom.Vec2;
import nape.phys.BodyType;
import nape.shape.Polygon;
import openfl.Lib;
import systems.Base;
import systems.Canvas;

// Setup the main window, frame rate, resolution and game loop.
class Main extends Canvas
{
	var base:Base;
	var logo:Base;
	
	public function new ()
	{
		Canvas.main = this;
		super(Vec2.weak(0, 9.81));
		
		// Test
		base = new Base("Anim", null );
		
		// base.json = "{columns:9,tileWidth:200,rows:9,smooth:false,tileHeight:300,spritesheet:\"assets/art/spritesheet.png\",animations:[],play:null}";
		
		logo = new Base("Sprite", null );
		
		Actuate.tween (Canvas.main, 6, { scaleX: 2, scaleY: 2 } ).delay (0.4).ease (Elastic.easeOut);
	}
}