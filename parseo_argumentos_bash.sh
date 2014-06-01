#!/bin/bash
# Recuperamos los parámetros de entrada
while [[ $# > 1 ]]
do
key="$1"
shift

case $key in
    -h|--host)
    HOST="$1"
    shift
    ;;
    -p|--port)
    PORT="$1"
    shift
    ;;
    -U|--username)
    USERNAME="$1"
    shift
    ;;
    *)
            # unknown option
    ;;
esac
done
echo Host = "${HOST}"
echo Port = "${PORT}"
echo Username = "${USERNAME}"

echo

SOURCE="${BASH_SOURCE[0]}"
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

echo Ejecutando $SOURCE
echo Carpeta de ejecución $DIR

# echo Creamos el esquema cnpd
# psql -h $HOST -p $PORT -U $USERNAME -d opi -f ../sql/create_schema.sql
echo creamos la tabla poligonos
psql -h $HOST -p $PORT -U $USERNAME -d opi -f ../sql/create_poligonos.sql

echo insertamos a tabla poligonos
for f in ../wgs84/*.shp
do
    echo transformando poligono: $f
    shp2pgsql  -a -W LATIN1 -s 4326 $f cnpd.poligonos > `basename $f .shp`.sql
done

[ -d ../wgs84/sql ] && rm -R ../wgs84/sql

mkdir ../wgs84/sql




for f in *_wgs84.sql
do
   echo instertamos a postgres el poligono $f
   psql -h $HOST -p $PORT -U $USERNAME -d opi -f $f
   mv $f $DIR/../wgs84/sql/
done


## El polígono de Tepito viene con campos de más
sed -i "s/\"nom_pol\",\"campo_1\",\"__oid\",the_geom/\"cve_pol\",\"nom_pol\",\"cve_ent\",\"nom_edo\",\"cve_mun\",\"nom_mun\",\"campo_0\",\"__oid\",the_geom/ " $DIR/../wgs84/sql/DISTRITO_FEDERAL_TEPITO_wgs84.sql

sed -i "s/NULL,NULL/'','Tepito','09','Distrito Federal','09015','Cuauhtémoc',''/ " $DIR/../wgs84/sql/DISTRITO_FEDERAL_TEPITO_wgs84.sql

psql -h $HOST -p $PORT -U $USERNAME -d opi -f $DIR/../wgs84/sql/DISTRITO_FEDERAL_TEPITO_wgs84.sql


## Los polígonos de Zapopan vienen con campos de más

sed -i 's/(\"objectid_1\",/(/' $DIR/../wgs84/sql/*ZAPOPAN*.sql

sed -i 's/\"oid_1\",\"objectid_2\",\"objectid\",\"id\",\"sum_pobtot\",\"sum_vivtot\",\"sum_p_0a25\",\"ave_grapro\",\"nombre\",\"idmpio\",\"identidad\",\"ave_ppobde\",\"ave_ppobsi\",\"shape_leng\",\"shape_le_1\",\"shape_area\",/ /' $DIR/../wgs84/sql/*ZAPOPAN*.sql

sed -i "s/VALUES ('[0-9]\+',/VALUES (/" $DIR/../wgs84/sql/*ZAPOPAN*.sql

sed  -i "s/NULL,\('[0-9.]\+',\)\{8\}'ZAPOPAN',\('[0-9.]\+',\)\{7\}/NULL,/g" $DIR/../wgs84/sql/*ZAPOPAN*.sql

for f in $DIR/../wgs84/sql/*ZAPOPAN*.sql
do
    psql -h $HOST -p $PORT -U $USERNAME -d opi -f $f
done


psql -h $HOST -p $PORT -U $USERNAME -d opi -f $DIR/../sql/fix_poligonos.sql
