package;

import external.dat.GUI;
import external.particle.Emitter;
import external.particle.Group;
import external.webgl.Detector;
import js.Browser;
import js.three.Color;
import js.three.ImageUtils;
import js.three.Mesh;
import js.three.Object3D;
import js.three.OrthographicCamera;
import js.three.PerspectiveCamera;
import js.three.Raycaster;
import js.three.Scene;
import js.three.ShaderMaterial;
import js.three.SphereGeometry;
import js.three.utils.Stats;
import js.three.Vector2;
import js.three.Vector3;
import js.three.WebGLRenderer;
import ludum.CinematicText;
import ludum.Describable;
import ludum.Player;
import ludum.screens.RandomScreen;
import ludum.screens.Screen;
import ludum.screens.ScreenFour;
import ludum.screens.ScreenOne;
import ludum.screens.ScreenThree;
import ludum.screens.ScreenTwo;
import ludum.screens.ScreenZero;
import ludum.ScreenSwitcher;
import motion.Actuate;
import motion.easing.*;
import msignal.Signal;
import shaders.SkyEffectController;

class Main {
	public static inline var DEGREES_TO_RAD:Float = 0.01745329;
	public static inline var GAME_VIEWPORT_WIDTH:Float = 800;
	public static inline var GAME_VIEWPORT_HEIGHT:Float = 500;
	private static inline var REPO_URL:String = "https://github.com/Tw1ddle/Ludum-Dare-33";
	private static inline var TWITTER_URL:String = "https://twitter.com/Sam_Twidale";
	private static inline var LUDUM_DARE_URL:String = "http://ludumdare.com/";
	private static inline var WEBSITE_URL:String = "http://samcodes.co.uk/";
	
	#if debug
	private var guiItemCount:Int = 0;
	public var sceneGUI(default, null):GUI = new GUI( { autoPlace:true } );
	public var particleGUI(default, null):GUI = new GUI( { autoPlace:true } );
	public var shaderGUI(default, null):GUI = new GUI( { autoPlace:true } );
	public var stats(default, null):Stats = new Stats();
	#end
	
	public var mouse(default, null):Vector2 = new Vector2(0.0, 0.0);
	
	public var backdropScene(default, null):Scene = new Scene();
	public var backdropCamera(default, null):OrthographicCamera;
	
	public var worldScene(default, null):Scene = new Scene();
	public var worldCamera(default, null):PerspectiveCamera;
	public var worldCameraFollowPoint(default, null):Vector3 = new Vector3();
	
	public var signal_screenChangeTrigger(default, null) = new Signal2<Screen, Screen>();
	
	public var uiScene(default, null):Scene = new Scene();
	public var uiCamera(default, null):OrthographicCamera;

	private var gameAttachPoint:Dynamic;
	private var renderer:WebGLRenderer;
	public var skyEffectController(default, null):SkyEffectController = new SkyEffectController();
	
	private var gameText:Dynamic = null;
	private var gameTextFractionShown:Float = 0.0;
	
	public var signal_hoveredObjectChanged(default, null):Signal1<Object3D> = new Signal1<Object3D>();
	private var hoveredObject:Object3D = null;
	private var hoveredObjectClickCount:Int = 0;
	public var interactables(default, null):Array<Object3D> = new Array<Object3D>();
	private var raycaster = new Raycaster();
	
	private var starGroup:Group;
	public var starEmitter(default, null):Emitter;
	public var player(default, null):Player;
	public var signal_playerClicked(default, null) = new Signal2<Float, Float>();
	private var titleText:CinematicText = new CinematicText();
	private var subtitleText:CinematicText = new CinematicText();
	private var charredLandsText:CinematicText = new CinematicText();
	private var parchedWastesText:CinematicText = new CinematicText();
	private var seaOfStarsText:CinematicText = new CinematicText();
	
	private var lastPlayerPosition:Vector3 = new Vector3();
	private var playerReturningToStart:Bool = false; // Player returns to start after death
	
	private var screenZero:ScreenZero;
	private var screenOne:ScreenOne;
	private var screenTwo:ScreenTwo;
	private var screenThree:ScreenThree;
	private var screenFour:ScreenFour;
	private var screens:List<Screen> = new List<Screen>();
	
