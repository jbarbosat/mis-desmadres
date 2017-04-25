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

# 09-abril-2016
# Mil cambios porque se modificó la estructura del sitio: los datos
# se obtienen vía api, así que hay que parsear menos cosas: armamos
# la petición y cachamos un json que parseamos y guardamos

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
        json_raw = self.get_data(saldo_api,0)
        #self.logger.debug(json_raw)

        saldo = ''
        if len(json_raw)>0:
            saldo = self.parse_saldo(json_raw,'normal')

            self.logger.debug(saldo)
            #self.escribe_archivo(saldo)
            if len(saldo)!=0:
                self.logger.debug("Info de saldo guardada")
                self.logger.info("Tiempo de ejecución: %s" % (str(datetime.now() - start_time)))
            else:
               self.logger.debug("No se guardó info. No se conectó bien.")
               self.logger.info("Tiempo de ejecución: %s" % (str(datetime.now() - start_time)))


        internet_api = 'https://www.mitelcel.com/mitelcel/mitelcel-api-web/api/prepago/internet/consumo/' + str(self.numero)
        json_raw = self.get_data(internet_api,1)
        #self.logger.debug(json_raw)

        internet = ''
        if len(json_raw)>0:
            internet = self.parse_saldo(json_raw,'internet')

            self.logger.debug(internet)
            #self.escribe_archivo(internet)
            if len(internet)!=0:
                self.logger.debug("Info de megas guardada")
                self.logger.info("Tiempo de ejecución: %s" % (str(datetime.now() - start_time)))
            else:
               self.logger.debug("No se guardó info. No se conectó bien.")
               self.logger.info("Tiempo de ejecución: %s" % (str(datetime.now() - start_time)))

        self.escribe_archivo(saldo + ', ' + internet+'\n')



    def get_data(self, api_url,logout): 

        # curl 'https://www.mitelcel.com/mitelcel/mitelcel-api-web/api/prepago/saldo/5522161084' -H 'Cookie: JSESSIONID=405F6A8EAE3F5E001B3999B50778AA2B.mt-as3-site-1' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: es-ES,es;q=0.8,en;q=0.6' -H 'Content-Type: application/json' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: https://www.mitelcel.com/mitelcel/saldo/detalle' -H 'X-Requested-With: XMLHttpRequest' --compressed  
        
        # {"response":{"data":{"saldoAmigo":283.67,"saldoMix":null,"vigencia":"29/07/2016","saldos":[{"descripcion":"Saldo Amigo","vigencia":"29/07/2016","cantidad":"$283.67"}],"fechaConsulta":"06.53 hrs. del 26/07/2016","fechaLimite":null,"insuficiente":false,"expirado":false},"message":{"titulo":"Éxito","descripcion":"Operación exitosa","descripcionSistema":null,"categoria":"TXT","causer":null,"status":null}}}%                                               


        # api_url = 'https://www.mitelcel.com/mitelcel/mitelcel-api-web/api/prepago/saldo/5522161084'

