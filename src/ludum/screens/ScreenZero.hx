package ludum.screens;

import external.dat.GUI;
import external.particle.Emitter;
import external.particle.Group;
import js.three.ImageUtils;
import js.three.Mesh;
import js.three.Vector2;
import js.three.Vector3;

class ScreenZero extends Screen {	
	public var starGroup(default, null):Group;
	public var starEmitter(default, null):Emitter;
	
	private var temple:Mesh;
	
	public function new(game:Main, index:Vector2, active:Bool = false) {
		super(game, index, active);
		
		// Particle emitter
		starGroup = new Group( {
			texture: ImageUtils.loadTexture('assets/images/darkfly.png'),
			maxAge: 5
		});
		
		starEmitter = new Emitter({
			type: 'cube',
			position: new Vector3(-25, 0, -1417),
			positionSpread: new Vector3(808, 426, 0),
			acceleration: new Vector3(6.7, 5, 63),
			accelerationSpread: new Vector3(3.9, 4, 0),
			velocity: new Vector3(-101, 0, 0),
			velocitySpread: new Vector3(7, 0, 0),
			sizeStart: 10,
			sizeEnd: 10,
			opacityStart: 0,
			opacityMiddle: 1,
			opacityEnd: 0,
			particleCount: 5000
		});
		starGroup.addEmitter(starEmitter);
		starGroup.mesh.frustumCulled = false;
		game.worldScene.add(starGroup.mesh);
		
		game.worldScene.add(loadGround('assets/images/ground0.png', index));
		game.worldScene.add(loadBuilding('assets/images/temple0.png', index, 80, 118, 100, 110, "Temple of Flame", [ "A charred husk of a temple...", "...", "How was I summoned if this place is abandoned...?", "...", "......", "A worn inscription on the altar reads 'Requiem aeternam dona ei, Varuna'...", "..."]));
		game.worldScene.add(loadBuilding('assets/images/tomb0.png', index, 280, 118, 100, 110, "Sepulchre of Cinders", [ "An monument dedicated to a God...", "The inscription has worn away.", "...", "I should look around and collect my thoughts...", "..." ]));
	}
	
	override public function onEnter() {
		super.onEnter();
	}
	
	override public function onExit() {
		super.onExit();
	}
	
	override public function onFirstEnter() {
		super.onFirstEnter();
	}
	
	override public function onFirstExit() {
		super.onFirstExit();
	}
	
	override public function update(dt:Float):Void {
		super.update(dt);
		starGroup.tick(dt);
	}
	
	#if debug
	override public function addGUIItems(gui:GUI):Void {
		game.addGUIItem(game.particleGUI.addFolder("Ocean Emitter"), starEmitter, "Ocean Emitter");
	}
	#end
}