/*
create table requestlog ( RequestID INT, Request VARCHAR(50000), TimeStamp DATETIME)

select * from stl_load_errors;

copy requestlog
from 's3://smartcarerequests/tblrequestlog.txt'
credentials 'aws_access_key_id=AKIAINGWZ3T5JEFEN7GQ;aws_secret_access_key=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' 
delimiter ','
escape


select * from requestlog limit 10

select count(*)
from requestlog
where json_extract_path_text(request,'appInfo', 'build_platform')= 'Android' 


select * from requestlog
where = 'appinfo.build_platform == Android'                                                                                                                                                                                                                     	1	requestid                                                                                                                      	int4      	0         	0	6144,{"partnerInfo":{"partnerId":"c465c49e-4f13-49e9-af8d-1eabfb4087dc"}\\,"appInfo":{"build_platform":"Android"\\,"name":"TV Care"\\,"version":"0.0.1.BUILD_NUMBER"}\\,"environmentInfo":{"country":"US"\\,"device_id":"eac12afcaf4bfde7"\\,"language":"en"\\,"modelName":"Sony BRAVIA 2015"\\,"os_version":"REL 22 5.1.1 2.463"\\,"timeZoneOffset":-28800000}\\,"deviceStatus":{"installedApps":[]\\,"bluetooth":{"address":"AC:D1:B8:57:56:8E"\\,"bondedDevices":[]\\,"name":"KDL-50W800C"}\\,"brightness":255\\,"displays":[{"density":2\\,"densityDpi":320\\,"displayId":0\\,"height":1080\\,"width":1920}]\\,"isFromQrScan":true\\,"inputs":[{"label":"HDMI 2"\\,"state":"CONNECTED"\\,"type":"HDMI"}\\,{"label":"Video/Component"\\,"state":"CONNECTED"\\,"type":"COMPONENT"}\\,{"label":"HDMI 4/ARC"\\,"state":"CONNECTED"\\,"type":"HDMI"}\\,{"label":"HDMI 3"\\,"state":"CONNECTED"\\,"type":"HDMI"}\\,{"label":"HDMI 1/MHL"\\,"state":"CONNECTED"\\,"type":"HDMI"}\\,{"label":"Cable/Antenna"\\,"state":"CONNECTED"\\,"type":"TUNER"}]\\,"modelName":	6144,{"partnerInfo":{"partnerId":"c465c49e-4f13-49e9-af8d-1eabfb4087dc"}\\,"appInfo":{"build_platform":"Android"\\,"name":"TV Care"\\,"version":"0.0.1.BUILD_NUMBER"}\\,"environmentInfo":{"country":"US"\\,"device_id":"eac12afcaf4bfde7"\\,"language":"en"\\,"modelName":"Sony BRAVIA 2015"\\,"os_version":"REL 22 5.1.1 2.463"\\,"timeZoneOffset":-28800000}\\,"deviceStatus":{"installedApps":[]\\,"bluetooth":{"address":"AC:D1:B8:57:56:8E"\\,"bondedDevices":[]\\,"name":"KDL-50W800C"}\\,"brightness":255\\,"displays":[{"density":2\\,"densityDpi":320\\,"displayId":0\\,"height":1080\\,"width":1920}]\\,"isFromQrScan":true\\,"inputs":[{"label":"HDMI 2"\\,"state":"CONNECTED"\\,"type":"HDMI"}\\,{"label":"Video/Component"\\,"state":"CONNECTED"\\,"type":"COMPONENT"}\\,{"label":"HDMI 4/ARC"\\,"state":"CONNECTED"\\,"type":"HDMI"}\\,{"label":"HDMI 3"\\,"state":"CONNECTED"\\,"type":"HDMI"}\\,{"label":"HDMI 1/MHL"\\,"state":"CONNECTED"\\,"type":"HDMI"}\\,{"label":"Cable/Antenna"\\,"state":"CONNECTED"\\,"type":"TUNER"}]\\,"modelName":	1214	Delimiter not found                                                                                 
*/

drop table rawmobilemetrics;
drop table rawmobilemetricscomp;


create table rawmobilemetricstest
(
  event_type VARCHAR(50) ENCODE lzo, 
  event_timestamp BIGINT ENCODE lzo,
  testfield VARCHAR(1200) ENCODE lzo
)

