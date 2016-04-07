#!/usr/bin/python
# -*- coding: utf-8 -*-
# 06-dic-2013
# clase TelcelScrapper
# Código para monitorear diario mi saldo en telcel.
# Eventualmente lo pondré en un chron para que corra solo.

# Para correrlo, en ipython:
"""
%load_ext autoreload
%autoreload 1
%aimport telcel_scrapper
#Para mi número
run telcel.py -i parametros.yaml
"""
# Esto para que se vuelva a cargar la clase telcel_scrapper.py
# De otra manera, hay que borrar un archivo .pyc que se
# genera y cerrar la sesión de python

#================================
# Debugging:

# 04-enero-2014
# Tronaba si no hay saldo de regalo pero ya lo corregí.
# Tbn alargué el tiempo de dormir.

# 05-mayo-2014
# Quité \r malditos del texto recuperado antes de escribirlo en output.
# Además, agregué parámetros para poder monitorear más de un número

# 01-junio-2014
# Agregué todos los parámetros en un solo file yaml para correr todo
# una sola vez y otener datos de los números de todo el mundo.
# Los diferentes archivos .out son parte de los parámetros del yaml.

from datetime import datetime

# Manejo de conexiones y parseo de HTML
import bs4
from bs4 import BeautifulSoup

# Manejo de JSONS
import json

# Escribir a archivo
import codecs

# Regexp
import re

class TelcelScrapper():

    def __init__(self, logger, session, archivo, numero):
        self.logger = logger
        self.session = session
        self.archivo = archivo
        self.numero = numero


    def obten_saldo(self):
    #Esta es la función importante que llama a todas las demás
        self.logger.debug("Iniciando obten_saldo")
        start_time = datetime.now()
        self.logger.info("Empezando scrappeo")

        saldo_api = 'https://www.mitelcel.com/mitelcel/mitelcel-api-web/api/prepago/saldo/' + str(self.numero)
        # Hay que dar click en el coso que pide saldo                   
        json_raw = self.get_data(saldo_api)
        #self.logger.debug(json_raw)

        saldo = ''
        if len(json_raw)>0:
            saldo = self.parse_saldo(json_raw)
            self.logger.debug(saldo)
            self.escribe_archivo(saldo)
            if len(saldo)!=0:
                self.logger.debug("Info guardada")
                self.logger.info("Tiempo de ejecución: %s" % (str(datetime.now() - start_time)))
            else:
               self.logger.debug("No se guardó info. No se conectó bien.")
               self.logger.info("Tiempo de ejecución: %s" % (str(datetime.now() - start_time)))


    def get_data(self, api_url): 

        # curl 'https://www.mitelcel.com/mitelcel/mitelcel-api-web/api/prepago/saldo/5522161084' -H 'Cookie: JSESSIONID=405F6A8EAE3F5E001B3999B50778AA2B.mt-as3-site-1' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: es-ES,es;q=0.8,en;q=0.6' -H 'Content-Type: application/json' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: https://www.mitelcel.com/mitelcel/saldo/detalle' -H 'X-Requested-With: XMLHttpRequest' --compressed  
        
        # api_url = 'https://www.mitelcel.com/mitelcel/mitelcel-api-web/api/prepago/saldo/5522161084'

        response = self.session.open(api_url)
        texto = response.read()

        # Para debuggeo:
        f = codecs.open ('texto.html', 'w','utf-8')
        f.write("".join(texto).decode('utf-8'))
        f.close()
        #self.logger.debug(texto)

        # Hay que hacer logout
        self.session.open('https://www.mitelcel.com/mitelcel/logout')

        return texto


    # ## Versión de prueba. Lee un html que se guarda descomentando líneas en el código productivo de get_data
    def get_data(self, api_url): 

        # curl 'https://www.mitelcel.com/mitelcel/mitelcel-api-web/api/prepago/saldo/5522161084' -H 'Cookie: JSESSIONID=405F6A8EAE3F5E001B3999B50778AA2B.mt-as3-site-1' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: es-ES,es;q=0.8,en;q=0.6' -H 'Content-Type: application/json' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: https://www.mitelcel.com/mitelcel/saldo/detalle' -H 'X-Requested-With: XMLHttpRequest' --compressed  
        
        # api_url = 'https://www.mitelcel.com/mitelcel/mitelcel-api-web/api/prepago/saldo/5522161084'

        #response = self.session.open(api_url)
        #texto = response.read()
        # # Para debuggeo:
        # f = codecs.open ('texto.html', 'w','utf-8')
        # f.write("".join(texto).decode('utf-8'))
        # f.close()
        # #self.logger.debug(texto)

        f = codecs.open ('texto.html', 'r','utf-8')
        texto = f.read()
        f.close()

        # Hay que hacer logout
        self.session.open('https://www.mitelcel.com/mitelcel/logout')

        return texto

    def parse_saldo(self, datos_raw):
        if len(datos_raw)>1:
            data = json.loads(datos_raw)['response']['data']['saldos']
            return 'fecha: '+str(datetime.now()) +', ' + \
                str(data[0]['descripcion']).replace('Saldo ','').replace('de ','').lower() +': ' + str(data[0]['cantidad']).replace('$','') + \
                ', ' + str(data[1]['descripcion']).replace('Saldo ','').replace('de ','').lower() +': ' + str(data[1]['cantidad']).replace('$','') + \
                ', ' +'vigencia: ' + str(data[0]['vigencia'])
        else:
            return ''

    def escribe_archivo(self,credito):
        f = codecs.open (self.archivo, 'a','utf-8')
        f.write("".join(credito).decode('utf-8'))
        f.close()


  