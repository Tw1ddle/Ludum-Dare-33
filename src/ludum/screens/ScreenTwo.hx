package ludum.screens;

import js.three.Vector2;
import external.dat.GUI;

class ScreenTwo extends Screen {	
	public function new(game:Main, index:Vector2, active:Bool = false) {
		super(game, index, active);
		
		game.worldScene.add(loadGround('assets/images/ground2.png', index));
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
		
		game.raycastingEnabled = false; // Hack to avoid text getting chopped off by interactables raycasting bug after this screen
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