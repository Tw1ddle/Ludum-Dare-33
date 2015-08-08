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
	private static inline var numStars:Int = 5000;
	
	public static inline function makeStars(scene:Scene):Void {
		var geometry = new Geometry();
		
		var rect:Rect = { left: 0, right: Main.GAME_WIDTH, top: 0, bottom: Main.GAME_HEIGHT };
		
		for (i in 0...numStars) {
			// TODO Place stars according to a nice night sky distribution
			// Stars using http://mathworld.wolfram.com/DiskPointPicking.html with density function for semicircle cutoff effect
			var vector = new Vector3(Math.random() * 2000 - 1000, Math.random() * 2000 - 1000, Math.random() * 2000 - 1000);
			geometry.vertices.push(vector);
		}
		
		// TODO Vary the star texture etc
		var sprite = ImageUtils.loadTexture("assets/images/snowflake1.png");
		var color = [1.0, 0.2, 1.0];
		var size = 20;
		
		var material = new PointCloudMaterial({ size: size, map: sprite });

		var particles = new PointCloud(geometry, material);
		particles.rotation.x = Math.random() * 6;
		particles.rotation.y = Math.random() * 6;
		particles.rotation.z = Math.random() * 6;
		scene.add(particles);
	}
	
	public static inline function makeComets(scene:Scene):Void {
		
	}
}