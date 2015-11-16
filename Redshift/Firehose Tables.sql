
drop table if exists fh_sbs_get_products;
drop table if exists fh_sbs_get_camera_product_solutions;
drop table if exists fh_sbs_get_categories;
drop table if exists fh_unknown;
drop table if exists fh_songpal_browse_solutions;

create table fh_unknown
(
  json VARCHAR(65535),
  id int IDENTITY(1,1)
);

create table fh_sbs_get_products
(
  partnerInfo_partnerId VARCHAR(36),

  rawappinfo VARCHAR(200),

  appInfo_build_platform  VARCHAR(30),
  appInfo_name VARCHAR(30),
  appInfo_version VARCHAR(30),

  rawenvironmentInfo VARCHAR(500),

  environmentInfo_country VARCHAR(20),
  environmentInfo_device_id VARCHAR(30),
  environmentInfo_language VARCHAR(36),
  environmentInfo_modelName VARCHAR(50),
  environmentInfo_os_version VARCHAR(50),
  environmentInfo_timeZoneOffset VARCHAR(50),
  environmentInfo_region VARCHAR(30),
  
  rawcameraInfo VARCHAR(500),

  cameraInfo_cameraCategory VARCHAR(30),
  cameraInfo_firmwareVersion VARCHAR(30),
  cameraInfo_lensFirmwareVersion VARCHAR(30),
  cameraInfo_lensModel VARCHAR(30),
  cameraInfo_modelName VARCHAR(30),
  cameraInfo_platformVersion VARCHAR(30),
  cameraInfo_pmcaInfo VARCHAR(30),
  cameraInfo_settingInfo VARCHAR(30),
  cameraInfo_shootingMode VARCHAR(30),
  
  rawproductInfo VARCHAR(500),
  
  productInfo_modelName VARCHAR(30),
  productInfo_model VARCHAR(30),
  pagination_category_id VARCHAR(60),
  pagination_parent_id VARCHAR(60),
  pagination_count VARCHAR(30),
  pagination_filter VARCHAR(60),
  pagination_start VARCHAR(30),
  objectkey VARCHAR(200),
  size INT,
  createDateString VARCHAR(75),
  id int IDENTITY(1,1)
);


create table fh_sbs_get_camera_product_solutions
(
  partnerInfo_partnerId VARCHAR(36),

  rawappinfo VARCHAR(200),

  appInfo_build_platform  VARCHAR(30),
  appInfo_name VARCHAR(30),
  appInfo_version VARCHAR(30),

  rawenvironmentInfo VARCHAR(500),

  environmentInfo_country VARCHAR(20),
  environmentInfo_device_id VARCHAR(30),
  environmentInfo_language VARCHAR(36),
  environmentInfo_modelName VARCHAR(50),
  environmentInfo_os_version VARCHAR(50),
  environmentInfo_timeZoneOffset VARCHAR(50),
  environmentInfo_region VARCHAR(30),
  
  rawcameraInfo VARCHAR(500),

  cameraInfo_cameraCategory VARCHAR(30),
  cameraInfo_firmwareVersion VARCHAR(30),
  cameraInfo_lensFirmwareVersion VARCHAR(30),
  cameraInfo_lensModel VARCHAR(30),
  cameraInfo_modelName VARCHAR(30),
  cameraInfo_platformVersion VARCHAR(30),
  cameraInfo_pmcaInfo VARCHAR(30),
  cameraInfo_settingInfo VARCHAR(30),
  cameraInfo_shootingMode VARCHAR(30),
  
  rawproductInfo VARCHAR(500),
  
  productInfo_modelName VARCHAR(30),
  productInfo_model VARCHAR(30),
  pagination_category_id VARCHAR(60),
  pagination_parent_id VARCHAR(60),
  pagination_count VARCHAR(30),
  pagination_filter VARCHAR(60),
  pagination_start VARCHAR(30),
  objectkey VARCHAR(200),
  size INT,
  createDateString VARCHAR(75),
  id int IDENTITY(1,1)
);


