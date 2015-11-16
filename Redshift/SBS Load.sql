
drop table if exists sbsprodload;

create table sbsprodload
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
  pagination_count VARCHAR(30),
  pagination_filter VARCHAR(60),
  pagination_start VARCHAR(30),
  objectkey VARCHAR(200),
  size INT,
  createDateString VARCHAR(75),
  id int IDENTITY(1,1)
);

-- Load from the concat file of json
copy sbsprodload
from 's3://smartcarerequests/proddata/sbsdata.json'
credentials 'aws_access_key_id=AKIAINGWZ3T5JEFEN7GQ;aws_secret_access_key=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'
json 's3://smartcarerequests/sbsmapprod.json'
TRUNCATECOLUMNS
MAXERROR 1000
;

drop table if exists sbsprod;

create table sbsprod as
SELECT 
  upper(partnerInfo_partnerId) partnerInfo_partnerId,

  rawappinfo,

  upper(appInfo_build_platform) appInfo_build_platform,
  upper(appInfo_name) appInfo_name,
  upper(appInfo_version) appInfo_version,

  rawenvironmentInfo,

  upper(environmentInfo_country) environmentInfo_country,
  upper(environmentInfo_device_id) environmentInfo_device_id,
  upper(environmentInfo_language) environmentInfo_language,
  upper(environmentInfo_modelName) environmentInfo_modelName,
  upper(environmentInfo_os_version) environmentInfo_os_version,
  upper(environmentInfo_timeZoneOffset) environmentInfo_timeZoneOffset,
  upper(environmentInfo_region) environmentInfo_region,
  
  rawcameraInfo,

  upper(cameraInfo_cameraCategory) cameraInfo_cameraCategory,
  upper(cameraInfo_firmwareVersion) cameraInfo_firmwareVersion,
  upper(cameraInfo_lensFirmwareVersion) cameraInfo_lensFirmwareVersion,
  upper(cameraInfo_lensModel) cameraInfo_lensModel,
  upper(cameraInfo_modelName) cameraInfo_modelName,
  upper(cameraInfo_platformVersion) cameraInfo_platformVersion,
  upper(cameraInfo_pmcaInfo) cameraInfo_pmcaInfo,
  upper(cameraInfo_settingInfo) cameraInfo_settingInfo,
  upper(cameraInfo_shootingMode) cameraInfo_shootingMode,
  
  rawproductInfo,
  
  upper(productInfo_modelName) productInfo_modelName,
  upper(productInfo_model) productInfo_model,
  upper(pagination_category_id) pagination_category_id,
  pagination_count,
  upper(pagination_filter) pagination_filter,
  upper(pagination_start) pagination_start,
  objectkey,
  size,
  convert(datetime, createDateString) createDate,
  id
from sbsprodload;

drop table if exists sbs_appinfo_build_platform;
drop table if exists sbs_appinfo_build_platform_loaded;

create table sbs_appinfo_build_platform_loaded as select distinct appinfo_build_platform from sbsprod;
create table sbs_appinfo_build_platform as 
select appinfo_build_platform from (select 'ANDROID' appinfo_build_platform union select 'IOS' appinfo_build_platform );

drop table if exists sbs_appinfo_name;
drop table if exists sbs_appinfo_name_loaded;

create table sbs_appinfo_name_loaded as select distinct appinfo_name from sbsprod;
create table sbs_appinfo_name as 
select appinfo_name from (select 'SONGPAL' appinfo_name union select 'SUPPORT' appinfo_name union select 'TV CARE' appinfo_name union select 'TV SUPPORT' appinfo_name );

drop table if exists sbs_appinfo_version;
create table sbs_appinfo_version as 
select distinct appinfo_version from sbsprod;

--create table sbs_appinfo_version as 
--select distinct appinfo_version from sbsprod
--where appinfo_version ~ '^[[:digit:]]{1,}$|^[[:digit:]]{1,}\\.[[:digit:]]{1,}$|^[[:digit:]]{1,}\\.[[:digit:]]{1,}\\.[[:digit:]]{1,}$';

