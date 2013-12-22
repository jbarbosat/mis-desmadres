#!/usr/bin/python
# -*- coding: utf-8 -*-

# 11-dic-2013
# Dada una búsqueda, se recuperan conjuntos de 20 noticias de ReliefWeb. 

# Notitas:
# - Se puede buscar por mes. Creo que es lo mejor, porque no hay tantísimas noticias, aunque se puede hacer diario
# - Hay noticias y reportes de las organizaciones. Se puede filtrar x organización. Qué queremos?
# - Tbn se puede filtrar por país y por tipo de doc. Yo opino que news y reports funciona.
# - Hay 20 resultados por hoja. Eso nos sirve para ver cuántas veces más buscamos resultados.
# - A diferencia de google news, acá no se repiten noticias y el número de resultados sí es exacto => uso el número para
# ver cuántas hojas de resultados tendré
# - Aquí no hay abstract... Qué onda? guardo todo el html de la noticia? algo así?
# - Qué es mejor: Escribir poquito y echarlo a archivo? O concatenar lo de toda la búsqueda y mandarlo?
# so far tengo concatenado lo de toda la búsqueda pero no hay bronca con cambiarlo
# - Qué onda con los idiomas? Sólo inglés?

# Tbn en Reuters hay filtro para icrc

# Cambios:
# - Hay que buscar por mes
# - Ojo! A diferencia de google news, aquí los meses y días deben tener dos caracteres!
# ----------------------------------------------------------------------------------------
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
#from sets import Set
from time import sleep
from random import randint
import os

def create_browser():
	br = mechanize.Browser()
	br.set_handle_robots(False)
	br.addheaders = [('User-agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.101  Safari/537.36')]
	
	return br


def make_query(year0,fecha0,fecha1,busqueda_si,busqueda_no,busqueda_exacta,num):
#Armamos la query, la mandamos a reliefweb y hacemos soup del código de la página

#Marzo de 2012. "Crisis AND fear NOT dog NOT cat AND "red cross". ICRC. News & situation reports. Inglés.
# http://reliefweb.int/updates?search=&page=0&extended_search=%7B%22entity_name%22%3A%22node_report%22%2C%22text%22%3A%7B%22
# all%22%3A%5B%22crisis%22%2C%22fear%22%5D%2C%22
# exclude%22%3A%5B%22dog%22%2C%22cat%22%5D%2C%22
# exact%22%3A%22red+cross%22%7D%7D
# &f[0]=field_source%3A1048
# &f[1]=field_content_format%3A8
# &f[2]=field_content_format%3A10
# &f[3]=field_report_date%3A%5B2004-01-01T00%3A00%3A00Z%20TO%202005-01-01T00%3A00%3A00Z%5D
# &f[4]=field_report_date%3A%5B2004-03-01T00%3A00%3A00Z%20TO%202004-04-01T00%3A00%3A00Z%5D
# &f[5]=field_language%3A267

	base = "http://reliefweb.int/updates?search=&page="+str(num)+"&extended_search=%7B%22entity_name%22%3A%22node_report%22%2C%22text%22%3A%7B%22"
	si = "all%22%3A%5B%22"+busqueda_si.replace(" ","%22%2C%22")+"%22%5D%2C%22"
	if busqueda_no!="":
		no = "exclude%22%3A%5B%22"+busqueda_no.replace(" ","%22%2C%22")+"%22%5D%2C%22"
	else:
		no = ""
	if busqueda_exacta!="":
		exacta = "exact%22%3A%22"+busqueda_exacta.replace(" ","+")+"%22%7D%7D"
	else:
		exacta = ""
	tipodocs = "&f[0]=field_content_format%3A8&f[1]=field_content_format%3A10"
	anio = "&f[2]=field_report_date%3A%5B"+year0+"-01-01T00%3A00%3A00Z%20TO%20"+str(int(year0)+1)+"-01-01T00%3A00%3A00Z%5D"
	fecha = "&f[3]=field_report_date%3A%5B"+fecha0+"T00%3A00%3A00Z+TO+"+fecha1+"T00%3A00%3A00Z%5D"
	organismo = "&f[4]=field_source%3A1048"
	idioma = "&f[5]=field_language%3A267"

	query = base + si + no + exacta + tipodocs + anio + fecha + organismo + idioma
	#print query
	return query


def get_page(query,br):
	htmltext = br.open(query).read()

	# Guardé un ejemplo del html que lee, para hacer pruebas

	# f = open('texto.html','w')
	# f.write(htmltext)
	# f.close()

	# f = open('texto.html')
	# htmltext = f.read()
	# f.close()
	
	#ojo! hay un bug en el parser que usa default! sin 'html.parser', muere
	soup = BeautifulSoup(htmltext,'html5lib')#'html.parser' sirve en mac pero no en la compu de amazon, así que lo cambiamos a html5lib, q tbn jaa en mac) 
	#print soup
	# Si sale un empty array aquí, es q no esta encontrando nada y entonces la query esta mal

	return soup


