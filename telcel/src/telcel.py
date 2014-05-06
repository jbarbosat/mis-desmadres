#!/usr/bin/python
# -*- coding: utf-8 -*-
# 06-dic-2013
# Código para monitorear diario mi saldo en telcel.
# Eventualmente lo pondré en un chron para que corra solo.

# Para correrlo, en ipython:

# %load_ext autoreload
# %autoreload 1
# %aimport telcel_scrapper
# Para mi número
# run telcel.py -i parametros.yaml -o ../datos.out
# Para el de Diego:
# run telcel.py -i parametrosD.yaml -o ../datosD.out

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

# Parseo de argumentos
import argparse

from telcel_scrapper import TelcelScrapper



def get_parameters(archivo):
    yaml_file = open(archivo)
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
    # Leemos archivo de parámetros y de salida

    parser = argparse.ArgumentParser(description='')

    parser.add_argument('-i', '--input', help='Mes, a dos dígitos, desde el que queremos buscar', required=True)
    parser.add_argument('-o', '--output', help='Mes, a dos dígitos, hasta el que queremos buscar', required=True)
  
    args = parser.parse_args()

    parametros = str(args.input)
    salida = str(args.output)

    # Para guardar logs
    logger = make_logger()

    # Abrimos el yaml
    telcel = get_parameters(parametros)

    logger.info("Obteniendo saldo para el número %s" % (telcel["numero"]))
    
    # Necesitamos loggearnos una vez a la página principal y luego, con las cookies, 
    # ya podemos tener acceso a la info de la cuenta
    cosa = login(telcel["numero"], telcel["password"])

    t = TelcelScrapper(logger=logger, session=cosa, archivo=str(os.path.relpath(salida)))
    t.obten_saldo()

    logger.info("Concluido a las %s" % str(datetime.now()))


