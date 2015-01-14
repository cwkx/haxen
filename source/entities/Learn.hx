package entities;

import haxe.Json;

/** Example entity for learning purposes. **/
class Learn extends Entity
{
	public var data1:String;
	public var data2:Int;
	
	/** Creates an instance of the entity with default non-unique data **/
	override public function init()
	{
		super.init();
		data1 = "data that doesn't get saved to base.json";
		data2 = Json.parse(base.json);
	}
	
	/** Updates the instance data before physics integration **/
	override public function phys()
	{
		super.phys();
		data2 += 2;
	}
	
	/** Updates the instance data before drawing **/
	override public function draw()
	{
		super.draw();
		data2--;
	}
	
	/** Removes the instance data **/
	override public function kill()
	{
		super.kill();
		
		base.json = Json.stringify(data2); // (optional)
		base.body.position = body.position; // (optional)
		data1 = null;
	}
}