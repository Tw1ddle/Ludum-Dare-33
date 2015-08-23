package ludum.screens;

import external.dat.GUI;
import external.particle.Emitter;
import external.particle.Group;
import js.three.ImageUtils;
import js.three.Mesh;
import js.three.Vector2;
import js.three.Vector3;
import motion.*;

class ScreenZero extends Screen {	
	public var starGroup(default, null):Group;
	public var starEmitter(default, null):Emitter;
	
	private var temple:Mesh;
	
	public function new(game:Main, index:Vector2, active:Bool = false) {
		super(game, index, active);
		
		// Particle emitter
		starGroup = new Group( {
			texture: ImageUtils.loadTexture('assets/images/firefly.png'),
			maxAge: 5
		});
		
		starEmitter = new Emitter({
			type: 'cube',
			position: new Vector3(-25, 0, -1417),
			positionSpread: new Vector3(808, 426, 0),
			acceleration: new Vector3(6.7, 5, 63),
			accelerationSpread: new Vector3(3.9, 4, 0),
			velocity: new Vector3(-101, 0, 0),
			velocitySpread: new Vector3(7, 0, 0),
			sizeStart: 10,
			sizeEnd: 10,
			opacityStart: 0,
			opacityMiddle: 1,
			opacityEnd: 0,
			particleCount: 5000
		});
		starGroup.addEmitter(starEmitter);
		starGroup.mesh.frustumCulled = false;
		game.worldScene.add(starGroup.mesh);
		
		game.worldScene.add(loadGround('assets/images/ground0.png', index));
		game.worldScene.add(loadBuilding('assets/images/temple0.png', index, 80, 118, 100, 110, "Temple of Flame", [ "A charred husk of a temple...", "...", "The dust lays thick on the floors and chokes the air", "......", "A worn inscription at the main altar reads 'Requiem aeternam dona ei, Agni'...", "..."]));
		game.worldScene.add(loadBuilding('assets/images/tomb0.png', index, 280, 118, 100, 110, "Sepulchre of Cinders", [ "A monument dedicated to a God...", "The inscription on the altar has worn away.", "...", "I should look around and collect my thoughts...", "..." ]));
	}
	
	override public function skyEnterTransition() {
		super.skyEnterTransition();
		
		Actuate.tween(game.skyEffectController, 3, {
			turbidity: 4.7,
			rayleigh: 2.28,
			mieCoefficient: 0.005,
			mieDirectionalG: 0.82,
			luminance: 1.00,
			inclination: 0.4983,
			azimuth: 0.1979,
			refractiveIndex: 1.00029,
			numMolecules: 2.542e25,
			depolarizationFactor: 0.02,
			rayleighZenithLength: 8400,
			mieV: 3.936,
			mieZenithLength: 34000,
			sunIntensityFactor: 1000,
			sunIntensityFalloffSteepness: 1.5,
			sunAngularDiameterDegrees: 0.00933
		}).onUpdate(function() {
			game.skyEffectController.updateUniforms();
		});
		
		game.starEmitter.accelerationSpread.set(50, 50, 0);
	}
	
	override public function onEnter() {
		super.onEnter();
	}
	
	override public function onExit() {
		super.onExit();
	}
	
	override public function onFirstEnter() {
		super.onFirstEnter();
	}
	
	override public function onFirstExit() {
		super.onFirstExit();
	}
	
	override public function update(dt:Float):Void {
		super.update(dt);
		starGroup.tick(dt);
	}
	
	#if debug
	override public function addGUIItems(gui:GUI):Void {
		game.addGUIItem(game.particleGUI.addFolder("Screen Zero Star Emitter"), starEmitter, "Screen Zero Star Emitter");
	}
	#end
}