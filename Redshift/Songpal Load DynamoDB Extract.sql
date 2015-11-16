
drop table if exists songpalload1026;

create table songpalload1026 (
  dynamoContainer_name VARCHAR(10),
  dynamoContainer_version VARCHAR(10),
  dynamoContainer_token VARCHAR(127),
  dynamoContainer_timestamp bigint,
  partnerInfo_partnerId VARCHAR(36),
  appInfo_build_platform VARCHAR(234),
  appInfo_name VARCHAR(234),
  appInfo_version VARCHAR(234),
  appInfo_metadata_DeviceSetupScenario VARCHAR(5),
  environmentInfo_country VARCHAR(234),
  environmentInfo_language VARCHAR(234),
  environmentInfo_modelName VARCHAR(234),
  environmentInfo_os_version VARCHAR(234),
  environmentInfo_timeZoneOffset bigint,
  environmentInfo_region VARCHAR(3),
  environmentInfo_device_id VARCHAR(36),
  productSet VARCHAR(300),
  id int IDENTITY(1,1)
);


copy songpalload1026
from 's3://smartcarerequests/proddata/songpalsupportcontext.json'
credentials 'aws_access_key_id=AKIAINGWZ3T5JEFEN7GQ;aws_secret_access_key=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'
json 's3://smartcarerequests/proddata/songpalsupportcontextmap.json'
TRUNCATECOLUMNS
MAXERROR 1000
;


drop table if exists songpal1026;

create table songpal1026 as select
  id,
  upper(partnerInfo_partnerId) partnerInfo_partnerId,
  upper(appInfo_build_platform) appInfo_build_platform,
  upper(appInfo_name) appInfo_name,
  upper(appInfo_version) appInfo_version,
  upper(appInfo_metadata_DeviceSetupScenario) appInfo_metadata_DeviceSetupScenario,
  upper(environmentInfo_country) environmentInfo_country,
  upper(environmentInfo_device_id) environmentInfo_device_id,
  upper(environmentInfo_language) environmentInfo_language,
  upper(environmentInfo_modelName) environmentInfo_modelName,
  upper(environmentInfo_os_version) environmentInfo_os_version,
  environmentInfo_timeZoneOffset,
  upper(environmentInfo_region) environmentInfo_region,
  productSet,
  (TIMESTAMP 'epoch' + dynamoContainer_timestamp / 1000 * INTERVAL '1 second ') createdate
from songpalload1026;


-- *************************************************************
-- STEP 2: Rip out the product array into an associated table
-- *************************************************************


drop table if exists songpalproductset1026;

create table songpalproductset1026 (
  modelName VARCHAR(234),
  name VARCHAR(8),
  productid VARCHAR(8),
  connected bool,
  songpalid int,
  id int IDENTITY(1,1)
);

INSERT INTO songpalproductset1026 (modelName, name, productid, connected, songpalid)

WITH exploded_array AS (
    SELECT ID, JSON_EXTRACT_ARRAY_ELEMENT_TEXT(products, seq.i) AS product
    FROM (
      SELECT id, json_extract_path_text(productset, 'products') products
      FROM songpal1026
    ) G, seq1000 seq
    WHERE seq.i < JSON_ARRAY_LENGTH(products)
  )
SELECT upper(TRIM(modelName)) ModelName, 
       upper(TRIM(name)) name, 
       upper(TRIM(productid)) productid, 
       CASE 
        WHEN connected = '1' then true 
        WHEN connected = 'rue' then true 
        ELSE false 
       END connected,
       ID 
       FROM (
  SELECT ID, 
         json_extract_path_text(product, 'name') name, 
         json_extract_path_text(product, 'productid') productid, 
         json_extract_path_text(product, 'modelName') modelName, 
         json_extract_path_text(product, 'metadata','connected') connected
  FROM exploded_array
) G
WHERE LENGTH(ModelName) <= 30 AND LENGTH(ModelName) > 0
limit 100
;

-- *************************************************************
-- STEP 3:  Good, Time to build some cross reference tables 
--          so we can clean up the data (physically or in reference)
-- *************************************************************

