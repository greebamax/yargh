/**
 * Remove all hook scripts from .git/hooks directory which names are equal
 * to near scripts
 */
'use strict';

var fs = require('fs');
var path = require('path');
var hooksDir = '.git/hooks';
var hooksList = [];

fs.readdir(__dirname, function (readdirErr, list) {
  if (readdirErr) {
    console.log('Cannot read directory ' + __dirname);
    process.exit(1);
  }

  for (var i = 0; i < list.length; i++) {
    var file = __dirname + '/' + list[i];
    if (file.endsWith('.sh')) {
      hooksList.push(path.basename(file, '.sh'));
    }
  }

  fs.access(hooksDir, fs.R_OK | fs.W_OK, function (accessErr) {
    if (accessErr) {
      console.log('No access to the path: ' + hooksDir);
      process.exit(1);
    }

    fs.readdir(hooksDir, function (readHooksDirErr, hooks) {
      if (readHooksDirErr) {
        console.log('Cannot read directory ' + hooksDir);
        process.exit(1);
      }

      for (var _i = 0; _i < hooks.length; _i++) {
        var _file = hooksDir + '/' + hooks[_i];
        if (hooksList.includes(path.basename(_file))) {
          fs.unlink(_file);
        }
      }
    });
  });
});
