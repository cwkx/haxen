package systems;

import haxe.Json;
import haxe.Serializer;
import haxe.Unserializer;

/** Serialization in json (default recommended) and string forms with checking with error checking **/
class Serialize
{
	public static inline function toJson(value:Dynamic):String
	{
		return Json.stringify(value);
	}
	
	public static function fromJson(text:String, out:Dynamic):Bool
	{
		try
		{
			out = Json.parse(text);
			return true;
		} 
		catch (e:Dynamic)
		{
			trace("Could not parse json!");
			return false;
		}
		return true;
	}
	
	public static inline function toString(value:Dynamic):String
	{
		return Serializer.run(value);
	}
	
	public static function fromString(text:String, out:Dynamic):Bool
	{
		try
		{
			out = Unserializer.run(text);
			return true;
		}
		catch (e:Dynamic)
		{
			trace("Could not parse string!");
			return false;
		}
		return true;
	}
}