#!/usr/bin/python
# -*- coding: utf-8 -*-

# 24-dic-2013

# Bronca: Google news ya no deja filtrar por fecha. Está la opción pero no regresa ni madres.
# Así que ahora vamos a obtener las noticias sin filtro de fecha. Que viven, más o menos en el último mes. 
# pero agregar ese filtro mata noticias...
# Estoy haciendo búsquedas suponiendo que el idioma del navegador está en inglés => fecha: M/D/Y
# Habrá que correr esta madre cada mes para obtener el índice de las noticias.

# run ejemplo5.py -b "granjero vigilancia" -e ""

# Cambios:
# - Agregamos código comentado para el eventual retrieving del texto de las noticias.
# - Cambió la url para buscar mugres...
# - En get_links, con r_links ESTÁBAMOS omitiendo unos links raros que salían sin abstract ni fecha ni nada...
# eran de la forma: <a href="/url?url=http://www.etcetera.com.mx/articulo.php%3Farticulo%3D7891&amp;rct=j&amp;sa=X&amp;ei=KGBLUueZIOjhygHv9IGoAg&amp;ved=0CDQQjQwoBDAA&amp;q=&amp;usg=AFQjCNEphK-pOj209pzcki4LqXx_VVcbgA"
# pero cambió la pág y ya no es cierto.
# - Quité busqueda_no de los argumentos de entrada porque no lo estamos usando.
# - Archivo fails.err que guarda las queries que no se pudieron llevar a cabo por errores de conexión.
# - En lugar de un for, un while para saber cuándo dejar de buscar noticias.

# ----------------------------------------------------------------------------------------
# - Ya no estamos quitando repetidos
# - Pasamos el código a funciones separadas
# - Cuando la dirección es:
# http://www.google.com/search?num=100&pz=1&cf=all&ned=us&hl=en&tbm=nws&gl=us&as_q=mexico%20crisis&as_eq=guerrero&as_occt=any&as_drrb=b&as_mindate=7%2F7%2F2010&as_maxdate=1%2F1%2F2010&tbs=cdr%3A1%2Ccd_min%3A7%2F7%2F2010%2Ccd_max%3A1%2F1%2F2010&authuser=0
# la primera noticia tiene formato distinto; no aparece periódico.
# Pero, dado que estamos buscando así:
# https://www.google.com/search?pz=1&cf=all&ned=us&hl=en&tbm=nws&gl=us&as_q=mexico%20crisis&as_eq=guerrero&as_occt=any&as_drrb=b&as_mindate=7%2F7%2F2010&as_maxdate=1%2F1%2F2010&tbs=cdr%3A1%2Ccd_min%3A7%2F7%2F2010%2Ccd_max%3A1%2F1%2F2010&authuser=0#as_drrb=b&authuser=0&gl=us&hl=en&q=mexico+crisis+-guerrero&start=0&tbm=nws&tbs=cdr:1,cd_min:7/7/2010,cd_max:1/1/2010
# Ya no hay bronca. Todas las noticias tienen periódico.
# - Matamos location; no sirve para nada
# - Los nombres de los archivos ahora tienen timestamp
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
# Para cada noticia, fecha | url | periódico | titulo | abstract

##########################################################################################

#Necesitan bajarse...
import urllib
import mechanize
from bs4 import BeautifulSoup
import html5lib
#Ya vienen en ubuntu
import re
import codecs
import datetime
#from sets import Set
from time import sleep
from random import randint
import requests
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
	br.addheaders = [('User-agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1650.63  Safari/537.36')]

	return br


def make_query(palabras2,num):
# Armamos la query, la mandamos a googlenews y hacemos soup del código de la página

