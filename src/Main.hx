package;

import external.dat.GUI;
import js.Browser;
import js.three.Color;
import js.three.ImageUtils;
import js.three.Mesh;
import js.three.MeshBasicMaterial;
import js.three.Object3D;
import js.three.OrthographicCamera;
import js.three.PerspectiveCamera;
import js.three.PlaneGeometry;
import js.three.Projector;
import js.three.Raycaster;
import js.three.Scene;
import js.three.Three;
import js.three.utils.Stats;
import js.three.Vector2;
import js.three.Vector3;
import js.three.WebGLRenderer;
import js.three.Mapping;
import js.three.Mappings;
import ludum.NightSky;
import ludum.Player;
import external.detector.WebGLDetector;
import motion.Actuate;
import msignal.Signal;

typedef Mouse = {
	var x:Float;
	var y:Float;
}

class Main {
	public static inline var DEGREES_TO_RAD:Float = 0.01745329;
	
	public static inline var GAME_VIEWPORT_WIDTH:Int = 800;
	public static inline var GAME_VIEWPORT_HEIGHT:Int = 500;
	private static inline var REPO_URL:String = "https://github.com/Tw1ddle/ludum-dare-33";
	
	#if debug
	private var guiItemCount:Int = 0;
	public var gui(default, null):GUI = new GUI( { autoPlace:true } );
	public var stats(default, null):Stats = new Stats();
	#end
	
	public var mouse(default, null):Mouse = { x: 0.0, y: 0.0 };
	
	public var backdropScene(default, null):Scene = new Scene();
	public var backdropCamera(default, null):OrthographicCamera;
	
	public var worldScene(default, null):Scene = new Scene();
	public var worldCamera(default, null):PerspectiveCamera;
	public var worldCameraFollowPoint(default, null):Vector3 = new Vector3();
	
	public var signal_screenChanged(default, null) = new Signal2<Float,Float>();
	
	public var uiScene(default, null):Scene = new Scene();
	public var uiCamera(default, null):OrthographicCamera;
	
	public var renderer(default, null):WebGLRenderer;
	
	public var intersectedObject(default, null):Dynamic = null;
	private var intersectables:Array<Object3D> = new Array<Object3D>();
	private var projector:Projector = new Projector();
	private var intersectionVector = new Vector3();
	private var raycaster = new Raycaster();
	
	private var player:Player;
	private var lastAnimationTime:Float = 0.0;
	private var dt:Float = 0.0; // Frame delta time
	
    public static function main():Void {
		var main = new Main();
    }
	
	public inline function new() {
		Browser.window.onload = onWindowLoaded;
	}
	
