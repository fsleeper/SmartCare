

var SBSValidator = function () {
    this.appName = "Support";
    this.partnerID = "c465c49e-4f13-49e9-af8d-1eabfb4087dc";
};

SBSValidator.prototype.isValidNameAndPartner = function (jsonObject) {
    return (
        "appInfo" in jsonObject &&
        "partnerInfo" in jsonObject);
}

SBSValidator.prototype.isValid = function (jsonObject) {
    var returnInfo = { isValid: false };
    
    if (!this.isValidNameAndPartner(jsonObject))
        return returnInfo;
    
    returnInfo.isValid = (
        "Context" in jsonObject &&
        "Token" in jsonObject &&
        "Timestamp" in jsonObject &&
        "s" in jsonObject.Token &&
        "n" in jsonObject.Timestamp &&
        "s" in jsonObject.Context);
    
    return returnInfo;
}

module.exports = new SBSValidator();

