#!/usr/bin/python
# -*- coding: utf-8 -*-

# 6-dic-2013
# clase TelcelScrapper

from datetime import datetime

# Manejo de conexiones y parseo de HTML
import bs4
from bs4 import BeautifulSoup

# Para ser buen ciudadano digital
from time import sleep
from random import randint, shuffle

# Escribir a archivo
import codecs

class TelcelScrapper():

    # Constantes "cool behaviour"
    MIN_NAPTIME = 10
    MAX_NAPTIME = 20 # Máximo tiempo de dormir


    def __init__(self, logger, session, archivo):
        self.logger = logger
        self.session = session
        self.archivo = archivo


    def obten_saldo(self):
    #Esta es la función importante que llama a todas las demás
        self.logger.debug("Iniciando obten_saldo")
        start_time = datetime.now()
        self.logger.info("Empezando scrappeo")

        saldo_url = 'https://www.mitelcel.com/mitelcel/micuenta/saldo'
        cuadrito = self.get_div(saldo_url)
        saldo = self.get_saldo(str(cuadrito))
        
        self.escribe_archivo(saldo)

        self.logger.debug("Info guardada")
        self.logger.info("Tiempo de ejecución: %s" % (str(datetime.now() - start_time)))


    def make_soup(self, url):
        n = randint(self.MIN_NAPTIME, self.MAX_NAPTIME) # Número aleatorio entre MIN y MAX_NAPTIME
        self.logger.debug("Dormiré %s segundos..." % str(n))
        sleep(n)
        self.logger.debug("OK, continuemos")
        response = self.session.open(url)
        soup = BeautifulSoup(response.read())
        self.logger.debug(soup)

        return soup


    def get_div(self,saldo_url):
        soup = self.make_soup(saldo_url)
        cuadrito = soup.findAll('div',attrs={'class':'plan-box first'}) #sólo hay uno
        
        return cuadrito[0]


    def get_saldo(self, texto_div):
        soup2 = BeautifulSoup(texto_div)
        renglones = soup2.findAll('tr')
        amigo = renglones[1].findAll('strong')[0]
        regalo = renglones[2].findAll('strong')[0]
        
        return  'fecha: '+str(datetime.now())+ ', amigo: '+str(amigo).replace('<strong>','').replace('\n','').replace('</strong>','').replace('  ','')+', regalo: '+str(regalo).replace('<strong>','').replace('\n','').replace('</strong>','').replace('  ','')+"\n"


    def escribe_archivo(self,credito):
        f = codecs.open (self.archivo, 'a','utf-8')
        f.write("".join(credito).decode('utf-8'))
        f.close()


  