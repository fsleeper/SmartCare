/**
 * Created by fsleeper on 11/23/15.
 */

var AWS             = require("aws-sdk");
var _               = require("underscore");
var commander       = require("commander");
var log             = require("./Logger");
var config          = require("config");
var promises        = require("node-promise");
var fs              = require("fs");
var LineByLineReader = require("line-by-line");


AWS.config.update(config.dynamo);

var dynamodb = new AWS.DynamoDB();

initialize()
    .then(function(res){
        createTables(res);
    }).then(function(res){
        loadData(res);
    });


return;

function loadData() {


    return new Promise(function (fulfill, reject) {
        var cnt = 0;

        try {
            var dynamodbDoc = new AWS.DynamoDB.DocumentClient();
            var options = {
                encoding: "utf8",
                skipEmptyLines: false
            };

            console.log("Importing songpal into DynamoDB. Please wait.");

            var lr = new LineByLineReader('/Users/fsleeper/Downloads/supportfiles/songpalfile.json', options);

            lr.on("end", function() {
                fulfill();
            });

            lr.on("error", function (err) {
                reject(err);
             });

            lr.on('line', function (str) {
                try {
                    var json = JSON.parse(str);

                    var params = {
                        TableName: "songpal",
                        Item: {
                            "modelName": json.environmentInfo.modelName,
                            "language": json.environmentInfo.language,
                            "info": json
                        }
                    };

                    cnt++;
                    dynamodbDoc.put(params, function (err, data) {
                        if (err) {
//                            console.error("Unable to add record", json.environmentInfo, ". Error JSON:", JSON.stringify(err, null, 2));
                        } else {
                            if(cnt % 100 == 0)
                                console.log("Write: " + cnt);

//                            console.log("PutItem succeeded:", json.environmentInfo.modelName);
                        }
                    });
                }
                catch (ex) {
//                    console.log(ex);
                }
            });
        }
        catch(ex) {
            reject(ex);
        }
    });

}

function createTables() {

    return new Promise(function (fulfill, reject) {
        var params = {
            TableName: "songpal",
            KeySchema: [
                {AttributeName: "modelName", KeyType: "HASH"},  //Partition key
                {AttributeName: "language", KeyType: "RANGE"}  //Sort key
            ],
            AttributeDefinitions: [
                {AttributeName: "modelName", AttributeType: "S"},
                {AttributeName: "language", AttributeType: "S"}
            ],
            ProvisionedThroughput: {
                ReadCapacityUnits: 10,
                WriteCapacityUnits: 10
            }
        };

        try {
            dynamodb.createTable(params, function (err, data) {
                if (err) {
                    console.error("Unable to create table. Error JSON:", JSON.stringify(err, null, 2));
                    fulfill(true);
                } else {
                    console.log("Created table. Table description JSON:", JSON.stringify(data, null, 2));
                    fulfill(true);
                }
            });
        }
        catch(ex) {
            reject(ex);
        }
    });
}

function initialize() {

    return new Promise(function (fulfill, reject) {

        commander
            .version("0.0.1")
    //        .option("-f, --files [file/directory]", "The file or directory of files to parse")
    //        .option("-e, --ext [extension]", "The extension of files to process, such as json, txt or use --ext none for files with NO extension")
            .parse(process.argv);

        var isValid = true;

        if(!isValid) {
            commander.outputHelp();
            reject(false);
        }

        process.on('exit', function (code) {
            console.log("Finished with code:", code);
        });

        fulfill(true);
    });
}
