
drop table if exists isolanguage;

create table isolanguage
(
  languagefamily VARCHAR(19),
  languagename   VARCHAR(51),
  nativename   VARCHAR(57),
  iso639_1   VARCHAR(2),
  iso639_2_T   VARCHAR(3),
  iso639_2_B   VARCHAR(3),
  iso639_3   VARCHAR(7),
  iso639_6   VARCHAR(4),
  bnotes   VARCHAR(75)  
);

copy isolanguage
from 's3://smartcarerequests/languages.json'
credentials 'aws_access_key_id=AKIAINGWZ3T5JEFEN7GQ;aws_secret_access_key=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'
TRUNCATECOLUMNS
json 's3://smartcarerequests/languagemap.json'
;

update isolanguage set
  languagefamily = upper(languagefamily),
  languagename   = upper(languagename),
  nativename   = upper(nativename),
  iso639_1   = upper(iso639_1),
  iso639_2_T   = upper(iso639_2_T),
  iso639_2_B   = upper(iso639_2_B),
  iso639_3   = upper(iso639_3),
  iso639_6   = upper(iso639_6);
  
drop table if exists isocountry;

create table isocountry
(
  englishshortname VARCHAR(43),
  alpha2code   VARCHAR(2),
  alpha3code   VARCHAR(3),
  numericcode   INT
);

copy isocountry
from 's3://smartcarerequests/country.json'
credentials 'aws_access_key_id=AKIAINGWZ3T5JEFEN7GQ;aws_secret_access_key=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'
TRUNCATECOLUMNS
json 's3://smartcarerequests/countrymap.json'
;

update isocountry set
  englishshortname= upper(englishshortname),
  alpha2code= upper(alpha2code),
  alpha3code= upper(alpha3code); 
 


-- *************************************************************
-- STEP 1:  Load up the songpal table
-- *************************************************************
drop table if exists songpalload;

create table songpalload
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

-- Load from the concat file of json
copy songpalload
from 's3://smartcarerequests/proddata/songpaldata.json'
credentials 'aws_access_key_id=AKIAINGWZ3T5JEFEN7GQ;aws_secret_access_key=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'
json 's3://smartcarerequests/songpalprodmap.json'
TRUNCATECOLUMNS
MAXERROR 1000
;

drop table if exists songpal;

create table songpal as select
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
  upper(productInfo_modelName) productInfo_modelName,
  objectkey,
  size,
  convert(datetime, createDateString) createdate
from songpalload;


-- *************************************************************
-- STEP 2: Rip out the product array into an associated table
-- *************************************************************

DROP TABLE IF EXISTS products;
CREATE TEMP TABLE products AS
SELECT id, json_extract_path_text(productset, 'products') products
FROM songpal;

DROP TABLE IF EXISTS products2;
CREATE TEMP TABLE products2 AS
SELECT id, products, JSON_ARRAY_LENGTH(products) productslength
FROM products;

DROP TABLE IF EXISTS elems;
CREATE TEMP TABLE elems AS
SELECT *
FROM seq1000 
WHERE i < (SELECT MAX(productslength) FROM products2);

DROP TABLE IF EXISTS exploded;

CREATE TEMP TABLE exploded AS
SELECT ID, JSON_EXTRACT_ARRAY_ELEMENT_TEXT(products, seq.i) AS product
FROM products2 G, 
     elems seq
WHERE seq.i < G.productslength;

 
drop table if exists songpalproductset;

create table songpalproductset
(
  ID INT,
  ModelName VARCHAR(30),
  Connected BOOLEAN, 
  SourceConnected VARCHAR(25),
  IsValid BOOLEAN
);

INSERT INTO songpalproductset (ID, ModelName, Connected, SourceConnected, IsValid)
SELECT ID, 
       upper(TRIM(modelName)) ModelName, 
       CASE 
          WHEN connected = '1' then true 
          WHEN connected = '0' then false 
          WHEN connected = 'true' then true 
          WHEN connected = 'false' then false 
          ELSE false 
       END connected,
       left(connected, 25) SourceConnected,
       CASE 
          WHEN connected = '1' then true 
          WHEN connected = '0' then true 
          WHEN connected = 'true' then true 
          WHEN connected = 'false' then true 
          ELSE false 
       END IsValid
       
