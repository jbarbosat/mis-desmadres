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

# Para ser buen ciudadano digital
from time import sleep
from random import randint, shuffle

# Escribir a archivo
import codecs

# Regexp
import re

class TelcelScrapper():

    # Constantes "cool behaviour"
    MIN_NAPTIME = 20
    MAX_NAPTIME = 40 # Máximo tiempo de dormir


    def __init__(self, logger, session, archivo):
        self.logger = logger
        self.session = session
        self.archivo = archivo


    def obten_saldo(self):
    #Esta es la función importante que llama a todas las demás
        self.logger.debug("Iniciando obten_saldo")
        start_time = datetime.now()
        self.logger.info("Empezando scrappeo")

        # #saldo_url = 'https://www.mitelcel.com/mitelcel/micuenta/saldo'
        # welcome_url = 'https://www.mitelcel.com/mitelcel/welcome'
        # response = self.session.open(welcome_url)

        saldo_url = 'https://www.mitelcel.com/mitelcel/saldo/detalle'
        # Hay que dar click en el coso que pide saldo                   
        cuadrito = self.make_soup(saldo_url)
        self.logger.debug("---------HOLA---------")
        self.logger.debug(cuadrito)

        #if len(cuadrito)>0:
        # saldo = self.get_saldo(str(cuadrito))
        # self.escribe_archivo(saldo)
        # if len(saldo)!=0:
        #     self.logger.debug("Info guardada")
        #     self.logger.info("Tiempo de ejecución: %s" % (str(datetime.now() - start_time)))
        # else:
        #    self.logger.debug("No se guardó info. No se conectó bien.")
        #    self.logger.info("Tiempo de ejecución: %s" % (str(datetime.now() - start_time)))


    def make_soup(self, url): 
        #n = randint(self.MIN_NAPTIME, self.MAX_NAPTIME) # Número aleatorio entre MIN y MAX_NAPTIME
        #self.logger.debug("Dormiré %s segundos..." % str(n))
        #sleep(n)
        #self.logger.debug("OK, continuemos")

        # curl 'https://www.mitelcel.com/mitelcel/mitelcel-api-web/api/prepago/saldo/5522161084' -H 'Cookie: JSESSIONID=405F6A8EAE3F5E001B3999B50778AA2B.mt-as3-site-1' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: es-ES,es;q=0.8,en;q=0.6' -H 'Content-Type: application/json' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: https://www.mitelcel.com/mitelcel/saldo/detalle' -H 'X-Requested-With: XMLHttpRequest' --compressed  
        
        # url = 'https://www.mitelcel.com/mitelcel/mitelcel-api-web/api/prepago/saldo/5522161084'
        # values = {'Cookie' : 'JSESSIONID=405F6A8EAE3F5E001B3999B50778AA2B.mt-as3-site-1'}
        # data = urllib.urlencode(values)
        #     cookies = cookielib.CookieJar()

        # opener = urllib2.build_opener(
        #     urllib2.HTTPRedirectHandler(),
        #     urllib2.HTTPHandler(debuglevel=0),
        #     urllib2.HTTPSHandler(debuglevel=0),
        #     urllib2.HTTPCookieProcessor(cookies))

        # cosa = opener.open(url,data)
        # #    

        #self.logger.debug(self.session.cookie)

        response = self.session.open('https://www.mitelcel.com/mitelcel/mitelcel-api-web/api/prepago/saldo/5522161084')
        texto = response.read()

        # Para debuggeo:
        f = codecs.open ('texto.html', 'w','utf-8')
        f.write("".join(texto).decode('utf-8'))
        f.close()
        self.logger.debug(texto)

        self.session.open('https://www.mitelcel.com/mitelcel/logout')

        return texto


    # ## Versión de prueba. Lee un html que se guarda descomentando líneas en el código productivo de make_soup
    # def make_soup(self, url):
    #     n = randint(self.MIN_NAPTIME, self.MAX_NAPTIME) # Número aleatorio entre MIN y MAX_NAPTIME
    #     self.logger.debug("Dormiré %s segundos..." % str(n))
    #     #sleep(n)
    #     self.logger.debug("OK, continuemos")
    #     #response = self.session.open(url)
    #     #texto = response.read()
    #     f = codecs.open ('texto.html', 'r','utf-8')
    #     texto = f.read()
    #     f.close()
    #     soup = BeautifulSoup(texto)
    #     # self.logger.debug(soup)

    #     return soup


    def get_div(self,saldo_url):
        soup = self.make_soup(saldo_url)
        cuadrito = soup.findAll('div',attrs={'id':'box-detalle-saldo-table'}) #sólo hay uno
        self.logger.debug(cuadrito)
        if len(cuadrito)!=0:
            return cuadrito[0]
        else:
            return ''


    def get_saldo(self, texto_div):
        soup2 = BeautifulSoup(texto_div)
        renglones = soup2.findAll('tr')
        #print '-----------'
        if len(renglones)>1:
            # print renglones
            vigencia = renglones[1].findAll('td')[1]
            amigo = renglones[1].findAll('strong')[0]
            if len(renglones)>2:    
                regalo = renglones[2].findAll('strong')[0]
            else:
                regalo = 0
            print 'fecha: '+str(datetime.now())+ ', amigo: '+str(amigo).replace(' ','').replace('\n','').replace('\r','').replace('<strong>','').replace('</strong>','')+', regalo: '+str(regalo).replace(' ','').replace('\n','').replace('\r','').replace('<strong>','').replace('</strong>','')+ ', vigencia: '+str(vigencia).replace(' ','').replace('\n','').replace('\r','').replace('<strong>','').replace('</strong>','').replace('<td>','').replace('</td>','')+"\n"
            return 'fecha: '+str(datetime.now())+ ', amigo: '+str(amigo).replace(' ','').replace('\n','').replace('\r','').replace('<strong>','').replace('</strong>','')+', regalo: '+str(regalo).replace(' ','').replace('\n','').replace('\r','').replace('<strong>','').replace('</strong>','')+ ', vigencia: '+str(vigencia).replace(' ','').replace('\n','').replace('\r','').replace('<strong>','').replace('</strong>','').replace('<td>','').replace('</td>','')+"\n"

        else:
            return ''

    def escribe_archivo(self,credito):
        f = codecs.open (self.archivo, 'a','utf-8')
        f.write("".join(credito).decode('utf-8'))
        f.close()


  