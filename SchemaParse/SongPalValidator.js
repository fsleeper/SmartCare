

var SongPalValidator = function() {
    this.appName = "SongPal";
    this.partnerID = "3fc1ee35-a08a-49ef-8adf-b150010441e4";
};

SongPalValidator.prototype.isValidNameAndPartner = function (jsonObject) {
    return (
            "appInfo" in jsonObject &&
            "partnerInfo" in jsonObject &&
            jsonObject.appInfo.name === this.appName && 
            jsonObject.partnerInfo.partnerId === this.partnerID
    );
}

SongPalValidator.prototype.getType = function (jsonObject) {
    if ("productSet" in jsonObject)
        return "browse-solutions";
/*
    if ("mode" in jsonObject)
        return "save-content-validation-mode";

    if ("SolutionID" in jsonObject &&
        "TitleID" in jsonObject &&
        "SolutionType" in jsonObject &&
        "URL" in jsonObject)
        return "studio-api";
 */   
    return "unknown";
}

SongPalValidator.prototype.isValid = function(jsonObject) {
    var returnInfo = { isValid: false, schemaType: "unknown" };
    
    try {
        if (!this.isValidNameAndPartner(jsonObject))
            return returnInfo;

        returnInfo.isValid = true;
        returnInfo.schemaType = this.getType(jsonObject);

    } catch (ex) {
    }
    
    return returnInfo;
}

module.exports = new SongPalValidator();
