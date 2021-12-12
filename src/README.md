### Ludum Dare 33 - Otherworldly Stars

[![Build Status](https://img.shields.io/travis/Tw1ddle/Ludum-Dare-33.svg?style=flat-square)](https://travis-ci.org/Tw1ddle/Ludum-Dare-33)

For Windows, open the .hxproj in FlashDevelop, select either debug or release configuration and hit test. 

Manually invoking build using the .hxml files will also work on other platforms.

### Notes

Running locally in the browser requires the [same origin policy to be disabled](https://stackoverflow.com/questions/3102819/disable-same-origin-policy-in-chrome) so that required assets can be loaded.
	
I am using three.js r71, so to build you either need to generate updated three.js externs, or make minor changes needed to get the project building.
	
There is an issue with particle systems flickering a bit on Google Chrome, changing three.js revisions doesn't seem to help.

Debug builds include a debugger UI that slows things down a lot and breaks IE.