# Y ahora se volvió un desmadre de queries...
	# Query anterior. 04-dic-2013
	# query="https://www.google.com/search?q="+palabras2+"&as_drrb=b&authuser=0&gl=us&hl=en&tbs=cdr:1,cd_min:"+fecha0.replace("%2F","/")+",cd_max:"+fecha1.replace("%2F","/")+"&tbm=nws&ei=RYZtUr7qJcPz2QW15IC4Dw&start="+num+"&sa=N"

	# Query nueva 21-dic-2013, que jala pero no hay resultados
	# https://www.google.com/search?q=mexico+crisis+%22red+cross%22
	# &hl=en&gl=us&as_drrb=b&authuser=0&sa=X&ei=vmS2UvT-NOGp2gWtxoDYBA&ved=0CCEQpwUoBQ&source=lnt
	# &tbs=cdr%3A1%2Ccd_min%3A1%2F1%2F2010%2Ccd_max%3A7%2F1%2F2013
	# &tbm=nws#authuser=0&gl=us&hl=en
	# &q=mexico+crisis+%22red+cross%22
	# &start=0&tbas=0&tbm=nws

	# Otra opción que tbn funciona pero no escupe resultados
	# https://www.google.com/search?q=mexico+crisis+%22red+cross%22
	# &hl=en&gl=us&as_drrb=b&authuser=0&sa=X&ei=vmS2UvT-NOGp2gWtxoDYBA&ved=0CCEQpwUoBQ&source=lnt
	# &tbs=cdr%3A1%2Ccd_min%3A1%2F1%2F2010%2Ccd_max%3A7%2F1%2F2010
	# &start=0&tbas=0&tbm=nws

	# Versión para buscar durante el último mes, que un poco peor que no filtrar nada.
		# https://www.google.com/search?pz=1&cf=all&ned=en_us&hl=en&tbm=nws&gl=us&as_q=mexico%20crisis&as_epq=red%20cross&as_occt=any&as_qdr=m&authuser=0
	# Esa última es la que estamos usando:
		# https://www.google.com/search?q=mexico+%22red+cross%22
		# &hl=es&gl=mx&authuser=0&noj=1&tbm=nws&ei=Pm62UoSTCeWD2gWIlYDwDA
		# &start=0&sa=N&biw=1095&bih=659&dpr=1

	base = "https://www.google.com/search?q=" + palabras2 
	info = "&hl=en&gl=us&authuser=0&noj=1&tbm=nws&ei=Pm62UoSTCeWD2gWIlYDwDA"
	num_pag = "&start=" + str(num) + "&sa=N&biw=1095&bih=659&dpr=1"
	
	query = base + info + num_pag

	print query

	return query



def get_page(query,br):
# Y si se muere el internet? Y si google se pone punk?
	print "Recuperando html de la página."
	intentos = 0
	max_intentos = 3
	while intentos<max_intentos:
		try:
			htmltext = br.open(query).read()
			print "Conexión exitosa."
			break
		except Exception as e:
				intentos = intentos + 1
				n = randint(MIN_SLEEPTIME, MAX_SLEEPTIME) # Número aleatorio entre MIN_SLEEPTIME y MAX_SLEEPTIME
				print "Falló la conexión, intentando de nuevo en %s segs." % str(n)
				sleep(n)
				
	if intentos == max_intentos:
		htmltext = ""
		print "Número de intentos excedido, omitiendo la búsqueda: " + query
		f = codecs.open ('fails.err', 'a','utf-8')
		f.write("".join(query).decode('utf-8'))
		f.write("\n")
		f.close()


	# try:
	# 	r = requests.get(query,verify = False)
	# 	r.encoding=r.apparent_encoding
	# 	htmltext = r.text
	# 	print htmltext
	# except requests.exceptions.Timeout:
	# 	if intentos<3:
	# 		n = randint(MIN_SLEEPTIME, MAX_SLEEPTIME) # Número aleatorio entre MIN_SLEEPTIME y MAX_SLEEPTIME
	# 		print "Falló la conexión, intentando de nuevo en %s segs." % str(n)
	# 		sleep(n)
	# 		get_page(query,br,intentos+1)
	# except requests.exceptions.TooManyRedirects:
	# 	print "bad url"
	# except requests.exceptions.RequestException as e:
	# 	print "400 error something"
	# 	print e


# Guardar un ejemplo del html que lee, for further reference y pruebitas.
	f = open('texto.html','w')
	f.write(htmltext)
	f.close()


#Abrir el html guardado.
	# f = open('texto.html')
	# htmltext = f.read()
	# f.close()
	
#Ojo! hay un bug en el parser que usa default! sin 'html.parser', muere
	soup = BeautifulSoup(str(htmltext), 'html5lib')
	#'html.parser' sirve en mac pero no en la compu de amazon, así que lo cambiamos a html5lib, 
	# q no jala a la perfección en mac, pero ni pex... 
	# Por ejemplo: Greyhound bus to Mexico, to visit - as she 
	# queda parseado como: Greyhound bus to Mexico, to visit â€“ as she 
	
	#print soup
	# Si sale un empty array aquí, es q no esta encontrando nada y entonces la query esta mal o el internet murió

	return soup

