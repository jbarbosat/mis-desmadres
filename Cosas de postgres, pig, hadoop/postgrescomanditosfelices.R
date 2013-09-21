#https://code.google.com/p/rpostgresql/
library(RPostgreSQL)
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, user="postgres",password="erick")
creatabla<-dbGetQuery(con,"create table abalones 
(
 id int NOT NULL,
 sex char(1) NOT NULL,
 length float8 NOT NULL,
 diameter float8 NOT NULL,
 height float8 NOT NULL,
 wholeweight float8 NOT NULL,
 shuckedweight float8 NOT NULL,
 visceraweight float8 NOT NULL,
 shellweight float8 NOT NULL,
 rings int NOT NULL,
 CONSTRAINT id primary key(id));")

copiadatos<-dbGetQuery(con,"copy abalones from 'C:/Datos-Prueba/DatosProyecto.csv' with csv header;")

rs <- dbGetQuery(con,"SELECT * FROM abalones")
#para desconectar del servidor
dbDisconnect(con)
dbUnloadDriver(drv)
#para listar las tablas creadas:
dbListTables(con)
#para borrar una tabla creada-abalones-
dbRemoveTable(con,"abalones")



################################################
#fetch(rs,n=2)
#dbSendQuery(con,"COPY abalones from 'C:/Archivos de Programa/PostgreSQL 9.1/abalones.csv' with delimiter ','")
#para copiar todo y no insertar uno x uno con insert.
#ejemplos de queries
#SELECT id, sex, length, diameter, height, wholeweight, shuckedweight, 
#visceraweight, shellweight, rings
#FROM abalones;
#INSERT INTO abalones(
#  id, sex, length, diameter, height, wholeweight, shuckedweight, 
#  visceraweight, shellweight, rings)
#VALUES (?, ?, ?, ?, ?, ?, ?, 
#        ?, ?, ?);
#UPDATE abalones
#SET id=?, sex=?, length=?, diameter=?, height=?, wholeweight=?, shuckedweight=?, 
#visceraweight=?, shellweight=?, rings=?
#WHERE <condition>;
#DELETE FROM abalones
#WHERE <condition>;

#dbClearResult(rs)