-- Create the Models list
drop table if exists songpal1026_models;
create table songpal1026_models as select distinct ModelName from songpalproductset1026;

-- Create the appinfo_build_platform list
drop table if exists songpal1026_appinfo_build_platform;
drop table if exists songpal1026_appinfo_build_platform_loaded;

create table songpal1026_appinfo_build_platform_loaded as select distinct appinfo_build_platform from songpal1026;
create table songpal1026_appinfo_build_platform as 
select appinfo_build_platform from (select 'ANDROID' appinfo_build_platform union select 'IOS' appinfo_build_platform );

-- Create the appinfo_name list
drop table if exists songpal1026_appinfo_name;
drop table if exists songpal1026_appinfo_name_loaded;

create table songpal1026_appinfo_name_loaded as select distinct appinfo_name from songpal1026;
create table songpal1026_appinfo_name as 
select appinfo_name from (select 'SONGPAL' appinfo_name union select 'SONGPAL (B)' appinfo_name );


-- Create the appinfo_version list
drop table if exists songpal1026_appinfo_version;

create table songpal1026_appinfo_version as 
select distinct appinfo_version from songpal1026;

--create table songpal1026_appinfo_version as 
--select distinct appinfo_version from songpal1026
--where appinfo_version ~ '^[[:digit:]]{1,}$|^[[:digit:]]{1,}\\.[[:digit:]]{1,}$|^[[:digit:]]{1,}\\.[[:digit:]]{1,}\\.[[:digit:]]{1,}$';

-- Create the appinfo_metadata_devicesetupscenario list
drop table if exists songpal1026_appinfo_metadata_devicesetupscenario;

create table songpal1026_appinfo_metadata_devicesetupscenario as select distinct appinfo_metadata_devicesetupscenario from songpal1026;

-- Create the environmentinfo_country list
drop table if exists songpal1026_environmentinfo_country;

create table songpal1026_environmentinfo_country as select distinct environmentinfo_country from songpal1026;

-- Create the environmentinfo_device_id
drop table if exists songpal1026_environmentinfo_device_id;

create table songpal1026_environmentinfo_device_id as select distinct environmentinfo_device_id from songpal1026;

-- Create the environmentinfo_language
drop table if exists songpal1026_environmentinfo_language;

create table songpal1026_environmentinfo_language as select distinct environmentinfo_language from songpal1026;

-- Create the environmentinfo_modelname
drop table if exists songpal1026_environmentinfo_modelname;

create table songpal1026_environmentinfo_modelname as select distinct environmentinfo_modelname from songpal1026;
-- The reason?  We want to keep the modelname loaded around for a bit, but we'll manually clean up the songpal_environmentinfo_modelname
create table songpal1026_environmentinfo_modelname_loaded as select * from songpal_environmentinfo_modelname;

-- Create the environmentinfo_os_version
drop table if exists songpal1026_environmentinfo_os_version;

create table songpal1026_environmentinfo_os_version as select distinct environmentinfo_os_version from songpal1026;
-- The reason?  We want to keep the os_version loaded around for a bit, but we'll manually clean up the songpal_environmentinfo_os_version
create table songpal1026_environmentinfo_os_version_loaded as select * from songpal_environmentinfo_os_version;

-- Create the environmentinfo_timezoneoffset
drop table if exists songpal1026_environmentinfo_timezoneoffset;

create table songpal1026_environmentinfo_timezoneoffset as select distinct environmentinfo_timezoneoffset from songpal1026;

-- Create the environmentinfo_region
drop table if exists songpal1026_environmentinfo_region;

create table songpal1026_environmentinfo_region as select distinct environmentinfo_region from songpal1026;

-- delete from songpal_environmentinfo_country where len(environmentinfo_country) <> 2;
-- delete from songpal_environmentinfo_language where len(environmentinfo_language) <> 2;

-- ******************************* S T O P *******************************
-- HERE you need to edit the records in the above tables to reduce them to valid records
-- ******************************* S T O P *******************************

