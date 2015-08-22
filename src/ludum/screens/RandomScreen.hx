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
		
		//game.worldScene.add(loadBuilding('assets/images/crosses0.png', index, 180, 118, 110, 81, "Burial Ground", [ "That vile spirit rose from here...", "The inscription on the stone has been scorched away...", "...", "......" ], false));
		//game.worldScene.add(loadBuilding('assets/images/cross0.png', index, -180, 118, 100, 110, "Ruined Tombstone", ["A charred grave marker, covered in ash...", "The inscription has been destroyed by flame..."], false));
		//game.worldScene.add(loadBuilding('assets/images/tomb1.png', index, 280, 118, 100, 110, "Scorched Altar", [ "A runic engraving in the sept reads...", "'Vocatus atque non vocatus, Deus aderit'...", "...", "It's coming back now... yes...", "...", "...AGNI, that was my name...", "Where are my disciples...?" ], false));
	}
	
	override public function onFirstEnter() {
		super.onFirstEnter();
		game.setGameText(gameText);
	}
	
	override public function onFirstExit() {
		super.onFirstExit();
	}
	
	override public function onEnter() {
		super.onEnter();
	}
	
	override public function skyEnterTransition() {
		super.skyEnterTransition();
		
		switch(index.x) {
			case 2:
				sunup1();
			case 3:
				sunup2();
			case 4:
				sunup3();
			case 5:
			case 6:
			case 7:
			case 8:
			case 9:
			case 10:
			case 11:
			case 12:
			case 13:
			case 14:
			case 15:
			case 16:
			case 17:
			case 18:
			case 19:
			case 20:
			case 21:
			case 22:
			case 23:
			case 24:
			case 25:
			case 26:
			case 27:
			case 28:
			case 29:
			case 30:
			case 31:
			case 32:
			case 33:
			case 34:
			case 35:
			case 36:
			case 37:
			case 38:
			case 39:
			case 40:
			case 41:
			case 42:
			case 43:
			case 44:
			case 45:
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
	}
	
	private function sunup2():Void {
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
	}
	
	private function sunup3():Void {
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
	}
	
	private function mutateSky():Void {
		// TODO
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
	}
	
	//private var templeSpecs:Array<[
	
	private var tweenFunctions:Array<Void->Void> = new Array<Void->Void>();
	
	private var templeDescriptions:Array<Array<String>> = [ [""], [""], [""] ];
	private var tombDescriptions:Array<Array<String>> = [ [""], [""], [""] ];
	private var graveDescriptions:Array<Array<String>> = [ [""], [""], [""] ];
}