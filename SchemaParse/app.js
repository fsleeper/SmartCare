
var _               = require("underscore");
var files           = require("./Files");
var commander       = require("commander");
var FileProcessor   = require("./FileProcessor");
var log             = require("./Logger");
var Logger          = new log();

var numJSONRows = 0;
var numBadJSON = 0;
var numGoodJSON = 0;
var goodSongPal = 0;
var goodSBS = 0;
var numfiles = 0;
var numTests = 0;
var numSecurityChecks = 0;

var control = {
    files: null,
    extension: null
}

initialize();
processFiles();

return;


function initialize() {
    commander
    .version("0.0.1")
    .option("-f, --files [file/directory]", "The file or directory of files to parse")
    .option("-e, --ext [extension]", "The extension of files to process, such as json, txt or use --ext none for files with NO extension")
    .parse(process.argv);
    
    control.files = commander.files;
    if ("ext" in commander && commander.ext) {
        control.extension = commander.ext.toUpperCase();
    }
    
    process.on('exit', function (code) {
        Logger.Log2("", numfiles, numJSONRows, numGoodJSON, numBadJSON, goodSongPal, goodSBS, numTests, numSecurityChecks);
        console.log("Finished with code:", code);
    });

}

function processFiles() {
    console.log("Processing files: " + commander.files);

    files.getFiles(commander.files, function (err, files) {
        if (err) {
            console.log(err);
            return;
        }
            
        try {
            var func = function(i) {
                numfiles++;
                var file = files[i];
                var processor = new FileProcessor(control, file);
                
                processor.processFile({
                    complete: function (err, statusEntry) {
                        numJSONRows += statusEntry.numJSONRows;
                        numGoodJSON += statusEntry.numGoodJSON;
                        goodSongPal += statusEntry.goodSongPal;
                        goodSBS += statusEntry.goodSBS;
                        numBadJSON += statusEntry.numBadJSON;
                        numTests += statusEntry.isTest;
                        numSecurityChecks += statusEntry.isSecurityCheck;

                        Logger.Log2(file, numfiles, numJSONRows, numGoodJSON, numBadJSON, goodSongPal, goodSBS, numTests, numSecurityChecks);

                        if (i < files.length) {
                            func(i+1);
                        }
                    }
                });
            }
            
            if ( files.length)
                func(0);

            var x = 1;
        } catch (ex) {
            console.log(ex);
        }
    });
}   
