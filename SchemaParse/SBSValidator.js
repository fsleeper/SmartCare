var _ = require("underscore");
var __ = require("underscore.string");
var AJV = require("ajv");

var schemaValidator = AJV({
    allErrors: false
});

var SBSValidator = function () {
    this.appName = "Support";
    this.partnerID = "c465c49e-4f13-49e9-af8d-1eabfb4087dc";
    this.schemas = [];
    
    var paginationSchema = {
        id: "#paginationSchema",
        type: "object",
        properties: {
            category_id: { type: "string" },
            filter: { type: "string" },
            count: { type: "integer", "minimum": 0 },
            start: { type: "integer", "minimum": 0 }
        },
        required: ["count", "start", "filter", "category_id"],
        additionalProperties: false
    };
    
    var paginationSchema2 = {
        id: "#paginationSchema2",
        type: "object",
        properties: {
            category_id: { type: "string" },
            parent_id: { type: "string" },
            count: { type: "integer", "minimum": 0 },
            start: { type: "integer", "minimum": 0 }
        },
        required: ["count", "start", "parent_id", "category_id"],
        additionalProperties: false
    };
    
    var cameraInfoSchema = {
        id: "#cameraInfoSchema",
        type: "object",
        properties: {
            cameraCategory: { type: "string" },
            firmwareVersion: { type: "string" },
            lensFirmwareVersion: { type: "string" },
            lensModel: { type: "string" },
            modelName: { type: "string" },
            platformVersion: { type: "string" },
            pmcaInfo: { type: "string" },
            settingInfo: { type: "string" },
            shootingMode: { type: "string" }
        },
        required: [
            "cameraCategory",
            "firmwareVersion", 
            "lensFirmwareVersion", 
            "lensModel", 
            "modelName", 
            "platformVersion", 
            "pmcaInfo",
            "settingInfo",
            "shootingMode"
        ],
        additionalProperties: false
    };

    var productInfoSchema = {
        id: "#productInfoSchema",
        type: "object",
        properties: {
            modelName: { type: "string" }
        },
        required: ["modelName"],
        additionalProperties: false
    };
    
    var productSchema = {
        id: "#productSchema",
        type: "object",
        properties: {
            model: { type: "string" }
        },
        required: ["model"],
        additionalProperties: false
    };

    var environmentInfoSchema = {
        id: "#environmentInfoSchema",
        type: "object",
        properties: {
            country: { type: "string" },
            device_id: { type: "string" },
            language: { type: "string" },
            modelName: { type: "string" },
            os_version: { type: "string" },
            region: { type: "string" },
            timeZoneOffset: { type: "number" }
        },
        required: ["country", "language", "modelName", "timeZoneOffset"],
        additionalProperties: false
    };
    
    var partnerInfoSchema = {
        id: "#partnerInfoSchema",
        type: "object",
        properties: {
            partnerId: { "enum": [this.partnerID] }
        },
        required: ["partnerId"],
        additionalProperties: false
    };
    
    var appInfoSchema = {
        id: "#appInfoSchema",
        type: "object",
        properties: {
            build_platform: { type: "string" },
            name: { "enum": [this.appName] },
            version: { type: "string" }
        },
        required: ["build_platform", "name", "version"],
        additionalProperties: false
    };
    
    var getProductsSchema = {
        type: "object",
        properties: {
            pagination: { "$ref": "#paginationSchema" },
            CreateDate: { type: "string" },
            Size: { type: "integer" },
            Key: { type: "string" }
        },
        required: ["pagination"],
        additionalProperties: false
    };
    
    var getCategoriesSchema = {
        type: "object",
        properties: {
            pagination: { "$ref": "#paginationSchema2" },
            CreateDate: { type: "string" },
            Size: { type: "integer" },
            Key: { type: "string" }
        },
        required: ["pagination"],
        additionalProperties: false
    };
    
    var getCameraSolutionsSchema = {
        type: "object",
        properties: {
            cameraInfo: { "$ref": "#cameraInfoSchema" },
            CreateDate: { type: "string" },
            Size: { type: "integer" },
            Key: { type: "string" }
        },
        required: ["cameraInfo"],
        additionalProperties: false
    };
    
    var getProductSolutionsSchema = {
        type: "object",
        properties: {
            productInfo: { "$ref": "#productInfoSchema" },
            CreateDate: { type: "string" },
            Size: { type: "integer" },
            Key: { type: "string" }
        },
        required: ["productInfo"],
        additionalProperties: false
    };
    
    var validateProductSchema = {
        type: "object",
        properties: {
            product: { "$ref": "#productSchema" },
            CreateDate: { type: "string" },
            Size: { type: "integer" },
            Key: { type: "string" }
        },
        required: ["product"],
        additionalProperties: false
    };
    
    var definitions = {};
    
    definitions.paginationSchema = paginationSchema;
    definitions.paginationSchema2 = paginationSchema2;
    definitions.cameraInfoSchema = cameraInfoSchema;
    definitions.productInfoSchema = productInfoSchema;
    definitions.productSchema = productSchema;
    definitions.environmentInfoSchema = environmentInfoSchema;
    definitions.partnerInfoSchema = partnerInfoSchema;
    definitions.appInfoSchema = appInfoSchema;
    
    // Add the properties to the schemas
    // Add the definitions to the schemas
    (function(schemas) {
        _.each(schemas, function(schema) {
            schema["$schema"] = "http://json-schema.org/draft-04/schema#";
            schema.properties.appInfo = { "$ref": appInfoSchema.id };
            schema.properties.environmentInfo = { "$ref": environmentInfoSchema.id };
            schema.properties.partnerInfo = { "$ref": partnerInfoSchema.id };
            schema.required.push("appInfo", "environmentInfo", "partnerInfo");
        });
    })([
        getProductsSchema,
        getCategoriesSchema,
        getCameraSolutionsSchema,
        getProductSolutionsSchema,
        validateProductSchema]);
    
    for (var key in definitions)
        schemaValidator.addMetaSchema(definitions[key], definitions[key].id);
    
    this.schemas.push({ name: "get-products", schema: getProductsSchema, compiledSchema: schemaValidator.compile(getProductsSchema) });
    this.schemas.push({ name: "get-categories", schema: getCategoriesSchema, compiledSchema: schemaValidator.compile(getCategoriesSchema) });
    this.schemas.push({ name: "get-camera-product-solutions", schema: getCameraSolutionsSchema, compiledSchema: schemaValidator.compile(getCameraSolutionsSchema) });
    this.schemas.push({ name: "get-camera-product-solutions", schema: getProductSolutionsSchema, compiledSchema: schemaValidator.compile(getProductSolutionsSchema) });
    this.schemas.push({ name: "validate-product", schema: validateProductSchema, compiledSchema: schemaValidator.compile(validateProductSchema) });
};

