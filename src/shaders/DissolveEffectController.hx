package shaders;

import external.dat.GUI;
import js.three.Vector3;
import util.FileReader;

class DissolveShader {	
	public static var uniforms = {
	};
	
	public static var vertexShader = FileReader.readFile("shaders/glsl/dissolve.vertex");
	public static var fragmentShader = FileReader.readFile("shaders/glsl/dissolve.fragment");
}

class DissolveEffectController {	
	public function new() {		
		setInitialValues();
		updateUniforms();
	}
	
	private inline function setInitialValues():Void {
	}
	
	// TODO do these individually using setters
	public function updateUniforms():Void {
	}
	
	#if debug
	public function addGUIItem(c:DissolveEffectController, gui:GUI):Void {		
		var controller:DissolveEffectController = cast c;
		
		var updateValues = function(t:Dynamic) {
			controller.updateUniforms();
		};
	}
	#end
}