def get_all_news(soup):
	news_list = soup.findAll('h1',attrs={'class':'node-title'})
	#print news_list
	return news_list


def get_countries(text):
#<a class="country-slug" href="/country/col">Colombia</a>
	country = re.sub('<[^<]+?>', '',str(text))

	return country


def get_links(source_text):
# <a class="title-link" href="/report/colombia/colombia-everything-set-release-10-held-farc-ep">Colombia: everything set for release of 10 held by FARC-EP</a>
	r_links = "href=\".*\""
	pattern_links = re.compile(r_links)
	source_url = re.findall(pattern_links,str(source_text))[0].replace('href=','').replace('\"','')
	#print source_url
	# if len(source_url)>0:
	# 	previo = urllib.unquote(str(source_url[0].replace("href=\"","").replace("\" ","")))
	# 	links_array.append(re.sub('&amp;.*', '',previo)) #algunos links tienen esta mugrita; lo matamos
	# else:
	# 	links_array.append('NA')

	link = "http://reliefweb.int"+str(source_url)

	return link


def get_titles(source_text):
# <a class="title-link" href="/report/colombia/colombia-everything-set-release-10-held-farc-ep">Colombia: everything set for release of 10 held by FARC-EP</a>
	title = re.sub('<[^<]+?>', '',str(source_text))
#	r_titles = "\">(.*)</a>" 
	# pattern_titles = re.compile(r_titles)

	# titles_array= []

 # 	source_title = re.findall(pattern_titles,str(source_text))
	# # print source_title
	# if len(source_title)>0:
 # 		titles_array.append(source_title[0].replace("<em>","").replace("</em>","").replace("<b>","").replace("</b>","").replace("|",""))
	# else: 
	# 	titles_array.append('NA')

	#print title
	return title


# def get_nwspp(soup2):

# 	nwspp_array = []

# 	texto2 = soup2.findAll('span',attrs={'class':'f nsa'})
# 	#if len(texto2)>2:
# 	nwspp_array.append(re.sub('<[^<]+?>', '',str(texto2[0])).replace("|",""))

# 	return nwspp_array


def get_dates(soup):
	#<div class="submitted"><span class="icon"></span>03 Apr 2012</div>
	dates = []
	texto = soup.findAll('div',attrs={'class':'submitted'})
	for li in texto:
		dates.append(re.sub('<[^<]+?>', '',str(li)))
	#print dates_array
	#print texto
	#print dates

	return dates


# def get_abstracts(soup):

# 	abstracts_array = []

# 	list2 = soup.findAll('div',attrs={'class':'st'})
# 	for li in list2:
# 		#li = str(li).replace("<span class=\"f\">",)
# 	 	abstracts_array.append(re.sub('<[^<]+?>', '',str(li)).replace("|",""))

# 	return abstracts_array


def get_hits(soup):
# El número de hits que regresa es un entero

	hits_div = soup.findAll('div',attrs={'class':'total'})
	#hits0 = str(hits_secs[0]).replace("<div id=\"resultStats\">","").replace("<nobr> ","").replace(" </nobr></div>","")
	#hits1 = re.sub(' \([^<]+?\)','',hits0)
	pre_hits = str(hits_div[0]).replace("<div class=\"total\">", "").replace("</div>","")
	hits = re.sub('update.*found', '',pre_hits) #Para matar update y updates
	print hits + "resultados"
	return int(hits)


def get_texto(br, links_array):
# Para guardar el texto de las noticias
	
	for url in links_array:
		texto = get_page(query,br)
		f = codecs.open ("/home/ec2-user/tesis/"+url.replace(':',' ').replace('/','|'), 'a','utf-8')
		f.write("".join(str(texto)).decode('utf-8'))
		f.close()


def write_1st_line(archivo,primeralinea):
	f = codecs.open (archivo, 'a','utf-8')
	f.write("".join(primeralinea).decode('utf-8'))
	f.close()


# def write_1st_line(hdfs_path,primeralinea):
# 	#hadoopy.writetb(hdfs_path,[('linea1',primeralinea)])
# 	return [('info',primeralinea)]
# 	print "Primera linea impresa"


def write_to_file(archivo,dates_array,links_array,titles_array,countries_array):
# Para estofar los resultados, quitar repetidos y escribirlos en un archivo.
	#resultados = []		

	f = codecs.open (archivo, 'a','utf-8')

	for i in range(len(titles_array)):
		previo = str(dates_array[i])+"|"+ str(links_array[i]) +"|"+ str(titles_array[i])+"|"+ str(countries_array[i]) +"\n"
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
# Defino qué voy a buscar. Esto eventualmente lo sacaré de algún archivo que estoy suponiendo separado por pipes

# f = open('busquedas.pipe')
# busquedas = f.read()
# f.close()

