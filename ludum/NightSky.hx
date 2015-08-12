package ludum;

import js.three.Geometry;
import js.three.ImageUtils;
import js.three.PointCloud;
import js.three.PointCloudMaterial;
import js.three.Scene;
import js.three.Vector3;
import ludum.NightSky.Rect;

typedef Rect = {
	var left:Int;
	var right:Int;
	var top:Int;
	var bottom:Int;
}

class NightSky {
	public static inline function randomFloat(from:Float, to:Float):Float {
		return from + ((to - from) * Math.random());
	}
	
	// TODO Vary the star texture etc
	public static inline function makeStars(scene:Scene, numStars:Int = 1000):Void {
		var geometry = new Geometry();
		
		var rect:Rect = { left: Std.int(-Main.GAME_VIEWPORT_WIDTH / 2) * 20, right: Std.int(Main.GAME_VIEWPORT_WIDTH / 2) * 20, top: Std.int(-Main.GAME_VIEWPORT_HEIGHT / 2) * 10, bottom: Std.int(Main.GAME_VIEWPORT_HEIGHT / 2) * 10 };
		
		for (i in 0...numStars) {
			var cutoff = randomFloat(rect.bottom, rect.top * Math.random());
			var vector = new Vector3(randomFloat(rect.left, rect.right), cutoff, -14170);
			geometry.vertices.push(vector);
		}
		
		var sprite = ImageUtils.loadTexture("assets/images/snowflake1.png");
		var color = [1.0, 0.2, 1.0];
		var size = 160;
		
		var material = new PointCloudMaterial( { size: size, map: sprite, transparent:true } );
		
		var particles = new PointCloud(geometry, material);
		
		scene.add(particles);
	}
	
	// TODO make a layer of stars that can be used to form text
	
	public static inline function makeComets(scene:Scene):Void {
		
	}
}