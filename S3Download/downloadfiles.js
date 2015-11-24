var AWS = require("aws-sdk");
var fs = require('fs');
var path = require("path");
var filendir = require('filendir')

AWS.config.update({ accessKeyId: 'AKIAI6FLMSLBSLE4YBKQ', secretAccessKey: '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', region: 'us-east-1' });

var s3 = new AWS.S3();

var options = { encoding: 'utf8' };
var fileLogGood = fs.createWriteStream('all.txt', options);
var fileLogError = fs.createWriteStream('all.txt', options);
var root = __dirname;

var moredata = true;

var params = {
    //Bucket: 'server-analytics-data',
    Bucket: 'logs-concierge-prod',
    Delimiter: '~~`~~',
    //Prefix: '3fc1ee35-a08a-49ef-8adf-b150010441e4/Product/',
    MaxKeys: 10000
};

var numFiles = 0;

function saveBucket(data, bucket) {
    numFiles++;
    var params = { Bucket: bucket, Key: data.Key };

    s3.getObject(params, function (err, data) {
        if (err) {
            console.log(err);
            var message = "Error getting object " + params.Key + " from bucket " + params.Bucket +
                ". Make sure they exist and your bucket is in the same region as this function.";
            console.log(message);
            fileLogError.write(params.Bucket + "/" + params.Key + "\n");
        } else {
            try {
                var theObject = JSON.parse(data.Body);
                var filename = path.join(root, params.Bucket, params.Key);

                filendir.writeFile(filename, JSON.stringify(theObject), options);
//                var file = fs.createWriteStream(filename, options);
//                file.write(JSON.stringify(theObject));
                fileLogGood.write(params.Bucket + "/" + params.Key + "\n");
            }
            catch (ex) {
                fileLogError.write(params.Bucket + "/" + params.Key + "\n");
            }
        }
    });
}

function loop() {

    s3.listObjects(params, function (err, data) {
        if (err) {
            console.log(err, err.stack);
        }
        else {
            for (var i = 0; i < data.Contents.length; i++) {
                saveBucket(data.Contents[i], params.Bucket);
            }

            console.log(numFiles);

            console.log(data.NextMarker);

            params.Marker = data.NextMarker;
            if (data.IsTruncated)
                loop();
            else
                console.log("The end");
        }
    });
}

loop();