FROM (
  SELECT ID, 
         json_extract_path_text(product, 'modelName') modelName, 
         json_extract_path_text(product, 'metadata','connected') connected
  FROM exploded
) G
WHERE LENGTH(ModelName) <= 30 AND LENGTH(ModelName) > 0
;

select * from songpalproductset where isvalid limit 100;

-- *************************************************************
-- STEP 3:  Good, Time to build some cross reference tables 
--          so we can clean up the data (physically or in reference)
-- *************************************************************

-- Create the Models list
drop table if exists songpal_models;
create table songpal_models as select distinct ModelName from songpalproductset where isvalid;

delete songpal_models
where ModelName like '%\\%%' 
or ModelName like '%WHSEC%' 
or ModelName like '%PING%'
or ModelName like '%WHSCHECK%'
or ModelName like '%;%'
or ModelName like '%''%';

-- now create the valid songpalproductset.  This is a TEMP one because we will
-- create the final real one after based on what is considered valid
-- for the main records
DROP TABLE IF EXISTS songpalproductset_valid1;
CREATE TEMP TABLE songpalproductset_valid1 AS
SELECT s.id, s.modelname, s.connected
FROM   songpalproductset s
INNER  join songpal_models m on s.modelname = m.modelname;

-- Create the appinfo_build_platform list
drop table if exists songpal_appinfo_build_platform;
drop table if exists songpal_appinfo_build_platform_loaded;

create table songpal_appinfo_build_platform_loaded as select distinct appinfo_build_platform from songpal;
create table songpal_appinfo_build_platform as select appinfo_build_platform from (select 'ANDROID' appinfo_build_platform union select 'IOS' appinfo_build_platform );

-- Create the appinfo_name list
drop table if exists songpal_appinfo_name;
drop table if exists songpal_appinfo_name_loaded;

create table songpal_appinfo_name_loaded as select distinct appinfo_name from songpal;
create table songpal_appinfo_name as select appinfo_name from (select 'SONGPAL' appinfo_name union select 'SONGPAL (B)' appinfo_name );

-- Create the appinfo_version list
drop table if exists songpal_appinfo_version;
drop table if exists songpal_appinfo_version_loaded;

create table songpal_appinfo_version as select distinct appinfo_version from songpal;
create table songpal_appinfo_version_loaded as select distinct appinfo_version from songpal;

--create table songpal_appinfo_version as 
--select distinct appinfo_version from songpal
--where appinfo_version ~ '^[[:digit:]]{1,}\\.[[:digit:]]{1,}$|^[[:digit:]]{1,}\\.[[:digit:]]{1,}\\.[[:digit:]]{1,}$';

-- Create the appinfo_metadata_devicesetupscenario list
drop table if exists songpal_appinfo_metadata_devicesetupscenario;

create table songpal_appinfo_metadata_devicesetupscenario as select distinct appinfo_metadata_devicesetupscenario from songpal;

-- Create the environmentinfo_country list
drop table if exists songpal_environmentinfo_country;

create table songpal_environmentinfo_country as select distinct environmentinfo_country from songpal;

-- Create the environmentinfo_device_id
drop table if exists songpal_environmentinfo_device_id;

create table songpal_environmentinfo_device_id as select distinct environmentinfo_device_id from songpal;

-- Create the environmentinfo_language
drop table if exists songpal_environmentinfo_language;

create table songpal_environmentinfo_language as select distinct environmentinfo_language from songpal;

-- Create the environmentinfo_modelname
drop table if exists songpal_environmentinfo_modelname;
drop table if exists songpal_environmentinfo_modelname_loaded;

create table songpal_environmentinfo_modelname as select distinct environmentinfo_modelname from songpal;
create table songpal_environmentinfo_modelname_loaded as select distinct environmentinfo_modelname from songpal;

delete songpal_environmentinfo_modelname 
where environmentinfo_modelname like '%\\%%' 
or environmentinfo_modelname like '%WHSEC%' 
or environmentinfo_modelname like '%PING%'
or environmentinfo_modelname like '%WHSCHECK%'
or environmentinfo_modelname like '%;%'
or environmentinfo_modelname like '%''%'
;

-- Create the environmentinfo_os_version
drop table if exists songpal_environmentinfo_os_version;
drop table if exists songpal_environmentinfo_os_version_loaded;

