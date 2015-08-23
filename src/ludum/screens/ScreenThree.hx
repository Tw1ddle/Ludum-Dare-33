package ludum.screens;

import js.three.Vector2;
import external.dat.GUI;
import motion.*;

class ScreenThree extends Screen {	
	public function new(game:Main, index:Vector2, active:Bool = false) {
		super(game, index, active);
		
		game.worldScene.add(loadGround('assets/images/ground6.png', index));
	}
	
	override public function onFirstEnter() {
		super.onFirstEnter();
	}
	
	override public function onFirstExit() {
		super.onFirstExit();
	}
	
	override public function skyEnterTransition() {
		super.skyEnterTransition();
		
		Actuate.tween(game.skyEffectController, 3, {
			turbidity: 2.32,
			rayleigh: 2.92,
			mieCoefficient: 0.005,
			mieDirectionalG: 0.82,
			luminance: 1.00,
			inclination: 0.5056,
			azimuth: 0.2408,
			refractiveIndex: 1.000337,
			numMolecules: 3.72e25,
			depolarizationFactor: 0.02,
			rayleighZenithLength: 27030,
			mieV: 3.946,
			mieZenithLength: 53000,
			sunIntensityFactor: 1048,
			sunIntensityFalloffSteepness: 1.65,
			sunAngularDiameterDegrees: 0.00933
		}).onUpdate(function() {
			game.skyEffectController.updateUniforms();
		});
		
		Actuate.tween(game.skyEffectController.cameraPos, 3, {
			x: 100000,
			y: -42000,
			z: -219500
		});
	}
	
	override public function onEnter() {
		super.onEnter();
	}
	
	override public function onExit() {
		super.onExit();
	}
	
	override public function reset() {
		super.reset();
	}
	
	override public function update(dt:Float):Void {
		super.update(dt);
	}
	
	#if debug
	override public function addGUIItems(gui:GUI):Void {
	}
	#end
}