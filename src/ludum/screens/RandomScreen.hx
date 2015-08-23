package ludum.screens;

import haxe.ds.Vector;
import js.three.Vector2;
import motion.*;

class RandomScreen extends Screen {
	private var gameText:String;
	
	public function new(game:Main, index:Vector2, ?gameText:String = "", active:Bool = false) {
		super(game, index, active);
		
		this.gameText = gameText;
		
		if(index.x == 12) {
			game.worldScene.add(loadGround("assets/images/ground5.png", index));
		} else if(index.x < 12) {
			
			var rand = Math.random();
			if (rand < 0.2) {
				game.worldScene.add(loadGround("assets/images/ground1.png", index));
			} else if (rand < 0.4) {
				game.worldScene.add(loadGround("assets/images/ground2.png", index));
			} else if (rand < 0.8) {
				game.worldScene.add(loadGround("assets/images/ground3.png", index));
			} else {
				game.worldScene.add(loadGround("assets/images/ground4.png", index));
			}
		}
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
			case 7:
				sunup5();
			case 8:
				sunup6();
			case 9:
				night1();
			case 10:
				night2();
			case 11:
				hastening1();
			case 12:
				sea1();
			case 13:
				sea2();
			case 14:
				sea3();
			case 15:
				sea4();
			case 16:
				sea5();
			case 17:
				void1();
			case 18:
				void2();
			case 19:
				void3();
			case 20:
				void4();
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
	
	private function sunup5():Void {
		Actuate.tween(game.skyEffectController, 3, {
			turbidity: 5.825,
			rayleigh: 6.05,
			mieCoefficient: 0.017225,
			mieDirectionalG: 0.842,
			luminance: 1.0755,
			inclination: 0.4971,
			azimuth: 0.2171,
			refractiveIndex: 1.000295,
			numMolecules: 2.542e25,
			depolarizationFactor: 0.083,
			rayleighZenithLength: 8985,
			mieV: 4.003,
			mieZenithLength: 1000,
			sunIntensityFactor: 1936,
			sunIntensityFalloffSteepness: 2.95,
			sunAngularDiameterDegrees: 0.01674
		}).onUpdate(function() {
			game.skyEffectController.updateUniforms();
		});
	}
	
	private function sunup6():Void {
		Actuate.tween(game.skyEffectController, 3, {
			turbidity: 5.825,
			rayleigh: 6.05,
			mieCoefficient: 0.017225,
			mieDirectionalG: 0.842,
			luminance: 1.0755,
			inclination: 0.4986,
			azimuth: 0.2171,
			refractiveIndex: 1.000295,
			numMolecules: 2.542e25,
			depolarizationFactor: 0.083,
			rayleighZenithLength: 3630,
			mieV: 4.003,
			mieZenithLength: 1000,
			sunIntensityFactor: 1936,
			sunIntensityFalloffSteepness: 2.95,
			sunAngularDiameterDegrees: 0.01674
		}).onUpdate(function() {
			game.skyEffectController.updateUniforms();
		});
	}
	
	private function night1():Void {
		Actuate.tween(game.skyEffectController, 3, {
			turbidity: 4.7,
			rayleigh: 2.28,
			mieCoefficient: 0.005,
			mieDirectionalG: 0.82,
			luminance: 1.00,
			inclination: 0.5133,
			azimuth: 0.2361,
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
		
		game.starEmitter.acceleration.set(32, -9, 276);
		game.starEmitter.accelerationSpread.set(0, 22, 26);
	}
	
	private function night2():Void {
		Actuate.tween(game.skyEffectController, 3, {
			turbidity: 4.7,
			rayleigh: 2.28,
			mieCoefficient: 0.005,
			mieDirectionalG: 0.82,
			luminance: 1.00,
			inclination: 0.5133,
			azimuth: 0.2361,
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
		
		game.starEmitter.acceleration.set(32, 388, 1235);
		game.starEmitter.accelerationSpread.set(0, 342, 564);
		
		Actuate.tween(game.windEmitter, 1, { alive: 0.0 } );
	}
	
	private function hastening1():Void {
		Actuate.tween(game.skyEffectController, 3, {
			turbidity: 4.7,
			rayleigh: 2.28,
			mieCoefficient: 0.005,
			mieDirectionalG: 0.82,
			luminance: 1.00,
			inclination: 0.5133,
			azimuth: 0.2361,
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
		
		game.starEmitter.acceleration.set(-40, 0, 0);
		game.starEmitter.accelerationSpread.set(20, 0, 0);
		
		Actuate.tween(game.windEmitter, 1, { alive: 1.0 } );
	}
	
	private function sea1():Void {
		Actuate.tween(game.skyEffectController, 3, {
			turbidity: 4.7,
			rayleigh: 2.28,
			mieCoefficient: 0.005,
			mieDirectionalG: 0.82,
			luminance: 1.00,
			inclination: 0.5056,
			azimuth: 0.2445,
			refractiveIndex: 1.00029,
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
		
		if (!game.playerReturningToStart) {
			Actuate.tween(game.skyEffectController.primaries, 3, { x: 7.5e-7, y: 4.5e-7, z: 5.1e-7 } ).onUpdate(function() {
				game.skyEffectController.updateUniforms();
			});
		}
		
		Actuate.tween(game.skyEffectController.cameraPos, 3, {
			y: -43250
		});
		
		game.starEmitter.acceleration.set(0, 0, 0);
		game.starEmitter.accelerationSpread.set(0, 0, 0);
		
		Actuate.tween(game.windEmitter, 3, { alive: 0.0 } );
	}
	
	private function sea2():Void {
		Actuate.tween(game.skyEffectController, 3, {
			turbidity: 4.7,
			rayleigh: 2.28,
			mieCoefficient: 0.005,
			mieDirectionalG: 0.82,
			luminance: 1.00,
			inclination: 0.5056,
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
		
		if (!game.playerReturningToStart) {
			Actuate.tween(game.skyEffectController.primaries, 3, { x: 7.5e-7, y: 4.5e-7, z: 5.1e-7 } ).onUpdate(function() {
				game.skyEffectController.updateUniforms();
			});
		}
		
		game.starEmitter.acceleration.set(0, 0, 0);
		game.starEmitter.accelerationSpread.set(0, 0, 0);
	}
	
	private function sea3():Void {
		game.starEmitter.acceleration.set(32, 388, 435);
		game.starEmitter.accelerationSpread.set(0, 342, 164);
	}
	
	private function sea4():Void {
		game.starEmitter.acceleration.set(32, 388, 835);
		game.starEmitter.accelerationSpread.set(0, 342, 364);
	}
	
	private function sea5():Void {
		game.starEmitter.acceleration.set(32, 388, 1235);
		game.starEmitter.accelerationSpread.set(0, 342, 564);
	}
	
	private function void1():Void {
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
		
		game.starEmitter.acceleration.set(32, 388, 835);
		game.starEmitter.accelerationSpread.set(0, 342, 364);
	}
	
	private function void2():Void {
		game.starEmitter.acceleration.set(32, 388, 435);
		game.starEmitter.accelerationSpread.set(0, 342, 164);
	}
	
	private function void3():Void {
		game.starEmitter.acceleration.set(0, 0, 0);
		game.starEmitter.accelerationSpread.set(0, 0, 0);
	}
	
	private function void4():Void {
		game.starEmitter.acceleration.set(0, 0, 0);
		game.starEmitter.accelerationSpread.set(0, 0, 0);
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