create table fh_sbs_get_categories
(
  partnerInfo_partnerId VARCHAR(36),

  rawappinfo VARCHAR(200),

  appInfo_build_platform  VARCHAR(30),
  appInfo_name VARCHAR(30),
  appInfo_version VARCHAR(30),

  rawenvironmentInfo VARCHAR(500),

  environmentInfo_country VARCHAR(20),
  environmentInfo_device_id VARCHAR(30),
  environmentInfo_language VARCHAR(36),
  environmentInfo_modelName VARCHAR(50),
  environmentInfo_os_version VARCHAR(50),
  environmentInfo_timeZoneOffset VARCHAR(50),
  environmentInfo_region VARCHAR(30),
  
  rawcameraInfo VARCHAR(500),

  cameraInfo_cameraCategory VARCHAR(30),
  cameraInfo_firmwareVersion VARCHAR(30),
  cameraInfo_lensFirmwareVersion VARCHAR(30),
  cameraInfo_lensModel VARCHAR(30),
  cameraInfo_modelName VARCHAR(30),
  cameraInfo_platformVersion VARCHAR(30),
  cameraInfo_pmcaInfo VARCHAR(30),
  cameraInfo_settingInfo VARCHAR(30),
  cameraInfo_shootingMode VARCHAR(30),
  
  rawproductInfo VARCHAR(500),
  
  productInfo_modelName VARCHAR(30),
  productInfo_model VARCHAR(30),
  pagination_category_id VARCHAR(60),
  pagination_parent_id VARCHAR(60),
  pagination_count VARCHAR(30),
  pagination_filter VARCHAR(60),
  pagination_start VARCHAR(30),
  objectkey VARCHAR(200),
  size INT,
  createDateString VARCHAR(75),
  id int IDENTITY(1,1)
);

create table fh_songpal_browse_solutions
(
  partnerInfo_partnerId VARCHAR(36),
  appInfo_build_platform  VARCHAR(30),
  appInfo_name VARCHAR(30),
  appInfo_version VARCHAR(30),
  appInfo_metadata_DeviceSetupScenario  VARCHAR(30),
  environmentInfo_country VARCHAR(20),
  environmentInfo_device_id VARCHAR(30),
  environmentInfo_language VARCHAR(36),
  environmentInfo_modelName VARCHAR(50),
  environmentInfo_os_version VARCHAR(50),
  environmentInfo_timeZoneOffset INT,
  environmentInfo_region VARCHAR(30),
  productSet VARCHAR(1000),
  productInfo_modelName VARCHAR(50),
  objectkey VARCHAR(200),
  size INT,
  createDateString VARCHAR(75),
  id int IDENTITY(1,1)
);

/*

copy fh_unknown
from 's3://smartcare-firehose/unknown/manifests/2015/11/11/23/unknown-2015-11-11-23-36-41-db31d368-175f-4849-90d4-2699604617b4'
credentials 'aws_access_key_id=AKIAINGWZ3T5JEFEN7GQ;aws_secret_access_key=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'
TRUNCATECOLUMNS
manifest
;


copy fh_unknown
from 's3://smartcare-firehose/unknown/2015/11/12/00/unknown-4-2015-11-12-00-30-10-e7cb2bb4-b976-4595-aa7d-72210a4e45a8'
credentials 'aws_access_key_id=AKIAINGWZ3T5JEFEN7GQ;aws_secret_access_key=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'
TRUNCATECOLUMNS fixedwidth 'json:65535'
manifest
;
select count(*) from fh_unknown;

select * from fh_unknown limit 100;

truncate table stl_load_errors
select * from stl_load_errors order by starttime desc limit 10;


json 's3://smartcarerequests/sbsmapprod.json' TRUNCATECOLUMNS
*/
