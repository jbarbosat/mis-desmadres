#!/usr/bin/python
# -*- coding: utf-8 -*-

# 21-ene-2014

# OJO: Necesito ver si esto jala 

# Dada una búsqueda, se recuperan conjuntos de noticias de Alertnet, by Reuters, de más reciente a más viejo
# Hay 12 noticias que tienen todos los atributos en cada búsqueda y otras noticias que son related items
# No se puede filtrar por fecha (salvo 1,3,7 days ago) ni permite hacer búsquedas exactas o excluir términos.
# Estábamos filtrando por país y recuperando todos los resultados pero eran muy pocos así que matamos el filtro

# run reuters.py -b "climate change science"

# Notitas:
# - Aquí no se puede buscar por mes; no hay filtros de fecha. 
# - Tampoco parece haber chance de hacer búsquedas exactas ni de filtrar cosas que no queremos
# - Hay noticias y reportes de las organizaciones. Se puede filtrar x organización. So far no estoy filtrando x organización.
# - Queremos sólo recuperar artículos? So far eso estoy haciendo
# - A diferencia de google news, acá no se repiten noticias
# - Aquí no hay abstract
# - Qué es mejor: Escribir poquito y echarlo a archivo? O concatenar lo de toda la búsqueda y mandarlo?
# so far tengo concatenado lo de toda la búsqueda pero no hay bronca con cambiarlo
# - Hay unas noticias raras que sólo tienen título y que, presumiblemente, son del mismo autor (Reuters)
# que otras noticias que las contienen... So far las estoy ignorando. Salen como related items...

# Cambios:
# - Quitamos el país como filtro
# ----------------------------------------------------------------------------------------
# - Ojo! A diferencia de google news, aquí no hay filtro de fecha
# - Las direcciones cambiaban % por %25. Solución: urllib.unquote
# http://stackoverflow.com/questions/1695183/how-to-percent-encode-url-parameters-in-python
# - Modo de instanciar el browser
# http://stockrt.github.io/p/emulating-a-browser-in-python-with-mechanize/
# - Segmentation fault:11, por culpa de un big en el parser default de BeautifulSoup
# https://bugs.launchpad.net/beautifulsoup/+bug/1026381

#IN: 
# - Un archivo separado por pipes con mes0, mes1, dia0, dia1, year0, year1, busqueda_si, busqueda_no, busqueda_exacta
# aunque ahorita lo estoy metiendo a mano

#OUT: 
# Timestamp.out; un archivo separado por pipes. 
# En la primera línea hay: fecha0|fecha1|busqueda|hits|link de la query a google news
# Para cada noticia, fecha | url | periódico | titulo | country

##########################################################################################

#Necesitan bajarse...
import urllib
import mechanize
from bs4 import BeautifulSoup
#import hadoopy
import html5lib
#Ya vienen en ubuntu
import re
import codecs
import datetime
# from sets import Set
from time import sleep
from random import randint
import os
# Manejo de parámetros desde la línea de comandos
import argparse

# import sys

# # Constantes para colores
# OKBLUE = '\033[34m'
# OKGREEN = '\033[32m'
# WARNING = '\033[33m'
# FAIL = '\033[31m'
# ENDC = '\033[0m'

# # Coloritos para imprimir mensajes
# def message(msg):
#     return OKBLUE + msg + ENDC

# def warning(msg):
#     return WARNING + msg + ENDC

# def fatal(msg):
#     return FAIL + msg + ENDC

# def update_progress(progress, total):
# # for n in range(1, num_of_surveys):
# 	# acción
# 	# update_progress(n, num_of_surveys)
#     amtDone = float(progress)/float(total)
#     sys.stdout.write('\r[{0:50s}] {1:.1f}%'.format("#" * int(amtDone*50), amtDone*100))

##########################################################################################

def create_browser():
	br = mechanize.Browser()
	br.set_handle_robots(False)
	br.addheaders = [('User-agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.101  Safari/537.36')]
	
	return br


def make_query(busqueda_si,num):
# "Humanitarian worker" death. Hoja 1 de resultados. Ordenados por fecha; de lo más nuevo a lo más viejo. Artículos (tbn hay videos)
# http://www.trust.org/search/?page=2&q=humanitarian+worker+death&f_type=article&f_country=syria&sbd=1
# http://www.trust.org/search/
# ?page=2
# &q=humanitarian+worker+death
# &f_type=article
# &f_country=syria # QUITMAOS ESTO
# &sbd=1

	base = "http://www.trust.org/search/?page=" + str(num)
	si = "&q=" + busqueda_si.replace(" ","+")
	tipodocs = "&f_type=article"
	#filtro_pais = "&f_country=" + pais
	ordena_fecha = "&sbd=1" #para ordenar de lo más reciente a lo más viejo

	query = base + si + tipodocs + ordena_fecha
	#print query
	return query


