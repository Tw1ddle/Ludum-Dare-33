package ludum.screens;

import external.dat.GUI;
import js.three.Vector2;
import ludum.Enemy;
import motion.*;

typedef SpeechDef = { text:String, color:String }

class ScreenFour extends Screen {
	private var visnu:Enemy;
	private var varuna:Enemy;
	private var vayu:Enemy;
	
	private static var godTalk:Array<SpeechDef> = [
		{ text: "So you came back...", color: "#FFBF00" },
		{ text: "I thought we had been through this before...", color: "#2ECCFA" },
		{ text: "You cannot have your followers back...", color: "#DBA901" },
		{ text: "You LESSER Gods conspire to stop ME?", color: "#990000" },
		{ text: "Where are they?! You stole them from me!", color: "#990000" },
		{ text: "Nonsense! Do you remember nothing?", color: "#FFBF00" },
		{ text: "You undid yourself when you burnt many disciples in a rage!", color: "#FFBF00" },
		{ text: "The proof of your crimes lies in your wake, fool.", color: "#FFBF00" },
		{ text: "You have but a single follower left!", color: "#CEF6F5" },
		{ text: "Let us put an end to this farce?", color: "#FFBF00" },
		{ text: "Yes!", color: "#2ECCFA" },
		{ text: "Indeed! We have no time for dawdling.", color: "#CEF6F5" },
		{ text: "It is decided. Come back when you have atoned for your crimes...!", color: "#FFBF00" },
		{ text: "Now begone!", color: "#FFBF00" }
	];
	private var godTalkTextIndex:Int = 0;
	private var gameOverTriggered:Bool = false;
	
	public function new(game:Main, index:Vector2, active:Bool = false) {
		super(game, index, active);
		
		game.worldScene.add(loadGround('assets/images/ground3.png', index));
		
		// Each enemy says their stuff and then banishes player
		visnu = new Enemy(game.worldScene, 0, 0, "God of Earth", "assets/images/earthfly.png", 3000, 0.1);
		varuna = new Enemy(game.worldScene, 0, 0, "God of Water", "assets/images/icefly.png", 3000, 0.1);
		vayu = new Enemy(game.worldScene, 0, 0, "God of Air", "assets/images/airfly.png", 3000, 0.1);
		
		positionItem(visnu, -250, 300);
		positionItem(varuna, 0, 300);
		positionItem(vayu, 250, 300);
		
		enemies.push(visnu);
		enemies.push(varuna);
		enemies.push(vayu);
		
		for (enemy in enemies) {
			enemy.particleEmitter.alive = 0;
			enemy.particleEmitter.accelerationSpread.set(8, 8, 0);
		}
		
		game.signal_playerClicked.add(advanceText);
	}
	
	override public function permitsTransition(next:Screen):Bool {
		return false;
	}
	
	override public function onFirstEnter() {
		super.onFirstEnter();
		
		advanceText(0, 0);
		
		for (enemy in enemies) {
			enemy.particleEmitter.alive = 1.0;
			enemy.particleEmitter.accelerationSpread.set(8, 8, 0);
		}
	}
	
	override public function onFirstExit() {
		super.onFirstExit();
	}

	override public function skyEnterTransition() {
		super.skyEnterTransition();
	}
	
	override public function onEnter() {
		super.onEnter();
	}
	
	override public function onExit() {
		super.onExit();
	}
	
	override public function reset() {
		super.reset();
		
		godTalkTextIndex = 0;
		gameOverTriggered = false;
		
		for (enemy in enemies) {
			enemy.particleEmitter.alive = 0.0;
		}
	}
	
	override public function update(dt:Float):Void {
		super.update(dt);
	}
	
	#if debug
	override public function addGUIItems(gui:GUI):Void {
	}
	#end
	
	private function advanceText(x:Float, y:Float):Void {
		if (active) {
			if (godTalkTextIndex > godTalk.length - 1 && !game.playerReturningToStart && !gameOverTriggered) {
				gameOverTriggered = true;
				
				visnu.particleEmitter.acceleration.set(65, -15, 351);
				visnu.particleEmitter.accelerationSpread.set(43, 41, 61);
				
				varuna.particleEmitter.acceleration.set(0, -14, 262);
				varuna.particleEmitter.accelerationSpread.set(21, 30, 0);
				
				vayu.particleEmitter.acceleration.set(-65, -15, 351);
				vayu.particleEmitter.accelerationSpread.set(43, 41, 61);
				
				game.setGameText("Arrrrrghhhh! Noooooooooooooooooooooo....", 3);
				Actuate.tween(game.player.particleEmitter, 1, { alive: 0.1 } );
				
				Actuate.tween(game.skyEffectController.primaries, 1, {
					x: 6.8e-7,
					y: 4.5e-7,
					z: 4.5e-7
				}).onUpdate(function():Void {
					game.skyEffectController.updateUniforms();
				});
				game.starEmitter.opacityMiddle = 1.0;
				game.starEmitter.acceleration.set(0, 0, 830);
				game.starEmitter.accelerationSpread.set(0, 0, 560);
				game.starEmitter.alive = 1.0;
				
				Actuate.tween(visnu.particleEmitter, 3, { alive: 1.0 } ).onUpdate(function() {
					varuna.particleEmitter.alive = visnu.particleEmitter.alive;
					vayu.particleEmitter.alive = visnu.particleEmitter.alive;
				}).onComplete(function() {
					game.player.signal_Died.dispatch();
				});
			} else {
				if (godTalkTextIndex < godTalk.length - 1) {
					game.setGameText(godTalk[godTalkTextIndex].text, godTalk[godTalkTextIndex].color);
					godTalkTextIndex++;
				}
			}
		}
	}
}