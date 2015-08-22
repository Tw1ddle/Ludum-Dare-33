package ludum;

import external.particle.Emitter;
import external.particle.Group;
import js.three.Object3D;
import js.three.Vector2;
import js.three.Vector3;
import msignal.Signal;

class Enemy extends Object3D {
	public var signal_PositionChanged(default, null) = new Signal1<Vector3>();
	public var signal_Died(default, null) = new Signal0();
	
	private var baseVelocity:Float = 125; // Pixels per second
	private var velocity = new Vector2();
	
	public var particleGroup(default, null):Group;
	public var particleEmitter(default, null):Emitter;
	
	public function new() {
		super();
	}
	
	public function tweenPosition():Void {
		// TODO get next position in upper quartile of screen, or relative to player?
	}
	
	public inline function update(dt:Float):Void {
	}
}