package;

@:enum abstract WebGLSupport(Int) {
	var SUPPORTED_AND_ENABLED = 0;
	var SUPPORTED_BUT_DISABLED = 1;
	var NOT_SUPPORTED = 2;
}

extern class WebGLDetector {
	public static function detect():WebGLSupport;
}