drop table if exists sbs_environmentinfo_country;
create table sbs_environmentinfo_country as select distinct environmentinfo_country from sbsprod;

drop table if exists sbs_environmentinfo_device_id;
create table sbs_environmentinfo_device_id as select distinct environmentinfo_device_id from sbsprod;

drop table if exists sbs_environmentinfo_language;
create table sbs_environmentinfo_language as select distinct environmentinfo_language from sbsprod;

drop table if exists sbs_environmentinfo_modelname;
create table sbs_environmentinfo_modelname as select distinct environmentinfo_modelname from sbsprod;

drop table if exists sbs_environmentinfo_os_version;
create table sbs_environmentinfo_os_version as select distinct environmentinfo_os_version from sbsprod;

drop table if exists sbs_environmentinfo_timezoneoffset;
create table sbs_environmentinfo_timezoneoffset as select distinct environmentinfo_timezoneoffset from sbsprod;

drop table if exists sbs_environmentinfo_region;
create table sbs_environmentinfo_region as select distinct environmentinfo_region from sbsprod;

drop table if exists sbs_camerainfo_cameracategory;
create table sbs_camerainfo_cameracategory as select distinct camerainfo_cameracategory from sbsprod;

drop table if exists sbs_camerainfo_firmwareversion;
create table sbs_camerainfo_firmwareversion as select distinct camerainfo_firmwareversion from sbsprod;

drop table if exists sbs_camerainfo_lensmodel;
create table sbs_camerainfo_lensmodel as select distinct camerainfo_lensmodel from sbsprod;

drop table if exists sbs_camerainfo_modelname;
create table sbs_camerainfo_modelname as select distinct camerainfo_modelname from sbsprod;

drop table if exists sbs_camerainfo_platformversion;
create table sbs_camerainfo_platformversion as select distinct camerainfo_platformversion from sbsprod;

drop table if exists sbs_camerainfo_pmcainfo;
create table sbs_camerainfo_pmcainfo as select distinct camerainfo_pmcainfo from sbsprod;

drop table if exists sbs_camerainfo_settinginfo;
create table sbs_camerainfo_settinginfo as select distinct camerainfo_settinginfo from sbsprod;

drop table if exists sbs_camerainfo_shootingmode;
create table sbs_camerainfo_shootingmode as select distinct camerainfo_shootingmode from sbsprod;

drop table if exists sbs_productinfo_modelname;
create table sbs_productinfo_modelname as select distinct productinfo_modelname from sbsprod;

drop table if exists sbs_productinfo_model;
create table sbs_productinfo_model as select distinct productinfo_model from sbsprod;

drop table if exists sbs_pagination_category_id;
create table sbs_pagination_category_id as select distinct pagination_category_id from sbsprod;

drop table if exists sbs_pagination_count;
create table sbs_pagination_count as select distinct pagination_count from sbsprod;

drop table if exists sbs_pagination_filter;
create table sbs_pagination_filter as select distinct pagination_count from sbsprod;


select 'sbsprod', count(*) from sbsprod
union
select 'sbs_appinfo_build_platform', count(*) from sbs_appinfo_build_platform
union
select 'sbs_appinfo_name', count(*) from sbs_appinfo_name 
union
select 'sbs_appinfo_version', count(*) from sbs_appinfo_version
union
select 'sbs_environmentinfo_country', count(*) from sbs_environmentinfo_country
union
select 'sbs_environmentinfo_device_id', count(*) from sbs_environmentinfo_device_id
union
select 'sbs_environmentinfo_language', count(*) from sbs_environmentinfo_language
union
select 'sbs_environmentinfo_modelname', count(*) from sbs_environmentinfo_modelname
union
select 'sbs_environmentinfo_os_version', count(*) from sbs_environmentinfo_os_version
union
select 'sbs_environmentinfo_timezoneoffset', count(*) from sbs_environmentinfo_timezoneoffset
union
select 'sbs_environmentinfo_region', count(*) from sbs_environmentinfo_region
union
select 'sbs_camerainfo_cameracategory', count(*) from sbs_camerainfo_cameracategory
union
select 'sbs_camerainfo_firmwareversion', count(*) from sbs_camerainfo_firmwareversion
union
select 'sbs_camerainfo_lensmodel', count(*) from sbs_camerainfo_lensmodel
union
select 'sbs_camerainfo_modelname', count(*) from sbs_camerainfo_modelname
union
select 'sbs_camerainfo_platformversion', count(*) from sbs_camerainfo_platformversion
union
select 'sbs_camerainfo_pmcainfo', count(*) from sbs_camerainfo_pmcainfo
union
select 'sbs_camerainfo_settinginfo', count(*) from sbs_camerainfo_settinginfo
union
select 'sbs_camerainfo_shootingmode', count(*) from sbs_camerainfo_shootingmode
union
select 'sbs_productinfo_modelname', count(*) from sbs_productinfo_modelname
union
select 'sbs_productinfo_model', count(*) from sbs_productinfo_model
union
select 'sbs_pagination_category_id', count(*) from sbs_pagination_category_id
union
select 'sbs_pagination_count', count(*) from sbs_pagination_count
union
select 'sbs_pagination_filter', count(*) from sbs_pagination_filter;

