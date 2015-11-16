/*
1. Number of times opened SongPal SDK by countries
2. Version of SongPal opened the SDK

3. Ranking of which items in SDK user selected
  3.1 Help or Device Support？
  3.2 Ranking of items selected in Device Support
  3.3 How much in ration the devices are already connected when opened SDK?
  Question: To which extent the tracking codes are given to help guide, only the first time selected in SDK or as long as browsing in SDK webview? 
  
4. Connected devices information when opened SDK
  4.1 Model name
  4.2 Wireless options, Wi-Fi or Bluetooth.
  Quextion: Is it possible to track whole process when users opend the SDK and browsed “How to connect” and the if they could actually get connected?

5. Count getHome by country over time
*/


drop table if exists _songpal;

create temp table _songpal as
select trunc(createdate) shortdate, 
      partnerinfo_partnerid partnerid,
      appinfo_build_platform platform,
      appinfo_name appname,
      appinfo_version version,
      appinfo_metadata_devicesetupscenario scenario,
      environmentinfo_country isocountry,
      environmentinfo_device_id deviceid,
      environmentinfo_language isolanguage,
      environmentinfo_modelname modelname,
      environmentinfo_os_version osversion,
      environmentinfo_timezoneoffset timezoneoffset,
      environmentinfo_region region,
      productinfo_modelname productmodelname,
      createdate,
      id
from  songpal_isvalid 
;

-----------------------------------------------------------------
-- 1. Number of times opened SongPal SDK by countries
-----------------------------------------------------------------
drop table if exists EXPORTSongpalOpenedByCountry;

create table EXPORTSongpalOpenedByCountry as
select isocountry, englishshortname,
      count(*) count
from _songpal a
inner join isocountry c on a.isocountry = c.alpha2code
group by isocountry, englishshortname
order by count(*) desc;
;

select * from EXPORTSongpalOpenedByCountry order by count desc;

-----------------------------------------------------------------
-- 1.(2) Number of times opened SongPal SDK by countries (extended request = by date)
-----------------------------------------------------------------

drop table if exists EXPORTSongpalOpenedByCountryByMonth;
drop table if exists EXPORTSongpalOpenedByCountryByMonthTranspose;

create table EXPORTSongpalOpenedByCountryByMonth as

select right('0' + convert(varchar, Month), 2) + '/' + convert(varchar, Year) AS Date, isocountry, englishshortname, count
from (
  select isocountry,
        DATEPART(year, shortdate) AS Year, 
        DATEPART(month, shortdate) AS Month, 
        count(*) count
  from _songpal
  group by isocountry, Year, Month
  ) a
inner join isocountry c on a.isocountry = c.alpha2code
;

create table EXPORTSongpalOpenedByCountryByMonthTranspose as
select isocountry, sum(d201504) d201504, sum(d201505) d201505, sum(d201506) d201506, sum(d201507) d201507, sum(d201508) d201508, sum(d201509) d201509, sum(d201510) d201510 from (
select isocountry, sum(count) d201504, 0 d201505, 0 d201506, 0 d201507, 0 d201508, 0 d201509, 0 d201510 from EXPORTSongpalOpenedByCountryByMonth where date = '04/2015' group by isocountry
union
select isocountry, 0 d201504, sum(count) d201505, 0 d201506, 0 d201507, 0 d201508, 0 d201509, 0 d201510 from EXPORTSongpalOpenedByCountryByMonth where date = '05/2015' group by isocountry
union
select isocountry, 0 d201504, 0 d201505, sum(count) d201506, 0 d201507, 0 d201508, 0 d201509, 0 d201510 from EXPORTSongpalOpenedByCountryByMonth where date = '06/2015' group by isocountry
union
select isocountry, 0 d201504, 0 d201505, 0 d201506, sum(count) d201507, 0 d201508, 0 d201509, 0 d201510 from EXPORTSongpalOpenedByCountryByMonth where date = '07/2015' group by isocountry
union
select isocountry, 0 d201504, 0 d201505, 0 d201506, 0 d201507, sum(count) d201508, 0 d201509, 0 d201510 from EXPORTSongpalOpenedByCountryByMonth where date = '08/2015' group by isocountry
union
select isocountry, 0 d201504, 0 d201505, 0 d201506, 0 d201507, 0 d201508, sum(count) d201509, 0 d201510 from EXPORTSongpalOpenedByCountryByMonth where date = '09/2015' group by isocountry
union
select isocountry, 0 d201504, 0 d201505, 0 d201506, 0 d201507, 0 d201508, 0 d201509, sum(count) d201510 from EXPORTSongpalOpenedByCountryByMonth where date = '10/2015' group by isocountry
) g
group by isocountry
order by isocountry
;


-----------------------------------------------------------------
-- 2. Version of SongPal opened the SDK
-----------------------------------------------------------------
drop table if exists EXPORTSongpalVersionsOpened;

create table EXPORTSongpalVersionsOpened as
select version, 
      count(*) count
from _songpal
group by version
order by count(*) desc;

select * from EXPORTSongpalVersionsOpened order by count desc;


-----------------------------------------------------------------
-- 4.1. Connected devices information when opened SDK(by Year/Month)
-----------------------------------------------------------------
drop table if exists EXPORTSongpalVersionsYearMonthConnected;

create table EXPORTSongpalVersionsYearMonthConnected as
select Year, Month, modelname, sum(ConnectedCount) ConnectedCount, sum(NotConnectedCount) NotConnectedCount
from (
  select date_part(year, shortdate) AS Year, date_part(month, shortdate) AS Month, a.modelname, count(*) ConnectedCount, 0 NotConnectedCount
  from  songpalproductset_isvalid a
  inner join _songpal b on a.id = b.id  
  where connected 
  group by date_part(year, shortdate), date_part(month, shortdate), a.modelname
  
  union
  
  select date_part(year, shortdate) AS Year, date_part(month, shortdate) AS Month, a.modelname, 0 ConnectedCount, count(*) NotConnectedCount
  from  songpalproductset_isvalid a
  inner join _songpal b on a.id = b.id  
  where not connected 
  group by date_part(year, shortdate), date_part(month, shortdate), a.modelname
) g
group by Year, Month, modelname
ORDER BY Year, Month, modelname;


select modelname, Year, Month, connectedcount, notconnectedcount
from EXPORTSongpalVersionsConnected
order by modelname, Year, Month;




-----------------------------------------------------------------
-- 4.1. Connected devices information when opened SDK(in total)
-----------------------------------------------------------------
drop table if exists EXPORTSongpalVersionsConnected;

create table EXPORTSongpalVersionsConnected as
select modelname, sum(ConnectedCount) ConnectedCount, sum(NotConnectedCount) NotConnectedCount
from (
  select a.modelname, count(*) ConnectedCount, 0 NotConnectedCount
  from  songpalproductset_isvalid a
  inner join _songpal b on a.id = b.id  
  where connected 
  group by date_part(year, shortdate), date_part(month, shortdate), a.modelname
  
  union
  
  select a.modelname, 0 ConnectedCount, count(*) NotConnectedCount
  from  songpalproductset_isvalid a
  inner join _songpal b on a.id = b.id  
  where not connected 
  group by date_part(year, shortdate), date_part(month, shortdate), a.modelname
) g
group by modelname
ORDER BY modelname;


select modelname, connectedcount, notconnectedcount
from EXPORTSongpalVersionsConnected
order by modelname;

