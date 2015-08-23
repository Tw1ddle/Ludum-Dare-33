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

class Player extends Mesh {	
	public var signal_PositionChanged(default, null) = new Signal1<Vector3>();
	public var signal_Died = new Signal0();
	
	public var pressedArrowKey:Bool = false;
	
	public var baseVelocity:Float = 125; // Pixels per second
	private var velocity = new Vector2();
	
	public var particleGroup(default, null):Group;
	public var particleEmitter(default, null):Emitter;
	
	public var blastParticleGroup(default, null):Group;
	public var blastParticleEmitter(default, null):Emitter;
	
	public var inputEnabled(default, set):Bool = true;
	
	public function new(scene:Scene, x:Float, y:Float, width:Float, height:Float) {
		super();
		
		position.set(x, y, -1400);
		
		width = 1000;
		height = 1000;
		
		// Particle emitter
		particleGroup = new Group( { texture: ImageUtils.loadTexture('assets/images/flamefly.png'), maxAge: 5 } );
		particleEmitter = new Emitter({
			type: 'cube',
			position: this.position,
			acceleration: new Vector3(0, 0, 0),
			velocity: new Vector3(0, 0, 0),
			velocitySpread: new Vector3(10, 10, 10),
			particleCount: 3000,
			alive: 0.1,
			sizeStart: 12,
			sizeEnd: 42,
			opacityStart: 0.9,
			opacityEnd: 0
		});
		
		blastParticleGroup = new Group( { texture: ImageUtils.loadTexture('assets/images/flamefly.png'), maxAge: 5 } );
		blastParticleEmitter = new Emitter({
			type: 'cube',
			position: this.position,
			acceleration: new Vector3(0, 0, 0),
			velocity: new Vector3(0, 0, 0),
			velocitySpread: new Vector3(30, 30, 30),
			particleCount: 3000,
			sizeStart: 42,
			sizeEnd: 64,
			opacityStart: 0.5,
			opacityMiddle: 1.0,
			opacityEnd: 0,
			alive: 0.0
		});
		
		// Emitter bobbing on the y-axis
		Actuate.tween(particleEmitter.position, 0.5, { y: position.y + 40 } ).ease(Quad.easeOut).repeat().reflect();
		
		#if debug
		name = "Player";
		particleGroup.mesh.name = "Player Particle Group";
		blastParticleGroup.mesh.name = "Player Blast Particle Group";
		#end
		
		particleGroup.addEmitter(particleEmitter);
		particleGroup.mesh.frustumCulled = false;
		scene.add(particleGroup.mesh);
		
		blastParticleGroup.addEmitter(blastParticleEmitter);
		blastParticleGroup.mesh.frustumCulled = false;
		scene.add(blastParticleGroup.mesh);
		
		scene.add(this);
	}
	
	public inline function update(dt:Float):Void {		
		position.x += velocity.x * dt;
		position.y += velocity.y * dt;
		
		particleEmitter.position.x = position.x;
		particleEmitter.position.z = position.z;
		particleEmitter.velocity.x = -velocity.x * Math.random() * 0.02;
		particleEmitter.velocity.y = Math.random() * 50 - 1;
		particleGroup.tick(dt);
		
		blastParticleEmitter.position.set(position.x, position.y , position.z);
		blastParticleGroup.tick(dt);
		
		if (velocity.x != 0 || velocity.y != 0) {
			signal_PositionChanged.dispatch(position);
		}
	}
	
	public inline function reset():Void {
		velocity.set(0, 0);
		inputEnabled = true;
		baseVelocity = Math.min(baseVelocity, 350);
		
		// TODO reset whole particle system
		particleEmitter.alive = 0.1;
		particleEmitter.velocitySpread.set(10, 10, 10);
	}
	
	public function setupInputEvents():Void {
		// Input events
		Browser.document.addEventListener('keydown', function(event) {
			trace("got keydown");
			
			if (!inputEnabled) {
				return;
			}
			
			trace("keydown, player input enabled");
			
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
			trace("got keyup");
			
			if (!inputEnabled) {
				return;
			}
			
			trace("keyup, player input enabled");
			
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
	
	private static var vocabulary:Array<String> = [ "twinkle", "glow", "sparkle", "glimmer", "gleam", "glint", "blaze", "flicker", "glitter", "shimmer", "glare", "shine" ];
	public static function randomMessage(parts:Int):String {
		if (parts == 0) {
			return "...";
		}
		
		var message:String = "";
		
		for (i in 0...parts) {
			message += ("...*" + vocabulary[Std.int(Math.random() * (vocabulary.length - 1))] + "*...");
		}
		
		return message;
	}
	
	public function set_inputEnabled(enabled:Bool):Bool {
		inputEnabled = enabled;
		
		velocity.set(0, 0);
		
		return inputEnabled;
	}
}