	#if debug
	private var xKeyDown:Bool = false;
	#end
	
	private var lastAnimationTime:Float = 0.0; // Last time from requestAnimationFrame
	private var dt:Float = 0.0; // Frame delta time
	
    public static function main():Void {
		var main = new Main();
	}
	
	public inline function new() {
		Browser.window.onload = onWindowLoaded;
	}
	
	public inline function onWindowLoaded():Void {
		// Attach game div
		gameAttachPoint = Browser.document.getElementById("game");		
		var gameDiv = Browser.document.createElement("attach");
		gameAttachPoint.appendChild(gameDiv);
		
		// WebGL support check
		var glSupported:WebGLSupport = Detector.detect();
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
		
		// Gameplay instruction and examine text
		gameText = Browser.document.createElement('div');
		gameText.style.position = 'absolute';
		gameText.style.bottom = '-30px';
		gameText.style.width = '100%';
		gameText.style.textAlign = 'center';
		gameText.style.color = '#444444';
		gameText.style.fontSize = '20px';
		gameText.innerHTML = '';
		gameDiv.appendChild(gameText);
		
		// Credits and video link
		var credits = Browser.document.createElement('div');
		credits.style.position = 'absolute';
		credits.style.bottom = '-70px';
		credits.style.width = '100%';
		credits.style.textAlign = 'center';
		credits.style.color = '#333333';
		credits.innerHTML = 'Created by <a href=' + TWITTER_URL + ' target="_blank">Sam Twidale</a> for <a href=' + LUDUM_DARE_URL + ' target="_blank">Ludum Dare 33</a>. Get the code <a href=' + REPO_URL + ' target="_blank">here</a>.';
		gameDiv.appendChild(credits);
		
		// Setup WebGL renderer
        renderer = new WebGLRenderer({ antialias: false });
        renderer.sortObjects = false;
		renderer.autoClear = false;
        renderer.setSize(GAME_VIEWPORT_WIDTH, GAME_VIEWPORT_HEIGHT);
		renderer.setClearColor(new Color(0x222222));
		
		// Setup cameras
        worldCamera = new PerspectiveCamera(20, GAME_VIEWPORT_WIDTH / GAME_VIEWPORT_HEIGHT, 0.5, 2000000);
		worldCameraFollowPoint.set(worldCamera.position.x, worldCamera.position.y, worldCamera.position.z);
		
		uiCamera = new OrthographicCamera(0, GAME_VIEWPORT_WIDTH, 0, GAME_VIEWPORT_HEIGHT, -1, 1);
		uiCamera.position.set(0, 0, 0);
		
		backdropCamera = new OrthographicCamera(0, GAME_VIEWPORT_WIDTH, 0, GAME_VIEWPORT_HEIGHT, -1, 1);
		backdropCamera.position.set(0, 0, 0);
		
		// Setup world entities
		player = new Player(worldScene, 0, -Main.GAME_VIEWPORT_HEIGHT / 2 + 100 + 20, 10, 30);
		
		var skyMat = new ShaderMaterial( {
			fragmentShader: SkyShader.fragmentShader,
			vertexShader: SkyShader.vertexShader,
			uniforms: SkyShader.uniforms,
			side: BackSide
		});
		var skyMesh = new Mesh(new SphereGeometry(450000, 32, 15), skyMat);
		
		#if debug
		skyMesh.name = "Sky Mesh";
		#end
		
		worldScene.add(skyMesh);
		
		// TODO could use vignette shader for life force, create the need to flag spots/reach places (good for a time limit themed game actually!)
		// Stars
		starGroup = new Group( { texture: ImageUtils.loadTexture('assets/images/icefly.png'), maxAge: 3 } );
		starEmitter = new Emitter({
			type: 'cube',
			position: new Vector3(0, 0, -14170), // worldCamera position * 10
			positionSpread: new Vector3(Main.GAME_VIEWPORT_WIDTH * 12, Main.GAME_VIEWPORT_HEIGHT * 10, 0), // Extra space on x axis so new stars appear before player sees them
			acceleration: new Vector3(0, 0, 0),
			accelerationSpread: new Vector3(0, 0, 0),
			velocity: new Vector3(0, 0, 0),
			velocitySpread: new Vector3(0, 0, 0),
			particleCount: 2000,
			opacityStart: 0.0,
			opacityMiddle: 0.6,
			opacityMiddleSpread: 0.4,
			opacityEnd: 0.0,
			sizeStart: 220,
		});
		
		#if debug
		starGroup.mesh.name = "Star Particle Group";
		#end
		
		starGroup.addEmitter(starEmitter);
		starGroup.mesh.frustumCulled = false;
		worldScene.add(starGroup.mesh);
		
		// Setup screens
		screenZero = new ScreenZero(this, new Vector2(0, 0));
		screenOne = new ScreenOne(this, new Vector2(1, 0));
		screenTwo = new ScreenTwo(this, new Vector2(2, 0));
		
		screens.push(screenZero);
		screens.push(screenOne);
		screens.push(screenTwo);
		
		var narrative:Array<String> = [ 
			"I must find my disciples...",
			"Perhaps they have forgotten me...",
			"...",
			"......",
			"The impudence! How dare they leave me!",
			"...",
			"I will track them down and make them pay...!",
			"...",
			"......",
			"I searched for long days...",
			"My anger growing hot under the blazing sun...",
			"...",
			"And at night...",
			"The stars wheeled overhead, unable to touch me...",
			"...",
			"As I hastened in my search, even the winds failed to bear against me...",
			"...",
			"And eventually I happened past fresher tombs...",
			"...of heathen...",
			"...and long dead priests",
			"...and of my own followers",
			"...",
			"At last, I thought the search nearing an end...",
			"...",
			"......",
			".........",
			"......",
			"...But instead I found myself come to the edge of the sea of Otherworldly Stars...",
			"...",
			"To come this far and find no one...",
			"My disciples must have abandoned me...",
			"That is...",
			"UNFORGIVEABLE",
			"...",
			"They dare to flee to my sisters across the sea...",
			"I shall immolate their lands...!",
			"...THEY SHALL BOW BEFORE ME, AGNI, LORD OF FIRE",
			"...",
			"...",
		];
		
		for (i in 0...narrative.length) {
			screens.push(new RandomScreen(this, new Vector2(2 + i, 0), narrative[i]));
		}
		
		screenThree = new ScreenThree(this, new Vector2(narrative.length + 3, 0));
		screenFour = new ScreenFour(this, new Vector2(narrative.length + 4, 0));
		screens.push(screenThree);
		screens.push(screenFour);
		
		// Title/intro text
		titleText.init("Otherworldly Stars");
		subtitleText.init("You Are The Monster");
		worldScene.add(titleText);
		worldScene.add(subtitleText);
		
		// Screen/area intro text
		charredLandsText.init("The Charred Lands");
		parchedWastesText.init("The Parched Wastes");
		seaOfStarsText.init("The Sea Of Stars");
		worldScene.add(charredLandsText);
		worldScene.add(parchedWastesText);
		worldScene.add(seaOfStarsText);
		
		// Specify items player can click
		interactables.push(player);
		
		// Connect signals and slots
		player.signal_PositionChanged.add(onPlayerMoved);
		player.signal_Died.add(onPlayerDied);
		signal_screenChangeTrigger.add(onScreenChange);
		signal_hoveredObjectChanged.add(onHoveredObjectChanged);
		signal_playerClicked.add(onObjectClicked);
		
		// Event setup
		// Window resize event
		Browser.document.addEventListener('resize', function(event) {
			
		}, false);
		
		// Mouse events
        Browser.document.addEventListener('mousedown', function(event) {
			if (event.which != 1) {
				return;
			}
			event.preventDefault();
			updateMousePosition(event.clientX, event.clientY);
			signal_playerClicked.dispatch(mouse.x, mouse.y);
        }, false);
        Browser.document.addEventListener('mouseup', function(event) {
			if (event.which != 1) {
				return;
			}
			event.preventDefault();
			updateMousePosition(event.clientX, event.clientY);
        }, false);
        Browser.document.addEventListener('mousemove', function(event) {
            event.preventDefault();
			updateMousePosition(event.clientX, event.clientY);
        }, false);
		
		// Key events
        Browser.document.addEventListener('keydown', function(event) {
			var charCode:Int = event.keyCode;
			
			#if debug
			if (charCode == 88) {
				xKeyDown = true;
				player.signal_Died.dispatch();
			}
			#end
        }, false);
        Browser.document.addEventListener('keyup', function(event) {
			var charCode = event.keyCode;
			
			#if debug
			if (charCode == 88) {
				xKeyDown = false;
			}
			#end
        }, false);
		
		// Disable context menu opening
		Browser.document.addEventListener('contextmenu', function(event) {
			event.preventDefault();
		}, false);
		
		// Disable page scrolling with keys etc
		Browser.document.addEventListener('DOMMouseScroll', function(event) {
			event.preventDefault();
		}, false);
		
		// Debug setup
		#if debug
		setupStats();
		setupGUI();
		#end
		
		// Run the game intro scene
		runGameIntro();
		
		// Present game and start animation loop
		gameDiv.appendChild(renderer.domElement);
		Browser.window.requestAnimationFrame(animate);
	}
	