create table rawmobilemetricscomp 
(
  event_type VARCHAR(50) ENCODE lzo, 
  event_timestamp BIGINT ENCODE lzo,
  arrival_timestamp BIGINT ENCODE lzo,
  event_version VARCHAR(15) ENCODE lzo,
  application VARCHAR(1200) ENCODE lzo,
  application_app_id VARCHAR(32) ENCODE lzo,
  application_cognito_identity_pool_id VARCHAR(70) ENCODE lzo,
  application_package_name VARCHAR(200) ENCODE lzo,
  application_sdk VARCHAR(120) ENCODE lzo,
  application_sdk_name VARCHAR(120) ENCODE lzo,
  application_sdk_version VARCHAR(15) ENCODE lzo,
  application_title VARCHAR(120) ENCODE lzo,
  application_version_name VARCHAR(50) ENCODE lzo,
  application_version_code VARCHAR(15) ENCODE lzo,
  client VARCHAR(200) ENCODE lzo,
  client_client_id VARCHAR(36) ENCODE lzo,
  client_cognito_id VARCHAR(70) ENCODE lzo,
  device VARCHAR(1200) ENCODE lzo,
  device_locale VARCHAR(200) ENCODE lzo,
  device_locale_code VARCHAR(30) ENCODE lzo,
  device_locale_country VARCHAR(30) ENCODE lzo,
  device_locale_language VARCHAR(30) ENCODE lzo,
  device_make VARCHAR(50) ENCODE lzo,
  device_model VARCHAR(50) ENCODE lzo,
  device_platform VARCHAR(200) ENCODE lzo,
  device_platform_name VARCHAR(50) ENCODE lzo,
  device_platform_version VARCHAR(15) ENCODE bytedict,
  session VARCHAR(200) ENCODE lzo,
  session_session_id VARCHAR(36) ENCODE lzo,
  session_start_timestamp BIGINT ENCODE lzo,
  attributes VARCHAR(1200) ENCODE lzo,
  metrics VARCHAR(1200) ENCODE lzo
);

insert into rawmobilemetricscomp
select * from rawmobilemetrics;

create table rawmobilemetrics 
(
  event_type VARCHAR(50), 
  event_timestamp BIGINT,
  arrival_timestamp BIGINT,
  event_version VARCHAR(15),
  application VARCHAR(1200),
  application_app_id VARCHAR(32),
  application_cognito_identity_pool_id VARCHAR(70),
  application_package_name VARCHAR(200),
  application_sdk VARCHAR(120),
  application_sdk_name VARCHAR(120),
  application_sdk_version VARCHAR(15),
  application_title VARCHAR(120),
  application_version_name VARCHAR(50),
  application_version_code VARCHAR(15),
  client VARCHAR(200),
  client_client_id VARCHAR(36),
  client_cognito_id VARCHAR(70),
  device VARCHAR(1200),
  device_locale VARCHAR(200),
  device_locale_code VARCHAR(30),
  device_locale_country VARCHAR(30),
  device_locale_language VARCHAR(30),
  device_make VARCHAR(50),
  device_model VARCHAR(50),
  device_platform VARCHAR(200),
  device_platform_name VARCHAR(50),
  device_platform_version VARCHAR(15),
  session VARCHAR(200),
  session_session_id VARCHAR(36),
  session_start_timestamp BIGINT,
  attributes VARCHAR(1200),
  metrics VARCHAR(1200)
);

copy rawmobilemetricstest
from 's3://smartcarerequests/loadmanifest1.json'
credentials 'aws_access_key_id=AKIAINGWZ3T5JEFEN7GQ;aws_secret_access_key=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'
manifest
json 's3://smartcarerequests/mobilemetricspathstest.json'
GZIP;

copy rawmobilemetrics
from 's3://smartcarerequests/loadmanifest1.json'
credentials 'aws_access_key_id=AKIAINGWZ3T5JEFEN7GQ;aws_secret_access_key=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'
manifest
json 's3://smartcarerequests/mobilemetricspaths.json'
GZIP;
*/



select count(*) from rawmobilemetrics;

select * from rawmobilemetrics limit 10;


select * from stl_load_errors;
order by starttime desc;

select distinct device_platform_name from rawmobilemetrics;
select distinct event_type from rawmobilemetrics;
select distinct application_sdk_version from rawmobilemetrics;
select distinct device_locale_code from rawmobilemetrics;

