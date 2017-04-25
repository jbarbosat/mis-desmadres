#https://code.google.com/p/rpostgresql/
###################################################################################
#Crear la tabla.
###################################################################################
library(RPostgreSQL)
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, user="postgres",password="patapon1")
#creatabla<-dbGetQuery(con,"
#CREATE TABLE travel
#(
#  id character varying(15),
#  cliente character varying(10),
#  modelo character varying(20),
#  referencia character varying(50),
#  nombre_th character varying(200),
#  importe real,
#  tarjeta character varying(52),
#  bin character varying(10),
#  tipo_tarjeta character varying(20),
#  moneda character varying(3),
#  respuesta_cobro character varying(3),
#  itinerario character varying(70),
#  fecha_vuelo timestamp without time zone,
#  pasajeros character varying(3000),
#  direccion_th character varying(200),
#  colonia_th character varying(100),
#  ciudad_th character varying(30),
#  estado_th character varying(20),
#  cp_th character varying(10),
#  pais_th character varying(50),
#  telefono_th character varying(20),
#  email_th character varying(100),
#  origen character varying(15),
#  customfield3 character varying(250),
#  browsersessionid character varying(255),
#  browserhostname character varying(50),
#  browseraccept character varying(300),
#  browseracceptencoding character varying(50),
#  browseracceptcharset character varying(50),
#  browserid character varying(255),
#  browseridlanguagecode character varying(255),
#  browsercookie character varying(50),
#  browserip character varying(15),
#  browserreferer character varying(1000),
#  browserconnection character varying(50),
#  fecha_transaccion timestamp without time zone,
#  fecha_hora_trx timestamp without time zone,
#  contracargo character varying(10),
#  fecha_contracargo timestamp without time zone,
#  th_es_pasajero boolean,
#  deltatiempo bigint,
#  deltatiempofraude bigint,
#  deltatiemponofraude bigint
#)
#WITH (
#  OIDS=FALSE
#);")
#copiadatos<-dbGetQuery(con,"COPY travel FROM '/Applications/PostgreSQL 9.1/datos_mit.txt' with delimiter '\t';")
#Tarda un buen rato
#Mala idea:
#datostravel<- data.frame(dbGetQuery(con,"SELECT * FROM travel"))


###################################################################################
#Contar observaciones
###################################################################################
n<-fetch(dbSendQuery(con,"select count(distinct(id)) FROM travel"))
# 2677502

###################################################################################
#Cosas que queremos saber de forma exacta
###################################################################################

#Num de fraudes
rs<-dbSendQuery(con, "SELECT contracargo, count(*) FROM travel group by contracargo")
table(fetch(rs,n=-1))
#count
#contracargo  12651   2897904
#NO               0        1
#SI               1        0
#nel!!! le faltan muchas cosas que cargar.. pero el código funciona
#mejor lo hice en postgres directo
dbClearResult(rs)

#Num de tarjetas que cometieron fraude
rs<-dbSendQuery(con, "SELECT count(distinct(tarjeta)) FROM travel WHERE contracargo='SI'")
table(fetch(rs,n=-1))
#7425 
#1 
dbClearResult(rs)


###################################################################################
#ALGUNOS ESTADÍSTICOS
###################################################################################

#CONTRACARGOS
rs<-dbSendQuery(con, "SELECT * FROM travelcontrac LIMIT all;")
dbGetInfo(rs)
muestraCONTRA<-as.data.frame(cbind((fetch(rs,n=-1))))
dbClearResult(rs)

summary(muestraCONTRA)
nrow(muestraCONTRA) #12651
rs<-muestraCONTRA
#Variables que vale la pena ver cuántas hay de cada tipo
indices<-c(3,8,9,10,12,18,20,38,40)
for (i in indices){
  print(summary(rs[i]))
  print(table(rs[,i]))
  #print(names(rs)[i]) 
  #if (any(table(rs[,i])>2))   
  cat("-----------------------------\n")
}

