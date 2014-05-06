#!/usr/bin/bash
# coding:utf-8

# 23.nov.2013
# Bash para Convertir la música m4a de diego a mp3 y ponerla en carpetas Artista/Album/canciones
# Tal que cuando se importen a itunes se conserven estas propiedades. Notamos que si se trataba
# de archivos m4a, a pesar de que la estructura de carpetas en que estaban contenidos fuera correcta,
# a itunes le valía madre y no lo pelaba. ffmpeg es un coso que convierte los archivos. sólo estoy corriendo
# el ejecutable sin compilarlo ni nada porque no me pareció que valiera la pena. 
# Las carpetas están nombradas Artista - Album, aunque a veces falta el album, en cuyo caso estamos 
# haciendo que album = Unknown. Hubo tbn que quitar el espacio que está al final de artista y el que está
# al inicio de album para que las carpetas fueran nombradas correctamente.
# En /Users/PandoraMac/Documents/Esperimento/ están las carpetas originales y se mueven a 
# /Users/PandoraMac/Documents/Musica Movida/artista/album
# El ffmpeg está en /Users/PandoraMac/Downloads. 
# Eran 10GB de música y tardó como 12 horas. HAbía unos videos de mago de oz colados del mal.

# Esto no es un ejecutable; lo estoy copiando y pegando en la consola de mac, ha.
# TBn podríamos mejorar el cambiar las rutas de los archivos por strings que pudieran modificarse.

for folder in *
do
 artista=$(echo $folder | cut -d "-" -f 1)
 album=$(echo $folder | cut -d "-" -f 2)
 echo "-----------"
 echo $folder
 echo "-----------"
 if [ "$album" == "" ]
 then
  album=" Unknown"
 fi
 cd "$folder"
 for cancion in *.m4a
 do 
  if [ "$cancion" != "*.m4a" ]
  then
   echo "BANDERA"
   cd /Users/PandoraMac/Downloads
   ./ffmpeg -i "/Users/PandoraMac/Documents/Esperimento/$folder/$cancion" -acodec libmp3lame -ab 320k "/Users/PandoraMac/Documents/Esperimento/$folder/${cancion%.m4a}.mp3"
   cd ..
   cd "/Users/PandoraMac/Documents/Esperimento/$folder"
  fi
 done
 for cancion in *.mp3
 do
  if [ "$cancion" != "*.mp3" ]
  then
   long=`expr ${#artista} - 1`
   mkdir -pv "/Users/PandoraMac/Documents/MusicaMovida/${artista:0:long}/${album:1}"
   mv -v "/Users/PandoraMac/Documents/Esperimento/$folder/$cancion" "/Users/PandoraMac/Documents/MusicaMovida/${artista:0:long}/${album:1}"
  fi
 done
 cd ..
done