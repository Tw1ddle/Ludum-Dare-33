package ludum.screens;

import external.dat.GUI;
import js.three.Vector2;

class ScreenOne extends Screen {	
	public function new(game:Main, index:Vector2, active:Bool = false) {
		super(game, index, active);
		
		game.worldScene.add(loadGround('assets/images/ground1.png', index));
		game.worldScene.add(loadBuilding('assets/images/cross0.png', index, 80, 118, 100, 110, "Temple of Flame", [ "A charred husk of a temple...", "...", "How was I summoned if this place is abandoned...?", "...", "......", "A worn inscription on the altar reads 'Requiem aeternam dona ei, Varuna'...", "..."]));
		game.worldScene.add(loadBuilding('assets/images/cross1.png', index, 280, 118, 100, 110, "Sepulchre of Cinders", [ "An monument dedicated to a God...", "The inscription has worn away.", "...", "I should look around and collect my thoughts...", "..." ]));
		game.worldScene.add(loadBuilding('assets/images/cross1.png', index, 280, 118, 100, 110, "Sepulchre of Cinders", [ "An monument dedicated to a God...", "The inscription has worn away.", "...", "I should look around and collect my thoughts...", "..." ]));
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