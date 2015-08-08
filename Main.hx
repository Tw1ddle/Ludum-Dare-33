package;

import dat.GUI;
import js.Browser;
import js.three.Camera;
import js.three.FogExp2;
import js.three.Object3D;
import js.three.PerspectiveCamera;
import js.three.Projector;
import js.three.Raycaster;
import js.three.Scene;
import js.three.utils.Stats;
import js.three.Vector3;
import js.three.WebGLRenderer;
import ludum.NightSky;

import WebGLDetector;

typedef Mouse = {
	var x:Float;
	var y:Float;
}

class Main {		
	public static inline var GAME_WIDTH:Int = 800;
	public static inline var GAME_HEIGHT:Int = 500;
	private static inline var REPO_URL:String = "https://github.com/Tw1ddle/ludum-dare-33";
	
	#if debug
	public var gui(default, null):GUI = new GUI( { autoPlace:true } );
	public var stats(default, null):Stats = new Stats();
	#end
	
	public var mouse(default, null):Mouse = { x: 0.0, y: 0.0 };
	public var scene(default, null):Scene = new Scene();
	public var renderer(default, null):WebGLRenderer;
	public var camera(default, null):Camera;
	
	public var intersection:Dynamic = null;
	
	public var gameDiv(default, null):Dynamic;
	
	private var intersectables:Array<Object3D> = new Array<Object3D>();
	private var projector:Projector = new Projector();
	
    public static function main():Void {
		var main = new Main();
    }
	
	public inline function new() {
		Browser.window.onload = onWindowLoaded;
	}
	
	public inline function onWindowLoaded():Void {
		// Attach game div
		var gameAttachPoint = Browser.document.getElementById("game");		
		gameDiv = Browser.document.createElement("attach");
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
		
		// Window resize
		Browser.document.addEventListener('resize', function(event) {
			
		}, false);
		
		// Mouse events
        Browser.document.addEventListener('mousedown', function(event) {
			if (event.which != 1) {
				return;
			}
			
            mouse.x = (event.clientX / Browser.window.innerWidth) * 2 - 1;
            mouse.y = - (event.clientY / Browser.window.innerHeight) * 2 + 1;
        }, false);
		
        Browser.document.addEventListener('mouseup', function(event) {
			if (event.which != 1) {
				return;
			}
			
            mouse.x = (event.clientX / Browser.window.innerWidth) * 2 - 1;
            mouse.y = - (event.clientY / Browser.window.innerHeight) * 2 + 1;
        }, false);
		
        Browser.document.addEventListener('mousemove', function(event) {
            event.preventDefault();
			
            mouse.x = (event.clientX / Browser.window.innerWidth) * 2 - 1;
            mouse.y = - (event.clientY / Browser.window.innerHeight) * 2 + 1;
        }, false);
		
		Browser.document.addEventListener('contextmenu', function(event) {
			event.preventDefault();
		}, false);
		
        camera = new PerspectiveCamera(70, GAME_WIDTH / GAME_HEIGHT, 1, 10000);
        camera.position.set(0, 300, 500);
		
		scene.add(camera);
		scene.fog = new FogExp2( 0x000000, 0.0008 );
		
        renderer = new WebGLRenderer();
        renderer.sortObjects = false;
        renderer.setSize(GAME_WIDTH, GAME_HEIGHT);
		
        gameDiv.appendChild(renderer.domElement);
		
		NightSky.makeStars(scene);
		
		#if debug
		setupStats();
		setupGUI();
		#end
		
		Browser.window.requestAnimationFrame(animate);
	}
	
	#if debug
	private inline function setupStats():Void {
		stats.domElement.style.position = 'absolute';
		stats.domElement.style.top = '0px';
		gameDiv.appendChild(stats.domElement);
	}
	
	private inline function setupGUI():Void {
		
	}
	#end
	
	private var intersectionVector = new Vector3();
	private var raycaster = new Raycaster();
	
	private function animate(dt:Float):Void {
		camera.lookAt(scene.position);
		
		// Find intersections
		intersectionVector.set(mouse.x, mouse.y, 1);
		projector.unprojectVector(intersectionVector, camera);
		raycaster.set(camera.position, cast intersectionVector.sub(camera.position).normalize() );
		
		var intersects = raycaster.intersectObjects(intersectables);
		
		if (intersects.length > 0) {
			if (intersection != intersects[0].object) {
				if (intersection != null) {
					(cast intersection).material.color.setHex(intersection.currentHex);
				}
				
				intersection = intersects[0].object;
				intersection.currentHex = intersection.material.color.getHex();
				intersection.material.color.setHex(0xff0000);
			}
		}
		else {
			if (intersection != null) {
				intersection.material.color.setHex(intersection.currentHex);
			}
			intersection = null;
		}
		
		renderer.render(scene, camera);
		
		#if debug
		stats.update();
		#end
		
		Browser.window.requestAnimationFrame(animate);
	}
}