# modelo         
# Length:12651      
# Class :character  
# Mode  :character  
# 
# TRAVEL TRAVEL_CC 
# 4265      8386 
# -----------------------------
#   bin           
# Length:12651      
# Class :character  
# Mode  :character  
# 
# 402318    402766    404360    404903    405306    405930    407458    408244    408245 
# 12         6        25         4       131        51         1        26        38 
# 409851    410177    410180    410181    413406    415231    416502    417849    417967 
# 2         2        34       593         7        23        56         4         2 
# 417968    418080    420199    420713    421316    421364    425981    426513    426807 
# 5        43        15        25       116        13        48         2        16 
# 433454    439120    439185    439187    441311    441541    441545    441549    444449 
# 4        10        23         1         9         9         1         2         1 
# 446118    446351    448790    454057    454069    455255    455500    455503    455504 
# 1         2         3       122       116       198       184        18        34 
# 455505    455507    455508    455509    455510    455511    455513    455514    455515 
# 92        22        19         2         1        13        52        23         1 
# 455525    455526    455527    455529    455540    455545    456880    462974    465828 
# 4         2         2         2       132       303         1         3         8 
# 473701    474175    490176 490176060    491089    491272    491280    491281    491282 
# 20         1         1        13        30         2        29         9        26 
# 491283    491284    491327    491341    491346    491366    491371    491375    491501 
# 159       143         6         3         3        18         1        24        28 
# 491502    491512    491566    491572    491871    491872    493135    493136    493158 
# 73         4         4         8        20         4         7        13        18 
# 493160    493161    493162    493166    493172    493173    494133    494134    494388 
# 9       611       311         2       161       128        19        12         9 
# 494398    512029    512745    512809    517712    517721    518004    518853    518899 
# 1         1        13        70        49         2        61       256       119 
# 520021    520213    520416    520694    520698    522130    522174    522498    525424 
# 42        21        86        16        46         8        37        24        31 
# 525678    528804    528843    528851    528877    529001    529091    530756    537830 
# 47        32       777       298         1       330       228        11        13 
# 539672    540845    541286    541290    542010    542537    544204    544548    544549 
# 1        80        23        40         5        40       122        60        22 
# 544551    545307    545375    547015    547046    547068    547074    547075    547078 
# 1         1        40        99       313         3         3        11         2 
# 547079    547092    547093    547095    547096    547097    547146    547155    547156 
# 6        39        22         1        28         1       464        16         8 
# 547157    547380    547484    548234  54823409    549138    549639    552263    554492 
# 2        31        17       634       275       167         9         2         4 
# 554764    554900    557905    557907    557908    557909    557910    557920    557922 
# 4        79        34        94         2         7        84        16         4 
# 558426      NULL 
# 70      2396 
# -----------------------------
#   tipo_tarjeta      
# Length:12651      
# Class :character  
# Mode  :character  
# 
# C 
# 12651 
# -----------------------------
#   moneda         
# Length:12651      
# Class :character  
# Mode  :character  
# 
# MXN   USD 
# 10257  2394 
# -----------------------------
#   itinerario       
# Length:12651      
# Class :character  
# Mode  :character  
# 
# ACA-TIJ AGU-LAX AGU-TIJ BJX-CUN BJX-TIJ CAQ-PYQ CBV-CQQ CCK-VEV CEQ-MXD CHK-M4D COV-JAV 
# 44       5      43       1     135       2       2       1       1       2       2 
# COV-M4D COV-VEV CQQ-BAT CQQ-MEY CQQ-MFY CQQ-MXD CQQ-PUP CQQ-VEV CQQ-VHT CRT-CQQ CUL-GDL 
# 1       2       1       2       2      32      13      25       6       1      55 
# CUL-MEX CUL-TIJ CUL-TLC CUN-GDL CUN-MEX CUN-PBC CUN-TLC CUU-MEX CVJ-TIJ FAT-GDL GDL-CUL 
# 118     703       3     231     498      62     107      56      18      19      47 
# GDL-CUN GDL-FAT GDL-HMO GDL-LAP GDL-LAS GDL-LAX GDL-MDW GDL-MEX GDL-MXL GDL-OAK GDL-SAN 
# 255      10     102       9      55     248      73     217     256      81      27 
# GDL-SJC GDL-TIJ GDL-TLC HMO-GDL HMO-MEX HMO-TIJ JAV-COV JAV-M4D JAV-MXD JAV-VEV LAP-GDL 
# 55    1142      72     108     295      81       2       2       3       6      26 
# LAP-MEX LAP-TIJ LAS-GDL LAS-MEX LAX-GDL LAX-MEX LAX-MLM LAX-TLC LAX-ZCL LMM-TIJ M2D-HJO 
# 80      81      43       5     188       7      12      12       7      52       2 
# M2D-MIV M2D-PRV M2D-TUH M2D-VEV M4D-COV M4D-JAV M4D-OAO M4D-TAC M4D-VEV M4D-VHT M5D-ZTR 
# 2       6       1       3       1       2       3       2      27       3       1 
# MDW-GDL MEX-CUL MEX-CUN MEX-CUU MEX-GDL MEX-HMO MEX-LAP MEX-LAS MEX-LAX MEX-MDW MEX-MID 
# 57     114     486      66     220     259      40      14      16       6       6 
# MEX-MTY MEX-MXL MEX-OAK MEX-PVR MEX-SAN MEX-SJD MEX-TIJ MEY-CHK MEY-CQQ MEY-M4D MEY-TGC 
# 26     200      15       1      20      56     417       2       1       5       4 
# MEY-VEV MEY-VHT MID-MEX MID-TLC MIV-VEV MLM-LAX MLM-MDW MLM-TIJ MTY-MEX MTY-TIJ MTY-TLC 
# 5       5       7       8       4      36       2     121      28      71     101 
# MXD-AYV MXD-CBV MXD-CQQ MXD-MEY MXD-OAO MXD-PEV MXD-TEP MXD-TST MXD-TXO MXD-VEV MXL-GDL 
# 2       1       6       2       2       2       2       2       7       2     218 
# MXL-MEX MXL-TLC MZT-TIJ    NULL OAK-GDL OAK-MEX OAO-M2D OAO-TLM OAO-VEV OAX-TIJ OZV-AMD 
# 124       3     146       6      56       7       2       1       2      35       1 
# PAH-PUP PBC-CUN PBC-TIJ PRV-M2D PRV-VEV PUP-CQQ PUP-MRO PUP-PHO PUP-VEV PUP-VHT PVR-TIJ 
# 2      55     110       5       4       1       1       1       4       2      41 
# PYQ-MEY PYQ-VEV SAN-GDL SAN-MEX SCO-PUP SCO-VEV SEY-CQQ SJC-GDL SJD-MEX SJD-TIJ TAC-M2D 
# 3       1      12       4       1       1       2      42      38      46       1 
# TAC-M4D TAC-VEV TGC-VEV TGC-VHT THP-COV TIJ-ACA TIJ-AGU TIJ-BJX TIJ-CUL TIJ-CVJ TIJ-GDL 
# 1       1       2       1       2      42      34      78     442      13     865 
# TIJ-HMO TIJ-LAP TIJ-LMM TIJ-MEX TIJ-MLM TIJ-MTY TIJ-MZT TIJ-OAX TIJ-PBC TIJ-PVR TIJ-SJD 
# 95      55      49     455      67      74     120      45      78      42      41 
# TIJ-TLC TIJ-UPN TIJ-ZCL TLC-CUN TLC-GDL TLC-LAX TLC-MID TLC-MTY TLC-MXL TLC-TIJ TLM-CBV 
# 53     113      50      83      70       5       4      68       5      42       1 
# TMA-JAV TMA-M2D TMA-TUH TPV-TUH TXO-MXD UPN-TIJ VEV-CCK VEV-COV VEV-CQQ VEV-CRT VEV-JAV 
# 3       2       2       1       2     110       1       4       6       1       5 
# VEV-M2D VEV-M4D VEV-M5D VEV-MEY VEV-MXD VEV-OAO VEV-OZV VEV-PRV VEV-TLM VEV-TPV VEV-UXC 
# 7      23       2       1       2       2       3       2       1       2       1 
# VEV-VHT VHT-CQQ VHT-MEY VXV-JAV ZCL-LAX ZCL-MDW ZCL-MEX ZCL-TIJ 
# 1       1       2       2       6       1       1      28 
# -----------------------------
#   estado_th        
# Length:12651      
# Class :character  
# Mode  :character  
# 
# D.F.                DF  DISTRITO FEDERAL  Distrito Federal  Estado de Mexico 
# 1                 4                 5                 2                10 
# Guanajuato          Hidalgo         NUEVO LEON              NULL            Oaxaca 
# 2                 2                 2             12314                 1 
# Q ROO      QUINTANA ROO      Quintana Roo           SINALOA        TAMAULIPAS 
# 1                64                 2                 1                 3 
# VERACRUZ          Veracruz           YUCATAN                df  distrito federal 
# 22                 7                 1                28                 8 
# distrito federal   estado de mexico          guerrero           hidalgo           jalisco 
# 5                 6                 2                 2                 4 
# mexico         michoacan        nuevo leon            oaxaca            q roo. 
# 20                 2                 2                 2                 6 
# q. roo             q.roo      quintana roo           sinaloa           tabasco 
# 1                 4                 1                 6                 6 
# veracruz           veracuz          verzcruz           yucatan 
# 91                 1                 2                 8 
# -----------------------------
#   pais_th         
# Length:12651      
# Class :character  
# Mode  :character  
# 
# NULL 
# 12651 
# -----------------------------
#   contracargo       
# Length:12651      
# Class :character  
# Mode  :character  
# 
# SI 
# 12651 
# -----------------------------
#   th_es_pasajero 
# Mode :logical  
# FALSE:10061    
# TRUE :2590     
# NA's :0        
# 
# FALSE  TRUE 
# 10061  2590 
# -----------------------------

