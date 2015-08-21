package ludum;

import js.three.Geometry;
import js.three.Material;
import js.three.Mesh;

class DescribableMesh extends Mesh implements Describable {
	public var hoverText(default, null):String;
	private var clickMessages:Array<String>;
	
	public function new(geometry:Geometry, material:Material, hoverText:String, clickText:Array<String>) {
		super(geometry, material);
		this.hoverText = hoverText;
		this.clickMessages = clickText;
	}
	
	public function clickText(click:Int):String {
		if (clickMessages.length == 0) {
			return hoverText;
		}
		
		return clickMessages[Std.int(MathUtils.clamp(click, 0, clickMessages.length - 1))];
	}
}