select 'camerainfo_cameracategory' name, coalesce(A.camerainfo_cameracategory,'<blank>'), COUNT(*) from sbs_camerainfo_cameracategory A INNER JOIN sbsprod S on coalesce(A.camerainfo_cameracategory,'<blank>')=coalesce(S.camerainfo_cameracategory,'<blank>') GROUP BY coalesce(A.camerainfo_cameracategory,'<blank>')
UNION
select 'camerainfo_platformversion', coalesce(A.camerainfo_platformversion,'<blank>') , COUNT(*) from sbs_camerainfo_platformversion A INNER JOIN sbsprod S on coalesce(A.camerainfo_platformversion,'<blank>')=coalesce(S.camerainfo_platformversion,'<blank>') GROUP BY coalesce(A.camerainfo_platformversion,'<blank>')
UNION
select 'camerainfo_settinginfo', coalesce(A.camerainfo_settinginfo,'<blank>') , COUNT(*) from sbs_camerainfo_settinginfo A INNER JOIN sbsprod S on coalesce(A.camerainfo_settinginfo,'<blank>')=coalesce(S.camerainfo_settinginfo,'<blank>') GROUP BY coalesce(A.camerainfo_settinginfo,'<blank>')
UNION
select 'camerainfo_firmwareversion', coalesce(A.camerainfo_firmwareversion,'<blank>') , COUNT(*) from sbs_camerainfo_firmwareversion A INNER JOIN sbsprod S on coalesce(A.camerainfo_firmwareversion,'<blank>')=coalesce(S.camerainfo_firmwareversion,'<blank>') GROUP BY coalesce(A.camerainfo_firmwareversion,'<blank>')
UNION
select 'camerainfo_lensmodel', coalesce(A.camerainfo_lensmodel,'<blank>') , COUNT(*) from sbs_camerainfo_lensmodel A INNER JOIN sbsprod S on coalesce(A.camerainfo_lensmodel,'<blank>')=coalesce(S.camerainfo_lensmodel,'<blank>') GROUP BY coalesce(A.camerainfo_lensmodel,'<blank>')
UNION
select 'camerainfo_pmcainfo', coalesce(A.camerainfo_pmcainfo,'<blank>') , COUNT(*) from sbs_camerainfo_pmcainfo A INNER JOIN sbsprod S on coalesce(A.camerainfo_pmcainfo,'<blank>')=coalesce(S.camerainfo_pmcainfo,'<blank>') GROUP BY coalesce(A.camerainfo_pmcainfo,'<blank>')
UNION
select 'camerainfo_shootingmode', coalesce(A.camerainfo_shootingmode,'<blank>') , COUNT(*) from sbs_camerainfo_shootingmode A INNER JOIN sbsprod S on coalesce(A.camerainfo_shootingmode,'<blank>')=coalesce(S.camerainfo_shootingmode,'<blank>') GROUP BY coalesce(A.camerainfo_shootingmode,'<blank>')
;

-- Time to produce a valid records table


drop table if exists sbs_results;


