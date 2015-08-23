package ludum;

import js.three.BoundingBox;
import js.three.Box3;
import js.three.Mesh;
import js.three.MeshBasicMaterial;
import js.three.Object3D;
import js.three.TextGeometry;
import msignal.Signal;
import motion.Actuate;
import motion.easing.*;

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
		for (i in 0...message.length) {
			var material = new MeshBasicMaterial( { color: 0x990000, overdraw: 0.5, transparent: true, opacity: 1.0 } );
			
			var geometry = new TextGeometry(message.charAt(i), {
				size: 24,
				height: 20,
				curveSegments: 2,
				font: "absender"
			});
			
			var mesh = new Mesh(geometry, material);
			
			letters.push(mesh);
			add(mesh);
		}
		
		var x:Int = 0;
		for (letter in letters) {
			letter.position.x = x;
			letter.scale.z = 0.0;
			letter.material.opacity = 0.0;
			x += 18;
		}
	}
	
	public function tween(?onTweenInComplete:Void->Void = null, ?onTweenOutComplete:Void->Void = null):Void {
		var tweenDuration:Float = letters.length * 0.15; // 0.15 seconds per letter in the text
		
		for (i in 0...letters.length) {
			// Tween down and across slightly
			Actuate.tween(letters[i].position, tweenDuration, { x: letters[i].position.x - 300, y: letters[i].position.y + 30 } ).delay(i * 0.1).ease(Sine.easeInOut);
			
			// Tween alpha in, and on complete fade and move out again
			Actuate.tween(letters[i].material, tweenDuration, { opacity: 1 } ).onComplete(function(v:Dynamic) {
					if (i == letters.length - 1 && onTweenInComplete != null) {
						onTweenInComplete();
					}
				
				Actuate.tween(letters[i].material, tweenDuration, { opacity: 0 } );
				Actuate.tween(letters[i].position, tweenDuration, { x: letters[i].position.x - 300, y: letters[i].position.y + 30 } ).ease(Sine.easeInOut).onComplete(function(v:Dynamic) {
					if (i == letters.length - 1 && onTweenOutComplete != null) {
						onTweenOutComplete();
					}
				});
			}).delay(i * 0.1);
		}
	}
	
	public function update(dt:Float):Void {
		
	}
	
	public inline function computeBoundingBox():Box3 {
		return new Box3().setFromObject(this);
	}
}