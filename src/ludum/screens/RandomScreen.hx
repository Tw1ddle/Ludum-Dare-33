package ludum.screens;

import haxe.ds.Vector;
import js.three.Vector2;
import motion.*;

class RandomScreen extends Screen {
	private var gameText:String;
	
	public function new(game:Main, index:Vector2, ?gameText:String = "", active:Bool = false) {
		super(game, index, active);
		
		this.gameText = gameText;
		game.worldScene.add(loadGround("assets/images/ground1.png", index));
	}
	
	override public function onFirstEnter() {
		super.onFirstEnter();
	}
	
	override public function onFirstExit() {
		super.onFirstExit();
	}
	
	override public function onEnter() {
		super.onEnter();
		
		if (!game.playerReturningToStart) {
			game.setGameText(gameText);
		}
	}
	
	override public function skyEnterTransition() {
		super.skyEnterTransition();
		
		switch(index.x) {
			case 3:
				sunup1();
			case 4:
				sunup2();
			case 5:
				sunup3();
			case 6:
				sunup4();
			default:
				mutateSky();
		}
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
	
	// Sun up with light blue->red sky, sun low right above horizon
	private function sunup1():Void {
		Actuate.tween(game.skyEffectController, 3, {
			turbidity: 2.075,
			rayleigh: 5.74,
			mieCoefficient: 0.005975,
			mieDirectionalG: 0.80,
			luminance: 1.10,
			inclination: 0.4895,
			azimuth: 0.2239,
			refractiveIndex: 1.000374,
			numMolecules: 2.442e25,
			depolarizationFactor: 0.12,
			rayleighZenithLength: 3480,
			mieV: 4.064,
			mieZenithLength: 8300,
			sunIntensityFactor: 1035,
			sunIntensityFalloffSteepness: 1.99,
			sunAngularDiameterDegrees: 0.012
		}).onUpdate(function() {
			game.skyEffectController.updateUniforms();
		});
	}
	
	private function sunup2():Void {
		Actuate.tween(game.skyEffectController, 3, {
			turbidity: 0.825,
			rayleigh: 7.455,
			mieCoefficient: 0.005975,
			mieDirectionalG: 0.536,
			luminance: 1.10,
			inclination: 0.4895,
			azimuth: 0.2171,
			refractiveIndex: 1.000374,
			numMolecules: 2.0e25,
			depolarizationFactor: 0.12,
			rayleighZenithLength: 3480,
			mieV: 4.034,
			mieZenithLength: 8300,
			sunIntensityFactor: 1380,
			sunIntensityFalloffSteepness: 1.99,
			sunAngularDiameterDegrees: 0.012
		}).onUpdate(function() {
			game.skyEffectController.updateUniforms();
		});
		
		Actuate.tween(game.skyEffectController.cameraPos, 3, {
			y: -42000,
		});
	}
	
	private function sunup3():Void {
		Actuate.tween(game.skyEffectController, 3, {
			turbidity: 4.025,
			rayleigh: 7.455,
			mieCoefficient: 0.005975,
			mieDirectionalG: 0.536,
			luminance: 1.1,
			inclination: 0.4895,
			azimuth: 0.2171,
			refractiveIndex: 1.000369,
			numMolecules: 2.542e25,
			depolarizationFactor: 0.12,
			rayleighZenithLength: 3480,
			mieV: 4.034,
			mieZenithLength: 2300,
			sunIntensityFactor: 1454,
			sunIntensityFalloffSteepness: 1.82,
			sunAngularDiameterDegrees: 0.0084
		}).onUpdate(function() {
			game.skyEffectController.updateUniforms();
		});
		
		Actuate.tween(game.skyEffectController.cameraPos, 3, {
			y: 6000,
		});
	}
	
	private function sunup4():Void {
		Actuate.tween(game.skyEffectController, 3, {
			turbidity: 5.825,
			rayleigh: 6.05,
			mieCoefficient: 0.017225,
			mieDirectionalG: 0.842,
			luminance: 1.0755,
			inclination: 0.4912,
			azimuth: 0.2171,
			refractiveIndex: 1.000295,
			numMolecules: 2.542e25,
			depolarizationFactor: 0.083,
			rayleighZenithLength: 3225,
			mieV: 4.003,
			mieZenithLength: 500,
			sunIntensityFactor: 1936,
			sunIntensityFalloffSteepness: 2.95,
			sunAngularDiameterDegrees: 0.01674
		}).onUpdate(function() {
			game.skyEffectController.updateUniforms();
		});
		
		Actuate.tween(game.skyEffectController.cameraPos, 3, {
			y: -26750
		});
	}
	
	private function mutateSky():Void {		
		Actuate.tween(game.skyEffectController, 3, {
			turbidity: 7.25,
			rayleigh: 4.815,
			mieCoefficient: 0.005975,
			mieDirectionalG: 0.80,
			luminance: 1.00,
			inclination: 0.4935,
			azimuth: 0.2361,
			refractiveIndex: 1.000369,
			numMolecules: 2.542e25,
			depolarizationFactor: 0.091,
			rayleighZenithLength: 3330,
			mieV: 3.956,
			mieZenithLength: -16900,
			sunIntensityFactor: 1069,
			sunIntensityFalloffSteepness: 1.05,
			sunAngularDiameterDegrees: 0.012
		}).onUpdate(function() {
			game.skyEffectController.updateUniforms();
		});
		
		Actuate.tween(game.skyEffectController.cameraPos, 3, {
			y: -42000,
		});
		
		if(Math.random() < 0.5) {
			game.starEmitter.accelerationSpread.set(Math.random() * 5, Math.random() * 5, 0);
		} else {
			game.starEmitter.accelerationSpread.set(0, 0, 0);
		}
	}
	
	private var templeDescriptions:Array<Array<String>> = [ [""], [""], [""] ];
	private var tombDescriptions:Array<Array<String>> = [ [""], [""], [""] ];
	private var graveDescriptions:Array<Array<String>> = [ [""], [""], [""] ];
}