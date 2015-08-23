package ludum.screens;

import external.dat.GUI;
import js.three.Vector2;
import ludum.Enemy;

typedef SpeechDef = { text:String, color:String }

class ScreenFour extends Screen {
	private var visnu:Enemy;
	private var varuna:Enemy;
	private var vayu:Enemy;
	
	private static var godTalk:Array<SpeechDef> = [
		{ text: "So you came here again Agni...", color: "#AAAAAA" },
		{ text: "So you came here again Agni...", color: "#AAAAAA" },
		{ text: "So you came here again Agni...", color: "#AAAAAA" },
		{ text: "So you came here again Agni...", color: "#AAAAAA" },
		{ text: "So you came here again Agni...", color: "#AAAAAA" },
		{ text: "So you came here again Agni...", color: "#AAAAAA" },
		{ text: "So you came here again Agni...", color: "#AAAAAA" },
		{ text: "So you came here again Agni...", color: "#AAAAAA" },
		{ text: "So you came here again Agni...", color: "#AAAAAA" },
		{ text: "So you came here again Agni...", color: "#AAAAAA" },
		{ text: "So you came here again Agni...", color: "#AAAAAA" },
		{ text: "So you came here again Agni...", color: "#AAAAAA" },
		{ text: "So you came here again Agni...", color: "#AAAAAA" },
		{ text: "So you came here again Agni...", color: "#AAAAAA" },
		{ text: "So you came here again Agni...", color: "#AAAAAA" },
		{ text: "So you came here again Agni...", color: "#AAAAAA" },
		{ text: "So you came here again Agni...", color: "#AAAAAA" },
		{ text: "So you came here again Agni...", color: "#AAAAAA" },
		{ text: "So you came here again Agni...", color: "#AAAAAA" }
	];
	private var godTalkTextIndex:Int = 0;
	
	public function new(game:Main, index:Vector2, active:Bool = false) {
		super(game, index, active);
		
		game.worldScene.add(loadGround('assets/images/ground4.png', index));
		
		// TODO sequence advanced by clicks:
		// Each enemy says their stuff and then banishes player
		visnu = new Enemy(game.worldScene, 0, 0, "God of Earth");
		varuna = new Enemy(game.worldScene, 0, 0, "God of Water");
		vayu = new Enemy(game.worldScene, 0, 0, "God of Air");
		
		game.signal_playerClicked.add(advanceText);
	}
	
	override public function permitsTransition(next:Screen):Bool {
		return false;
	}
	
	override public function onFirstEnter() {
		super.onFirstEnter();
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
			godTalkTextIndex++;
			if (godTalkTextIndex > godTalk.length) {
				game.player.signal_Died.dispatch();
			} else {
				game.setGameText(godTalk[godTalkTextIndex].text, godTalk[godTalkTextIndex].color);
			}
		}
	}
}