-- OK, so we can do loops through known fields to find the max lengths, let's do that now and dump those to a table
json_extract_path_text(request,'appInfo', 'build_platform')= 'Android' 



create view tables_vw as
select distinct(id) table_id
,trim(datname)   db_name
,trim(nspname)   schema_name
,trim(relname)   table_name
from stv_tbl_perm
join pg_class on pg_class.oid = stv_tbl_perm.id
join pg_namespace on pg_namespace.oid = relnamespace
join pg_database on pg_database.oid = stv_tbl_perm.db_id;

select datname, nspname, relname, sum(rows) as rows
from pg_class, pg_namespace, pg_database, stv_tbl_perm
where pg_namespace.oid = relnamespace
and pg_class.oid = stv_tbl_perm.id
and pg_database.oid = stv_tbl_perm.db_id
--and datname ='tickit'
group by datname, nspname, relname
order by datname, nspname, relname;

select distinct attrelid, rtrim(name), attname, typname
from pg_attribute a, pg_type t, stv_tbl_perm p
where t.oid=a.atttypid and a.attrelid=p.id
and a.attrelid between 100100 and 110000
and typname not in('oid','xid','tid','cid')
order by a.attrelid asc, typname, attname;

begin;

DECLARE curColumns CURSOR FOR
select distinct attname colname
from pg_attribute a, pg_type t, stv_tbl_perm p
where t.oid=a.atttypid and a.attrelid=p.id
and a.attrelid between 100100 and 110000
and typname not in('oid','xid','tid','cid')
and rtrim(name) = 'rawmobilemetrics'
order by a.attrelid asc, typname, attname;

fetch forward 5 from curColumns;

close curColumns;
commit;


create view WLM_QUEUE_STATE_VW as
select (config.service_class-5) as queue
, trim (class.condition) as description
, config.num_query_tasks as slots
, config.query_working_mem as mem
, config.max_execution_time as max_time
, config.user_group_wild_card as "user_*"
, config.query_group_wild_card as "query_*"
, state.num_queued_queries queued
, state.num_executing_queries executing
, state.num_executed_queries executed
from
STV_WLM_CLASSIFICATION_CONFIG class,
STV_WLM_SERVICE_CLASS_CONFIG config,
STV_WLM_SERVICE_CLASS_STATE state
where
class.action_service_class = config.service_class 
and class.action_service_class = state.service_class 
and config.service_class > 4
order by config.service_class;

select * from WLM_QUEUE_STATE_VW

  SELECT ut.userid, 
  trim(u.usename), 
  COUNT(text) as count 
  FROM stl_utilitytext ut 
  JOIN pg_user u ON ut.userid = u.usesysid 
  WHERE ut.text LIKE 'SAVEPOINT%' 
  GROUP BY ut.userid, u.usename 
  ORDER BY count DESC;
  


select * from rawmobilemetrics limit 5;