drop table if exists songpal1026_results;

create table songpal1026_results as
select  case when isvalid_appinfo_build_platform = 1 
              and isvalid_appinfo_name = 1
              and isvalid_appinfo_version = 1
              and isvalid_appinfo_metadata_devicesetupscenario = 1
              and isvalid_environmentinfo_country = 1
              and isvalid_environmentinfo_device_id = 1
              and isvalid_environmentinfo_language = 1
--              and isvalid_environmentinfo_modelname = 1
--              and isvalid_environmentinfo_os_version = 1
              and isvalid_environmentinfo_timezoneoffset = 1
              and isvalid_environmentinfo_region = 1
          THEN 1 ELSE 0 END IsValid,
        *
from    (
select  sp.*, 
        case when sp.appinfo_build_platform         is not null AND j01.appinfo_build_platform is null then 0 else 1 end isvalid_appinfo_build_platform,
        case when sp.appinfo_name                   is not null AND j02.appinfo_name is null then 0 else 1 end isvalid_appinfo_name,
        case when sp.appinfo_version                is not null AND j03.appinfo_version is null then 0 else 1 end isvalid_appinfo_version,
        case when sp.appinfo_metadata_devicesetupscenario is not null AND j04.appinfo_metadata_devicesetupscenario is null then 0 else 1 end isvalid_appinfo_metadata_devicesetupscenario,
        case when sp.environmentinfo_country        is not null AND j05.alpha2code is null then 0 else 1 end isvalid_environmentinfo_country,
        case when sp.environmentinfo_device_id      is not null AND j06.environmentinfo_device_id is null then 0 else 1 end isvalid_environmentinfo_device_id,
        case when sp.environmentinfo_language       is not null AND j07.iso639_1 is null then 0 else 1 end isvalid_environmentinfo_language,
        case when sp.environmentinfo_modelname      is not null AND j08.environmentinfo_modelname is null then 0 else 1 end isvalid_environmentinfo_modelname,
        case when sp.environmentinfo_os_version     is not null AND j09.environmentinfo_os_version is null then 0 else 1 end isvalid_environmentinfo_os_version,
        case when sp.environmentinfo_timezoneoffset is not null AND j10.environmentinfo_timezoneoffset is null then 0 else 1 end isvalid_environmentinfo_timezoneoffset,
        case when sp.environmentinfo_region         is not null AND j11.environmentinfo_region is null then 0 else 1 end isvalid_environmentinfo_region
from    songpal1026 sp
left join songpal1026_appinfo_build_platform                j01 on j01.appinfo_build_platform               = sp.appinfo_build_platform
left join songpal1026_appinfo_name                          j02 on j02.appinfo_name                         = sp.appinfo_name
left join songpal1026_appinfo_version                       j03 on j03.appinfo_version                      = sp.appinfo_version
left join songpal1026_appinfo_metadata_devicesetupscenario  j04 on j04.appinfo_metadata_devicesetupscenario = sp.appinfo_metadata_devicesetupscenario
left join isocountry                                    j05 on j05.alpha2code                           = sp.environmentinfo_country
left join songpal1026_environmentinfo_device_id             j06 on j06.environmentinfo_device_id            = sp.environmentinfo_device_id
left join isolanguage                                   j07 on j07.iso639_1                             = sp.environmentinfo_language
left join songpal1026_environmentinfo_modelname             j08 on j08.environmentinfo_modelname            = sp.environmentinfo_modelname
left join songpal1026_environmentinfo_os_version            j09 on j09.environmentinfo_os_version           = sp.environmentinfo_os_version
left join songpal1026_environmentinfo_timezoneoffset        j10 on j10.environmentinfo_timezoneoffset       = sp.environmentinfo_timezoneoffset
left join songpal1026_environmentinfo_region                j11 on j11.environmentinfo_region               = sp.environmentinfo_region
) g;


select count(*) from songpal1026;
select count(*) from songpal1026_results;
select count(*) from songpal1026_results where isvalid = 1;





