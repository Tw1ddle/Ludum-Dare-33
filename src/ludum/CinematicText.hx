package ludum;

import js.three.Mesh;
import js.three.MeshBasicMaterial;
import js.three.Object3D;
import js.three.TextGeometry;
import msignal.Signal;

class CinematicText extends Object3D {
	private var letters:Array<Mesh> = new Array<Mesh>();
	public var signal_Complete(default, null):Signal0 = new Signal0();
	
	public function new() {
		super();
		
		#if debug
		name = "Cinematic Text";
		#end
	}
	
	public function init(message:String):Void {
		var material = new MeshBasicMaterial( { color: 0xAA55AA, overdraw: 0.5 } );
		
		for (i in 0...message.length) {
			var geometry = new TextGeometry(message.charAt(i), {
				size: 80,
				height: 20,
				curveSegments: 2,
				font: "helvetiker"
			});
			
			var mesh = new Mesh(geometry, material);
			
			mesh.visible = false;
			
			letters.push(mesh);
			add(mesh);
		}
		
		var x:Int = 0;
		for (letter in letters) {
			letter.position.x = x;
			x += 60;
		}
	}
	
	public function tween():Void {
		for (letter in letters) {
			
		}
	}
}