def get_page(query,br):
# # Y si se muere el internet? Y si google se pone punk?
# 	print "Recuperando html de la página."
# 	intentos = 0
# 	max_intentos = 3
# 	while intentos<max_intentos:
# 		try:
# 			htmltext = br.open(query).read()
# 			print "Conexión exitosa."
# 			break
# 		except Exception as e:
# 				intentos = intentos + 1
# 				n = randint(MIN_SLEEPTIME, MAX_SLEEPTIME) # Número aleatorio entre MIN_SLEEPTIME y MAX_SLEEPTIME
# 				print "Falló la conexión, intentando de nuevo en %s segs." % str(n)
# 				sleep(n)
				
# 	if intentos == max_intentos:
# 		htmltext = ""
# 		print "Número de intentos excedido, omitiendo la búsqueda: " + query
# 		f = codecs.open ('fails.err', 'a','utf-8')
# 		f.write("".join(query).decode('utf-8'))
# 		f.write("\n")
# 		f.close()

	# Guardé un ejemplo del html que lee, para hacer pruebas

	# f = open('texto.html','w')
	# f.write(htmltext)
	# f.close()

	f = open('texto.html')
	htmltext = f.read()
	f.close()
	
	#ojo! hay un bug en el parser que usa default! sin 'html.parser', muere
	soup = BeautifulSoup(htmltext,'html5lib')
	#'html.parser' sirve en mac pero no en la compu de amazon, así que lo cambiamos a html5lib, q tbn jaa en mac) 
	# print soup
	# Si sale un empty array aquí, es q no esta encontrando nada y entonces la query esta mal
	return soup

##########################################################################################

def get_all_news(soup):
	news_box = soup.findAll('ul',attrs={'class':'standard-content-list search-results-content-listing'})
	if len(news_box)>0:
		news_list = news_box[0].findAll('li')
	else:
		news_list=[]
	#print len(news_list)
	return news_list


def get_links(source_text):
#<a href="http://www.trust.org/item/20131205155947-j8k9b/?source=search">Syria top priority for ICRC in 2014 despite limited access</a>
# Los links que no salieron de la búsqueda; los que son related items no tienen ?source=search al final! 
	r_links = "href=\".*\""
	pattern_links = re.compile(r_links)
	source_url = re.findall(pattern_links,str(source_text))[0].replace('href=','').replace('\"','')
	#print source_url
	# if len(source_url)>0:
	# 	previo = urllib.unquote(str(source_url[0].replace("href=\"","").replace("\" ","")))
	# 	links_array.append(re.sub('&amp;.*', '',previo)) #algunos links tienen esta mugrita; lo matamos
	# else:
	# 	links_array.append('NA')

	#print source_url
	return source_url


def get_titles(source_text):
#<a href="http://www.trust.org/item/20131205155947-j8k9b/?source=search">Syria top priority for ICRC in 2014 despite limited access</a>
	title = re.sub('<[^<]+?>', '',str(source_text)).replace('	','').replace('\n','')
	#hay que quitarle tabs y enters a los titulines

	#print title
	return title


def get_sources(source_text):
# <span>By Reuters | Thu, 5 Dec 2013 16:14</span>
# Hay otras sources que se ven así:
#<span>By<a href="/profile/?id=003D000001HjLJYIA3">Karrie Kehoe</a> | Thu, 5 Dec 2013 16:14</span>

	if len(source_text)>0:
		sin_divs = re.sub('<[^<]+?>', '',str(source_text[0]))
		sin_by = re.sub('By ','',str(sin_divs))
		source = re.sub(' \|.*','',sin_by) # ojo: los pipes se escapan...
	else:
		source = 'NA'

	#print source
	return source


def get_dates(source_text):
	# <span>By Reuters | Thu, 5 Dec 2013 16:14</span>
	
	if len(source_text)>0:
		pre_date = re.sub('<span>By.*\| .*, ','',str(source_text[0])) #estoy matando el día de la semana y dejando la hora... 
		date = re.sub('</span>','',pre_date) #ojo: los pipes se escapan...
	else:
		date = 'NA'

	#print date
	return date