##########################################################################################

def get_cursor(soup,cursor_previo):
# el cursor que regresa es un string
	previo = soup.findAll('td',attrs={'class':'cur'})
	if len(previo)>0:
		cursor = re.sub('<[^<]+?>', '', str(previo[0]))
	else:
		cursor = cursor_previo 
		#para que sean iguales viejo y nuevo cursores y ya deje de buscar noticias
	#print cursor
	return cursor


def get_all_news(soup):

	news_list = soup.findAll('li',attrs={'class':'g'})
	#print news_list
	return news_list


def get_links(source_text):
# Expresiones regulares para quitar cosas raras que rodean links
# <a class="l" href="http://www.washingtonpost.com/sf/investigative/2013/12/21/covert-action-in-colombia/" onmousedown="return rwt(this,'','','','1','AFQjCNEsOxph8QfAadW_Q3NcuS0uCn66rQ','','0CCsQqQIoADAA','','',event)">Covert action in Colombia</a>

	r_links = "href=\".*?\" " 
	# The '*', '+', and '?' qualifiers are all greedy; 
	# they match as much text as possible. Sometimes this behaviour isn’t desired; 
	# if the RE <.*> is matched against '<H1>title</H1>', it will match the entire string: '<H1>title</H1>'
	# Adding '?' after the qualifier makes it perform the match in non-greedy or minimal fashion; 
	# as few characters as possible will be matched. Using .*? in the previous expression will match only '<H1>'.
	
	pattern_links = re.compile(r_links)

	links_array = []

	source_url = re.findall(pattern_links,str(source_text))
	#print source_url
	if len(source_url)>0:
		previo = urllib.unquote(str(source_url[0].replace("href=\"","").replace("\" ","")))
		links_array.append(re.sub('&amp;.*', '',previo)) #algunos links tienen esta mugrita; lo matamos
	else:
		links_array.append('NA')

	#print links_array
	return links_array


def get_titles(source_text):
# Expresiones regulares para quitar cosas raras que rodean títulos
# <a class="l" href="http://www.washingtonpost.com/sf/investigative/2013/12/21/covert-action-in-colombia/" onmousedown="return rwt(this,'','','','1','AFQjCNEsOxph8QfAadW_Q3NcuS0uCn66rQ','','0CCsQqQIoADAA','','',event)">Covert action in Colombia</a>
	#r_titles = "\">(.*)</a>" 
	#r_titles = "href=\".*\" " 
	#pattern_titles = re.compile(r_titles)

	titles_array= []

 	#source_title = re.findall(pattern_titles,str(source_text))
	# print source_title

	source_title = re.sub("a class=\"l\" href=\".*\"", '',str(source_text))
	#print source_title
	
	# if len(source_title)>0:
  	#	titles_array.append(source_title[0].replace("<em>","").replace("</em>","").replace("<b>","").replace("</b>","").replace("|",""))
	# else: 
	# 	titles_array.append('NA')

	if len(source_title)>0:
		titles_array.append(re.sub('<[^<]*?>', '',source_title))
		# ojo, esta regexp es distinta de las que quitan cosas como <div> porque tbn quita <>
	else: 
	 	titles_array.append('NA')

	#print titles_array
	return titles_array


def get_nwspp(soup2):

	nwspp_array = []

	# texto2 = soup2.findAll('span',attrs={'class':'f nsa'})
	# #if len(texto2)>2:
	# nwspp_array.append(re.sub('<[^<]+?>', '',str(texto2[0])).replace("|",""))
	
	texto2 = soup2.findAll('span',attrs={'class':'news-source'})
	if len(texto2)>0:
		nwspp_array.append(re.sub('<[^<]+?>', '',str(texto2[0])).replace("|",""))
	else:
		nwspp_array.append("NA")

	#print nwspp_array
	return nwspp_array


def get_dates(soup2):

	dates_array = []
	texto2 = soup2.findAll('span',attrs={'class':'f nsa'})
	if len(texto2)>0:
		dates_array.append(re.sub('<[^<]+?>', '',str(texto2[0])).replace("|",""))
	else:
		dates_array.append("NA")

	#print dates_array
	return dates_array


