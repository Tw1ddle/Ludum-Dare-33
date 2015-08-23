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
			turbidity: 4.7,
			rayleigh: 2.28,
			mieCoefficient: 0.005,
			mieDirectionalG: 0.82,
			luminance: 1.00,
			inclination: 0.5154,
			azimuth: 0.2721,
			refractiveIndex: 1.000218,
			numMolecules: 2.542e25,
			depolarizationFactor: 0.02,
			rayleighZenithLength: 9135,
			mieV: 3.936,
			mieZenithLength: 34000,
			sunIntensityFactor: 1000,
			sunIntensityFalloffSteepness: 1.5,
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