create table songpal_environmentinfo_os_version as select distinct environmentinfo_os_version from songpal;
-- The reason?  We want to keep the os_version loaded around for a bit, but we'll manually clean up the songpal_environmentinfo_os_version
create table songpal_environmentinfo_os_version_loaded as select distinct environmentinfo_os_version from songpal;

delete songpal_environmentinfo_os_version 
where environmentinfo_os_version like '%\\%%' 
or environmentinfo_os_version like '%WHSEC%' 
or environmentinfo_os_version like '%PING%'
or environmentinfo_os_version like '%WHSCHECK%'
or environmentinfo_os_version like '%;%'
or environmentinfo_os_version like '%''%'
or environmentinfo_os_version like 'LI4VLI4VLI4VLI4VLI4VLI4VLI4VLI4VLI4VLI4VZXRJL2HVC3'
;

-- Create the environmentinfo_timezoneoffset
drop table if exists songpal_environmentinfo_timezoneoffset;

create table songpal_environmentinfo_timezoneoffset as select distinct environmentinfo_timezoneoffset from songpal;

-- Create the environmentinfo_region
drop table if exists songpal_environmentinfo_region;

create table songpal_environmentinfo_region as select distinct environmentinfo_region from songpal;

-- delete from songpal_environmentinfo_country where len(environmentinfo_country) <> 2;
-- delete from songpal_environmentinfo_language where len(environmentinfo_language) <> 2;

-- ******************************* S T O P *******************************
-- HERE you need to edit the records in the above tables to reduce them to valid records
-- ******************************* S T O P *******************************

drop table if exists songpal_results;

create table songpal_results as
select  case when isvalid_appinfo_build_platform = 1 
              and isvalid_appinfo_name = 1
              and isvalid_appinfo_version = 1
              and isvalid_appinfo_metadata_devicesetupscenario = 1
              and isvalid_environmentinfo_country = 1
              and isvalid_environmentinfo_device_id = 1
              and isvalid_environmentinfo_language = 1
              and isvalid_environmentinfo_modelname = 1
              and isvalid_environmentinfo_os_version = 1
              and isvalid_environmentinfo_timezoneoffset = 1
              and isvalid_environmentinfo_region = 1
          THEN 1 ELSE 0 END IsValid,
        *
from    (
select  sp.*, 
        case when                                                   j01.appinfo_build_platform is null then 0 else 1 end isvalid_appinfo_build_platform,
        case when                                                   j02.appinfo_name is null then 0 else 1 end isvalid_appinfo_name,
        case when                                                   j03.appinfo_version is null then 0 else 1 end isvalid_appinfo_version,
        case when sp.appinfo_metadata_devicesetupscenario is not null AND j04.appinfo_metadata_devicesetupscenario is null then 0 else 1 end isvalid_appinfo_metadata_devicesetupscenario,
        case when                                                   j05.alpha2code is null then 0 else 1 end isvalid_environmentinfo_country,
        case when sp.environmentinfo_device_id      is not null AND j06.environmentinfo_device_id is null then 0 else 1 end isvalid_environmentinfo_device_id,
        case when                                                   j07.iso639_1 is null then 0 else 1 end isvalid_environmentinfo_language,
        case when sp.environmentinfo_modelname      is not null AND j08.environmentinfo_modelname is null then 0 else 1 end isvalid_environmentinfo_modelname,
        case when sp.environmentinfo_os_version     is not null AND j09.environmentinfo_os_version is null then 0 else 1 end isvalid_environmentinfo_os_version,
        case when sp.environmentinfo_timezoneoffset is not null AND j10.environmentinfo_timezoneoffset is null then 0 else 1 end isvalid_environmentinfo_timezoneoffset,
        case when sp.environmentinfo_region         is not null AND j11.environmentinfo_region is null then 0 else 1 end isvalid_environmentinfo_region
from    songpal sp
left join songpal_appinfo_build_platform                j01 on j01.appinfo_build_platform               = sp.appinfo_build_platform
left join songpal_appinfo_name                          j02 on j02.appinfo_name                         = sp.appinfo_name
left join songpal_appinfo_version                       j03 on j03.appinfo_version                      = sp.appinfo_version
left join songpal_appinfo_metadata_devicesetupscenario  j04 on j04.appinfo_metadata_devicesetupscenario = sp.appinfo_metadata_devicesetupscenario
left join isocountry                                    j05 on j05.alpha2code                           = sp.environmentinfo_country
left join songpal_environmentinfo_device_id             j06 on j06.environmentinfo_device_id            = sp.environmentinfo_device_id
left join isolanguage                                   j07 on j07.iso639_1                             = sp.environmentinfo_language
left join songpal_environmentinfo_modelname             j08 on j08.environmentinfo_modelname            = sp.environmentinfo_modelname
left join songpal_environmentinfo_os_version            j09 on j09.environmentinfo_os_version           = sp.environmentinfo_os_version
left join songpal_environmentinfo_timezoneoffset        j10 on j10.environmentinfo_timezoneoffset       = sp.environmentinfo_timezoneoffset
left join songpal_environmentinfo_region                j11 on j11.environmentinfo_region               = sp.environmentinfo_region
) g;