	private inline function runGameIntro():Void {
		player.inputEnabled = false;
		
		worldCamera.position.set(-1200, 0, 0); // Left of initial game screen for intro
		skyEffectController.inclination = 0.5160; // Sun set under horizon
		skyEffectController.azimuth = 0.1700; // East of world camera but west of altar
		skyEffectController.updateUniforms();
		
		titleText.position.set(-1000, 50, -1400);
		titleText.tween(function() {
			player.inputEnabled = true;
		});
		
		subtitleText.position.set(-1000, -50, -1400);
		subtitleText.tween();
		
		// Move camera to start position
		Actuate.tween(worldCamera.position, 6, { x: ScreenSwitcher.getNearestCameraClampX(player.position) } ).delay(3).ease(Sine.easeInOut).onComplete(function() {
			setGameText("Arrow keys to move, click and hover to interact.", "#AAAAAA"); // Initial player control instructions
		});
		
		// Kill most particles after the initial rush of stars
		Actuate.tween(screenZero.starEmitter, 5, { alive: 0.03 } ).delay(3);
		
		// Bring sun up
		Actuate.tween(skyEffectController, 5, { inclination: 0.4983, azimuth: 0.1979, turbidity: 4.7, rayleigh: 2.28, mieDirectionalG: 0.820, refractiveIndex: 1.00029, mieV: 3.936, mieZenithLength: 34000, sunAngularDiameter: 0.00830, depolarizationFactor: 0.020 } ).delay(5).onUpdate(function():Void {
			skyEffectController.updateUniforms();
		}).ease(Sine.easeInOut);
		
		// Reduce star background out due to sun being up
		Actuate.tween(starEmitter, 3, { alive: 0.5, opacityMiddle: 0.3 } ).delay(5);
	}
	
