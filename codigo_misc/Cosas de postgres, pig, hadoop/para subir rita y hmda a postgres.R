#https://code.google.com/p/rpostgresql/
###################################################################################
#Algunas instrucciones si se hace desde R.
#Que no es tan conveniente porque tarda mucho.
###################################################################################
library(RPostgreSQL)
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, user="postgres",password="patapon1")
creatabla<-dbGetQuery(con,"
CREATE TABLE rita
(Year varchar,
Month varchar,
DayofMonth varchar,
DayOfWeek varchar,
DepTime varchar,
CRSDepTime varchar,
ArrTime varchar,
CRSArrTime varchar,
UniqueCarrier varchar,
FlightNum varchar,
TailNum varchar,
ActualElapsedTime varchar,
CRSElapsedTime varchar,
AirTime varchar,
ArrDelay varchar,
DepDelay varchar,
Origin varchar,
Dest varchar,
Distance varchar,
TaxiIn varchar,
TaxiOut varchar,
Cancelled varchar,
CancellationCode varchar,
Diverted varchar,
CarrierDelay varchar,
WeatherDelay varchar,
NASDelay varchar,
SecurityDelay varchar,
LateAircraftDelay varchar )
WITH (
  OIDS=FALSE
);")

system.time(copiadatos<-dbGetQuery(con,"COPY rita FROM '/Applications/PostgreSQL 9.1/rita.csv' with delimiter ',';"))

###################################################################################
#Problemas 1: Garabatos raros
###################################################################################
#marca error en la línea 69932560, algo de encoding UT8 incorrecto?
#vemos qué pex con sed:
#sed -n 69932558,69932561p rita.csv
2000,12,12,2,613,613,1005,945,AA,705,N627AA,292,272,265,20,0,BOS,DFW,1562,9,18,0,NA,0,NA,NA,NA,NA,NA
2000,12,13,3,614,613,948,945,AA,705,N638AA,274,272,239,3,1,BOS,DFW,1562,12,23,0,NA,0,NA,NA,NA,NA,NA
2001,1,17,3,1806,1810,1931,1934,US,375,N700??,85,84,60,-3,-4,BWI,CLT,361,5,20,0,NA,0,NA,NA,NA,NA,NA
2001,1,18,4,1805,1810,1938,1934,US,375,N713??,93,84,64,4,-5,BWI,CLT,361,9,20,0,NA,0,NA,NA,NA,NA,NA
#el fuckin archivo de 2001 tiene unos signos de interrogación! y tbn arrobas
2001,1,22,1,630,630,730,725,WN,710,N80@@@,60,55,48,5,0,AMA,DAL,324,5,7,0,NA,0,NA,NA,NA,NA,NA
#hay que modificar esas líneas en el rita.csv
#hay cosas raritas en el campo 11. Hay de varias sopas. Una es cambiar el encoding en la base
#a latin 1 para que lo deje subir todo y luego limpiar las cosas ya arriba en postgres con
#regexp_replace o algo así. Para ello hay que tener una key porque la función regresa los
#renglones que surieron cambios. PAra poder updatear la tabla original hace falta tener id's. 

#Entonces, vamos a limpiarlo por fuera. 
#creamos una copia del archivo para hacer pruebitas.
split -l 50000 2001.csv prueba_
#con un archivín, borramos todo lo demás y ya luego lo hacemos en rita.csv, que es donde
#se guardó todo lo que des-zipeamos
head prueba_aa.csv
#el field 11 es el rarito. queremos hacer modificaciones x columna asi q usamos...
od -bc prueba_aa.csv|head -600
N   A   ,   N   A   ,   N   A  \n   2   0   0   1   ,   1   ,
0011160   063 061 054 063 054 071 064 061 054 071 064 060 054 061 060 064
3   1   ,   3   ,   9   4   1   ,   9   4   0   ,   1   0   4
0011200   066 054 061 060 065 064 054 125 123 054 063 067 066 054 116 063
6   ,   1   0   5   4   ,   U   S   ,   3   7   6   ,   N   3
0011220   070 064 344 342 054 066 065 054 067 064 054 064 071 054 055 070
8   4 344 342   ,   6   5   ,   7   4   ,   4   9   ,   -   8
0011240   054 061 054 120 110 114 054 115 110 124 054 062 071 060 054 063
,   1   ,   P   H   L   ,   M   H   T   ,   2   9   0   ,   3
0011260   054 061 063 054 060 054 116 101 054 060 054 116 101 054 116 101
,   1   3   ,   0   ,   N   A   ,   0   ,   N   A   ,   N   A

#esos 344 y 342 wtf!
iconv -f iso-8859-1 -t utf-8 prueba_aa.csv > prueba.csv
2001,1,25,4,1812,1810,1925,1934,US,375,N767äæ,73,84,52,-9,2,BWI,CLT,361,6,15,0,NA,0,NA,NA,NA,NA,NA

grep äæ prueba.csv
#sí jaló!!! sniff sniff
awk '{sub("ä","X"); print}' prueba.csv >prueba2.csv 
awk '{sub("æ","Z"); print}' prueba2.csv > prueba3.csv
awk '{sub("â","W"); print}' prueba3.csv > prueba4.csv

#convertimos el file de 2001,2002 a utf8 y le modificamos con awk los cositos
iconv -f iso-8859-1 -t utf-8 2002.csv > 2002utf.csv
awk '{gsub("ä","X"); print}' 2002utf.csv > 2002mod.csv
awk '{gsub("æ","Z"); print}' 2002mod.csv > 2002fin.csv 
awk '{gsub("â","W"); print}' 2002fin.csv > 2002bueno.csv 

#y ahora sí pegamos todo en el rita.csv y pum, pa' la base
#lo tuve que pegar a mano sin header:
awk FNR-1 1991.csv >> rita.csv
#y luego ponerle header
header='head -1 1987.csv';
cat header rita.csv > rita2.csv
#y luego en postgres...
COPY rita FROM '/Users/PandoraMac/RITA/rita2.csv'
with delimiter ',' header csv

#hubo error en la linea 123534971
#sospecho que los aviones no iban ahí, duh! hay que quitar eso.
#dejé sólo los archivos de los años porque planes, carriers y airports son otras 3 tablas.
#planes hubo que modificarlo porque había líneas raritas. Se solucionó quitando
#los renglones con una sola columna. lo hice a mano por ociosa en clase pero 
#con awk se habría hecho sin pedo
###################################################################################
###################################################################################
#Instrucciones para otros datos, HMDA, que al final no hemos usado mucho porque 
#han dado más lata los de RITA
###################################################################################
creatabla<-dbGetQuery(con,"
CREATE TABLE hmda
(as_of_year varchar,
respondent_id varchar,
agency_code varchar,
loan_type varchar,
property_type varchar,
loan_purpose varchar,
occupancy varchar,
loan_amount_Ks varchar,
preapproval varchar,
action_type varchar,
msa_md varchar,
state_code varchar,
county_code varchar,
census_tract_number varchar,
applicant_ethnicity varchar,
co_applicant_ethnicity varchar,
applicant_race_1 varchar,
applicant_race_2 varchar,
applicant_race_3 varchar,
applicant_race_4 varchar,
applicant_race_5 varchar,
co_applicant_race_1 varchar,
co_applicant_race_2 varchar,
co_applicant_race_3 varchar,
co_applicant_race_4 varchar,
co_applicant_race_5 varchar,
applicant_sex varchar,
co_applicant_sex varchar,
applicant_income_Ks varchar,
purchaser_type varchar,
denial_reason_1 varchar,
denial_reason_2 varchar,
denial_reason_3 varchar,
rate_spread varchar,
hoepa_status varchar,
lien_status varchar,
edit_status varchar,
sequence_number varchar,
population varchar,
minority_population_perc varchar,
hud_median_family_income varchar,
tract_to_msa_md_income_perc varchar,
number_of_owner_occupied_units varchar,
number_of_1_to_4_family_units varchar,
application_date_indicator varchar) 
WITH (
OIDS=FALSE
);")

system.time(copiadatos<-dbGetQuery(con,"COPY hmda FROM '/Applications/PostgreSQL 9.1/hmda.csv' with delimiter ',';"))
#el archivo original tiene 19493491x45 y se llama "2009HMDALAR - National.CSV"
#pero lo copié acá en la carpeta de postgres y le cambié el nombre para evitar broncas
#no hubo bronca :)




############################################################################
#En clase de Adolfo
############################################################################

#Vmos a meter un buen de comanditos en un script .sql para correrlo todo mil veces.

Truncate table if exists rita;
drop table if exists rita cascade;


CREATE UNLOGGED TABLE dirty_rita
(Year varchar,
 Month varchar,
 DayofMonth varchar,
 DayOfWeek varchar,
 DepTime varchar,
 CRSDepTime varchar,
 ArrTime varchar,
 CRSArrTime varchar,
 UniqueCarrier varchar,
 FlightNum varchar,
 TailNum varchar,
 ActualElapsedTime varchar,
 CRSElapsedTime varchar,
 AirTime varchar,
 ArrDelay varchar,
 DepDelay varchar,
 Origin varchar,
 Dest varchar,
 Distance varchar,
 TaxiIn varchar,
 TaxiOut varchar,
 Cancelled varchar,
 CancellationCode varchar,
 Diverted varchar,
 CarrierDelay varchar,
 WeatherDelay varchar,
 NASDelay varchar,
 SecurityDelay varchar,
 LateAircraftDelay varchar )
WITH (
  OIDS=FALSE
);


###########################################################
#Instrucciones para descomprimir de cero.
###########################################################
#Después de pelearnos con esto, vamos a hacer otra cosa...
#PAra descomprimir...

for f in *.bz2; do bunzip2 -k "$f"; done

split -l 1000000 rita2.csv rita_

#Y vamos a subir con un copy las cosas del rita2.csv a la base de datos en distintas tablas
#PAra que todo sea rápido y feliz. hay una tabla x año.
#ademñas, subimos con copys en bulk.

Truncate table rita;
drop table rita;


CREATE UNLOGGED TABLE dirty_rita
(Year varchar,
 Month varchar,
 DayofMonth varchar,
 DayOfWeek varchar,
 DepTime varchar,
 CRSDepTime varchar,
 ArrTime varchar,
 CRSArrTime varchar,
 UniqueCarrier varchar,
 FlightNum varchar,
 TailNum varchar,
 ActualElapsedTime varchar,
 CRSElapsedTime varchar,
 AirTime varchar,
 ArrDelay varchar,
 DepDelay varchar,
 Origin varchar,
 Dest varchar,
 Distance varchar,
 TaxiIn varchar,
 TaxiOut varchar,
 Cancelled varchar,
 CancellationCode varchar,
 Diverted varchar,
 CarrierDelay varchar,
 WeatherDelay varchar,
 NASDelay varchar,
 SecurityDelay varchar,
 LateAircraftDelay varchar )
WITH (
  OIDS=FALSE
);


CREATE UNLOGGED TABLE rita
(Year varchar,
 Month varchar,
 DayofMonth varchar,
 DayOfWeek varchar,
 DepTime varchar,
 CRSDepTime varchar,
 ArrTime varchar,
 CRSArrTime varchar,
 UniqueCarrier varchar,
 FlightNum varchar,
 TailNum varchar,
 ActualElapsedTime varchar,
 CRSElapsedTime varchar,
 AirTime varchar,
 ArrDelay varchar,
 DepDelay varchar,
 Origin varchar,
 Dest varchar,
 Distance varchar,
 TaxiIn varchar,
 TaxiOut varchar,
 Cancelled varchar,
 CancellationCode varchar,
 Diverted varchar,
 CarrierDelay varchar,
 WeatherDelay varchar,
 NASDelay varchar,
 SecurityDelay varchar,
 LateAircraftDelay varchar );

ALTER TABLE rita
ADD COLUMN flight_date timestamp;

CREATE TRIGGER rita_insert BEFORE INSERT ON rita
FOR EACH ROW EXECUTE PROCEDURE rita_insert();


#Lo siguiente fue configurar postgres para que fuera más pro

CREATE EXTENSION file_fdw;
CREATE SERVER file_sever FOREIGN DATA WRAPPER file_fw;
#esto daba bronca pero bajé quién sabe que complemento con el Application
#Stack Builder, que es parte del postgres para mac y todos felices

CREATE FOREIGN TABLE plane_data
( tailnum varchar,
  type varchar,
  manufacturer varchar,
  issue_date varchar,
  model varchar,
  status varchar,
  aircraft_type varchar,
  engine_type varchar,
  year varchar
)
SERVER file_server
OPTIONS (format 'csv', delimiter ',', 
         filename '/Users/PandoraMac/RITA/planelimpio.csv', header 'true', null '');

##############################################################################
#Cosas que hacer para hacer bulk copys a las ritas_años
##############################################################################
#hmmm hay bronca para abrirl el psql automáticamente!!
#/Library/PostgreSQL/9.1/scripts/runpsql.sh; exit

#/Library/PostgreSQL/9.1/bin/psql -h localhost -p 5431 -U postgres bigdata_db

#-h  -p  -d bigdata_db -U postgres -W patapon1 -c "$sql"


#/Library/PostgreSQL/9.1/bin/psql -U postgres bigdata_db -c "\copy dirty_rita from rita_aa with header csv;"

> #split -l 1000000 rita.csv rita_
  >
  > for f in rita_*
  > do
> sql="\copy dirty_rita from $f with header csv;";
> echo $sql
> echo "-------------------------------"
> date
> /Library/PostgreSQL/9.1/bin/psql -U postgres bigdata_db -c "$sql"
> echo "*******************************"
> date
> done
>
  
  
  > #rm rita_*
  >

#BRONCA! pide psswwd en cada paso! sucks
  30.13. The Password File
The file .pgpass in a user's home directory or the file referenced by 
PGPASSFILE can contain passwords to be used if the connection requires a 
password (and no password has been specified otherwise). On Microsoft Windows 
the file is named %APPDATA%\postgresql\pgpass.conf 
(where %APPDATA% refers to the Application Data subdirectory in the user's profile).

This file should contain lines of the following format:
  
  hostname:port:database:username:password

Each of the first four fields can be a literal value, or *, which matches anything. 
The password field from the first line that matches the current connection parameters 
will be used. (Therefore, put more-specific entries first when you are using wildcards.) 
If an entry needs to contain : or \, escape this character with \. A host name of 
localhost matches both TCP (host name localhost) and Unix domain socket (pghost empty 
or the default socket directory) connections coming from the local machine.

On Unix systems, the permissions on .pgpass must disallow any access to world or group; 
achieve this by the command chmod 0600 ~/.pgpass. If the permissions are less strict 
than this, the file will be ignored. On Microsoft Windows, it is assumed that the 
file is stored in a directory that is secure, so no special permissions check is made.

#http://www.postgresql.org/docs/8.3/static/libpq-pgpass.html

sudo nano /Library/PostgreSQL/9.1/.pgpass

#agregamos las líneas

chmod 0600 ~/.pgpass

#después de chmodearlo ya no pide psswd! a hevooos


#tarda un hcin....
BEGIN
Time: 44.332 ms
INSERT 0 0
Time: 27804033.159 ms
COMMIT
Time: 13.274 ms

#
##############################################################################
#antes de eso hay que configurar algunas cosas de postgres para que jale mejor.
##############################################################################
#Lo siguiente es mover el archivo:

sudo nano /Library/PostgreSQL/9.2/data/postgresql.conf

con los sig valores:

shared_buffers por lo menos un 1/4 de RAM (estaba en 24MB) (lo puse en 512)
PREVIAMENTE LE PICAS
sudo sysctl -w kern.sysv.shmmax=1073741824
EN TERMINAL PA QUE JALEN LOS 512. CADA QUE UNO REBOOTEE LA COMPU 
NECESITA HACER ESTE DESMADRIN

temp_buffers=16Mb (estaba en 8)
work_mem por lo menos 1Gb (estaba en 1mb)
maintenance_work_mem por lo menos 1Gb (estaba en 16mb)
wal_buffers=16Mb (estaba en -1)
effective_cache_size 3/4 de la RAM disponible... (estaba en 128MB) (lo puse 2GB)
default_statistics_target 1000 (estaba en 100)
autovacuum=off,
vacuum_cost_delay=off

#Además, me tuve que meter a modificar los permisos dentro de postgres 
#9.2/data para que todas las carpetas ls pudiera mover todo el mundo.

##############################################################################
#Crear las mini tablas.
##############################################################################

CREATE TABLE rita_2001 (
CONSTRAINT partition_date_range
CHECK (flight_date =   '2001-01-01'
       AND flight_date < '2001-12-31 23:59:59')
) INHERITS ( rita );

#Crear la función para insertar
-- Function: rita_insert()

-- DROP FUNCTION rita_insert();

CREATE OR REPLACE FUNCTION rita_insert()
RETURNS trigger AS
$BODY$
  BEGIN
CASE WHEN NEW.flight_date < '1989-01-01' 
THEN INSERT INTO rita_1988 VALUES (NEW.*);
WHEN NEW.flight_date < '1990-01-01' 
THEN INSERT INTO rita_1989 VALUES (NEW.*);
WHEN NEW.flight_date < '1991-01-01'
THEN INSERT INTO rita_1990 VALUES (NEW.*);
WHEN NEW.flight_date < '1992-01-01'
THEN INSERT INTO rita_1991 VALUES (NEW.*);
WHEN NEW.flight_date < '1993-01-01'
THEN INSERT INTO rita_1992 VALUES (NEW.*);
WHEN NEW.flight_date < '1994-01-01'
THEN INSERT INTO rita_1993 VALUES (NEW.*);
WHEN NEW.flight_date < '1995-01-01'
THEN INSERT INTO rita_1994 VALUES (NEW.*);
WHEN NEW.flight_date < '1996-01-01'
THEN INSERT INTO rita_1995 VALUES (NEW.*);
WHEN NEW.flight_date < '1997-01-01'
THEN INSERT INTO rita_1996 VALUES (NEW.*);
WHEN NEW.flight_date < '1998-01-01'
THEN INSERT INTO rita_1997 VALUES (NEW.*);
WHEN NEW.flight_date < '1999-01-01'
THEN INSERT INTO rita_1998 VALUES (NEW.*);
WHEN NEW.flight_date < '2000-01-01'
THEN INSERT INTO rita_1999 VALUES (NEW.*);
WHEN NEW.flight_date < '2001-01-01'
THEN INSERT INTO rita_2000 VALUES (NEW.*);
WHEN NEW.flight_date < '2002-01-01'
THEN INSERT INTO rita_2001 VALUES (NEW.*);
WHEN NEW.flight_date < '2003-01-01'
THEN INSERT INTO rita_2002 VALUES (NEW.*);
WHEN NEW.flight_date < '2004-01-01'
THEN INSERT INTO rita_2003 VALUES (NEW.*);
WHEN NEW.flight_date < '2005-01-01'
THEN INSERT INTO rita_2004 VALUES (NEW.*);
WHEN NEW.flight_date < '2006-01-01'
THEN INSERT INTO rita_2005 VALUES (NEW.*);
WHEN NEW.flight_date < '2007-01-01'
THEN INSERT INTO rita_2006 VALUES (NEW.*);
WHEN NEW.flight_date < '2008-01-01'
THEN INSERT INTO rita_2007 VALUES (NEW.*);
WHEN NEW.flight_date < '2009-01-01'
THEN INSERT INTO rita_2008 VALUES (NEW.*);
ELSE
INSERT INTO rita_overflow VALUES (NEW.*);
END CASE;
RETURN NULL;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
COST 100;
ALTER FUNCTION rita_insert()
OWNER TO postgres;

CREATE TRIGGER rita_insert BEFORE INSERT ON rita
FOR EACH ROW EXECUTE PROCEDURE rita_insert();

CREATE EXTENSION file_fdw;  -- Habilitamos la extensión
CREATE SERVER file_server FOREIGN DATA WRAPPER file_fdw;  -- Una formalidad

CREATE FOREIGN TABLE carriers
( Code varchar, Description varchar )
SERVER file_server
OPTIONS (format 'csv', delimiter ',', filename 'carriers.csv', header 'true', null '');

ALTER FOREIGN TABLE carriers OPTIONS ( SET filename '../carriers.csv' ); 

##############################################################################
#LIMPIAR RITA EN POSTGRES
#Sustituir los campos categóricos por valores numéricos en Rita.
##############################################################################
Select * from dirty_rita where year='2001';

#pruebas...
create table prueba....
copy prueba from '/Users/PandoraMac/RITA/2001bueno.csv' with header csv;

#y ahora, a limpiar todo acá en chiquito antes de correrlo en masivo en la dirty_rita original

hay caracteres â...

Pues los cambiamos por ... W

# no jala
select * from prueba where tailnum='\*â';

#hizo algo..
SELECT * from prueba where
'â'::tsquery @@ tailnum::tsvector;

#otro intento
SELECT *
  FROM prueba
WHERE to_tsvector(tailnum) @@ to_tsquery('â');

SELECT *
  FROM prueba
WHERE tailnum LIKE'â';

#A HUEVO
http://www.oreillynet.com/pub/a/databases/2006/02/02/postgresq_regexes.html

SELECT *
  FROM prueba
WHERE tailnum ~*'â';

#Ahora hay que sustituir esas madres por W's
With regexp_replace(subject, pattern, replacement [, flags]) you can replace regex matches in a string. If you omit the flags parameter, the regex is applied case sensitively, and only the first match is replaced. If you set the flags to 'i', the regex is applied case insensitively. The 'g' flag (for "global") causes all regex matches in the string to be replaced. You can combine both flags as 'gi'.

You can use the backreferences \1 through \9 in the replacement text to re-insert the text matched by a capturing group into the regular expression. \& re-inserts the whole regex match. Remember to double up the backslashes in literal strings.

E.g. regexp_replace('subject', '(\w)\w', '\&\1', 'g') returns 'susbjbecet'.
http://www.regular-expressions.info/postgresql.html

Select regexp_replace('â', '\w', 'W', 'g')
from prueba;

Select regexp_replace(tailnum,'â','W','g')
from prueba;

#Salvador: Hacer una primary key para ver cuáles modificamos y entonces hacerle update a la minitabla
#de 2001 y 2002. Sin prmary key no jala
Select year, regexp_replace(tailnum,'â','W','g')
from prueba;

#CRear secuencia y agregarlo en una columna :)

#O qué huevis! lo modificamos por fuera. recordemos que me seguía quedando un garabato sin mover
awk '{gsub("â","W"); print}' 2002bueno.csv > 2002fin.csv 
awk '{gsub("â","W"); print}' 2001bueno.csv > 2001fin.csv 

#Y ahora a subir todo al dirty_rita again
Truncate table dirty_rita;
drop table dirty_rita;


CREATE UNLOGGED TABLE dirty_rita
(Year varchar,
 Month varchar,
 DayofMonth varchar,
 DayOfWeek varchar,
 DepTime varchar,
 CRSDepTime varchar,
 ArrTime varchar,
 CRSArrTime varchar,
 UniqueCarrier varchar,
 FlightNum varchar,
 TailNum varchar,
 ActualElapsedTime varchar,
 CRSElapsedTime varchar,
 AirTime varchar,
 ArrDelay varchar,
 DepDelay varchar,
 Origin varchar,
 Dest varchar,
 Distance varchar,
 TaxiIn varchar,
 TaxiOut varchar,
 Cancelled varchar,
 CancellationCode varchar,
 Diverted varchar,
 CarrierDelay varchar,
 WeatherDelay varchar,
 NASDelay varchar,
 SecurityDelay varchar,
 LateAircraftDelay varchar )
WITH (
  OIDS=FALSE
);

for f in *.bz2; do bunzip2 -k "$f"; done
luego los pegamos en rita2.csv

for f in *.bz2
do 
bunzip2 -k "$f"
header=`head -1 "${f%.*}"`;
awk FNR-1 "${f%.*}" >> rita.csv && rm "${f%.*}"
done
sed -i "1i$header" rita.csv

split -l 1000000 rita.csv rita_
for f in rita_*
do
sql="\copy dirty_rita from $f with header csv;";
echo $sql
echo "-------------------------------"
date
/Library/PostgreSQL/9.1/bin/psql -U postgres bigdata_db -c "$sql"
echo "*******************************"
date
done


#hecho, ya trepé dirty_rita
##############################################################################
#ahora, a copiar dirty_rita a rita ya limpio
#código rifadísimo de liz
##############################################################################
insert into rita
(year , month , dayofmonth , dayofweek , deptime , crsdeptime , arrtime , crsarrtime , uniquecarrier , flightnum , tailnum , actualelapsedtime , crselapsedtime , airtime , arrdelay , depdelay , origin , dest , distance , taxiin , taxiout , cancelled , cancellationcode , diverted , carrierdelay , weatherdelay , nasdelay , securitydelay , lateaircraftdelay , flight_date) 
select nullif(btrim(year),'NA')::integer as year,
nullif(btrim(month) ,'NA')::integer as month,
nullif(btrim(dayofmonth),'NA')::integer as dayofmonth,
nullif(btrim(dayofweek) ,'NA')::integer as dayofweek,
nullif(lpad(btrim(deptime),4,'0') ,'00NA')::time as deptime,
nullif(lpad(btrim(crsdeptime),4,'0') ,'00NA')::time as crsdeptime,
nullif(lpad(btrim(arrtime),4,'0'),'00NA')::time as arrtime,
nullif(lpad(btrim(crsarrtime),4,'0') ,'00NA')::time as crsarrtime,
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
nullif(btrim(cancelled),'NA') as cancelled,
nullif(btrim(cancellationcode) ,'NA')::char as cancellationcode,
nullif(btrim(diverted),'NA')::integer as diverted,
nullif(btrim(carrierdelay),'NA')::integer as carrierdelay,
nullif(btrim(weatherdelay),'NA')::integer as weatherdelay,
nullif(btrim(nasdelay),'NA')::integer as nasdelay,
nullif(btrim(securitydelay),'NA')::integer as securitydelay,
nullif(btrim(lateaircraftdelay),'NA')::integer as lateaircraftdelay,
(btrim(year) ||'/'|| btrim(month) ||'/'|| btrim(dayofmonth) ||' '||nullif(lpad(btrim(crsdeptime),4,'0') ,'00NA'))::timestamp as flight_date 
from dirty_rita;

#corrí todo y no funcionó! me fuckin lleva
CREATE TABLE pruebita
(Year varchar,
 Month varchar,
 DayofMonth varchar,
 DayOfWeek varchar,
 DepTime varchar,
 CRSDepTime varchar,
 ArrTime varchar,
 CRSArrTime varchar,
 UniqueCarrier varchar,
 FlightNum varchar,
 TailNum varchar,
 ActualElapsedTime varchar,
 CRSElapsedTime varchar,
 AirTime varchar,
 ArrDelay varchar,
 DepDelay varchar,
 Origin varchar,
 Dest varchar,
 Distance varchar,
 TaxiIn varchar,
 TaxiOut varchar,
 Cancelled varchar,
 CancellationCode varchar,
 Diverted varchar,
 CarrierDelay varchar,
 WeatherDelay varchar,
 NASDelay varchar,
 SecurityDelay varchar,
 LateAircraftDelay varchar )
WITH (
  OIDS=FALSE
);

Insert into pruebita 
Select * from dirty_rita limit 200 

select nullif(btrim(year),'NA')::integer as year,
nullif(btrim(month) ,'NA')::integer as month,
nullif(btrim(dayofmonth),'NA')::integer as dayofmonth,
nullif(btrim(dayofweek) ,'NA')::integer as dayofweek,
nullif(lpad(btrim(deptime),4,'0') ,'00NA')::time as deptime,
nullif(lpad(btrim(crsdeptime),4,'0') ,'00NA')::time as crsdeptime,
nullif(lpad(btrim(arrtime),4,'0'),'00NA')::time as arrtime,
nullif(lpad(btrim(crsarrtime),4,'0') ,'00NA')::time as crsarrtime,
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
nullif(btrim(cancelled),'NA') as cancelled,
nullif(btrim(cancellationcode) ,'NA')::char as cancellationcode,
nullif(btrim(diverted),'NA')::integer as diverted,
nullif(btrim(carrierdelay),'NA')::integer as carrierdelay,
nullif(btrim(weatherdelay),'NA')::integer as weatherdelay,
nullif(btrim(nasdelay),'NA')::integer as nasdelay,
nullif(btrim(securitydelay),'NA')::integer as securitydelay,
nullif(btrim(lateaircraftdelay),'NA')::integer as lateaircraftdelay,
(btrim(year) ||'/'|| btrim(month) ||'/'|| btrim(dayofmonth) ||' '||nullif(lpad(btrim(crsdeptime),4,'0') ,'00NA'))::timestamp as flight_date 
from pruebita;

#lo pusimos en una tabla de mentiras apra ver qué hace el query feliz

#brtim... hmmmm

#nel, nel, parece que ya funciona!
#tardará siglos. 00:45 start time

liz:
  Para limpiarlo hay que poner hacer el siguiente query (usando el comando btrim y asignando a cada columna el tipo que le toca)....

insert into rita (campo1, campo2, ... campon)
select btrim(year)::integer, btrim(...., (year ||'/'|| month ||'/'|| day) as flight_date
from dirty_rita

hay que usar la tabla de airport y de carriers para obtener unos campos haciendo join de 
                                   dirty.origen=airport.origen, 
haciéndoles btrim antes. 

Nos dijo adolfo que hicieramos un select con pocos datos antes de hacer el insert para ver que saca el query. Y además que usemos el comando splane para ver que proceso ejecuta postgres.

Esto es lo que anoté pero por obvias razones todavía no lo he hecho..... jijii

Suerte!!!

##############################################################################
#Clase del 27-feb

##############################################################################
psql:
\h create index

#la query anterior de liz truena
insert into rita
(year , month , dayofmonth , dayofweek , deptime , crsdeptime , arrtime , crsarrtime , uniquecarrier , flightnum , tailnum , actualelapsedtime , crselapsedtime , airtime , arrdelay , depdelay , origin , dest , distance , taxiin , taxiout , cancelled , cancellationcode , diverted , carrierdelay , weatherdelay , nasdelay , securitydelay , lateaircraftdelay , flight_date) 
select nullif(btrim(year),'NA')::integer as year,
nullif(btrim(month) ,'NA')::integer as month,
nullif(btrim(dayofmonth),'NA')::integer as dayofmonth,
nullif(btrim(dayofweek) ,'NA')::integer as dayofweek,
nullif(lpad(btrim(deptime),4,'0') ,'00NA')::time as deptime,
nullif(lpad(btrim(crsdeptime),4,'0') ,'00NA')::time as crsdeptime,
nullif(lpad(btrim(arrtime),4,'0'),'00NA')::time as arrtime,
nullif(lpad(btrim(crsarrtime),4,'0') ,'00NA')::time as crsarrtime,
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
nullif(btrim(cancelled),'NA') as cancelled,
nullif(btrim(cancellationcode) ,'NA')::char as cancellationcode,
nullif(btrim(diverted),'NA')::integer as diverted,
nullif(btrim(carrierdelay),'NA')::integer as carrierdelay,
nullif(btrim(weatherdelay),'NA')::integer as weatherdelay,
nullif(btrim(nasdelay),'NA')::integer as nasdelay,
nullif(btrim(securitydelay),'NA')::integer as securitydelay,
nullif(btrim(lateaircraftdelay),'NA')::integer as lateaircraftdelay,
(btrim(year) ||'/'|| btrim(month) ||'/'|| btrim(dayofmonth) ||' '||nullif(lpad(btrim(crsdeptime),4,'0') ,'00NA'))::timestamp as flight_date 
from dirty_rita;

#esto truena con las fechas...


insert into rita
(year , month , dayofmonth , dayofweek , deptime , crsdeptime , arrtime , crsarrtime , 
 uniquecarrier , flightnum , tailnum , actualelapsedtime , crselapsedtime , airtime , 
 arrdelay , depdelay , origin , dest , distance , taxiin , taxiout , cancelled , 
 cancellationcode , diverted , carrierdelay , weatherdelay , nasdelay , securitydelay , 
 lateaircraftdelay , flight_date) 
select nullif(btrim(year),'NA')::integer as year,
nullif(btrim(month) ,'NA')::integer as month,
nullif(btrim(dayofmonth),'NA')::integer as dayofmonth,
nullif(btrim(dayofweek) ,'NA')::integer as dayofweek,
nullif(lpad( case when btrim(deptime) > '2400' then '0000'
            when substring(btrim(deptime),length(btrim(deptime))-1,length(btrim(deptime))) > '59' 
            then substring(btrim(deptime),1,length(btrim(deptime))-2)
            else btrim(deptime) end,4,'0') ,'00NA')::time as deptime,
nullif(lpad( case when btrim(crsdeptime)  > '2400' then '0000' 
            when substring(btrim(crsdeptime),length(btrim(crsdeptime))-1,length(btrim(crsdeptime))) > '59' 
            then substring(btrim(crsdeptime),1,length(btrim(crsdeptime))-2) else 
              btrim(crsdeptime) end ,4,'0') ,'00NA')::time as crsdeptime,
nullif(lpad( case when btrim(arrtime)  > '2400' then '0000' 
            when substring(btrim(arrtime),length(btrim(arrtime))-1,length(btrim(arrtime))) > '59' 
            then substring(btrim(arrtime),1,length(btrim(arrtime))-2) else 
              btrim(arrtime) end,4,'0'),'00NA')::time as arrtime,
nullif(lpad( case when btrim(crsarrtime)  > '2400' then '0000' 
            when substring(btrim(crsarrtime),length(btrim(crsarrtime))-1,length(btrim(crsarrtime))) > '59' 
            then substring(btrim(crsarrtime),1,length(btrim(crsarrtime))-2) else 
              btrim(crsarrtime) end,4,'0') ,'00NA')::time as crsarrtime,
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
nullif(btrim(distance),'NA')::numeric(10,2) as distance,
nullif(btrim(taxiin) ,'NA')::integer as taxiin,
nullif(btrim(taxiout),'NA')::integer as taxiout,
nullif(btrim(cancelled),'NA') as cancelled,
nullif(btrim(cancellationcode) ,'NA')::char as cancellationcode,
nullif(btrim(diverted),'NA')::integer as diverted,
nullif(btrim(carrierdelay),'NA')::integer as carrierdelay,
nullif(btrim(weatherdelay),'NA')::integer as weatherdelay,
nullif(btrim(nasdelay),'NA')::integer as nasdelay,
nullif(btrim(securitydelay),'NA')::integer as securitydelay,
nullif(btrim(lateaircraftdelay),'NA')::integer as lateaircraftdelay,
(btrim(year) ||'/'|| btrim(month) ||'/'|| btrim(dayofmonth) ||' '||
  nullif(lpad(case when btrim(crsdeptime)> '2400' then '0000' 
              when substring(btrim(crsdeptime),length(btrim(crsdeptime))-1,length(btrim(crsdeptime))) > '59' 
              then substring(btrim(crsdeptime),1,length(btrim(crsdeptime))-2)
              else btrim(crsdeptime) end,4,'0') ,'00NA'))::timestamp as flight_date 
from dirty_rita;
                                   
                                   
#tools, server status para ver qué está haciendo el servidor.
#podemos hacer scripts de sql!!!
# \i archivo_sql 
#aunq todo se hace juntito! si algo truena, rollback masivo

#erick tenía broncas con su base! así que le exportamos el dirty_rita
# pg_dump -h localhost -U postgres -F p -t dirty_rita -v -f "archivoparaerick.sql" bigdata_db
p es plano! hay opcion a binario y más cositas
                                
                                   
agregarle un id serial a rita!!!
hacemos un archivo. 
para que no borre los archivos que truenan...
psql "djfosifj"  && rm "el achivo que sí usó"
                                   
                                   
##############################################################################
#PAra crear el script de sql
##############################################################################
\timing
\x
para que muestre bonito el código
\i crea_rita.sql

drop table if exist table rita cascade;
el casacade manda todo a la chingada! todas las tablitas que hereda!



create table rita (
 id bigserial;
 ....
 );
create table rita_1998

                                   
esto creando un crea_crita.sql que se corre
                                   
\timing
\x
\i /Users/PandoraMac/Documents/crea_rita.sql
                                   

# coalesce (btrim(year), 1988)  otra opción para lidiar con nulos
# las horas están mal, hay que remplazar con regexp y hacer case de eso
 nullif(btrim(year),'NA')::integer
los que sean de horas...
                   
nullif(lpad( case when btrim(deptime) > '2400' then '0000'
            when substring(btrim(deptime),length(btrim(deptime))-1,length(btrim(deptime))) > '59' 
            then substring(btrim(deptime),1,length(btrim(deptime))-2)
            else btrim(deptime) end,4,'0') ,'00NA')::time as deptime,
                                   
                                   
crear índices!! para todas la scolumnas que queremos. solo los q y
                                   usareamos pa los ejercicios
base relacional no creo hrto índice!!!
búsquedas de ands=> crear índices juntos apra las cosas
PARA CADA TABLiTA  HAY QUE CREAR INDICES! no para RITA pero sí para las hijitas.
los´indices no se heredan                                   
 Create index for nombre variables bigdata_db
                                   
 
 chance los índices en otro script o ponerle algo de begin y comit
 
 al final vacuum analyze!!!
   
   autovacumm ponerle 0 o bien ponerle off

returning clause al final de inserte, update, delete.
podemos sacar estadísticas de los campos que inserté!!!
o mandar a otra table a los que borre!!!
 


CREATE OR REPLACE FUNCTION rita_insert()
RETURNS trigger AS
$BODY$
 BEGIN
CASE WHEN NEW.flight_date < '1988-01-01' 
THEN INSERT INTO rita_1987 VALUES (NEW.*);
WHEN NEW.flight_date < '1989-01-01' 
THEN INSERT INTO rita_1988 VALUES (NEW.*);
WHEN NEW.flight_date < '1990-01-01' 
THEN INSERT INTO rita_1989 VALUES (NEW.*);
WHEN NEW.flight_date < '1991-01-01'
THEN INSERT INTO rita_1990 VALUES (NEW.*);
WHEN NEW.flight_date < '1992-01-01'
THEN INSERT INTO rita_1991 VALUES (NEW.*);
WHEN NEW.flight_date < '1993-01-01'
THEN INSERT INTO rita_1992 VALUES (NEW.*);
WHEN NEW.flight_date < '1994-01-01'
THEN INSERT INTO rita_1993 VALUES (NEW.*);
WHEN NEW.flight_date < '1995-01-01'
THEN INSERT INTO rita_1994 VALUES (NEW.*);
WHEN NEW.flight_date < '1996-01-01'
THEN INSERT INTO rita_1995 VALUES (NEW.*);
WHEN NEW.flight_date < '1997-01-01'
THEN INSERT INTO rita_1996 VALUES (NEW.*);
WHEN NEW.flight_date < '1998-01-01'
THEN INSERT INTO rita_1997 VALUES (NEW.*);
WHEN NEW.flight_date < '1999-01-01'
THEN INSERT INTO rita_1998 VALUES (NEW.*);
WHEN NEW.flight_date < '2000-01-01'
THEN INSERT INTO rita_1999 VALUES (NEW.*);
WHEN NEW.flight_date < '2001-01-01'
THEN INSERT INTO rita_2000 VALUES (NEW.*);
WHEN NEW.flight_date < '2002-01-01'
THEN INSERT INTO rita_2001 VALUES (NEW.*);
WHEN NEW.flight_date < '2003-01-01'
THEN INSERT INTO rita_2002 VALUES (NEW.*);
WHEN NEW.flight_date < '2004-01-01'
THEN INSERT INTO rita_2003 VALUES (NEW.*);
WHEN NEW.flight_date < '2005-01-01'
THEN INSERT INTO rita_2004 VALUES (NEW.*);
WHEN NEW.flight_date < '2006-01-01'
THEN INSERT INTO rita_2005 VALUES (NEW.*);
WHEN NEW.flight_date < '2007-01-01'
THEN INSERT INTO rita_2006 VALUES (NEW.*);
WHEN NEW.flight_date < '2008-01-01'
THEN INSERT INTO rita_2007 VALUES (NEW.*);
WHEN NEW.flight_date < '2009-01-01'
THEN INSERT INTO rita_2008 VALUES (NEW.*);
ELSE
INSERT INTO rita_overflow VALUES (NEW.*);
END CASE;
RETURN NULL;
END;
$BODY$
 LANGUAGE plpgsql VOLATILE
COST 100;
ALTER FUNCTION rita_insert()
OWNER TO postgres;



(btrim(year) ||'/'|| btrim(month) ||'/'|| btrim(dayofmonth) ||' '||
  nullif(lpad(case when btrim(crsdeptime)> '2359' then '0000' 
              when substring(btrim(crsdeptime),length(btrim(crsdeptime))-1,length(btrim(crsdeptime))) > '59' 
              then substring(btrim(crsdeptime),1,length(btrim(crsdeptime))-2)
              else btrim(crsdeptime) end,4,'0') ,'00NA'))::timestamp as flight_date 
from dirty_rita;
                                   
#nos matamos! no se puede uno conectar al server!!                                   
http://stackoverflow.com/questions/12472988/postgres-could-not-connect-to-server-no-such-file-or-directory        


Truncate table rita;
drop table rita;


CREATE UNLOGGED TABLE dirty_rita
(Year varchar,
Month varchar,
DayofMonth varchar,
DayOfWeek varchar,
DepTime varchar,
CRSDepTime varchar,
ArrTime varchar,
CRSArrTime varchar,
UniqueCarrier varchar,
FlightNum varchar,
TailNum varchar,
ActualElapsedTime varchar,
CRSElapsedTime varchar,
AirTime varchar,
ArrDelay varchar,
DepDelay varchar,
Origin varchar,
Dest varchar,
Distance varchar,
TaxiIn varchar,
TaxiOut varchar,
Cancelled varchar,
CancellationCode varchar,
Diverted varchar,
CarrierDelay varchar,
WeatherDelay varchar,
NASDelay varchar,
SecurityDelay varchar,
LateAircraftDelay varchar )
WITH (
OIDS=FALSE
);


CREATE UNLOGGED TABLE rita
(Year varchar,
Month varchar,
DayofMonth varchar,
DayOfWeek varchar,
DepTime varchar,
CRSDepTime varchar,
ArrTime varchar,
CRSArrTime varchar,
UniqueCarrier varchar,
FlightNum varchar,
TailNum varchar,
ActualElapsedTime varchar,
CRSElapsedTime varchar,
AirTime varchar,
ArrDelay varchar,
DepDelay varchar,
Origin varchar,
Dest varchar,
Distance varchar,
TaxiIn varchar,
TaxiOut varchar,
Cancelled varchar,
CancellationCode varchar,
Diverted varchar,
CarrierDelay varchar,
WeatherDelay varchar,
NASDelay varchar,
SecurityDelay varchar,
LateAircraftDelay varchar );

ALTER TABLE rita
ADD COLUMN flight_date timestamp;



CREAR TRIGGER 
CREATE TRIGGER rita_insert BEFORE INSERT ON rita
FOR EACH ROW EXECUTE PROCEDURE rita_insert();


CREATE EXTENSION file_fwd;
CREATE SERVER file_sever FOREIGN DATA WRAPPER file_fw;

CREATE FOREIGN TABLE planes_data
( tailnum varchar,
type varchar,
manufacturer varchar,
issue_date varchar,
model varchar,
status varchar,
aircraft_type varchar,
engine_type varchar,
year varchar
)
SERVER file_server
OPTIONS (format 'csv', delimiter ',', 
    filename '/Users/PandoraMac/RITA/2005 a 2008, airports, carriers y planes/plane_data.csv', header 'true', null '');

CREATE FOREIGN TABLE plane_data
( tailnum varchar,
type varchar,
manufacturer varchar,
issue_date varchar,
model varchar,
status varchar,
aircraft_type varchar,
engine_type varchar,
year varchar
)
SERVER file_server
OPTIONS (format 'csv', delimiter ',', 
    filename '/Users/PandoraMac/RITA/planelimpio.csv', header 'true', null '');

##############################################################################                                   
#Losiguiente es crear índices para responder estas preguntar. estan en crea_indices.sql
##############################################################################
En la base de datos: RITA
¿Primer vuelo de cada aerolínea? ¿Primer vuelo de cada avión? (uniquecarrier) (tailnum) (flight_data)
¿Vuelos fantasmas? (Por favor pregúnten que es un vuelo fantasma)  (dest)
¿Promedio de retraso por avión, por mes, por año? (month) (year)
¿Los vuelos mas largos tienen más retrasos? (distance) (carrierdelay) (weatherdelay)(nasdelay) (securitydelay) (lateaircraftdelay)
¿Cuál aerolínea tiene más kilómetros, más vuelos, más destinos? 
¿Km por aerolínea, ciudad, y diferencia respecto al promedio de km? (origin)
¿Cómo podrían identificar un hub? 
Número de retrasos por aerolína, ¿Quién es la que más se retrasa? (row_num, rank, ...) (carrier)
Días con retraso ¿Qué días?¿Qué horas? (dayofweek) 
¿Hay un número de vuelo de mala suerte?¿De avión? (flightnum)
Distancia recorrida por carrier ¿Tiempo de vuelo? 
¿Cómo obtener accidentes?  
                                   
CREATE INDEX
Description: define a new index
Syntax:
                                     
 CREATE [ UNIQUE ] INDEX [ CONCURRENTLY ] [ name ] ON table [ USING method ]
( { column | ( expression ) } [ COLLATE collation ] [ opclass ] [ ASC | DESC ] [ NULLS { FIRST | LAST } ] [, ...] )
[ WITH ( storage_parameter = value [, ... ] ) ]
[ TABLESPACE tablespace ]
[ WHERE predicate ];
                                   
                                   
En R modo fácil de crear las queries
#variable="uniquecarrier"
anios<-"1987":"2008";
fin<-substr(anios,star=3,stop=4)
                                   
creasindex<-function(variable,anios,fin){                                   
    primero<-paste("CREATE INDEX ",variable,sep="")
    uno<-paste(primero,fin,sep="")
    dos<-paste(uno," ON rita_")
    tres<-paste(dos,anios,sep="")
    cuatro<-paste(tres," (",variable,"); ",sep="")
    cinco<-paste(cuatro,collapse="")
    return (cinco)
    }
creasindex("uniquecarrier",anios,fin)
creasindex("tailnum",anios,fin)
creasindex("month",anios,fin)
creasindex("year",anios,fin)
creasindex("origin",anios,fin)
creasindex("dayofweek",anios,fin)
creasindex("deptime",anios,fin)
creasindex("flightnum",anios,fin)
creasindex("flight_date",anios,fin)
creasindex("distance",anios,fin)
creasindex("carrierdelay",anios,fin)
creasindex("weatherdelay",anios,fin)
creasindex("nasdelay",anios,fin)
creasindex("securitydelay",anios,fin)
creasindex("lateaircraftdelay",anios,fin)
creasindex("dayofmonth",anios,fin)
creasindex("crsdeptime",anios,fin)                                   
creasindex("arrtime",anios,fin)  
creasindex("crsarrtime",anios,fin)  
creasindex("actualelapsedtime",anios,fin)  
creasindex("crselapsedtime",anios,fin)
creasindex("airtime",anios,fin)
creasindex("arrdelay",anios,fin)
creasindex("depdelay",anios,fin)
creasindex("dest",anios,fin)
creasindex("taxiin",anios,fin)
creasindex("taxiout",anios,fin)
creasindex("cancelled",anios,fin)
creasindex("cancellationcode",anios,fin)
creasindex("diverted",anios,fin)
creasindex("id",anios,fin)
                                   
dropindex<-function(variable,anios,fin){                                   
 primero<-paste("DROP INDEX ",variable,sep="")
 uno<-paste(primero,fin,sep="")
 #dos<-paste(uno," ON rita_")
 #tres<-paste(uno,anios,sep="")
 cuatro<-paste(uno,"; ",sep="")
 cinco<-paste(cuatro,collapse="")
 return (cinco)
}           
                                   
                                   
#Pues 13-marzo cambié de lugar todo el tablespace al disco de un tera porque no cabe nada en el otro.
http://www.postgresql.org/message-id/14078.1156300499@sss.pgh.pa.us
#PAra ello hubo que mover el tablespace. Copié la carpeta: /Volumes/PanBigData/bigdata_disk/PG_9.2_201204301/16397
#En /Library/PostgreSQL/9.2/data/pg_tblspace había un shortcut al disco duro anterior
#así que cree uno nuevo, tbn llamado 16396 que diera hacia el disco nuevo:
#Esto se corre estando en pg_tblspace para que ahí cree el link  que apunte al disco. :')
ln -s /Volumes/PanBigData/bigdata_disk ./16396

#ahora sí tengo chingos de espacio y puedo crear millones de índices forever                                   
                                   
#17 de marzo: haciendo la tarea vi que tardaba mucho y casi me mato. así que vi
#que no había cambiado los settings de postgres. pero los moví y otra vez me impidio
#conectarme al servidor maldito... tras muchos intentos, acá esta la historia

So I don't know if you guys have been messing around with the postgresql.conf 
file... I have. It turns out that I had modified the shared_buffers parameter 
into a bigger quantity that my kernel allows. How did I know this? I actually 
logged on as my PostgreSQL user when rebooting my computer.

I was trying to restart the server from my usual user:
```
/Library/PostgreSQL/9.2/bin/pg_ctl start -U postgres -D /Library/PostgreSQL/9.2/data
```
but I got this:
``
$ 2013-03-17 05:55:16 CST FATAL:
data directory "/Library/PostgreSQL/9.2/data" has wrong ownership
2013-03-17 05:55:16 CST HINT:  The server must be started by the user
that owns the data directory.
```
I tried several "sudo su postgres" stuff but nothing worked, so I rebooted, logged on to my PostgreSQL session and over there tried the same but got a permission error:
```
Permissions should be u=rwx (0700).
````
So, chmod:
```
chmod 700 "/Library/PostgreSQL/9.2/data"
```
And then again
````
/Library/PostgreSQL/9.2/bin/pg_ctl start -U postgres -D /Library/PostgreSQL/9.2/data
````
Which gave me:
```
postgres$ 2013-03-17 06:01:02 CST FATAL:
could not create shared memory segment: Invalid argument
2013-03-17 06:01:02 CST DETAIL:  Failed system call was
shmget(key=5432001, size=572522496, 03600).
2013-03-17 06:01:02 CST HINT:  This error usually means that
PostgreSQL's request for a shared memory segment exceeded your
kernel's SHMMAX parameter.  You can either reduce the request size or
reconfigure the kernel with larger SHMMAX.  To reduce the request size
(currently 572522496 bytes), reduce PostgreSQL's shared memory usage,
perhaps by reducing shared_buffers or max_connections.
If the request size is already small, it's possible that it is less
than your kernel's SHMMIN parameter, in which case raising the request
size or reconfiguring SHMMIN is called for.
The PostgreSQL documentation contains more information about shared
memory configuration.
````
So, I undid my shared_buffer changes in the postgresql.conf file, restarted 
the server and everything ran smoothly again. I guess this may be not the 
usual case for you, guys, but the thing was that I couldn't know what was wrong 
until I actually logged on to my PostgreSQL user.