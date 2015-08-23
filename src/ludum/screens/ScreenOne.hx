package ludum.screens;

import external.dat.GUI;
import js.three.Mesh;
import js.three.Vector2;
import ludum.Enemy;
import motion.*;

class ScreenOne extends Screen {
	private var spirit:Enemy;
	private var spiritCross:Mesh;
	private var spiritDied:Bool;
	
	public function new(game:Main, index:Vector2, active:Bool = false) {
		super(game, index, active);
		
		game.worldScene.add(loadGround('assets/images/ground1.png', index));
		
		spiritCross = loadBuilding('assets/images/crosses0.png', index, 180, 118, 110, 81, "Burial Ground", [ "That vile spirit rose from here...", "The inscription on the stone has been scorched away...", "...", "......" ]);
		game.worldScene.add(spiritCross);
		game.worldScene.add(loadBuilding('assets/images/cross0.png', index, -180, 118, 100, 110, "Ruined Tombstone", ["A charred grave marker, covered in ash...", "The inscription has been destroyed by flame..."]));
		game.worldScene.add(loadBuilding('assets/images/tomb1.png', index, 280, 118, 100, 110, "Scorched Altar", [ "A runic engraving in the sept reads...", "'Vocatus atque non vocatus, Deus aderit'...", "...", "It's coming back now... yes...", "...", "...I was a God, that I was...", "But where are my disciples...?" ]));
		
		spirit = new Enemy(game.worldScene, spiritCross.position.x, spiritCross.position.y);
		game.worldScene.add(spirit);
		enemies.push(spirit);
				
		game.interactables.push(spirit);
		
		spiritDied = false;
		spirit.signal_Died.add(onSpiritDied);
	}
	
	override public function permitsTransition(next:Screen):Bool {
		return spiritDied;
	}
	
	override public function reset():Void {
		super.reset();
		
		spiritDied = false;
		spirit.position.x = spiritCross.position.x;
		spirit.position.y = spiritCross.position.y;
		spirit.particleEmitter.alive = 1.0;
	}
	
	public function onSpiritDied() {
		spiritDied = true;
		game.setGameText("Stupid spirit, you don't tell ME what to do...");
		game.player.inputEnabled = true;
		game.raycastingEnabled = true;
	}

	override public function onFirstEnter() {
		super.onFirstEnter();
		
		spirit.position.x = spiritCross.position.x;
		
		game.raycastingEnabled = false;
		
		game.setGameText("Return to the dark! There is nothing for you here!", '#5555FF');
		
		Actuate.tween(spirit.position, 1, { y: 100 } ).delay(2.5).onUpdate(function() {
		}).onComplete(function() {
			game.setGameText("A mere spirit means to command ME? Die... NOW.");
			
			game.player.blastParticleEmitter.acceleration.x = 31;
			game.player.blastParticleEmitter.velocity.set(99, 86, 0);
			game.player.blastParticleEmitter.velocitySpread.set(26, 22, 30);
			
			// Player flares up and spirit explodes
			Actuate.tween(game.player.blastParticleEmitter, 2, { alive: 1.0 } ).onComplete(function() {
				Actuate.tween(game.player.blastParticleEmitter, 0.5, { alive: 0.0 } );
			});
			
			Actuate.tween(spirit.particleEmitter, 2, { alive: 0.0 } ).delay(2.0).onUpdate(function() {
				spirit.particleEmitter.acceleration.set(85, 36, 0);
				spirit.particleEmitter.accelerationSpread.set(200.6, 294, 0);
				game.setGameText("*Explodes*", '#5555FF');
				
				game.restoreSkyToDefaults(4, 0.4949, 0.1981);
				game.restoreStarsToDefaults();
			}).onComplete(function() {
				spirit.signal_Died.dispatch();
			});
		});
	}
	
	override public function onFirstExit() {
		super.onFirstExit();
	}
	
	override public function skyEnterTransition() {
		super.skyEnterTransition();
		
		Actuate.tween(game.skyEffectController, 3, {
			turbidity: 1.0,
			rayleigh: 3.25,
			mieCoefficient: 0.005975,
			mieDirectionalG: 0.80,
			luminance: 1.00,
			inclination: 0.4742,
			azimuth: 0.2268,
			refractiveIndex: 1.000266,
			numMolecules: 2.542e25,
			depolarizationFactor: 0.091,
			rayleighZenithLength: 570,
			mieV: 3.961,
			mieZenithLength: 2400,
			sunIntensityFactor: 1024,
			sunIntensityFalloffSteepness: 1.4,
			sunAngularDiameterDegrees: 0.00600
		}).onUpdate(function() {
			game.skyEffectController.updateUniforms();
		});
		
		game.starEmitter.opacityMiddle = 1.0;
		game.starEmitter.acceleration.set(0, 0, 830);
		game.starEmitter.accelerationSpread.set(0, 0, 560);
		game.starEmitter.alive = 1.0;
	}
	
	override public function onEnter() {
		super.onEnter();
	}
	
	override public function onExit() {
		super.onExit();
		game.restoreStarsToDefaults();
	}	
	
	override public function update(dt:Float):Void {
		super.update(dt);
	}
	
	#if debug
	override public function addGUIItems(gui:GUI):Void {
	}
	#end
}