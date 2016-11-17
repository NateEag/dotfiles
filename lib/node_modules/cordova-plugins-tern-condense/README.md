# cordova-plugins-tern-condense [![Build Status](https://travis-ci.org/albertinad/cordova-plugins-tern-condense.svg)](https://travis-ci.org/albertinad/cordova-plugins-tern-condense)

A [Tern](http://ternjs.net) plugin for Condense, that automatically generates tern definitions for cordova plugins.

This is a plugin for condense utility, from tern. To use this plugin, node environment is required to run it.
To use it, before set up the environment by running,

`$ npm install`

Download some cordova plugin sources and run the following,

`$ ./tern/bin/condense --plugin cordova-plugins-tern-condense/cordova-plugins-condense.js <path-to-cordova-plugin>/plugin.xml
`

The plugin parse the cordova plugin descriptor file, plugin.xml, to look for the JavaScript modules and the namespaces to mount the modules; and then it add the files to the tern server. When condense finishes generating the definition, the plugin will post process the output following the namespaces definition for the cordova plugin.

## Author

Albertina Durante

## License

MIT. Details on LICENSE file.