# for line in busquedas:
	# params = line.split("|")
	# mes0 = params[0]
	# mes1 = params[1]
	# dia0 = params[2]
	# dia1 = params[3]
	# year0 = params[4]
	# year1 = params[5]
	# busqueda_si = params[6]
	# busqueda_no = params[7]
	# busqueda_exacta = params[8]

	mes0 = '03'
	mes1 = '04'
	dia0 = '01'
	dia1 = '01'
	year0 = '2012'
	year1 = '2012'

	#fecha0 = mes0+"%2F"+dia0+"%2F"+year0
	#fecha1 = mes1+"%2F"+dia1+"%2F"+year1 

	fecha0 = year0+"-"+mes0+"-"+dia0
	fecha1 = year1+"-"+mes1+"-"+dia1

	busqueda_si = "syria fear"
	busqueda_no = "dog cat"
	busqueda_exacta = "red cross"
	#busqueda_exacta = ""

	#Hay o no frases exactas que buscar?
	# if busqueda_exacta=="":
	# 	palabras2 = busqueda_si.replace(" ","+")+"+-"+busqueda_no.replace(" ","+-") 
	# else:
	# 	palabras2 = busqueda_si.replace(" ","+")+"%22"+busqueda_exacta.replace(" ","+")+"%22+-"+busqueda_no.replace(" ","+-") 

	# Constantes "cool behaviour"
	MIN_NAPTIME = 10
	MAX_NAPTIME = 20 # Máximo tiempo de dormir

	# Cuánto tiempo nos toma el scrappeo?
	start_time = datetime.datetime.now()

	archivo = "/home/ec2-user/tesis/"+str(datetime.datetime.now()).replace(" ","_").replace(":","-")+".reliefweb.out"

	br = create_browser()

	links_array = []
	titles_array = []
	#nwspp_array = []
	dates_array = []
	#abstracts_array = []
	countries_array = []

	#todo_array = []

	# Hacemos la query una vez para ver si hay resultados y cuántos y determinar la longitud del for con eso.
	num = 0
	print "Búsqueda: "+busqueda_si+" NOT "+busqueda_no+" EXACT "+busqueda_exacta
	query = make_query(year0,fecha0,fecha1,busqueda_si,busqueda_no,busqueda_exacta,num)
	print query+"\n"
	soup = get_page(query,br)

	hits = get_hits(soup) #es un int
	primeralinea = str(fecha0+"|"+fecha1+"|"+busqueda_si+" NOT "+busqueda_no+" EXACT "+busqueda_exacta+"|"+str(hits)+"|"+query)#"\n")
	#print primeralinea
	#todo_array = todo_array + write_1st_line(archivo,primeralinea)
	write_1st_line(archivo,primeralinea)

	# Si nuestra query sí arroja resultados, recuperamos las noticias. 
	# Así estamos haciendo dos veces la primera búsqueda, pero ni pex

	if hits>0:
	# Hay 20 resultados por hoja => hits / 20 me da el tamaño del for porque, al dividir enteros, python trunca
		for num in range(hits/20+1):

			print "Procesando hoja %s." % str(num)
			query = make_query(year0,fecha0,fecha1,busqueda_si,busqueda_no,busqueda_exacta,num)
			soup = get_page(query,br)
			news_list = get_all_news(soup)

			for li in news_list:
				soup2 = BeautifulSoup(str(li))
				texto = soup2.findAll('a') 
				#source_text = texto[0]
				
				countries_array.append(get_countries(texto[0]))
				links_array.append(get_links(texto[1]))
				titles_array.append(get_titles(texto[1]))
				#nwspp_array = nwspp_array + get_nwspp(soup2)
				#abstracts_array = abstracts_array + get_abstracts(soup)

			dates_array = dates_array + get_dates(soup)
			#Porque recuperamos todas las fechas al mismo tiempo; a diferencia de los otros atributos
			# que vamos recuperando para cada noticia

			print "Recuperando texto de las noticas."
			get_texto(br,links_array)

			print "Llevamos %s noticias recuperadas.\n" % str(len(dates_array))
			n = randint(MIN_NAPTIME, MAX_NAPTIME) # Número aleatorio entre MIN y MAX_NAPTIME
			#self.logger.debug("Dormiré %s segundos..." % str(n))
			print "Dormiré %s segundos..." % str(n)
			sleep(n)
			#self.logger.debug("OK, continuemos")
			print "OK, continuemos"
			#response = self.session.open(url)
			#soup = BeautifulSoup(response.read())
			#self.logger.debug(soup)
			#start_time = datetime.now()
			#self.logger.info("Tiempo de ejecución: %s" % (str(datetime.now() - start_time)))
			print "Tiempo de ejecución: %s" % (str(datetime.datetime.now() - start_time))
			#return soup

			
		#Concatenamos los links y cosas de todas las noticias del for
		write_to_file(archivo,dates_array,links_array,titles_array,countries_array)	
			

	print "\""+archivo+"\""

# "Search Google with Python Tutorial" en http://www.youtube.com/watch?v=NcrEClpu8b8

