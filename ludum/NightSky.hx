package ludum;

import js.three.Scene;
import js.three.Geometry;
import js.three.Vector3;
import js.three.ImageUtils;
import js.three.PointCloudMaterial;
import js.three.PointCloud;

import ludum.NightSky.Rect;

typedef Rect = {
	var left:Int;
	var right:Int;
	var top:Int;
	var bottom:Int;
}

class NightSky {
	public static inline function float(from:Float, to:Float):Float {
		return from + ((to - from) * Math.random());
	}
	
	public static inline function makeStars(scene:Scene, numStars:Int = 1000):Void {
		var geometry = new Geometry();
		
		var rect:Rect = { left: Std.int(-Main.GAME_VIEWPORT_WIDTH / 2) * 10, right: Std.int(Main.GAME_VIEWPORT_WIDTH / 2) * 10, top: Std.int(-Main.GAME_VIEWPORT_HEIGHT / 2) * 10, bottom: Std.int(Main.GAME_VIEWPORT_HEIGHT / 2) * 10 };
		
		for (i in 0...numStars) {
			// TODO Place stars according to a nice night sky distribution
			// Stars using http://mathworld.wolfram.com/DiskPointPicking.html with density function for semicircle cutoff effect
			var vector = new Vector3(float(rect.left, rect.right), float(rect.bottom, rect.top), -14170);
			geometry.vertices.push(vector);
		}
		
		// TODO Vary the star texture etc
		var sprite = ImageUtils.loadTexture("assets/images/snowflake1.png");
		var color = [1.0, 0.2, 1.0];
		var size = 200;
		
		var material = new PointCloudMaterial( { size: size, map: sprite } );
		
		var particles = new PointCloud(geometry, material);
		
		scene.add(particles);
	}
	
	public static inline function makeComets(scene:Scene):Void {
		
	}
}