def get_abstracts(soup):
# Esta cosa recupera los abstracts de todas las noticias a la vez
	abstracts_array = []

	list2 = soup.findAll('div',attrs={'class':'st'})
	for li in list2:
		#li = str(li).replace("<span class=\"f\">",)
	 	abstracts_array.append(re.sub('<[^<]+?>', '',str(li)).replace("|",""))

	#print abstracts_array
	return abstracts_array


def get_hits(soup):
# Esta cosa regresa un string
	hits_secs = soup.findAll('div',attrs={'id':'resultStats'})
	if len(hits_secs)>0:
		hits0 = str(hits_secs[0]).replace("<div id=\"resultStats\">","").replace("<nobr> ","").replace("</nobr></div>","")
		hits1 = re.sub(' \([^<]+?\)','',hits0)
		hits = hits1.replace("About ", "").replace(" results","").replace(",","")
	else:
		hits = "0"

	print hits + " resultados"
	return hits


def get_texto(br, links_array):
# Para guardar el texto de las noticias
	
	for url in links_array:
		texto = get_page(url,br,0)
		f = codecs.open (url.replace(':',' ').replace('/','|'), 'a','utf-8')
		f.write("".join(str(texto)).decode('utf-8'))
		f.close()

##########################################################################################

def write_1st_line(archivo,primeralinea):
	f = codecs.open (archivo, 'a','utf-8')
	f.write("".join(primeralinea).decode('utf-8'))
	f.write("\n")
	f.close()


def write_to_file(archivo,dates_array,links_array,nwspp_array,titles_array,abstracts_array):
# Para estofar los resultados y escribirlos en un archivo.            

	f = codecs.open (archivo, 'a','utf-8')

	for i in range(len(titles_array)):
		previo = str(dates_array[i]+"|"+ links_array[i]+"|"+nwspp_array[i] +"|"+ titles_array[i]+"|"+ abstracts_array[i] +"\n")
		#print previo
		f.write("".join(previo).decode('utf-8'))
	f.close()

	print "Índice escrito a archivo."

# Para estofar los resultados, quitar repetidos y escribirlos en un archivo.
	# resultados = []		

	# for i in range(len(titles_array)):
	# 	previo = str(dates_array[i]+"|"+ links_array[i]+"|"+nwspp_array[i] +"|"+ titles_array[i]+"|"+ abstracts_array[i] +"\n")
	# 	resultados.append(previo)

	# f = codecs.open (archivo, 'a','utf-8')
	# for line in Set(resultados): #Para quitar resultados repetidos
	# 	f.write("".join(line).decode('utf-8'))
	# f.close()

	# print "De ellos, " + str(len(Set(resultados))) + " resultados distintos."


##########################################################################################