	// TODO have a few functions for different star field settings
	// TODO have a few functions for 
	
	private inline function showText(message:String, ?onShowComplete:Void->Void = null, ?onHideComplete:Void->Void = null):Void {
		titleText.init(message);
		titleText.tween(onShowComplete, onHideComplete);
	}
	
	private inline function updateMousePosition(x:Float, y:Float):Void {
		mouse.x = MathUtils.clamp(((x - gameAttachPoint.offsetLeft) / gameAttachPoint.clientWidth) * 2 - 1, -1, 1);
		mouse.y = MathUtils.clamp(-((y - gameAttachPoint.offsetTop) / gameAttachPoint.clientHeight) * 2 + 1, -1, 1);
	}
	
	public function onHoveredObjectChanged(o:Object3D):Void {
		hoveredObjectClickCount = 0;
		
		if (o != null) {
			if (Std.is(o, Describable)) {
				var describable:Describable = cast o;
				setGameText(describable.hoverText);
			} else if (Std.is(o, Player)) {
				var player:Player = cast o;
				setGameText(Player.randomMessage(Std.int(Math.random() * 3)));
			}
		} else {
			setGameText("");
		}
	}
	
	public inline function setGameText(text:String, color:String = '#990000', showDuration:Float = 0.5):Void {
		gameTextFractionShown = 0.0;
		Actuate.tween(this, showDuration, { gameTextFractionShown: 1.0 } ).onUpdate(function() {
			gameText.innerHTML = text.substring(0, Std.int(text.length * gameTextFractionShown));
			gameText.style.color = color;
		}).ease(Linear.easeNone);
	}
	
