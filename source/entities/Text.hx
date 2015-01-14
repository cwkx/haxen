package entities;

import haxe.Json;
import openfl.Assets;
import openfl.text.TextField;
import openfl.text.TextFormat;

/** Serializable **/
private typedef Data =
{
	var text:String;
	var font:String;
	var size:Int;
	var rgb:Int;
}

/** A text entity. **/
class Text extends Entity
{
	public var field:TextField;
	public var data:Data;
	
	override public function init() 
	{
		super.init();
		
		data = Json.parse(base.json);
		
		field = new TextField();
		
		if (data.font != null)
		{
			var font = Assets.getFont(data.font);
			field.defaultTextFormat = new TextFormat(font.fontName, data.size, data.rgb);
		}
		
		field.text = data.text;
	}
	
	override public function kill()
	{
		super.kill();
		data = null;
	}
}