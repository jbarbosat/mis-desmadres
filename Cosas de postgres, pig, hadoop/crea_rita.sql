drop table if exists rita cascade;

Create table rita
(id bigserial,
year integer,
month integer, 
dayofmonth integer,
dayofweek integer, 
deptime varchar, 
crsdeptime varchar, 
arrtime varchar, 
crsarrtime varchar,
uniquecarrier varchar, 
flightnum varchar, 
tailnum varchar,
actualelapsedtime integer,
crselapsedtime integer, 
airtime integer, 
arrdelay integer, 
depdelay integer,
origin varchar,
dest varchar,
distance numeric(10,2), 
taxiin integer, 
taxiout integer, 
cancelled boolean, 
cancellationcode varchar, 
diverted boolean, 
carrierdelay integer, 
weatherdelay integer, 
nasdelay integer, 
securitydelay integer, 
lateaircraftdelay integer, 
flight_date timestamp);

CREATE TABLE rita_1987 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '1987-01-01'
       AND flight_date <= '1987-12-31 23:59:59')
) INHERITS ( rita );

CREATE TABLE rita_1988 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '1988-01-01'
       AND flight_date <= '1988-12-31 23:59:59')
) INHERITS ( rita );

CREATE TABLE rita_1989 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '1989-01-01'
       AND flight_date <= '1989-12-31 23:59:59')
) INHERITS ( rita );

CREATE TABLE rita_1990 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '1990-01-01'
       AND flight_date <= '1990-12-31 23:59:59')
) INHERITS ( rita );

CREATE TABLE rita_1991 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '1991-01-01'
       AND flight_date <= '1991-12-31 23:59:59')
) INHERITS ( rita );

CREATE TABLE rita_1992 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '1992-01-01'
       AND flight_date <= '1992-12-31 23:59:59')
) INHERITS ( rita );

CREATE TABLE rita_1993 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '1993-01-01'
       AND flight_date <= '1993-12-31 23:59:59')
) INHERITS ( rita );

CREATE TABLE rita_1994 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '1994-01-01'
       AND flight_date <= '1994-12-31 23:59:59')
) INHERITS ( rita );

CREATE TABLE rita_1995 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '1995-01-01'
       AND flight_date <= '1995-12-31 23:59:59')
) INHERITS ( rita );

CREATE TABLE rita_1996 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '1996-01-01'
       AND flight_date <= '1996-12-31 23:59:59')
) INHERITS ( rita );

CREATE TABLE rita_1997 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '1997-01-01'
       AND flight_date <= '1997-12-31 23:59:59')
) INHERITS ( rita );

CREATE TABLE rita_1998 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '1998-01-01'
       AND flight_date <= '1998-12-31 23:59:59')
) INHERITS ( rita );

CREATE TABLE rita_1999 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '1999-01-01'
       AND flight_date <= '1999-12-31 23:59:59')
) INHERITS ( rita );


CREATE TABLE rita_2000 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '2000-01-01'
       AND flight_date <= '2000-12-31 23:59:59')
) INHERITS ( rita );


CREATE TABLE rita_2001 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '2001-01-01'
       AND flight_date <= '2001-12-31 23:59:59')
) INHERITS ( rita );

CREATE TABLE rita_2002 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '2002-01-01'
       AND flight_date <= '2002-12-31 23:59:59')
) INHERITS ( rita );

CREATE TABLE rita_2003 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '2003-01-01'
       AND flight_date <= '2003-12-31 23:59:59')
) INHERITS ( rita );

CREATE TABLE rita_2004 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '2004-01-01'
       AND flight_date <= '2004-12-31 23:59:59')
) INHERITS ( rita );

CREATE TABLE rita_2005 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '2005-01-01'
       AND flight_date <= '2005-12-31 23:59:59')
) INHERITS ( rita );

CREATE TABLE rita_2006 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '2006-01-01'
       AND flight_date <= '2006-12-31 23:59:59')
) INHERITS ( rita );

CREATE TABLE rita_2007 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '2007-01-01'
       AND flight_date <= '2007-12-31 23:59:59')
) INHERITS ( rita );

CREATE TABLE rita_2008 (
CONSTRAINT partition_date_range
CHECK (flight_date >=   '2008-01-01'
       AND flight_date <= '2008-12-31 23:59:59')
) INHERITS ( rita );


