# Otherworldly Stars

My entry for Ludum Dare 33, the world's largest online game jam.

Play it [here](TODO) and visit the Ludum Dare [submission page](TODO).

### About

Otherworldly Stars is a HTML5/WebGL game and has a graphical style inspired by the Ludum Dare 29 entry Beneath The Cave by [feiss](http://ludumdare.com/compo/author/feiss/) and Alto's Adventure by [Snowman](https://itunes.apple.com/gb/app/altos-adventure/id950812012). It requires a recent graphics card and modern browser with WebGL support to run.

### Screenshots

![Screenshot1](https://github.com/Tw1ddle/ludum-dare-33/blob/master/dev/screenshots/screenshot1.png?raw=true "Screenshot 1")

![Screenshot2](https://github.com/Tw1ddle/ludum-dare-33/blob/master/dev/screenshots/screenshot2.png?raw=true "Screenshot 2")

![Screenshot3](https://github.com/Tw1ddle/ludum-dare-33/blob/master/dev/screenshots/screenshot3.png?raw=true "Screenshot 3")

### Dev Log

#### August ####
* 7th-11th: Created boilerplate base code.
* 11th-13th: Reorganize repo for separate debug/release builds.
* 13th-14th: Implement sky shader based off of the [three.js](http://threejs.org/examples/#webgl_shaders_sky) sky example.
* 15th-16th: Implement tweenable text.
* 16th-21st: Holiday!
* 22nd-24th: The Compo.

See the [writeup](http://samcodes.co.uk/ludum-dare-33-dev-log/) postmortem blog.

### Credits

This project is written using the [Haxe](http://haxe.org/) programming language and depends on:

* [three.js](https://github.com/mrdoob/three.js) for rendering.
* Yaroslav Sivakov's [three.js](http://lib.haxe.org/u/yar3333/) externs.
* Joshua Granick's [actuate](http://lib.haxe.org/p/actuate) tweening library.
* Luke Moody's [ShaderParticleEngine](https://github.com/squarefeet/ShaderParticleEngine) particle engine and editor for three.js.
* Massive Interactive's [msignal](http://lib.haxe.org/p/msignal/) signals library.