	public inline function onWindowLoaded():Void {
		// Attach game div
		var gameAttachPoint = Browser.document.getElementById("game");		
		var gameDiv = Browser.document.createElement("attach");
		gameAttachPoint.appendChild(gameDiv);
		
		// WebGL support check
		var glSupported:WebGLSupport = WebGLDetector.detect();
		if (glSupported != SUPPORTED_AND_ENABLED) {
			var unsupportedInfo = Browser.document.createElement('div');
			unsupportedInfo.style.position = 'absolute';
			unsupportedInfo.style.top = '10px';
			unsupportedInfo.style.width = '100%';
			unsupportedInfo.style.textAlign = 'center';
			unsupportedInfo.style.color = '#ffffff';
			
			switch(glSupported) {
				case WebGLSupport.NOT_SUPPORTED:
					unsupportedInfo.innerHTML = 'Your browser does not support WebGL. Click <a href="' + REPO_URL + '" target="_blank">here for screenshots</a> instead.';
				case WebGLSupport.SUPPORTED_BUT_DISABLED:
					unsupportedInfo.innerHTML = 'Your browser supports WebGL, but the feature appears to be disabled. Click <a href="' + REPO_URL + '" target="_blank">here for screenshots</a> instead.';
				default:
					unsupportedInfo.innerHTML = 'Could not detect WebGL support. Click <a href="' + REPO_URL + '" target="_blank">here for screenshots</a> instead.';
			}
			
			gameDiv.appendChild(unsupportedInfo);
			return;
		}
		
		// Setup WebGL renderer
        renderer = new WebGLRenderer();
        renderer.sortObjects = false;
		renderer.autoClear = false;
        renderer.setSize(GAME_VIEWPORT_WIDTH, GAME_VIEWPORT_HEIGHT);
		renderer.setClearColor(new Color(0, 0, 0));
		
		// Setup cameras
        worldCamera = new PerspectiveCamera(20, GAME_VIEWPORT_WIDTH / GAME_VIEWPORT_HEIGHT, 1, 200000);
		worldCameraFollowPoint.set(worldCamera.position.x, worldCamera.position.y, worldCamera.position.z);
		
		uiCamera = new OrthographicCamera(0, GAME_VIEWPORT_WIDTH, 0, GAME_VIEWPORT_HEIGHT, -1, 1);
		uiCamera.position.set(0, 0, 0);
		
		backdropCamera = new OrthographicCamera(0, GAME_VIEWPORT_WIDTH, 0, GAME_VIEWPORT_HEIGHT, -1, 1);
		backdropCamera.position.set(0, 0, 0);
		
		// TODO Populate the screens
		
		var groundMaterial = new MeshBasicMaterial( { map: ImageUtils.loadTexture('assets/images/ground1.png', Mappings.UVMapping()), transparent:true, depthWrite: false, depthTest: false /*,opacity:1.0*/ } );
		var geometry = new PlaneGeometry(GAME_VIEWPORT_WIDTH, 200);
		var mesh = new Mesh(geometry, groundMaterial);
		mesh.position.set(0, -GAME_VIEWPORT_HEIGHT / 2 + 100, -1410);
		worldScene.add(mesh);
		
		// Sky
		// Sky renders after ground to avoid transparency rendering order issues
		NightSky.makeStars(worldScene);
		NightSky.makeComets(worldScene);
		
		player = new Player(10, 30);
		player.position.set(0, -GAME_VIEWPORT_HEIGHT / 2 + 100 + 30, -1417);
		worldScene.add(player);
		
		// Camera follows player
		worldCamera.position.set(player.position.x, worldCamera.position.y, worldCamera.position.z);
		
		// TODO setup particle systems
		
		// TODO setup events
		
		// Window resize event
		Browser.document.addEventListener('resize', function(event) {
			
		}, false);
		
		// Mouse events
        Browser.document.addEventListener('mousedown', function(event) {
			if (event.which != 1) {
				return;
			}
			event.preventDefault();
			
            mouse.x = (event.clientX / Browser.window.innerWidth) * 2 - 1;
            mouse.y = - (event.clientY / Browser.window.innerHeight) * 2 + 1;
        }, false);
        Browser.document.addEventListener('mouseup', function(event) {
			if (event.which != 1) {
				return;
			}
			event.preventDefault();
			
            mouse.x = (event.clientX / Browser.window.innerWidth) * 2 - 1;
            mouse.y = - (event.clientY / Browser.window.innerHeight) * 2 + 1;
        }, false);
        Browser.document.addEventListener('mousemove', function(event) {
            event.preventDefault();
			
            mouse.x = (event.clientX / Browser.window.innerWidth) * 2 - 1;
            mouse.y = - (event.clientY / Browser.window.innerHeight) * 2 + 1;
        }, false);
		
		// Disable context menu opening
		Browser.document.addEventListener('contextmenu', function(event) {
			event.preventDefault();
		}, false);
		
		// Debug setup
		#if debug
		setupStats();
		setupGUI();
		#end
		
		player.signal_PositionChanged.add(onPlayerMoved);
		
		// Present game and start animation loop
		gameDiv.appendChild(renderer.domElement);
		Browser.window.requestAnimationFrame(animate);
	}
	
	private var lastPosition:Vector3 = new Vector3();
	public function onPlayerMoved(position:Vector3):Void {
	}
	
