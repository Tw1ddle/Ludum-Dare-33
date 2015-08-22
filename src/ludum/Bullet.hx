package ludum;

import js.three.Object3D;
import js.three.Vector2;

// TODO need to give the bullet a destination and a speed
// TODO should signal expiry etc
// TODO work out how to rate limit these
class Bullet extends Object3D {
	public var velocity = new Vector2();
	
	public function new() {
		super();
	}
	
	public inline function update(dt:Float):Void {
	}
}