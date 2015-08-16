package shaders;

import external.dat.GUI;
import js.three.Vector3;
import util.FileReader;

class VignetteShader {	
	public static var uniforms = {
	};
	
	public static var vertexShader = FileReader.readFile("shaders/glsl/vignette.vertex");
	public static var fragmentShader = FileReader.readFile("shaders/glsl/vignette.fragment");
}

class VignetteEffectController {	
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
	public function addGUIItem(c:VignetteEffectController, gui:GUI):Void {		
		var controller:VignetteEffectController = cast c;
		
		var updateValues = function(t:Dynamic) {
			controller.updateUniforms();
		};
	}
	#end
}