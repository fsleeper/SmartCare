

var GeneratedDynamoDBValidator = function () {
};

GeneratedDynamoDBValidator.prototype.isValid = function (jsonObject) {
    var returnInfo = { isValid: false };
    
    returnInfo.isValid = (
        "CreateDate" in jsonObject &&
        "Size" in jsonObject &&
        "Key" in jsonObject);
    
    return returnInfo;
};

module.exports = new GeneratedDynamoDBValidator();