	private function animate(time:Float):Void {
		dt = (time - lastAnimationTime) * 0.001; // Seconds
		lastAnimationTime = time;
		
		// Find intersections
		intersectionVector.set(mouse.x, mouse.y, 1);
		projector.unprojectVector(intersectionVector, worldCamera);
		raycaster.set(worldCamera.position, cast intersectionVector.sub(worldCamera.position).normalize() );
		
		var intersects = raycaster.intersectObjects(intersectables);
		
		if (intersects.length > 0) {
			if (intersectedObject != intersects[0].object) {
				if (intersectedObject != null) {
					(cast intersectedObject).material.color.setHex(intersectedObject.currentHex);
				}
				
				intersectedObject = intersects[0].object;
				intersectedObject.currentHex = intersectedObject.material.color.getHex();
				intersectedObject.material.color.setHex(0xff0000);
			}
		}
		else {
			if (intersectedObject != null) {
				intersectedObject.material.color.setHex(intersectedObject.currentHex);
			}
			intersectedObject = null;
		}
		
		// Update entities
		player.update(dt);
		
		// Actuate.tween(worldCameraFollowPoint, 1, { x: player.position.x } );
		//worldCameraFollowPoint.x = player.position.x;
		// Actuate.tween(worldCameraFollowPoint, 1, { y: player.position.y } );
		
		worldCamera.position.set(worldCameraFollowPoint.x, worldCameraFollowPoint.y, worldCamera.position.z);
		
		// Clear the screen
		renderer.clear();
		
		// Render the backdrop
		renderer.render(backdropScene, backdropCamera);
		
		// Clear the depth buffer and render the world on top
		renderer.clearDepth();
		renderer.render(worldScene, worldCamera);
		
		// Clear the depth buffer and render the UI on top
		renderer.clearDepth();
		renderer.render(uiScene, uiCamera);
		
		#if debug
		stats.update();
		#end
		
		Browser.window.requestAnimationFrame(animate);
	}
	
	/*
	// TODO get the size of the geometry needed for a sprite n units away to have the given screen size
	private static inline function getSizeForDepth(camera:PerspectiveCamera) {
		
	}
	*/
	
	// Get the camera distance needed for a graphic height to fill the frustum
	public static inline function getDistanceForObjectHeight(fov:Float, height:Float):Float {
		return (height / Math.tan(fov * 0.5 * DEGREES_TO_RAD)) * 0.5;
	}
	
	// Get the height of the geometry required for a sprite n units away from the camera to have the given screen height
	public static inline function getWorldHeightForDistanceAndScreenHeight(fov:Float, distance:Float, pixelHeight:Float):Float {
		return (pixelHeight / GAME_VIEWPORT_HEIGHT) * (distance / (2 * Math.tan(fov / 2 * DEGREES_TO_RAD)));
	}
	
	// Get the frustum size for distance
	public static inline function getFrustumSizeAtDistance(fov:Float, aspectRatio:Float, distance:Float):Vector2 {
		var height:Float = 2.0 * distance * Math.tan(fov * 0.5 * DEGREES_TO_RAD);
		var width:Float = height * aspectRatio;
		return new Vector2(width, height);
	}
	
	#if debug
	private inline function setupStats():Void {
		stats.domElement.style.position = 'absolute';
		stats.domElement.style.top = '0px';
		Browser.window.document.body.appendChild(stats.domElement);
	}
	
	private inline function setupGUI():Void {
		addGUIItem(gui, worldCamera, "World Camera");
		addGUIItem(gui, uiCamera, "UI Camera");
		
		for (item in worldScene.children) {
			addGUIItem(gui, item);
		}
	}
	
	private inline function addGUIItem(gui:GUI, object:Dynamic, ?tag:String):GUI {
		if (gui == null || object == null) {
			return null;
		}
		
		var folder:GUI = null;
		
		// TODO prefer a way to get the name or other reasonable identifier for the object
		if (tag != null) {
			folder = gui.addFolder(tag + " (" + guiItemCount++ + ")");
		} else {
			folder = gui.addFolder("Item (" + guiItemCount++ + ")");
		}
		
		if (Std.is(object, Object3D)) {
			folder.add(object.position, 'x', -5000.0, 5000.0, 2).listen();
			folder.add(object.position, 'y', -5000.0, 5000.0, 2).listen();
			folder.add(object.position, 'z', -20000.0, 20000.0, 2).listen();

			folder.add(object.rotation, 'x', 0.0, Math.PI * 2, 0.1).listen();
			folder.add(object.rotation, 'y', 0.0, Math.PI * 2, 0.1).listen();
			folder.add(object.rotation, 'z', 0.0, Math.PI * 2, 0.1).listen();

			folder.add(object.scale, 'x', 0.0, 10.0, 0.1).listen();
			folder.add(object.scale, 'y', 0.0, 10.0, 0.1).listen();
			folder.add(object.scale, 'z', 0.0, 10.0, 0.1).listen();
		}
		
		if (Std.is(object, PerspectiveCamera)) {
			var camera:PerspectiveCamera = cast object;
		}
		
		if (Std.is(object, OrthographicCamera)) {
			var camera:OrthographicCamera = cast object;
		}
		
		return folder;
	}
	#end
}