#No contracargos
rs<-dbSendQuery(con, "select * FROM travelnocontrac LIMIT all;")
muestraNOCONTRA<-as.data.frame(cbind((fetch(rs,n=-1))))
dbClearResult(rs)

head(muestraNOCONTRA)
rs<-muestraNOCONTRA
#Variables que vale la pena ver cuántas hay de cada tipo
indices<-c(3,8,9,10,12,18,20,38,40)
for (i in indices){
  print(summary(rs[i]))
  print(table(rs[,i]))
  #print(names(rs)[i]) 
  #if (any(table(rs[,i])>2))   
  cat("-----------------------------\n")
}                   
                     
                       
                       
###################################################################################
#Histogramas
###################################################################################

rs<-dbSendQuery(con, "SELECT importe FROM travelcontrac;")
impor<-fetch(rs,n=-1)
muestra<-as.data.frame(cbind((fetch(rs,n=-1)))

hist(rs$importe,breaks=100)
summary(rs$importe)

hist(rs$deltatiempo,breaks=100)
summary(rs$deltatiempo)

hist(rs$deltatiempofraude)
summary(rs$deltatiempofraude)
plot(1:500,rs$deltatiempofraude)

hist(rs$deltatiemponofraude)
summary(rs$deltatiemponofraude)
plot(1:500,rs$deltatiemponofraude)

dbClearResult(rs)


                       
plot(rs$deltatiempofraude[order(rs$deltatiempofraude)],rs$deltatiemponofraude[order(rs$deltatiemponofraude)])

#Outlier raro
(1:500)[rs$deltatiempofraude>(-0.4)]
rs[65,]

dbClearResult(rs)
      
      
      
      
      
######################################################################################

cong1<-hclust(dist(rs,method="centroid"))
#sólo para contínuas

dist(rs,method="canberra")

kmeans(rs,centers=5)

dbClearResult(rs)






dbSendQuery(con,"fetch(travel,n=2)")


#moverle a las tripas de R para que podamos cargar más datos a la memoria.
#order by random limit 500
#partition by para generar nuevas variables. genera subset de los datos de acuerdo
#con tarjeta 
#adolfo.
#DB2 base de datos de IBM
#intersect!!! select * from travel intersect select * from travel
#algebra relacional.
#database system concepts. siberschatz korth sudarshan

#gpg mail para las encriptadas.
#sirve para la mac... 
#true cript para la base en la compu. designas un espacio dnd estan las 
#cosas secretas y copias las cosas. 
#zippear con pswwd 7z y otras cosas.



hay que sustituir fraud net es el puntooo
interfaz no nos toca
mejorable: 
  -AVS no sirve; los registros están mal
  -fingerprint de la compu es importante. van a necesitar contratar otro plug in
si se echan a los de fraud net
  -sacar cosas que decir de la base de datos.
  -














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
#out <- dbApply(rs, INDEX="contracargo", FUN = function(x,grp) summary(x$Data))