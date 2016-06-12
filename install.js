/**
 * Installs near hooks into .git/hooks directory
 */
'use strict';

var fs = require('fs');
var path = require('path');
var hooksDir = '.git/hooks';

fs.access(hooksDir, fs.R_OK | fs.W_OK, function (accessErr) {
  if (accessErr) {
    console.log('No access to the path: ' + hooksDir);
    process.exit(1);
  }

  fs.readdir(__dirname, function (readdirErr, list) {
    if (readdirErr) {
      console.log('Cannot read directory ' + __dirname);
      process.exit(1);
    }

    for (var i = 0; i < list.length; i++) {
      var file = __dirname + '/' + list[i];
      if (file.endsWith('.sh')) {
        var fileName = path.basename(file, '.sh');
        var targetFile = hooksDir + '/' + fileName;
        fs.createReadStream(file).pipe(fs.createWriteStream(targetFile));
        fs.chmod(targetFile, '755');
      }
    }
  });
});