drop table if exists songpal_isvalid;

create table songpal_isvalid as 
select  partnerInfo_partnerId,
  appInfo_build_platform,
  appInfo_name,
  appInfo_version,
  appInfo_metadata_DeviceSetupScenario,
  environmentInfo_country,
  environmentInfo_device_id,
  environmentInfo_language,
  environmentInfo_modelName,
  environmentInfo_os_version,
  environmentInfo_timeZoneOffset,
  environmentInfo_region,
  productInfo_modelName,
  createDate,
  id
from songpal_results where isvalid = 1;

DROP TABLE IF EXISTS songpalproductset_isvalid;
CREATE TABLE songpalproductset_isvalid AS
SELECT s.id, s.modelname, s.connected
FROM   songpalproductset s
INNER  JOIN songpal_models m on s.modelname = m.modelname
INNER  JOIN songpal_isvalid x on x.id = s.id;


/*
select * from songpal_isvalid limit 100;

select count(*) from songpal;
select count(*) from songpal_results;
select count(*) from songpal_results where isvalid = 1;

select * from songpal_results where isvalid = 1 limit 100;

select trunc(createdate) , count(*) from songpal_results where isvalid = 1 group by trunc(createdate) order by trunc(createdate);
select appinfo_version, count(*) 
from songpal_results 
where isvalid = 1 group by appinfo_version order by appinfo_version;

select count(*) from songpal_models;
select * from songpal_models;

select  modelname, sum(connected) connected, sum(notconnected) notconnected
from    (
  select  s.modelname, case when s.connected then 1 else 0 end connected, case when s.connected then 0 else 1 end notconnected
  from    songpalproductset s
  inner   join songpal_results ss on ss.id = s.id
  inner   join songpal_models m on m.modelname = s.modelname
  where   ss.isvalid = 1
        ) g
group   by modelname
order   by modelname
;

select  s.modelname, s.connected, count(*)
from    songpalproductset s
inner   join songpal_results ss on ss.id = s.id
inner   join songpal_models m on m.modelname = s.modelname
where   ss.isvalid = 1
group   by s.modelname, s.connected
order   by s.modelname, s.connected
;

select trunc(createdate) , count(*) from songpal_results where isvalid = 0 group by trunc(createdate) order by trunc(createdate);

select * from songpal_results 
where isvalid = 0 
and trunc(createdate) = trunc(convert(datetime, '10/22/2015'))
and not (
  nvl(partnerInfo_partnerId, '') +
  nvl(appInfo_build_platform, '') +
  nvl(appInfo_name, '') +
  nvl(appInfo_version, '') +
  nvl(appInfo_metadata_DeviceSetupScenario, '') +
  nvl(environmentInfo_country, '') +
  nvl(environmentInfo_device_id, '') +
  nvl(environmentInfo_language, '') +
  nvl(environmentInfo_modelName, '') +
  nvl(environmentInfo_os_version, '') +
  nvl(environmentInfo_region, '') +
  nvl(productSet, '') +
  nvl(productInfo_modelName, '')
  ) ilike '%WHS%';
  
select date, count(*) from songpal_results where isvalid = 1 group by date

select s2.spvalid / s1.spcount * 100, s1.spcount songpalhomeall, s2.spvalid songpalhomeallvalid
from
(
  select count(*) * 1.00 spcount from songpal_results where productinfo_modelname IS NULL
) s1,
(
select count(*) * 1.00 spvalid from songpal_results where isvalid = 1 and productinfo_modelname IS NULL
) s2;


select * from songpal_results where isvalid = 1 limit 100;

select *
from rawsongpal
limit 500;

select * from songpal where productinfo_modelname IS NOT NULL;
*/
