package ludum.screens;

import external.dat.GUI;
import js.three.Mesh;
import js.three.Vector2;
import ludum.Enemy;
import motion.*;

class ScreenOne extends Screen {
	private var spirit:Enemy;
	private var spiritCross:Mesh;
	
	public function new(game:Main, index:Vector2, active:Bool = false) {
		super(game, index, active);
		
		game.worldScene.add(loadGround('assets/images/ground1.png', index));
		
		spiritCross = loadBuilding('assets/images/cross0.png', index, 80, 118, 100, 110, "Tombstone", ["An ancient grave marker..."]);
		game.worldScene.add(spiritCross);
		game.worldScene.add(loadBuilding('assets/images/altar0.png', index, 280, 118, 100, 110, "Burnt Altar", [ "There is a runic engraving under the ash on the altar, it reads...", "'Vocatus atque non vocatus, Deus aderit'...", "...", "Where are my subjects...", "..." ]));
		
		spirit = new Enemy(game.worldScene, spiritCross.position.x, spiritCross.position.y);
		game.worldScene.add(spirit);
		enemies.push(spirit);
	}

	override public function onFirstEnter() {
		super.onFirstEnter();
		
		spirit.position.x = spiritCross.position.x;
		Actuate.tween(spirit.position, 3, { y: 100 } ).delay(1.5).onUpdate(function() {
			game.setGameText("SPIRIT: Go back AGNI! I'm warning you...!", '#AA00AA');
		}).onComplete(function() {
			game.setGameText("A mere spirit dares to command me? Hah. Die... now.");
			
			game.player.blastParticleEmitter.acceleration.x = 31;
			game.player.blastParticleEmitter.velocity.set(99, 86, 0);
			game.player.blastParticleEmitter.velocitySpread.set(26, 22, 30);
			// Player flares up and spirit explodes
			Actuate.tween(game.player.blastParticleEmitter, 2, { alive: 1.0 } ).onComplete(function() {
				Actuate.tween(game.player.blastParticleEmitter, 0.5, { alive: 0.0 } );
			});
			
			Actuate.tween(spirit.particleEmitter, 2, { alive: 0.0 } ).delay(1.0).onComplete(function() {
				spirit.particleEmitter.acceleration.set(85, 36, 0);
				spirit.particleEmitter.accelerationSpread.set(10.6, 94, 0);
				game.setGameText("Die... now.");
			});
		});
	}
	
	override public function onFirstExit() {
		super.onFirstExit();
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