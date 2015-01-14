package systems;

import haxe.Json;
import haxe.macro.Context;
import haxe.macro.Expr;
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
	
	@macro public static function build() : Array<Field>
	{
		var pos = Context.currentPos();
		var fields : Array<Field> = Context.getBuildFields();
		var serializeCalls : Array<Expr> = new Array<Expr>();
		var unserializeCalls : Array<Expr> = new Array<Expr>();
		
		//Get all serializable fields
		for (field in fields)
		{
			for (meta in field.meta)
			{
				if (meta.name == "serialize")
				{
					var fieldName = field.name;
					serializeCalls.push(macro s.serialize($i{fieldName}));
					unserializeCalls.push(macro $i{fieldName} = u.unserialize() );
				}
			}
		}
		
		//Create methods
		var hxSerialize : FieldType = FFun( {
			ret: null,
			params: [],
			expr: {
				pos: pos,
				expr: EBlock(serializeCalls)
			},
			args: [ {
					value: null,
					type: macro : haxe.Serializer,
					opt: false,
					name: "s"
				}]
		});
		var hxUnserialize : FieldType = FFun( {
			ret: null,
			params: [],
			expr: {
				pos: pos,
				expr: EBlock(unserializeCalls)
			},
			args: [ {
					value: null,
					type: macro : haxe.Unserializer,
					opt: false,
					name: "u"
				}]
		});
		
		fields.push( { pos:pos, name:"hxSerialize", meta:[], kind: hxSerialize, doc: null, access:[APublic] } ); 
		fields.push( { pos:pos, name:"hxUnserialize", meta:[], kind: hxUnserialize, doc: null, access:[APublic] } ); 
		
		return fields;
	}
}

@:autoBuild(systems.Serialize.build())
interface Serializable {}