#Request URL:https://www.mitelcel.com/mitelcel/mitelcel-api-web/api/prepago/internet/consumo/5522161084?_=1471897845424
#         # Internet:
#         {
# response: {
# data: [
# {
# totalContratado: 350,
# totalConsumido: 0,
# totalDisponible: 398.16,
# porcentajeConsumo: 0,
# porcentajeConsumoGrafica: 0,
# fechaExpiracion: "16/09/2016",
# horaConsulta: "18:31:52",
# productName: "Paquete Sin Límite 150",
# roamingFlag: 0,
# paqueteExpiradoAgotado: false,
# clave: null,
# whatsapp: false,
# redSocial: false,
# idAnchor: "paqInternet1",
# amigoSinLimite: true
# }
# ],
# message: {
# titulo: "Éxito",
# descripcion: "Operación exitosa",
# descripcionSistema: null,
# categoria: "TXT",
# causer: null,
# status: null
# }
# }
# }
        response = self.session.open(api_url)
        texto = response.read()

        # Para debuggeo:
        f = codecs.open ('texto.html', 'w','utf-8')
        f.write("".join(texto).decode('utf-8'))
        f.close()
        #self.logger.debug(texto)

        # Hay que hacer logout
        if logout == 1:
            self.session.open('https://www.mitelcel.com/mitelcel/logout')

        return texto


    # # ## Versión de prueba. Lee un html que se guarda descomentando líneas en el código productivo de get_data
    # def get_data(self, api_url): 

    #     #response = self.session.open(api_url)
    #     #texto = response.read()
    #     # # Para debuggeo:
    #     # f = codecs.open ('texto.html', 'w','utf-8')
    #     # f.write("".join(texto).decode('utf-8'))
    #     # f.close()
    #     # #self.logger.debug(texto)

    #     f = codecs.open ('texto.html', 'r','utf-8')
    #     texto = f.read()
    #     f.close()

    #     # Hay que hacer logout
    #     self.session.open('https://www.mitelcel.com/mitelcel/logout')

    #     return texto

    def parse_saldo(self, datos_raw,tipo):
        if len(datos_raw)>1:
            if tipo == 'normal':
                self.logger.debug(datos_raw)
                ## Cuando sigue vigente:
                #  {"response":{"data":{"saldoAmigo":283.67,"saldoMix":null,"vigencia":"29/07/2016","saldos":[{"descripcion":"Saldo Amigo","vigencia":"29/07/2016","cantidad":"$283.67"}],"fechaConsulta":"06.58 hrs. del 26/07/2016","fechaLimite":null,"insuficiente":false,"expirado":false},"message":{"titulo":"Éxito","descripcion":"Operación exitosa","descripcionSistema":null,"categoria":"TXT","causer":null,"status":null}}}
                ## Cuando ya expiró:
                #  {"response":{"data":{"saldoAmigo":184.41,"saldoMix":null,"vigencia":"27/09/2016","saldos":[],"fechaConsulta":"04.15 hrs. del 27/09/2016","fechaLimite":"27/09/2017","insuficiente":true,"expirado":true},"message":{"titulo":"Éxito","descripcion":"Operación exitosa","descripcionSistema":null,"categoria":"TXT","causer":null,"status":null}}}


                try:
                    data = json.loads(datos_raw)['response']['data']['saldos']
                except:
                    try: # Si caducó
                        data = [].push(json.loads(datos_raw)['response']['data'])

                    except: # si de plano no cargó o algo así
                        data = []
                
                # self.logger.debug(json.loads(datos_raw)['response']['data']['saldos'])
                # [{u'descripcion': u'Saldo Amigo', u'vigencia': u'29/07/2016', u'cantidad': u'$283.67'}]

                #self.logger.debug(json.loads(datos_raw)['response']['data'])
                # {u'fechaLimite': u'27/09/2017', u'saldoMix': None, u'vigencia': u'27/09/2016', u'expirado': True, u'saldoAmigo': 184.41, u'saldos': [], u'insuficiente': True, u'fechaConsulta': u'04.42 hrs. del 27/09/2016'}
                
                # self.logger.debug(data)

                # Si no hay saldo de regalo, truena.
                if len(data)>1:
                    return 'fecha: '+str(datetime.now()) +', ' + \
                        str(data[0]['descripcion']).replace('Saldo ','').replace('de ','').lower() +': ' + str(data[0]['cantidad']).replace('$','') + \
                        ', ' + str(data[1]['descripcion']).replace('Saldo ','').replace('de ','').lower() +': ' + str(data[1]['cantidad']).replace('$','') + \
                        ', ' +'vigencia: ' + str(data[0]['vigencia']) 
                else:
                    # si ya expiró, truena
                    if len(data)>0:
                        return 'fecha: '+str(datetime.now()) +', ' + \
                            str(data[0]['descripcion']).replace('Saldo ','').replace('de ','').lower() +': ' + str(data[0]['cantidad']).replace('$','') + \
                            ', regalo: 0.00' + \
                            ', ' +'vigencia: ' + str(data[0]['vigencia'])
                    else:
                        return ''
                        # return 'fecha: '+str(datetime.now()) +', ' + \
                        #     'amigo: ' + str(data['saldoAmigo']).replace('$','') + \
                        #     ', regalo: 0.00' + \
                        #     ', ' +'vigencia: ' + str(data['vigencia'])

            else: #tipo == 'internet'
                # self.logger.debug(datos_raw)
                
                ## cuando todavía hay megas:
                #   {"response":{"data":[{"totalContratado":350.0,"totalConsumido":0.0,"totalDisponible":388.86,"porcentajeConsumo":0.0,"porcentajeConsumoGrafica":0.0,"fechaExpiracion":"16/09/2016","horaConsulta":"16:36:21","productName":"Paquete Sin Límite 150","roamingFlag":0,"paqueteExpiradoAgotado":false,"clave":null,"whatsapp":false,"redSocial":false,"idAnchor":"paqInternet1","amigoSinLimite":true}],"message":{"titulo":"Éxito","descripcion":"Operación exitosa","descripcionSistema":null,"categoria":"TXT","causer":null,"status":null}}}
                ## cuando no:
                # {"response":{"data":[],"message":{"titulo":"Éxito","descripcion":"Operación exitosa","descripcionSistema":null,"categoria":"TXT","causer":null,"status":null}}}

                try:
                    data = json.loads(datos_raw)['response']['data']
                except:
                    data = []
                # self.logger.debug(data)
                #  [{u'horaConsulta': u'16:58:05', u'totalDisponible': 388.86, u'totalContratado': 350.0, u'porcentajeConsumo': 0.0, u'redSocial': False, u'productName': u'Paquete Sin L\xedmite 150', u'clave': None, u'fechaExpiracion': u'16/09/2016', u'roamingFlag': 0, u'amigoSinLimite': True, u'whatsapp': False, u'idAnchor': u'paqInternet1', u'totalConsumido': 0.0, u'porcentajeConsumoGrafica': 0.0, u'paqueteExpiradoAgotado': False}]
                
                # Si no hay saldo de internet, truena.
                if len(data)>0:
                    return 'MB consumidos: ' + str(data[0]['totalConsumido']) + \
                        ', ' + 'MB disponibles: ' + str(data[0]['totalDisponible']) + \
                        ', ' + 'vigencia: ' + str(data[0]['fechaExpiracion']) 
                else:
                    return 'MB contratados: 0' + \
                        ', ' + 'MB disponibles: 0'  + \
                        ', ' + 'expirado: True' #+ str(data[0]['paqueteExpiradoAgotado']) 
        else:
            return ''

    def escribe_archivo(self,credito):
        f = codecs.open (self.archivo, 'a','utf-8')
        f.write("".join(credito).decode('utf-8'))
        f.close()


  