package ludum.screens;

class Screen {
	private var enemies = new List<Enemy>();
	
	public function new() {
		
	}
	
	public function onEnter() {
		
	}
	
	public function onExit() {
		
	}
	
	public function update(dt:Float):Void {
		for (enemy in enemies) {
			enemy.update(dt);
		}
	}
}