var fs = require("fs");
var path = require("path");

exports.getFiles = function (filepath, callback) {
    
    var result = [];
    var foundFiles = [filepath];
    
    // the callback gets ( err, files) where files is an array of file names
    if (typeof callback !== "function") {
        console.log("callback required");
        return;
    }
    
    function traverseFiles() {
        
        if (foundFiles.length) {
            var name = foundFiles.shift();
            
            fs.stat(name, function (err, stats) {
                if (err) {
                    // in case there's broken symbolic links or a bad path
                    // skip file instead of sending error
                    if (err.errno === 34) {
                        traverseFiles();
                    }
                    else {
                        callback(err);
                    }
                } else {
                    if (stats.isDirectory()) {
                        fs.readdir(name, function (readdirerror, files2) {
                            if (readdirerror) {
                                callback(readdirerror);
                            }
                            else {
                                foundFiles = files2.map(function(file) {
                                    return path.join(name, file);
                                }).concat(foundFiles);
                                traverseFiles();
                            }
                        });
                    } else {
                        result.push(name);
                        traverseFiles();
                    }
                }
            });
        } else {
            callback(null, result);
        }
    }
    
    traverseFiles();
};