def get_themes(source_text):
# <a href="/search/?q=&amp;f_theme=hum-war">
# <img alt="hum-war" src="http://d24pg1nxua23qm.cloudfront.net/application/assets/images/category-tabs/hum-war.png"/></a>
	
	if len(source_text)>1:
		pre_theme = re.findall('<img alt=\".*\" src=\"',str(source_text[1]))
		if len(pre_theme)>0: 
			theme = str(pre_theme[0]).replace('<img alt=\"','').replace('\" src=\"','')
		else:
			theme = 'NA'
	else:
		theme = 'NA'

	#print theme
	return theme
# Temas (nada garantiza que sean todos): 
# hum-war : war and conflict
# hum-dis : health and diseases
# hum-nat : natural disasters
# hum-peo : vulnerable people
# hum-ref : refugees and displacement
# hum-aid : aid and developement
# cli-wea : extreme weather
# hum-hun : food and hunger
# wom-rig : women's rights
# hum-rig : human rights
# cli-ada : adapting to climate change
# cli-sec : climate security
# cor-gov : corruption and governance
# med-dev : media developement
# hum-wat : water and sanitation
# cli-cli : climate change general
# cli-pol : climate politics
# cli-ene : climate energy
# cli-for : forests
# cli-fin : climate finance
# cli-ino : climate technology

def get_hits(soup):
# El número de hits que regresa es un entero

	hits_div = soup.findAll('div',attrs={'class':'total'})
	#hits0 = str(hits_secs[0]).replace("<div id=\"resultStats\">","").replace("<nobr> ","").replace(" </nobr></div>","")
	#hits1 = re.sub(' \([^<]+?\)','',hits0)
	pre_hits = str(hits_div[0]).replace("<div class=\"total\">", "").replace("</div>","")
	hits = re.sub('update.*found', '',pre_hits) #Para matar update y updates
	# print hits + "resultados"
	return int(hits)


def get_texto(br, links_array):
# Para guardar el texto de las noticias
	
	for url in links_array:
		texto = get_page(url,br)
		f = codecs.open (url.replace(':',' ').replace('/','|'), 'a','utf-8')
		f.write("".join(str(texto)).decode('utf-8'))
		f.close()

##########################################################################################

def write_1st_line(archivo,primeralinea):
	f = codecs.open (archivo, 'a','utf-8')
	f.write("".join(primeralinea).decode('utf-8'))
	f.close()


def write_to_file(archivo,links_array,titles_array,sources_array,dates_array,themes_array):
# Para estofar los resultados, quitar repetidos y escribirlos en un archivo.
	#resultados = []		

	f = codecs.open (archivo, 'a','utf-8')

	for i in range(len(titles_array)):
		previo = str(dates_array[i])+"|"+ str(links_array[i]) +"|"+ str(titles_array[i])+"|"+ str(sources_array[i])+"|"+ str(themes_array[i]) +"\n"
		#print previo
		f.write("".join(previo).decode('utf-8'))
		#resultados.append(previo)

	#f = codecs.open (archivo, 'a','utf-8')
	# primeralinea = fecha0+"|"+fecha1+"|"+palabras2+"|"+hits+"|"+query+"\n"
	#f.write("".join(primeralinea).decode('utf-8'))
	# for line in Set(resultados): #Para quitar resultados repetidos
	# #for line in resultados:
	# 	f.write("".join(line).decode('utf-8'))
	# f.close()

	#f.write("".join(resultados).decode('utf-8'))
	f.close()

	print "Escrito a archivo."


# def write_to_file(hdfs_path,todo_array,dates_array,links_array,nwspp_array,titles_array,abstracts_array):
# # Para estofar los resultados en HDFS
# 	resultados = []		

# 	for i in range(len(titles_array)):
# 		previo = str(dates_array[i]+"|"+ links_array[i]+"|"+nwspp_array[i] +"|"+ titles_array[i]+"|"+ abstracts_array[i]) #+"\n")
# 		todo_array = todo_array + [(str(i),previo)]

# 	print todo_array
# 	hadoopy.writetb(hdfs_path,todo_array)
	
# 	print "Done en Hadoopy"


##########################################################################################

