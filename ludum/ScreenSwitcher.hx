package ludum;

import js.three.Vector2;
import js.three.Vector3;

// For switching between screens in the game
class ScreenSwitcher {		
	public static function checkForBoundaryCrossing(lastPosition:Vector3, currentPosition:Vector3):Bool {
		var lastNearestBoundary:Float = Math.round(lastPosition.x / Main.GAME_VIEWPORT_WIDTH) * Main.GAME_VIEWPORT_WIDTH + Main.GAME_VIEWPORT_WIDTH / 2;
		var currentNearestBoundary:Float = Math.round(currentPosition.x / Main.GAME_VIEWPORT_WIDTH) * Main.GAME_VIEWPORT_WIDTH + Main.GAME_VIEWPORT_WIDTH / 2;
		
		if (lastNearestBoundary != currentNearestBoundary) {
			return true;
		}
		
		return false;
	}
	
	public static function getScreenIndices(position:Vector3):Vector2 {
		return new Vector2(Math.round(position.x / (Main.GAME_VIEWPORT_WIDTH)), Std.int(position.y / (Main.GAME_VIEWPORT_HEIGHT)));
	}
	
	public static function getNearestCameraClampX(position:Vector3):Float {
		return Math.round(position.x / Main.GAME_VIEWPORT_WIDTH) * Main.GAME_VIEWPORT_WIDTH;
	}
}