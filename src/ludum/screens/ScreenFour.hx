package ludum.screens;

import external.dat.GUI;
import js.three.Vector2;
import ludum.Enemy;

class ScreenFour extends Screen {
	private var visnu:Enemy;
	private var varuna:Enemy;
	private var vayu:Enemy;
	
	public function new(game:Main, index:Vector2, active:Bool = false) {
		super(game, index, active);
		
		game.worldScene.add(loadGround('assets/images/ground4.png', index));
		
		// TODO sequence advanced by clicks:
		// Each enemy says their stuff and then banishes player
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