	public function onObjectClicked(x:Float, y:Float):Void {
		if (hoveredObject != null) {
			if (Std.is(hoveredObject, Describable)) {
				var describable:Describable = cast hoveredObject;
				setGameText(describable.clickText(hoveredObjectClickCount));
				hoveredObjectClickCount++;
			}
		} else {
			player.fire(x, y);
		}
	}
	
	public function onPlayerDied():Void {
		playerReturningToStart = true;
		
		player.inputEnabled = false;
		
		var duration = ScreenSwitcher.getScreenIndices(lastPlayerPosition).x * 2;
		
		Actuate.tween(player.particleEmitter, duration, { alive: 0.1 } );
		
		Actuate.tween(player.position, duration, { x: 0 } ).onUpdate(function() {
			player.signal_PositionChanged.dispatch(player.position);
		}).onComplete(function() {
			playerReturningToStart = false;
			restoreSkyToDefaults();
			
			for (screen in screens) {
				screen.reset();
			}
			
			player.inputEnabled = true;
			player.reset();
		}).ease(Quad.easeInOut);
		Actuate.tween(worldCameraFollowPoint, duration, { x: 0 } ).onUpdate(function() {
			worldCamera.position.x = worldCameraFollowPoint.x;
		}).ease(Quad.easeInOut);
	}
	
	public function onPlayerMoved(position:Vector3):Void {
		if (ScreenSwitcher.checkForBoundaryCrossing(lastPlayerPosition, position)) {
			var currentIndex = ScreenSwitcher.getScreenIndices(lastPlayerPosition);
			var nextIndex = ScreenSwitcher.getScreenIndices(position);
			
			if (nextIndex.x == -1) { // TODO || too early due to intro sequence (or just deny player control?)
				#if debug
				trace("Rejecting screen change to negative screen index");
				#end
				player.position.set(lastPlayerPosition.x, lastPlayerPosition.y, lastPlayerPosition.z);
			} else {
				var current:Screen = Screen.findScreen(currentIndex, screens);
				var next:Screen = Screen.findScreen(nextIndex, screens);
				
				if(current == null || current.permitsTransition(next)) {
					signal_screenChangeTrigger.dispatch(current, next);
				}
			}
		}
		
		lastPlayerPosition.set(position.x, position.y, position.z);
	}
	
	public function onScreenChange(current:Screen, next:Screen):Void {
		#if debug
		//trace("Screen changed from: " + lastIndex + " to: " + currentIndex);
		#end
		
		if (current != null) {
			current.onExit();
			current.active = false;
		}

		if (next != null) {
			next.active = true;
			next.onEnter();
		}
		
		if(!playerReturningToStart) {
			worldCameraFollowPoint.x = ScreenSwitcher.getNearestCameraClampX(player.position);
			// Tween the camera to the follow point
			Actuate.tween(worldCamera.position, 1, { x: worldCameraFollowPoint.x } ).ease(Sine.easeOut);
		}
	}
	
	public function restoreSkyToDefaults(duration:Float = 3, inclination:Float = 0.4983, azimuth:Float = 0.1979):Void {		
		Actuate.tween(skyEffectController, duration, {
			turbidity: 4.7,
			rayleigh: 2.28,
			mieCoefficient: 0.005,
			mieDirectionalG: 0.82,
			luminance: 1.00,
			inclination: inclination,
			azimuth: azimuth,
			refractiveIndex: 1.00029,
			numMolecules: 2.542e25,
			depolarizationFactor: 0.02,
			rayleighZenithLength: 8400,
			mieV: 3.936,
			mieZenithLength: 34000,
			sunIntensityFactor: 1000,
			sunIntensityFalloffSteepness: 1.5,
			sunAngularDiameterDegrees: 0.00933
		}).onUpdate(function() {
			skyEffectController.updateUniforms();
		});
		
		Actuate.tween(skyEffectController.primaries, duration, {
			x: 6.8e-7,
			y: 5.5e-7,
			z: 4.5e-7
		}).onUpdate(function() {
			skyEffectController.updateUniforms();
		});
		
		Actuate.tween(skyEffectController.cameraPos, duration, {
			x: 100000,
			y: -40000,
			z: 0
		}).onUpdate(function() {
			skyEffectController.updateUniforms();
		});
		
		Actuate.tween(skyEffectController.mieKCoefficient, duration, {
			x: 0.686,
			y: 0.678,
			z: 0.666
		}).onUpdate(function() {
			skyEffectController.updateUniforms();
		});
	}
	