select             1 as ID, 'event_type VARCHAR(' || max(length(event_type)) || '),' as statement from rawmobilemetrics
union all select   2 as ID, 'event_version VARCHAR(' || max(length(event_version)) || '),' from rawmobilemetrics
union all select   3 as ID, 'application VARCHAR(' || max(length(application)) || '),' from rawmobilemetrics
union all select   4 as ID, 'application_app_id VARCHAR(' || max(length(application_app_id)) || '),' from rawmobilemetrics
union all select   5 as ID, 'application_cognito_identity_pool_id VARCHAR(' || max(length(application_cognito_identity_pool_id)) || '),' from rawmobilemetrics
union all select   6 as ID, 'application_package_name VARCHAR(' || max(length(application_package_name)) || '),' from rawmobilemetrics
union all select   7 as ID, 'application_sdk VARCHAR(' || max(length(application_sdk)) || '),' from rawmobilemetrics
union all select   8 as ID, 'application_sdk_name VARCHAR(' || max(length(application_sdk_name)) || '),' from rawmobilemetrics
union all select   9 as ID, 'application_sdk_version VARCHAR(' || max(length(application_sdk_version)) || '),' from rawmobilemetrics
union all select  10 as ID, 'application_title VARCHAR(' || max(length(application_title)) || '),' from rawmobilemetrics
union all select  11 as ID, 'application_version_name VARCHAR(' || max(length(application_version_name)) || '),' from rawmobilemetrics
union all select  12 as ID, 'application_version_code VARCHAR(' || max(length(application_version_code)) || '),' from rawmobilemetrics
union all select  13 as ID, 'client VARCHAR(' || max(length(client)) || '),' from rawmobilemetrics
union all select  14 as ID, 'client_client_id VARCHAR(' || max(length(client_client_id)) || '),' from rawmobilemetrics
union all select  15 as ID, 'client_cognito_id VARCHAR(' || max(length(client_cognito_id)) || '),' from rawmobilemetrics
union all select  16 as ID, 'device VARCHAR(' || max(length(device)) || '),' from rawmobilemetrics
union all select  17 as ID, 'device_locale VARCHAR(' || max(length(device_locale)) || '),' from rawmobilemetrics
union all select  18 as ID, 'device_locale_code VARCHAR(' || max(length(device_locale_code)) || '),' from rawmobilemetrics
union all select  19 as ID, 'device_locale_country VARCHAR(' || max(length(device_locale_country)) || '),' from rawmobilemetrics
union all select  20 as ID, 'device_locale_language VARCHAR(' || max(length(device_locale_language)) || '),' from rawmobilemetrics
union all select  21 as ID, 'device_make VARCHAR(' || max(length(device_make)) || '),' from rawmobilemetrics
union all select  22 as ID, 'device_model VARCHAR(' || max(length(device_model)) || '),' from rawmobilemetrics
union all select  23 as ID, 'device_platform VARCHAR(' || max(length(device_platform)) || '),' from rawmobilemetrics
union all select  24 as ID, 'device_platform_name VARCHAR(' || max(length(device_platform_name)) || '),' from rawmobilemetrics
union all select  25 as ID, 'device_platform_version VARCHAR(' || max(length(device_platform_version)) || '),' from rawmobilemetrics
union all select  26 as ID, 'session VARCHAR(' || max(length(session)) || '),' from rawmobilemetrics
union all select  27 as ID, 'attributes VARCHAR(' || max(length(attributes)) || '),' from rawmobilemetrics
union all select  28 as ID, 'metrics VARCHAR(' || max(length(metrics)) || '),' from rawmobilemetrics
order by id;




select stv_tbl_perm.name as table, count(*) as mb
from stv_blocklist, stv_tbl_perm
where stv_blocklist.tbl = stv_tbl_perm.id
and stv_blocklist.slice = stv_tbl_perm.slice
--and stv_tbl_perm.name in ('lineorder','part','customer','dwdate','supplier')
group by stv_tbl_perm.name
order by 1 asc;


analyze compression rawmobilemetricscomp;
analyze compression requestlogcomp;



SELECT * FROM rawmobilemetrics LIMIT 10;
SELECT extract(epoch from now());
select count(*) from rawmobilemetrics;
SELECT CONVERT(DATETIME, event_timestamp) FROM rawmobilemetrics LIMIT 10;


SELECT (TIMESTAMP 'epoch' + 1440635712984 * INTERVAL '1 second ') as mytimestamp 
union all
SELECT (TIMESTAMP 'epoch' + 1440635712 * INTERVAL '1 second ') as mytimestamp 

CREATE TABLE mobilemetrics AS
SELECT (TIMESTAMP 'epoch' + (event_timestamp / 1000) * INTERVAL '1 second ') as eventtime, 
       (TIMESTAMP 'epoch' + (arrival_timestamp / 1000) * INTERVAL '1 second ') as arrivaltime, 
  * 
FROM rawmobilemetrics;

select trunc(arrivaltime), event_type, count(*) 
from mobilemetrics
group by trunc(arrivaltime), event_type
order by trunc(arrivaltime)


SELECT TRUNC(arrivaltime), Event_Type, JSON_EXTRACT_PATH_TEXT(attributes, 'NotificationSource'), COUNT(*)
FROM mobilemetrics 
WHERE event_type IN ( 'NotificationRead')
GROUP BY trunc(arrivaltime), Event_Type, JSON_EXTRACT_PATH_TEXT(attributes, 'NotificationSource')
ORDER BY trunc(arrivaltime), Event_Type, JSON_EXTRACT_PATH_TEXT(attributes, 'NotificationSource')

SELECT *
FROM mobilemetrics 
LIMIT 100;