if __name__ == '__main__':
# Defino qué voy a buscar. Esto lo saco de algún archivo que estoy suponiendo separado por pipes
# y lo paso como argumentos de la consola a este programa

	# mes0 = '1'
	# mes1 = '7'
	# dia0 = '1'
	# dia1 = '1'
	# year0 = '2010'
	# year1 = '2010'

	# fecha0 = mes0+"%2F"+dia0+"%2F"+year0
	# # fecha1 = mes1+"%2F"+dia1+"%2F"+year1 

	# busqueda_si = "jessica barbosa"
	# # no vale hacer búsqueda_no
	# #busqueda_no = "drogas"
	# #busqueda_no = ""
	# busqueda_exacta = ""
	# #busqueda_exacta = ""

	parser = argparse.ArgumentParser(description='')

	# parser.add_argument('-m0', '--mes0', help='Mes, sin ceros antes, desde el que queremos buscar', required=True)
	# parser.add_argument('-m1', '--mes1', help='Mes, sin ceros antes, hasta el que queremos buscar', required=True)
	# parser.add_argument('-d0', '--dia0', help='Dia, sin ceros antes, desde el que queremos buscar', required=True)
	# parser.add_argument('-d1', '--dia1', help='Dia, sin ceros antes, hasta el que queremos buscar', required=True)
	# parser.add_argument('-y0', '--year0', help='Anio, a cuatro digitos, desde el que queremos buscar', required=True)
	# parser.add_argument('-y1', '--year1', help='Anio, a cuatro digitos, hasta el que queremos buscar', required=True)
	parser.add_argument('-b', '--buscasi', help='Palabras que queremos buscar, entre comillas si son + de 1', required=True)
	parser.add_argument('-e', '--buscaexacta', help='Frase exacta que queremos buscar, entre comillas si son + de 1', required=True)
	#parser.add_argument('-n', '--buscanot', help='Términos que queremos excluir de la búsqueda, entre comillas si son + de 1', required=False)

	args = parser.parse_args()

	busqueda_si = str(args.buscasi)
	busqueda_exacta = str(args.buscaexacta)


	#Hay o no frases exactas que buscar?
	if busqueda_exacta=="":
		palabras2 = busqueda_si.replace(" ","+")#+"+-"+busqueda_no.replace(" ","+-") 
	else:
		palabras2 = busqueda_si.replace(" ","+")+"+%22"+busqueda_exacta.replace(" ","+")+"%22"#+"+-"+busqueda_no.replace(" ","+-") 


	# Constantes "cool behaviour"
	MIN_NAPTIME = 10 # dormir entre queries
	MAX_NAPTIME = 20
	MIN_SLEEPTIME = 50 # Tiempo para dormir luego de error de conexión
	MAX_SLEEPTIME = 60


	# Cuánto tiempo nos toma el scrappeo?
	start_time = datetime.datetime.now()


	archivo = str(datetime.datetime.now()).replace(" ","_").replace(":","-")+".gnews.out"
	#archivo = "/home/ec2-user/tesis/"+str(datetime.datetime.now()).replace(" ","_").replace(":","-")+".gnews.out"

	hits = ""

	br = create_browser()

	links_array = []
	titles_array = []
	nwspp_array = []
	dates_array = []
	abstracts_array = []

	# En qué hoja de resultados vamos, según Goole:
	cursor_anterior = '-1'
	cursor_actual = '0'

	#for i in range(2):#range(45):
	while cursor_anterior != cursor_actual:
		n = randint(MIN_NAPTIME, MAX_NAPTIME) # Número aleatorio entre MIN y MAX_NAPTIME
		print "Dormiré %s segundos antes de empezar..." % str(n)
		sleep(n)

		num = str(int(cursor_actual)*10)
		print "Procesando hoja " + str(cursor_actual) + "."

		query = make_query(palabras2,num)
		soup = get_page(query,br)

		#En qué número de hoja vamos?
		cursor_anterior = cursor_actual
		cursor_actual = get_cursor(soup,cursor_anterior)

		news_list = get_all_news(soup)

		if int(cursor_actual) ==0:
			hits = get_hits(soup)
			primeralinea = str(fecha0+"|"+fecha1+"|"+palabras2+"|"+hits+"|"+query+"\n")
			#print primeralinea
			#todo_array = todo_array + write_1st_line(archivo,primeralinea)
			write_1st_line(archivo,primeralinea)

		for li in news_list:
		# Los atributos se van recuperando por cada noticia, salvo abstracts, y se acumulan en u narray

			soup2 = BeautifulSoup(str(li))
			texto = soup2.findAll('a',attrs={'class':'l'}) 
			source_text = texto[0]
			
			links_array = links_array + get_links(source_text)
			titles_array = titles_array + get_titles(source_text)
			nwspp_array = nwspp_array + get_nwspp(soup2)
			dates_array = dates_array + get_dates(soup2)
		
		abstracts_array = get_abstracts(soup)

		# print "Recuperando texto de las noticas."
		# get_texto(br,links_array)
		# print "Llevamos %s noticias recuperadas.\n" % str(len(dates_array))

		print "Se tienen " + str(len(links_array)) + " resultados encontrados."
		
		# Mandamos a archivo lo que obutivmos en esta iteración del while
		write_to_file(archivo,dates_array,links_array,nwspp_array,titles_array,abstracts_array)	

		print "Tiempo de ejecución hasta esta iteración: %s \n" % (str(datetime.datetime.now() - start_time))

		# Vaciamos arreglos para la sig. iteración
		links_array = []
		titles_array = []
		nwspp_array = []
		dates_array = []
		abstracts_array = []
		
	print "Tiempo de ejecución total: %s" % (str(datetime.datetime.now() - start_time))

	print "\""+archivo+"\""




# "Search Google with Python Tutorial" en http://www.youtube.com/watch?v=NcrEClpu8b8
# pero para google news