	public function restoreStarsToDefaults():Void {
		starEmitter.position.set(0, 0, -14170);
		starEmitter.positionSpread.set(Main.GAME_VIEWPORT_WIDTH * 12, Main.GAME_VIEWPORT_HEIGHT * 10, 0);
		starEmitter.acceleration.set(0, 0, 0);
		starEmitter.accelerationSpread.set(0, 0, 0);
		starEmitter.velocity.set(0, 0, 0);
		starEmitter.velocitySpread.set(0, 0, 0);
		starEmitter.particleCount = 2000;
		starEmitter.opacityStart = 0.0;
		starEmitter.opacityMiddle = 0.3;
		starEmitter.opacityEnd = 0.0;
		starEmitter.sizeStart = 220;
		starEmitter.sizeMiddle = 220;
		starEmitter.sizeEnd = 220;
		starEmitter.alive = 0.5;
		// NOTE this doesn't reset everything, there are more props...
	}
	
	private function animate(time:Float):Void {
		dt = (time - lastAnimationTime) * 0.001; // Seconds
		lastAnimationTime = time;
		
		// Find intersections
		raycaster.setFromCamera(mouse, worldCamera);
		var hovereds = raycaster.intersectObjects(interactables);
		if (hovereds.length > 0) {
			if (hoveredObject != hovereds[0].object) {
				hoveredObject = hovereds[0].object;
				signal_hoveredObjectChanged.dispatch(hoveredObject);
			}
		} else {
			if (hoveredObject != null) {
				signal_hoveredObjectChanged.dispatch(null);
			}
			hoveredObject = null;
		}
		
		// Update entities
		
		// Make the star emitter follow the camera
		starEmitter.position.set(worldCamera.position.x, worldCamera.position.y, -14170);
		
		starGroup.tick(dt);
		
		titleText.update(dt);
		player.update(dt);
		
		for (screen in screens) {
			screen.update(dt);
		}
		
		// Clear the screen
		renderer.clear();
		
		// Render the backdrop
		renderer.render(backdropScene, backdropCamera);
		
		// Clear the depth buffer and render the world on top
		renderer.clearDepth();
		renderer.render(worldScene, worldCamera);
		
		// Clear the depth buffer and render the UI on top
		renderer.clearDepth();
		renderer.render(uiScene, uiCamera);
		
		#if debug
		stats.update();
		#end
		
		Browser.window.requestAnimationFrame(animate);
	}
	
	// Get the camera distance needed for a graphic height to fill the frustum
	public static inline function getDistanceForObjectHeight(fov:Float, height:Float):Float {
		return (height / Math.tan(fov * 0.5 * DEGREES_TO_RAD)) * 0.5;
	}
	
	// Get the height of the geometry required for a sprite n units away from the camera to have the given screen height
	public static inline function getWorldHeightForDistanceAndScreenHeight(fov:Float, distance:Float, pixelHeight:Float):Float {
		return (pixelHeight / GAME_VIEWPORT_HEIGHT) * (distance / (2 * Math.tan(fov / 2 * DEGREES_TO_RAD)));
	}
	
	// Get the frustum size for distance
	public static inline function getFrustumSizeAtDistance(fov:Float, aspectRatio:Float, distance:Float):Vector2 {
		var height:Float = 2.0 * distance * Math.tan(fov * 0.5 * DEGREES_TO_RAD);
		var width:Float = height * aspectRatio;
		return new Vector2(width, height);
	}
	
	#if debug
	private inline function setupStats():Void {
		stats.domElement.style.position = 'absolute';
		stats.domElement.style.top = '0px';
		Browser.window.document.body.appendChild(stats.domElement);
	}
	
