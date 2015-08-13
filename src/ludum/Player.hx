package ludum;

import js.Browser;
import js.three.Geometry;
import js.three.Mesh;
import js.three.MeshBasicMaterial;
import js.three.PlaneGeometry;
import js.three.Vector2;
import js.three.Vector3;
import msignal.Signal;

class Player extends Mesh {
	public var signal_PositionChanged(default, null) = new Signal1<Vector3>();
	
	private static inline var baseVelocity:Float = 200; // Pixels per second
	private var velocity = new Vector2();
	
	public function new(width:Float, height:Float) {
		super(new PlaneGeometry(width, height), new MeshBasicMaterial( { color:0x203040 } ));
		
		Browser.document.addEventListener('keydown', function(event) {
			var keyCode:Int = event.keyCode;
			
			switch(keyCode) {
				case 37:
					velocity.x = -baseVelocity;
				case 38:
					
				case 39:
					velocity.x = baseVelocity;
				case 40:
					
				default:
			}
		}, false);
		
		Browser.document.addEventListener('keyup', function(event) {
			var keyCode:Int = event.keyCode;
			
			switch(keyCode) {
				case 37:
					velocity.x = 0;
				case 38:
					
				case 39:
					velocity.x = 0;
				case 40:
					
				default:
			}
		}, false);
	}
	
	public function update(dt:Float):Void {		
		position.x += velocity.x * dt;
		position.y += velocity.y * dt;
		
		if(velocity.x != 0 || velocity.y != 0) {
			signal_PositionChanged.dispatch(position);
		}
	}
}