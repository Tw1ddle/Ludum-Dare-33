package ludum.screens;

import js.three.Vector2;

class RandomScreen extends Screen {
	private var gameText:String;
	
	public function new(game:Main, index:Vector2, ?gameText:String = "", active:Bool = false) {
		super(game, index, active);
		
		this.gameText = gameText;
		var groundIndex:String = Std.string(Std.int(Math.random() * 3) + 1);
		game.worldScene.add(loadGround("assets/images/ground" + groundIndex + ".png", index));
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
	
	override public function onExit() {
		super.onExit();
	}
	
	override public function reset() {
		super.reset();
	}
	
	override public function update(dt:Float):Void {
		super.update(dt);
	}
}