SBSValidator.prototype.findMatchingSchema = function (jsonObject) {

    for (var i = 0; i < this.schemas.length; i++) {
        var schema = this.schemas[i];

        var m = false;
                        
        if (schema.compiledSchema) {
            var validator = schema.compiledSchema;
            m = validator(jsonObject);
        } else {
            m = schemaValidator.validate(schema.schema, jsonObject);
        }
            
        if (m) {
            return schema.name;
        } else {
            var x = 1;
        }
    }
    
    return null;
}

SBSValidator.prototype.isValidNameAndPartner = function (jsonObject) {
    return (
            "appInfo" in jsonObject &&
            "partnerInfo" in jsonObject &&
            jsonObject.appInfo.name === this.appName && 
            jsonObject.partnerInfo.partnerId === this.partnerID
    );
}

SBSValidator.prototype.getType = function (jsonObject) {
    
    if ("cameraInfo" in jsonObject)
        return "get-camera-product-solutions";
    if ("productInfo" in jsonObject)
        return "get-camera-product-solutions";
    if ("product" in jsonObject)
        return "validate-product";
    if ("pagination" in jsonObject) {
        if ("parent_id" in jsonObject.pagination)
            return "get-categories";
        return "get-products";
    }

    return "unknown";
}

SBSValidator.prototype.isValid = function (jsonObject) {
    var returnInfo = { isValid: false, schemaType: "unknown" };
    
    if (!this.isValidNameAndPartner(jsonObject))
        return returnInfo;
        
//        returnInfo.schemaType = this.getType(jsonObject);
//        returnInfo.isValid = true;

    var schemaType = this.findMatchingSchema(jsonObject);
    if (schemaType) {
        returnInfo.isValid = true;
        returnInfo.schemaType = schemaType;
    } else {
        returnInfo.isValid = false;
    }
    
    return returnInfo;
}

module.exports = new SBSValidator();
