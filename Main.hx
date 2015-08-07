package;

import dat.GUI;
import js.Browser;
import js.three.FogExp2;
import js.three.Geometry;
import js.three.ImageUtils;
import js.three.Object3D;
import js.three.PerspectiveCamera;
import js.three.PointCloud;
import js.three.PointCloudMaterial;
import js.three.Projector;
import js.three.Raycaster;
import js.three.Scene;
import js.three.Vector3;
import js.three.WebGLRenderer;
import WebGLDetector;

class Main {	
	private static inline var REPO_URL:String = "https://github.com/Tw1ddle/ludum-dare-33";
	
	private static inline var GAME_WIDTH:Int = 800;
	private static inline var GAME_HEIGHT:Int = 500;
	
	public var gui(default, null):GUI;
	
    public static function main():Void {
		var main = new Main();
    }
	
	public function new() {
		Browser.window.onload = onWindowLoaded;
	}
	
	public inline function onWindowLoaded():Void {
		var gameDiv = Browser.document.getElementById("game");
		
		var glSupported:WebGLSupport = WebGLDetector.detect();
		
		var container = Browser.document.createElement("attach");
		gameDiv.appendChild(container);
		
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
			
			container.appendChild(unsupportedInfo);
			return;
		}
		
		gui = new GUI( { autoPlace:true } );
		
		// Black background as in Beneath the Cave
		// Stars using http://mathworld.wolfram.com/DiskPointPicking.html with density function for semicircle cutoff effect
		// Camera jumping between screens when moving horizontally as in Beneath the Cave
		
        var mouse = { x: 0.0, y: 0.0 };
        var objects = new Array<Object3D>();
        var INTERSECTED : Dynamic = null;
		
        var camera = new PerspectiveCamera(70, GAME_WIDTH / GAME_HEIGHT, 1, 10000);
        camera.position.set(0, 300, 500);
		
        var scene = new Scene();
		scene.fog = new FogExp2( 0x000000, 0.0008 );
        scene.add(camera);
		
        var projector = new Projector();
		
        var renderer = new WebGLRenderer();
        renderer.sortObjects = false;
        renderer.setSize(GAME_WIDTH, GAME_HEIGHT);
		
        container.appendChild(renderer.domElement);
		
        var stats = new js.three.utils.Stats();
        stats.domElement.style.position = 'absolute';
        stats.domElement.style.top = '0px';
        container.appendChild(stats.domElement);
		
		var geometry = new Geometry();
		
		var i:Int = 0;
		for (i in 0...5000) {
			var vector = new Vector3( Math.random() * 2000 - 1000, Math.random() * 2000 - 1000, Math.random() * 2000 - 1000 );
			geometry.vertices.push(vector);
		}

		var sprite1 = ImageUtils.loadTexture( "assets/images/snowflake1.png" );
		
		var color  = [1.0, 0.2, 1.0];
		var sprite = sprite1;
		var size   = 20;
		
		var material = new PointCloudMaterial( { size: size, map: sprite } );

		var particles = new PointCloud( geometry, material );
		particles.rotation.x = Math.random() * 6;
		particles.rotation.y = Math.random() * 6;
		particles.rotation.z = Math.random() * 6;
		scene.add( particles );
		
        Browser.document.addEventListener('mousemove', function(event) {
            event.preventDefault();
			
            mouse.x = (event.clientX / Browser.window.innerWidth) * 2 - 1;
            mouse.y = - (event.clientY / Browser.window.innerHeight) * 2 + 1;
        }, false);
		
        var radius = 100;
        var theta = 0.0;
		
        var timer = new haxe.Timer(std.Math.round(1000/60));
        timer.run = function() {
            theta += 0.2;
			
            camera.lookAt(scene.position);
			
            // find intersections
			
            var vector = new Vector3(mouse.x, mouse.y, 1);
            projector.unprojectVector(vector, camera);
			
            var raycaster = new Raycaster(camera.position, cast vector.sub(camera.position).normalize() );
			
            var intersects = raycaster.intersectObjects(objects);
			
            if (intersects.length > 0) {
                if (INTERSECTED != intersects[ 0 ].object) {
                    if (INTERSECTED != null) (cast INTERSECTED).material.color.setHex(INTERSECTED.currentHex);
					
                    INTERSECTED = intersects[ 0 ].object;
                    INTERSECTED.currentHex = INTERSECTED.material.color.getHex();
                    INTERSECTED.material.color.setHex(0xff0000);
                }
            }
			else {
                if (INTERSECTED != null) INTERSECTED.material.color.setHex(INTERSECTED.currentHex);
                INTERSECTED = null;
            }
			
            renderer.render(scene, camera);
            stats.update();
        }
	}
}