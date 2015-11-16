
drop table if exists songpalproduct;

create table songpalproduct
(
  partnerInfo_partnerId VARCHAR(36),
  appInfo_build_platform VARCHAR(7),
  appInfo_name VARCHAR(11),
  appInfo_version VARCHAR(51),
  environmentInfo_country VARCHAR(3),
  environmentInfo_language VARCHAR(3),
  environmentInfo_modelName VARCHAR(33),
  environmentInfo_os_version VARCHAR(69),
  environmentInfo_timeZoneOffset bigint,
  environmentInfo_region VARCHAR(3),
  environmentInfo_device_id VARCHAR(36),
  Product_ProductName VARCHAR(14),
  Product_ProductNameNormalized VARCHAR(13),
  objectKey VARCHAR(81),
  CreateDate VARCHAR(29),
  id int IDENTITY(1,1)
);

copy songpalproduct
from 's3://smartcarerequests/songpalproduct.json'
credentials 'aws_access_key_id=AKIAINGWZ3T5JEFEN7GQ;aws_secret_access_key=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'
TRUNCATECOLUMNS
json 's3://smartcarerequests/songpalproductmap.json'
;


drop table if exists songpalproduct_clean;

create table songpalproduct_clean as
select 
    id,
    CONVERT(DATETIME, CreateDate) CreateDate,
    upper(partnerInfo_partnerId) partnerId,
    upper(appInfo_build_platform) buildplatform,
    upper(appInfo_name) appName,
    upper(appInfo_version) appVersion,
    upper(environmentInfo_country) isocountry,
    upper(environmentInfo_language) isolanguage,
    upper(environmentInfo_modelName) modelName,
    upper(environmentInfo_os_version) osVersion,
    environmentInfo_timeZoneOffset timeZoneOffset,
    upper(environmentInfo_region) region,
    upper(environmentInfo_device_id) deviceId,
    upper(Product_ProductName) ProductName,
    upper(Product_ProductNameNormalized) ProductNameNormalized,
    objectKey
from songpalproduct
;

drop table if exists EXPORTsongpalproductByDate;

create table EXPORTsongpalproductByDate as 
select trunc(createdate) createdate, count(*) 
from songpalproduct_clean 
group by trunc(createdate) 
order by trunc(createdate);

drop table if exists songpalproduct_usebycountrydate;

create temp table songpalproduct_usebycountrydate as 
select isoCountry, trunc(createdate) createdate, count(*) count
from songpalproduct_clean c
inner join isocountry cc on cc.alpha2code = c.isocountry
group by isocountry, trunc(createdate) 
order by isocountry, trunc(createdate);


-- Generate the average for each month
drop table if exists songpalproduct_avgmonth;

create temp table songpalproduct_avgmonth as
select isocountry, datepart(month, createdate) as month, AVG(count) avgmonth 
from songpalproduct_usebycountrydate 
group by isocountry, datepart(month, createdate);

-- Find the top 10 countries last month
drop table if exists songpalproduct_highestlastmonth;

create temp table songpalproduct_highestlastmonth as
select  isocountry
from    songpalproduct_avgmonth s
where   month = (select max(month) from songpalproduct_avgmonth)
order   by avgmonth desc
limit   10;

drop table if exists EXPORTsongpalproduct_top10countrybyweek;

create table EXPORTsongpalproduct_top10countrybyweek as
select  trunc(date_trunc('week', createdate)) beginweek, c.isocountry, sum(count) count
from    songpalproduct_usebycountrydate c
inner   join songpalproduct_highestlastmonth cc on cc.isocountry = c.isocountry
group   by trunc(date_trunc('week', createdate)), c.isocountry
order   by trunc(date_trunc('week', createdate)), c.isocountry;

drop table if exists EXPORTsongpalproduct_top10countrybymonth;

create table EXPORTsongpalproduct_top10countrybymonth as
select  trunc(date_trunc('month', createdate)) as month, ccc.englishshortname, sum(count) count
from    songpalproduct_usebycountrydate c
inner   join songpalproduct_highestlastmonth cc on cc.isocountry = c.isocountry
inner   join isocountry ccc on cc.isocountry = ccc.alpha2code
group   by trunc(date_trunc('month', createdate)), ccc.englishshortname
order   by trunc(date_trunc('month', createdate)), ccc.englishshortname;

drop table if exists EXPORTsongpalproduct_productbymonth;

create table EXPORTsongpalproduct_productbymonth as 
select trunc(date_trunc('month', createdate)) createdate, isocountry, ProductName, count(*)
from songpalproduct_clean
group by trunc(date_trunc('month', createdate)), isocountry, ProductName
;

select * from EXPORTsongpalproduct_productbymonth;

drop table if exists EXPORTsongpalproduct_productbycountrymonth;

create table EXPORTsongpalproduct_productbycountrymonth as 
select trunc(date_trunc('month', createdate)) createdate, ProductName, count(*)
from songpalproduct_clean
group by trunc(date_trunc('month', createdate)), ProductName
;

select * from EXPORTsongpalproduct_productbycountrymonth;


select distinct model from
(
select distinct productname model from songpalproduct_clean
union
select distinct modelname from songpalproductset
union
select distinct productinfo_modelname from songpal_isvalid
union 
select distinct productinfo_modelname from sbs_isvalid
union 
select distinct productinfo_model from sbs_isvalid
union 
select distinct camerainfo_modelname from sbs_isvalid
) g


select name, model, count
from (
select 'songpalproduct' name, productname model, count(*) count from songpalproduct_clean group by productname
union
select 'songpalproductset', modelname, count(*) from songpalproductset group by modelname
union
select 'sbsproductinfo_model', productinfo_model, count(*) from sbs_isvalid group by productinfo_model
union
select 'sbscamerainfo_modelname', camerainfo_modelname, count(*) from sbs_isvalid group by camerainfo_modelname
) g
where model is not null
and ((name = 'songpalproduct' and count > 344) or (name = 'songpalproductset' and count > 4170))
order by name, count desc
;
-- lets simply import all the files and find their schemas
-- Can we create a Node.js implementation that looks at the schema structure of the json, constructs a table structure for it?
-- including sub-tables for related arrays?
-- including determining bool / int / bigint? (Date requires domain knowledge)

SELECT englishshortname,
       sum("count") count
FROM exportsongpalopenedbycountrybymonth
group by englishshortname
order by sum("count")  desc;



SELECT date,
       englishshortname,
       "count"
FROM exportsongpalopenedbycountrybymonth
where englishshortname in 
(
  SELECT englishshortname
  FROM exportsongpalopenedbycountrybymonth
  group by englishshortname
  order by sum("count")  desc
  limit 10
)
;

