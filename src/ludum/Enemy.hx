package ludum;

import external.particle.Emitter;
import external.particle.Group;
import js.Browser;
import js.three.ImageUtils;
import js.three.Mesh;
import js.three.Object3D;
import js.three.Scene;
import js.three.Vector2;
import js.three.Vector3;
import motion.Actuate;
import motion.easing.Quad;
import msignal.Signal;

class Enemy extends Mesh implements Describable {
	public var signal_PositionChanged(default, null) = new Signal1<Vector3>();
	public var signal_Died(default, null) = new Signal0();
	
	private var baseVelocity:Float = 125; // Pixels per second
	private var velocity = new Vector2();
	
	public var particleGroup(default, null):Group;
	public var particleEmitter(default, null):Emitter;
	
	public var hoverText(default, null):String;
	private var clickMessages:Array<String> = new Array<String>();
	
	public function new(scene:Scene, x:Float, y:Float, ?hoverText:String = "A vile spirit...") {
		super();
		
		this.hoverText = hoverText;
		
		position.set(x, y, -1400);
		
		// Particle emitter
		particleGroup = new Group( { texture: ImageUtils.loadTexture('assets/images/darkfly.png'), maxAge: 5 } );
		particleEmitter = new Emitter({
			type: 'cube',
			position: this.position,
			acceleration: new Vector3(0, 0, 0),
			velocity: new Vector3(0, 0, 0),
			velocitySpread: new Vector3(7, 3, 0),
			accelerationSpread: new Vector3(21, 30, 0),
			particleCount: 700,
			sizeStart: 42,
			sizeEnd: 60,
			opacityStart: 0.9,
			opacityEnd: 0.0
		});
		
		#if debug
		name = "Enemy";
		particleGroup.mesh.name = "Enemy Particle Group";
		#end
		
		particleGroup.addEmitter(particleEmitter);
		particleGroup.mesh.frustumCulled = false;
		scene.add(particleGroup.mesh);
		
		scene.add(this);
	}
	
	public function reset():Void {
		particleEmitter.position = this.position;
		particleEmitter.acceleration.set(0, 0, 0);
		particleEmitter.velocity.set(0, 0, 0);
		particleEmitter.velocitySpread.set(7, 3, 0);
		particleEmitter.accelerationSpread.set(21, 30, 0);
		particleEmitter.particleCount = 700;
		particleEmitter.sizeStart = 42;
		particleEmitter.sizeEnd = 60;
		particleEmitter.opacityStart = 0.9;
		particleEmitter.opacityEnd = 0.0;
	}
	
	public inline function update(dt:Float):Void {
		particleEmitter.position.set(position.x, position.y, position.z);
		
		particleGroup.tick(dt);
	}
	
	public function clickText(click:Int):String {
		if (clickMessages.length == 0) {
			return hoverText;
		}
		
		if (click > clickMessages.length) {
			return Player.randomMessage(Std.int(Math.random() * 3));
		}
		
		return clickMessages[Std.int(MathUtils.clamp(click, 0, clickMessages.length - 1))];
	}
}