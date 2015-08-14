### Building

For Windows, open the .hxproj in FlashDevelop, select either debug or release configuration and hit test. 

Manually invoking build using the .hxml files will also work on other platforms.

### Notes

Running locally in the browser requires the [same origin policy to be disabled](http://stackoverflow.com/questions/3102819/disable-same-origin-policy-in-chrome) so that required assets can be loaded.

Note that debug builds include a debugger UI that may slow things down a lot.