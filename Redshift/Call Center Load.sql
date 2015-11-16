drop table if exists callcenter;

CREATE TABLE callcenter (
casenumber INT,
actobjid INT,
creationtime VARCHAR(23),
casesource VARCHAR(25),
casereasonlevel0 VARCHAR(120),
casereasonlevel1 VARCHAR(120),
casereasonlevel2 VARCHAR(120),
casereasonlevel3 VARCHAR(120),
casereasonlevel4 VARCHAR(120),
casetitle VARCHAR(120),
country VARCHAR(18),
language VARCHAR(11),
model VARCHAR(40),
lineup VARCHAR(40),
typeof1stinteraction VARCHAR(30),
logcontent1stinteraction VARCHAR(36000)
);

copy callcenter
from 's3://smartcare-call-center-data/callcenter11.json'
credentials 'aws_access_key_id=AKIAINGWZ3T5JEFEN7GQ;aws_secret_access_key=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'
format as json 'auto'
;

select * from stl_load_errors order by starttime desc;

select * from callcenter limit 100;

select casereasonlevel0, count(*) from callcenter group by casereasonlevel0;
select casereasonlevel1, casereasonlevel2, count(*) from callcenter group by casereasonlevel1, casereasonlevel2 order by count(*) desc;
select casereasonlevel2, count(*) from callcenter group by casereasonlevel2 order by count(*) desc;
select casereasonlevel3, count(*) from callcenter group by casereasonlevel3 order by count(*) desc;