	private inline function setupGUI():Void {
		addGUIItem(sceneGUI, worldCamera, "World Camera");
		addGUIItem(sceneGUI, uiCamera, "UI Camera");
		
		for (item in worldScene.children) {
			addGUIItem(sceneGUI, item);
		}
		
		addGUIItem(particleGUI.addFolder("Player Emitter"), player.particleEmitter, "Player Emitter");
		
		addGUIItem(particleGUI.addFolder("Player Blast Emitter"), player.blastParticleEmitter, "Player Blast Emitter");
		
		addGUIItem(particleGUI.addFolder("Star Emitter"), starEmitter, "Star Emitter");
		
		for (screen in screens) {
			screen.addGUIItems(particleGUI);
			
			for (enemy in screen.enemies) {
				addGUIItem(particleGUI.addFolder("Enemy Emitter"), enemy.particleEmitter, "Enemy Emitter");
			}
		}
		
		addGUIItem(shaderGUI, skyEffectController, "Sky Shader");
	}
	
	public function addGUIItem(gui:GUI, object:Dynamic, ?tag:String):GUI {
		if (gui == null || object == null) {
			return null;
		}
		
		var folder:GUI = null;
		
		if (tag != null) {
			folder = gui.addFolder(tag + " (" + guiItemCount++ + ")");
		} else {
			var name:String = Std.string(Reflect.field(object, "name"));
			
			if (name == null || name.length == 0) {
				folder = gui.addFolder("Item (" + guiItemCount++ + ")");
			} else {
				folder = gui.addFolder(Reflect.getProperty(object, "name") + " (" + guiItemCount++ + ")");
			}
		}
		
		if (Std.is(object, Object3D)) {
			var object3d:Object3D = cast object;
			
			folder.add(object3d.position, 'x', -5000.0, 5000.0, 2).listen();
			folder.add(object3d.position, 'y', -5000.0, 5000.0, 2).listen();
			folder.add(object3d.position, 'z', -20000.0, 20000.0, 2).listen();

			folder.add(object3d.rotation, 'x', 0.0, Math.PI * 2, 0.1).listen();
			folder.add(object3d.rotation, 'y', 0.0, Math.PI * 2, 0.1).listen();
			folder.add(object3d.rotation, 'z', 0.0, Math.PI * 2, 0.1).listen();

			folder.add(object3d.scale, 'x', 0.0, 10.0, 0.1).listen();
			folder.add(object3d.scale, 'y', 0.0, 10.0, 0.1).listen();
			folder.add(object3d.scale, 'z', 0.0, 10.0, 0.1).listen();
			
			folder.add(object3d, 'visible');
		}
		
		if (Std.is(object, Mesh)) {
			var mesh:Mesh = cast object;
			var materialFolder = folder.addFolder("material (" + guiItemCount + ")");
			materialFolder.add(mesh.material, "opacity", 0, 1, 0.01).listen();
		}
		
		if (Std.is(object, PerspectiveCamera)) {
			var camera:PerspectiveCamera = cast object;
		}
		
		if (Std.is(object, OrthographicCamera)) {
			var camera:OrthographicCamera = cast object;
		}
		
		if (Std.is(object, Emitter)) {
			var emitter:Emitter = cast object;
			
			gui.add(emitter, 'type', ['cube', 'sphere', 'disk']);
			
			var fields = Reflect.fields(emitter);
			
			for (field in fields) {
				var prop = Reflect.getProperty(emitter, field);
				
				if (Std.is(prop, Color)) {
					var folder = gui.addFolder(field);
					folder.add(prop, 'r', 0, 1, 0.01).listen();
					folder.add(prop, 'g', 0, 1, 0.01).listen();
					folder.add(prop, 'b', 0, 1, 0.01).listen();
				}
				else if (Std.is(prop, Vector3)) {
					var folder = gui.addFolder(field);
					folder.add(prop, 'x', -2000, 2000, 0.1).listen();
					folder.add(prop, 'y', -2000, 2000, 0.1).listen();
					folder.add(prop, 'z', -4000, 4000, 0.1).listen();
				}
				else {
					if(Std.is(prop, Float)) {
						gui.add(emitter, field, 0.04).listen();
					}
				}
			}
		}
		
		if (Std.is(object, SkyEffectController)) {
			var controller:SkyEffectController = cast object;
			controller.addGUIItem(controller, gui);
		}
		
		return folder;
	}
	#end
}