CREATE TABLE rita_overflow () INHERITS ( rita );


CREATE TRIGGER rita_insert BEFORE INSERT ON rita
FOR EACH ROW EXECUTE PROCEDURE rita_insert();

BEGIN;

INSERT INTO rita
(year , month , dayofmonth , dayofweek , deptime , crsdeptime , arrtime , crsarrtime , uniquecarrier , flightnum , tailnum , actualelapsedtime , crselapsedtime , airtime , arrdelay , depdelay , origin , dest , distance , taxiin , taxiout , cancelled , cancellationcode , diverted , carrierdelay , weatherdelay , nasdelay , securitydelay , lateaircraftdelay , flight_date) 
select nullif(btrim(year),'NA')::integer as year,
nullif(btrim(month) ,'NA')::integer as month,
nullif(btrim(dayofmonth),'NA')::integer as dayofmonth,
nullif(btrim(dayofweek) ,'NA')::integer as dayofweek,
nullif(case when btrim(deptime) > '2359' then '0000'
            when substring(lpad(btrim(deptime),4,'0'),3,1) > '59' 
            then substring(lpad(btrim(deptime),4,'0'),1,2) || '00'
            else lpad(btrim(deptime),4,'0') end,'00NA') as deptime,
nullif(case when btrim(crsdeptime) > '2359' then '0000'
            when substring(lpad(btrim(crsdeptime),4,'0'),3,1) > '59' 
            then substring(lpad(btrim(crsdeptime),4,'0'),1,2) || '00'
            else lpad(btrim(crsdeptime),4,'0') end,'00NA') as crsdeptime,
nullif(case when btrim(arrtime) > '2359' then '0000'
            when substring(lpad(btrim(arrtime),4,'0'),3,1) > '59' 
            then substring(lpad(btrim(arrtime),4,'0'),1,2) || '00'
            else lpad(btrim(arrtime),4,'0') end,'00NA') as arrtime,
nullif(case when btrim(crsarrtime) > '2359' then '0000'
            when substring(lpad(btrim(crsarrtime),4,'0'),3,1) > '59' 
            then substring(lpad(btrim(crsarrtime),4,'0'),1,2) || '00'
            else lpad(btrim(crsarrtime),4,'0') end,'00NA') as crsarrtime,
nullif(btrim(uniquecarrier) ,'NA') as uniquecarrier,
nullif(btrim(flightnum) ,'NA') as flightnum,
nullif(btrim(tailnum) ,'NA') as tailnum,
nullif(btrim(actualelapsedtime),'NA')::integer as actualelapsedtime,
nullif(btrim(crselapsedtime),'NA')::integer as crselapsedtime,
nullif(btrim(airtime) ,'NA')::integer as airtime,
nullif(btrim(arrdelay) ,'NA')::integer as arrdelay,
nullif(btrim(depdelay),'NA')::integer as depdelay,
nullif(btrim(origin),'NA') as origin,
nullif(btrim(dest) ,'NA') as dest,
nullif(btrim(distance),'NA')::numeric as distance,
nullif(btrim(taxiin) ,'NA')::integer as taxiin,
nullif(btrim(taxiout),'NA')::integer as taxiout,
nullif(btrim(cancelled),'NA')::boolean as cancelled,
nullif(btrim(cancellationcode) ,'NA')::char as cancellationcode,
nullif(btrim(diverted),'NA')::boolean as diverted,
nullif(btrim(carrierdelay),'NA')::integer as carrierdelay,
nullif(btrim(weatherdelay),'NA')::integer as weatherdelay,
nullif(btrim(nasdelay),'NA')::integer as nasdelay,
nullif(btrim(securitydelay),'NA')::integer as securitydelay,
nullif(btrim(lateaircraftdelay),'NA')::integer as lateaircraftdelay,
(nullif(btrim(year),'NA') ||'/'|| nullif(btrim(month),'NA') ||'/'|| 
       nullif(btrim(dayofmonth),'NA') ||' '||
       nullif(case when btrim(deptime) > '2359' then '0000'
       when substring(lpad(btrim(deptime),4,'0'),3,1) > '59' 
       then substring(lpad(btrim(deptime),4,'0'),1,2)||'00'
       else lpad(btrim(deptime),4,'0') end, '00NA'))::timestamp as flight_date 
from dirty_rita;

COMMIT;

VACUUM ANALYZE;