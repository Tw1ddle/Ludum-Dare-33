package ludum.screens;

import external.dat.GUI;
import js.three.ImageUtils;
import js.three.Mappings;
import js.three.Mesh;
import js.three.MeshBasicMaterial;
import js.three.PlaneGeometry;
import js.three.Vector2;
import ludum.DescribableMesh;

class Screen {
	public var active(default, set):Bool;
	public var enemies(default, null) = new Array<Enemy>();
	private var index:Vector2;
	private var game:Main;
	private var firstEnter:Bool;
	private var firstExit:Bool;
	
	public function new(game:Main, index:Vector2, active:Bool = false) {
		this.index = index;
		this.active = active;
		this.game = game;
		firstEnter = true;
		firstExit = true;
	}
	
	public function skyEnterTransition() {
		
	}
	
	public function permitsTransition(next:Screen):Bool {
		return true;
	}
	
	public function onEnter() {
		if (firstEnter) {
			onFirstEnter();
			firstEnter = false;
		}
		
		skyEnterTransition();
		
		#if debug
		trace("Entering screen " + Std.string(index));
		#end
	}
	
	public function onExit() {
		if (firstExit) {
			onFirstExit();
			firstExit = false;
		}
		
		#if debug
		trace("Exiting screen " + Std.string(index));
		#end
	}
	
	public function onFirstEnter() {
		#if debug
		trace("Entering screen " + Std.string(index) + " for first time");
		#end
		
		game.player.baseVelocity += 15;
		game.player.particleEmitter.alive = Math.min(game.player.particleEmitter.alive + 0.05, 1.0);
		game.player.particleEmitter.velocitySpread.addScalar(1.0);
	}
	
	public function onFirstExit() {
		#if debug
		trace("Exiting screen " + Std.string(index) + " for first time");
		#end
	}
	
	public function update(dt:Float):Void {
		if (!active) {
			return;
		}
		
		for (enemy in enemies) {
			enemy.update(dt);
		}
	}
	
	public function reset():Void {
		firstEnter = true;
		firstExit = true;
		if (index.x != 0) { // To avoid deactivating the first screen by mistake on death
			active = false;
		}
	}
	
	private function set_active(active:Bool):Bool {
		if (this.active == active) {
			return this.active;
		}
		
		#if debug
		trace("Setting screen " + Std.string(index) + " active = " + active);
		#end
		
		return this.active = active;
	}
	
	public static function findScreen(index:Vector2, screens:List<Screen>):Screen {
		for (screen in screens) {
			if (screen.index.x == index.x && screen.index.y == index.y) {
				return screen;
			}
		}
		return null;
	}
	
	public function loadGround(imagePath:String, screenIndex:Vector2, width:Float = Main.GAME_VIEWPORT_WIDTH, height:Float = 200):Mesh {
		var texture = ImageUtils.loadTexture(imagePath, Mappings.UVMapping);
		texture.minFilter = NearestFilter;
		texture.magFilter = NearestFilter;
		var material = new MeshBasicMaterial( { map: texture, transparent:true, depthWrite: false, depthTest: false, opacity:1.0 } );
		var geometry = new PlaneGeometry(width, height);
		var mesh = new Mesh(geometry, material);
		mesh.position.set(Main.GAME_VIEWPORT_WIDTH * screenIndex.x, -Main.GAME_VIEWPORT_HEIGHT / 2 + height / 2, -1410);
		
		#if debug
		mesh.name = imagePath.substring(imagePath.lastIndexOf("/"));
		#end
		
		return mesh;
	}
	
	public function loadBuilding(imagePath:String, screenIndex:Vector2, xOffset:Float, yOffset:Float, width:Float, height:Float, hoverText:String = "Building", clickText:Array<String>, interactable:Bool = true):DescribableMesh {
		var texture = ImageUtils.loadTexture(imagePath, Mappings.UVMapping);
		texture.minFilter = NearestFilter;
		texture.magFilter = NearestFilter;
		var material = new MeshBasicMaterial( { map: texture, transparent:true, depthWrite: false, depthTest: false, opacity:1.0 } );
		var geometry = new PlaneGeometry(width, height);
		var mesh = new DescribableMesh(geometry, material, hoverText, clickText);
		mesh.position.set(Main.GAME_VIEWPORT_WIDTH * screenIndex.x + xOffset, -Main.GAME_VIEWPORT_HEIGHT / 2 + height / 2 + yOffset, -1410);
		
		#if debug
		mesh.name = hoverText;
		#end
		
		if(interactable) {
			game.interactables.push(mesh);
		}
		
		return mesh;
	}
	
	#if debug
	public function addGUIItems(gui:GUI):Void {
	}
	#end
}