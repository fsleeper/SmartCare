var AWS = require("aws-sdk");

//AWS.config.update({ accessKeyId: 'AKIAINGWZ3T5JEFEN7GQ', secretAccessKey: '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', region: 'us-west-2' });
AWS.config.update({ accessKeyId: 'AKIAI6FLMSLBSLE4YBKQ', secretAccessKey: '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', region: 'us-east-1' });

var s3 = new AWS.S3();
    
var options = { encoding: 'utf8' };
var fs = require('fs');
var file = fs.createWriteStream('songpaldata.json', options);
var fileLogGood = fs.createWriteStream('loggood.txt', options);
var fileLogError = fs.createWriteStream('logerror.txt', options);
    
var moredata = true;

var params = {
    //Bucket: 'server-analytics-data',
    Bucket: 'logs-concierge-prod',
    Delimiter: '/',
    Prefix: '3fc1ee35-a08a-49ef-8adf-b150010441e4/',
    MaxKeys: 10000
};

var numFiles = 0;

function saveBucket(file, data, bucket) {
    numFiles++;
    var params = { Bucket: bucket, Key: data.Key };
    
    s3.getObject(params, function (err, data) {
        if (err) {
            console.log(err);
            var message = "Error getting object " + params.Key + " from bucket " + params.Bucket +
                    ". Make sure they exist and your bucket is in the same region as this function.";
            console.log(message);
            fileLogError.write(params.Bucket + "/" + params.Key);
        } else {
            try {
                var theObject = JSON.parse(data.Body);
                
                theObject.Key = params.Key;
                theObject.CreateDate = data.LastModified;
                theObject.Size = data.Size;
                
                file.write(JSON.stringify(theObject));
                file.write('\n');
                fileLogGood.write(params.Bucket + "/" + params.Key);
            }
            catch (ex) {
                fileLogError.write(params.Bucket + "/" + params.Key);
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
                saveBucket(file, data.Contents[i], params.Bucket);
            }
            
            console.log(numFiles);

            params.Marker = data.NextMarker;
            if (data.IsTruncated)
                loop();
            else
                console.log("The end");
        }
    });
}

loop();
