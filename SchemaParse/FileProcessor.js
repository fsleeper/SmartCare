
var _                           = require("underscore");
var __                          = require("underscore.string");
var path                        = require("path");
var LineByLineReader            = require("line-by-line");
var AWS                         = require("aws-sdk");

// Validators
var DynamoDBExtractValidator    = require("./DynamoDBExtractValidator");
var SBSValidator                = require("./SBSValidator");
var SongPalValidator            = require("./SongPalValidator");
var GeneratedDynamoDBValidator  = require("./GeneratedDynamoDBValidator");
var log                         = require("./Logger");
var Logger                      = new log();

var Firehose = null;

// ******************************************************************************************
// FileProcessor(control, file)
// ******************************************************************************************

function FileProcessor(control, file) {
    this.control = control;
    this.status = {
        file: null,
        numJSONRows: 0,
        numGoodJSON: 0,
        numBadJSON: 0,

        dynamodb: 0, 
        goodSongPal: 0,
        goodSBS: 0,
        isTest: 0,
        isSecurityCheck: 0,

        dynamicCounts: {},
    
        skipped: true,
        fileReadError: false
    };

    this.status.file = file;

    this.recordBatch = {
        lastSendTime: 1,
        "songpal-browse-solutions": [],
        "unknown": [],
        "sbs-get-camera-product-solutions": [],
        "sbs-get-categories": [],
        "sbs-get-products": []
    };
    
    // ******************************************************************************************
    // configureAWS()
    // ******************************************************************************************

    this.configureAWS = function() {
        AWS.config.region = "us-west-2";
        AWS.config.update({ accessKeyId: "AKIAINGWZ3T5JEFEN7GQ", secretAccessKey: "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" });
        Firehose = new AWS.Firehose();
    };
    
    // ******************************************************************************************
    // sendFinalRecords()
    // ******************************************************************************************

    this.sendFinalRecords = function () {
        this.sendToFirehose("songpal-browse-solutions");
        this.sendToFirehose("unknown");
        this.sendToFirehose("sbs-get-camera-product-solutions");
        this.sendToFirehose("sbs-get-categories");
        this.sendToFirehose("sbs-get-products");
    };
    
    // ******************************************************************************************
    // storeInQueue(schemaName, jsonObject)
    // ******************************************************************************************
    
    this.storeInQueue = function (schemaName, jsonObject) {
        var length = 0;
        var delim = schemaName === "unknown" ? "\n" : "";

        try {
            if (jsonObject) {
                this.recordBatch[schemaName].push(JSON.stringify(jsonObject) + delim);
                length = this.recordBatch[schemaName].length;
            }
        } catch (ex) {
            console.log(ex);
        }

        return length;
    };

    // ******************************************************************************************
    // sendToFirehose(schemaName, jsonObject, forceSend)
    // ******************************************************************************************

    this.sendToFirehose = function (schemaName) {
        
        var records = this.recordBatch[schemaName];
        
        try {
            var params = {
                "DeliveryStreamName": schemaName,
                "Records": []
            };
                    
            for (var i = 0; i < records.length; i++)
                params.Records.push({ "Data": records[i] });
                    
            if (params.Records.length > 0) {
                Firehose.putRecordBatch(params, function (err, data) {
                    if (err)
                        var a = 1;
                });
            }
        } catch (ex) {
            var xx = 1;
        }
    };

    // ******************************************************************************************
    // processJSON(json)
    // ******************************************************************************************

    this.processJSON = function (json) {

        var appInfo = null;
        var appName = null;

        var isTest = function () {
            return appName === "INTEGRATION-TEST";
        };

        var isSecurityCheck = function (jsonObject) {
            var strRep = JSON.stringify(jsonObject).toUpperCase();
            
            return __.include(strRep, "WHS") || __.include(strRep, "FILE:");
        };
        
        var results = {
            length: 0,
            schemaName: null
        };

        var jsonObject = null;

        try {
            jsonObject = JSON.parse(json);
        } catch (ex) {
        }
        
        if (!jsonObject) {
            this.status.numBadJSON++;
            return results;
        }

        try {
            // Now to figure what kind of JSON this is. 
            // First, is this a DynamoDB Extract wrapper?
                
            var isDynamoDB = DynamoDBExtractValidator.isValid(jsonObject);
            if (isDynamoDB.isValid) {
                this.status.dynamodb++;
                jsonObject = JSON.parse(jsonObject.Context.s);
            }

            var skipRecord = false;
            appInfo = jsonObject.appInfo;
            appName = null;

            if (appInfo && appInfo.name)
                appName = appInfo.name.toUpperCase();

            if (isTest()) {
                skipRecord = true;
                this.status.isTest++;
            }
            else if (isSecurityCheck(jsonObject)) {
                skipRecord = true;
                this.status.isSecurityCheck++;
            }
            
            if (!skipRecord) {

                var songPalItem = SongPalValidator.isValid(jsonObject);
                if (songPalItem.isValid) {
                    this.status.goodSongPal++;
                    this.status.numGoodJSON++;
                    results.schemaName = "songpal-" + songPalItem.schemaType;
                }
                else {
                    var sbsitem = SBSValidator.isValid(jsonObject);
                    if (sbsitem.isValid) {
                        this.status.goodSBS++;
                        this.status.numGoodJSON++;
                        results.schemaName = "sbs-" + sbsitem.schemaType;
                    } 
                    else {
                        results.schemaName = "unknown";
                    }
                }
                
                if (results.schemaName) {
                    results.length = this.storeInQueue(results.schemaName, jsonObject);
                    
                    if (!(results.schemaName in this.status.dynamicCounts))
                        this.status.dynamicCounts[results.schemaName] = 1;
                    else
                        this.status.dynamicCounts[results.schemaName]++;
                }
            }
        } catch (ex) {
            // hmmm, need to review
        }

        return results;
    };

    // ******************************************************************************************
    // validFile()
    // ******************************************************************************************

    this.validFile = function () {
        if (!this.control.extension)
            return true;
    
        var fileExt = path.extname(this.status.file);
    
        if (fileExt == null || fileExt.length === 0)
            return this.control.extension === "NONE";
    
        fileExt = fileExt.replace(".", "");
        return this.control.extension === fileExt.toUpperCase();
    };
    
    // ******************************************************************************************
    // writeStatus()
    // ******************************************************************************************

    this.writeStatus = function () {
        Logger.Log(this.status);
    };

    // ******************************************************************************************
    // processFile(callback)
    // ******************************************************************************************

    this.processFile = function(callback) {
        
        var me = this;

        if (!this.validFile()) {
            console.log("Skipping: " + this.status.file);
            callback.complete(null, this.status);
            return;
        }
    
        this.status.skipped = false;
    
        console.log("Processing: " + this.status.file);

        var options = {
            encoding: "utf8",
            skipEmptyLines: false
        };

        try {
            var lr = new LineByLineReader(this.status.file, options);

            lr.on("error", function (err) {
                callback.complete(err);
            });
            
            lr.on('line', function (line) {
                // pause emitting of lines...
                lr.pause();

                me.status.numJSONRows++;
                
                var results = me.processJSON(line);

                if (results.length >= 500) {
                    var currTime = new Date();
                    var waitTime = currTime - me.recordBatch.lastSendTime;
                    if (waitTime < 0)
                        waitTime = 1;
                    else if (waitTime > 1000)
                        waitTime = 0;
                    
                    waitTime = 200 - waitTime;
                    if (waitTime <= 0)
                        waitTime = 1;

                    // ...do your asynchronous line processing..
                    setTimeout(function () {
                        me.sendToFirehose(results.schemaName);

                        me.recordBatch[results.schemaName] = [];
                        me.recordBatch.lastSendTime = new Date();

                        lr.resume();
                    }, waitTime);
                }
                else 
                    lr.resume();

                var resultOfMod = me.status.numJSONRows % 5000;
                
                if (!resultOfMod)
                    me.writeStatus();
            });
            
            lr.on("end", function () {
                me.sendFinalRecords();
                me.writeStatus();
                callback.complete(null, me.status);
            });
        } catch (e) {
            this.status.fileReadError = true;
            console.log("Error reading: " + this.status.file);
            console.log(e);
            callback.complete(e, this.status);
        }
    };

    this.configureAWS();
}

module.exports = FileProcessor;