create table sbs_results as
select  case when isvalid_appinfo_build_platform
              and isvalid_appinfo_name
              and isvalid_appinfo_version
              and isvalid_environmentinfo_country
              and isvalid_environmentinfo_device_id
              and isvalid_environmentinfo_language
              and isvalid_environmentinfo_timezoneoffset
              and isvalid_environmentinfo_region
          THEN true ELSE false END IsValid,
        *
from    (
select  sp.*, 
        case when                                                   j01.appinfo_build_platform is null then false else true end isvalid_appinfo_build_platform,
        case when                                                   j02.appinfo_name is null then false else true end isvalid_appinfo_name,
        case when                                                   j03.appinfo_version is null then false else true end isvalid_appinfo_version,
        case when                                                   j05.alpha2code is null then false else true end isvalid_environmentinfo_country,
        case when sp.environmentinfo_device_id      is not null AND j06.environmentinfo_device_id is null then false else true end isvalid_environmentinfo_device_id,
        case when                                                   j07.iso639_1 is null then false else true end isvalid_environmentinfo_language,
        case when sp.environmentinfo_modelname      is not null AND j08.environmentinfo_modelname is null then false else true end isvalid_environmentinfo_modelname,
        case when sp.environmentinfo_os_version     is not null AND j09.environmentinfo_os_version is null then false else true end isvalid_environmentinfo_os_version,
        case when sp.environmentinfo_timezoneoffset is not null AND j10.environmentinfo_timezoneoffset is null then false else true end isvalid_environmentinfo_timezoneoffset,
        case when sp.environmentinfo_region         is not null AND j11.environmentinfo_region is null then false else true end isvalid_environmentinfo_region
from    sbsprod sp
left join sbs_appinfo_build_platform                j01 on j01.appinfo_build_platform               = sp.appinfo_build_platform
left join sbs_appinfo_name                          j02 on j02.appinfo_name                         = sp.appinfo_name
left join sbs_appinfo_version                       j03 on j03.appinfo_version                      = sp.appinfo_version
left join isocountry                                j05 on j05.alpha2code                           = sp.environmentinfo_country
left join sbs_environmentinfo_device_id             j06 on j06.environmentinfo_device_id            = sp.environmentinfo_device_id
left join isolanguage                               j07 on j07.iso639_1                             = sp.environmentinfo_language
left join sbs_environmentinfo_modelname             j08 on j08.environmentinfo_modelname            = sp.environmentinfo_modelname
left join sbs_environmentinfo_os_version            j09 on j09.environmentinfo_os_version           = sp.environmentinfo_os_version
left join sbs_environmentinfo_timezoneoffset        j10 on j10.environmentinfo_timezoneoffset       = sp.environmentinfo_timezoneoffset
left join sbs_environmentinfo_region                j11 on j11.environmentinfo_region               = sp.environmentinfo_region
) g;


drop table if exists sbs_isvalid;

create table sbs_isvalid as
select 
  id,
  createDateString createDate,
  partnerInfo_partnerId as partnerId,
  appInfo_build_platform as buildPlatform,
  appInfo_name as appName,
  appInfo_version as appVersion,
  environmentInfo_country as isoCountry,
  environmentInfo_language as isoLanguage,
  environmentInfo_device_id as deviceId,
  environmentInfo_modelName as modelName,
  environmentInfo_os_version as osVersion,
  environmentInfo_timeZoneOffset as timeZoneOffset,
  environmentInfo_region as region,
  cameraInfo_cameraCategory,
  cameraInfo_firmwareVersion,
  cameraInfo_lensFirmwareVersion,
  cameraInfo_lensModel,
  cameraInfo_modelName,
  cameraInfo_platformVersion,
  cameraInfo_pmcaInfo,
  cameraInfo_settingInfo,
  cameraInfo_shootingMode,
  productInfo_modelName,
  productInfo_model
from sbs_results where isvalid;

select * from sbs_isvalid limit 100;

select count(*) from sbs_isvalid;

select count(*) from sbs_results
union
select count(*) from sbs_results where isvalid
union
select count(*) from sbs_results where not isvalid;

select * from sbs_results where not isvalid limit 1000;