if __name__ == '__main__':
# Defino qué voy a buscar. Esto lo saco de algún archivo que estoy suponiendo separado por pipes
# y lo paso como argumentos de la consola a este programa

	# busqueda_si = "humanitarian worker death"
	# pais = "afghanistan"

	parser = argparse.ArgumentParser(description='')

	# parser.add_argument('-m0', '--mes0', help='Mes, sin ceros antes, desde el que queremos buscar', required=True)
	# parser.add_argument('-m1', '--mes1', help='Mes, sin ceros antes, hasta el que queremos buscar', required=True)
	# parser.add_argument('-d0', '--dia0', help='Dia, sin ceros antes, desde el que queremos buscar', required=True)
	# parser.add_argument('-d1', '--dia1', help='Dia, sin ceros antes, hasta el que queremos buscar', required=True)
	# parser.add_argument('-y0', '--year0', help='Anio, a cuatro digitos, desde el que queremos buscar', required=True)
	# parser.add_argument('-y1', '--year1', help='Anio, a cuatro digitos, hasta el que queremos buscar', required=True)
	parser.add_argument('-b', '--buscasi', help='Palabras que queremos buscar, entre comillas si son + de 1', required=True)
	# parser.add_argument('-e', '--buscaexacta', help='Frase exacta que queremos buscar, entre comillas si son + de 1', required=True)
# parser.add_argument('-p', '--pais', help='País del cual queremos noticias, en inglés y minúsuculas', required=True)


	args = parser.parse_args()

	busqueda_si = str(args.buscasi)
	# pais = str(args.pais)


	# Constantes "cool behaviour"
	MIN_NAPTIME = 10
	MAX_NAPTIME = 20 # Máximo tiempo de dormir
	MIN_SLEEPTIME = 50 # Tiempo para dormir luego de error de conexión
	MAX_SLEEPTIME = 60


	# Cuánto tiempo nos toma el scrapping?
	start_time = datetime.datetime.now()


	archivo = str(datetime.datetime.now()).replace(" ","_").replace(":","-")+".reuters.out"

	br = create_browser()

	links_array = []
	titles_array = []
	sources_array = []
	dates_array = []
	themes_array = []

	#Vamos a hacer queries hasta que ya no haya resultados	
	print "Búsqueda: "+busqueda_si#" COUNTRY "+pais

	num = 1
	query = make_query(busqueda_si,num)
	print query+"\n"
	
	# primeralinea = str(busqueda_si+" COUNTRY "+pais+"|"+query+"\n")
	primeralinea = str(busqueda_si+"|"+query+"\n")
	write_1st_line(archivo,primeralinea)


# Mientras nuestra query sí arroje resultados, recuperamos las noticias. 
	
	print "Procesando hoja %s." % str(num)
	soup = get_page(query,br)
	news_list = get_all_news(soup)

	while len(news_list)>0:
		for li in news_list:
			soup2 = BeautifulSoup(str(li))
		# Se obtienen los atributos para cada noticia y se acumulan en un array	
			links_n_titles_div = soup2.findAll('a') 
			links_array.append(get_links(links_n_titles_div[0]))
			titles_array.append(get_titles(links_n_titles_div[0]))
			themes_array.append(get_themes(links_n_titles_div)) #es una lista de longitud 1 o 2

			sources_n_dates_div = soup2.findAll('span')
			sources_array.append(get_sources(sources_n_dates_div))
			dates_array.append(get_dates(sources_n_dates_div))

		
		# print "Recuperando texto de las noticas."
		# get_texto(br,links_array)

		# print "Se obtuvo el texto de %s noticias." % str(len(dates_array))

		n = randint(MIN_NAPTIME, MAX_NAPTIME) # Número aleatorio entre MIN y MAX_NAPTIME
		#self.logger.debug("Dormiré %s segundos..." % str(n))
		print "Dormiré %s segundos..." % str(n)
		sleep(n)
		#self.logger.debug("OK, continuemos")
		print "OK, continuemos\n"
		#response = self.session.open(url)
		#soup = BeautifulSoup(response.read())
		#self.logger.debug(soup)

				
		# Mandamos a archivo lo que obtuvimos en esta iteración del while
		write_to_file(archivo,links_array,titles_array,sources_array,dates_array,themes_array)	
		print "Tiempo de ejecución hasta esta iteración: %s" % (str(datetime.datetime.now() - start_time))

		#Buscamos más noticias
		num = num + 1
		print "Procesando hoja %s." % str(num)
		query = make_query(busqueda_si,num)
		soup = get_page(query,br)
		news_list = get_all_news(soup)

		#Vaciamos los arreglos para la siguiente iteración
		links_array = []
		titles_array = []
		sources_array = []
		dates_array = []
		themes_array = []

	print "Tiempo de ejecución total: %s" % (str(datetime.datetime.now() - start_time))

	print "\""+archivo+"\""

# "Search Google with Python Tutorial" en http://www.youtube.com/watch?v=NcrEClpu8b8

