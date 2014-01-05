#!/usr/bin/python
# -*- coding: utf-8 -*-

#06-dic-2013
#Para monitorear diario mi saldo en telcel

#04-enero-2014
#Tronaba si no hay saldo de regalo pero ya lo corregí.
#Tbn alargué el tiempo de dormir.

import sys
import os
from datetime import datetime

# Manejo de conexiones y parseo de HTML
import requests
import bs4
from bs4 import BeautifulSoup
import cookielib
import urllib
import urllib2

# Para ser buen ciudadano digital
from time import sleep
from random import randint, shuffle

# Logeo
import logging

# Gestión de archivos YAML
import yaml

from telcel_scrapper import TelcelScrapper



def get_parameters():
    yaml_file = open('parametros.yaml')
    params = yaml.load(yaml_file)
    yaml_file.close()

    return params


def make_logger():
#Pirateado tal cual del código de adolfo
    now = datetime.now().strftime("%Y%m%d_%H%M")
    # Creamos un logger
    logger = logging.getLogger('scrap_telcel')
    logger.setLevel(logging.DEBUG)
    # Creamos un handler a archivo
    fh = logging.FileHandler(os.path.relpath('../logs/'+'credito_'+now+'.log'))
    fh.setLevel(logging.INFO)
    # Creamos un handler a la Consola
    ch = logging.StreamHandler()
    ch.setLevel(logging.DEBUG)
    # Formateador
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    fh.setFormatter(formatter)
    ch.setFormatter(formatter)
    # agregamos los handlers
    logger.addHandler(fh)
    logger.addHandler(ch)

    return logger


def login(numero, password):
    # http://stackoverflow.com/questions/2910221/how-can-i-login-to-a-website-with-python
    url = 'https://www.mitelcel.com/mitelcel/login/auth'
    values = {'j_username' : numero, 'j_password' : password}

    data = urllib.urlencode(values)
    cookies = cookielib.CookieJar()

    opener = urllib2.build_opener(
        urllib2.HTTPRedirectHandler(),
        urllib2.HTTPHandler(debuglevel=0),
        urllib2.HTTPSHandler(debuglevel=0),
        urllib2.HTTPCookieProcessor(cookies))

    cosa = opener.open(url,data)

    return opener



if __name__ == '__main__':
    logger = make_logger()

    # Abrimos el yaml
    telcel = get_parameters()

    logger.info("Obteniendo saldo para el número %s" % (telcel["numero"]))
    
    # Necesitamos loggearnos una vez a la página principal y luego, con las cookies, 
    # ya podemos tener acceso a la info de la cuenta
    cosa = login(telcel["numero"], telcel["password"])

    t = TelcelScrapper(logger=logger, session=cosa, archivo=str(os.path.relpath('../datos.out')))
    t.obten_saldo()

    logger.info("Concluido a las %s" % str(datetime.now()))


