# coding:utf-8
# 4-dic

#!/usr/bin/python
# -*- coding: utf-8 -*-

# Dada una búsqueda, se recuperan los primeros 20 conjuntos de resultados de Google news.
# Aunque parece que Google news ya no escupe noticias después de la hoja 12, estamos obteniendo
# hasta la página 20 y mandándolo al HDFS; quitar repetidos se deberá hacer después.
# Dado que esto pasa, hay que hacer búsquedas por día o, a lo más, por semana. 

# Cambios:
# - Escupir esto al HDFS con hadoopy en vez de un archivo... Idealmente, con flume, pero so far no entiendo q pedo
# - Ya no estamos quitando repetidos
# ----------------------------------------------------------------------------------------
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
import hadoopy
import html5lib
#Ya vienenen ubuntu
import re
import codecs
import datetime
#from sets import Set
from time import sleep
import os

def create_browser():
	br = mechanize.Browser()
	br.set_handle_robots(False)
	br.addheaders = [('User-agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.101  Safari/537.36')]
	
	return br


def make_query(fecha0,fecha1,busqueda_si,busqueda_no,palabras2,num):
#Armamos la query, la mandamos a googlenews y hacemos soup del código de la página
	query="https://www.google.com/search?q="+palabras2+"&as_drrb=b&authuser=0&gl=us&hl=en&tbs=cdr:1,cd_min:"+fecha1.replace("%2F","/")+",cd_max:"+fecha0.replace("%2F","/")+"&tbm=nws&ei=RYZtUr7qJcPz2QW15IC4Dw&start="+num+"&sa=N"

	return query


def get_page(query,br):
	htmltext = br.open(query).read()

	# Guardé un ejemplo del html que lee, for further reference.

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

	news_list = soup.findAll('li',attrs={'class':'g'})
	#print news_list
	return news_list


def get_links(source_text):
# Expresiones regulares para quitar cosas raras que rodean links
# con r_links estamos omitiendo unos links raros que salen sin abstract ni fecha ni nada... queremos eso?
# tienen la forma: <a href="/url?url=http://www.etcetera.com.mx/articulo.php%3Farticulo%3D7891&amp;rct=j&amp;sa=X&amp;ei=KGBLUueZIOjhygHv9IGoAg&amp;ved=0CDQQjQwoBDAA&amp;q=&amp;usg=AFQjCNEphK-pOj209pzcki4LqXx_VVcbgA"
	r_links = "href=\".*\" "
	pattern_links = re.compile(r_links)

	links_array = []

	source_url = re.findall(pattern_links,str(source_text))
	#print source_url
	if len(source_url)>0:
		previo = urllib.unquote(str(source_url[0].replace("href=\"","").replace("\" ","")))
		links_array.append(re.sub('&amp;.*', '',previo)) #algunos links tienen esta mugrita; lo matamos
	else:
		links_array.append('NA')

	return links_array


def get_titles(source_text):
# Expresiones regulares para quitar cosas raras que rodean títulos
	r_titles = "\">(.*)</a>" 
	pattern_titles = re.compile(r_titles)

	titles_array= []

 	source_title = re.findall(pattern_titles,str(source_text))
	# print source_title
	if len(source_title)>0:
 		titles_array.append(source_title[0].replace("<em>","").replace("</em>","").replace("<b>","").replace("</b>","").replace("|",""))
	else: 
		titles_array.append('NA')

	return titles_array


def get_nwspp(soup2):

	nwspp_array = []

	texto2 = soup2.findAll('span',attrs={'class':'f nsa'})
	#if len(texto2)>2:
	nwspp_array.append(re.sub('<[^<]+?>', '',str(texto2[0])).replace("|",""))

	return nwspp_array


def get_dates(soup2):

	dates_array = []

	texto2 = soup2.findAll('span',attrs={'class':'f nsa'})
	dates_array.append(re.sub('<[^<]+?>', '',str(texto2[1])).replace("|",""))

	#print dates_array

	return dates_array


def get_abstracts(soup):

	abstracts_array = []

	list2 = soup.findAll('div',attrs={'class':'st'})
	for li in list2:
		#li = str(li).replace("<span class=\"f\">",)
	 	abstracts_array.append(re.sub('<[^<]+?>', '',str(li)).replace("|",""))

	return abstracts_array


def get_hits(soup):
	hits_secs = soup.findAll('div',attrs={'id':'resultStats'})
	hits0 = str(hits_secs[0]).replace("<div id=\"resultStats\">","").replace("<nobr> ","").replace(" </nobr></div>","")
	hits1 = re.sub(' \([^<]+?\)','',hits0)
	hits = hits1.replace("About ", "").replace(" results","").replace(",","")

	return hits


# def write_1st_line(archivo,primeralinea):
# 	f = codecs.open (archivo, 'a','utf-8')
# 	f.write("".join(primeralinea).decode('utf-8'))
# 	f.close()


def write_1st_line(hdfs_path,primeralinea):
	#hadoopy.writetb(hdfs_path,[('linea1',primeralinea)])
	return [('info',primeralinea)]
	print "Primera linea impresa"


# def write_to_file(archivo,dates_array,links_array,nwspp_array,titles_array,abstracts_array):
# # Para estofar los resultados, quitar repetidos y escribirlos en un archivo.
# 	resultados = []		

# 	for i in range(len(titles_array)):
# 		previo = str(dates_array[i]+"|"+ links_array[i]+"|"+nwspp_array[i] +"|"+ titles_array[i]+"|"+ abstracts_array[i] +"\n")
# 		resultados.append(previo)

# 	f = codecs.open (archivo, 'a','utf-8')
# 	# primeralinea = fecha0+"|"+fecha1+"|"+palabras2+"|"+hits+"|"+query+"\n"
# 	#f.write("".join(primeralinea).decode('utf-8'))
# 	for line in Set(resultados): #Para quitar resultados repetidos
# 	#for line in resultados:
# 		f.write("".join(line).decode('utf-8'))
# 	f.close()

# 	print "De ellos, " + str(len(Set(resultados))) + " resultados distintos."


def write_to_file(hdfs_path,todo_array,dates_array,links_array,nwspp_array,titles_array,abstracts_array):
# Para estofar los resultados en HDFS
	resultados = []		

	for i in range(len(titles_array)):
		previo = str(dates_array[i]+"|"+ links_array[i]+"|"+nwspp_array[i] +"|"+ titles_array[i]+"|"+ abstracts_array[i]) #+"\n")
		todo_array = todo_array + [(str(i),previo)]

	print todo_array
	#hadoopy.writetb(hdfs_path,todo_array)

	print "Done en Hadoopy"


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

	mes0 = '1'
	mes1 = '7'
	dia0 = '1'
	dia1 = '7'
	year0 = '2010'
	year1 = '2010'

	fecha0 = mes0+"%2F"+dia0+"%2F"+year0
	fecha1 = mes1+"%2F"+dia1+"%2F"+year1 

	busqueda_si = "méxico crisis"
	busqueda_no = "drogas"
	busqueda_exacta = "red cross"
	#busqueda_exacta = ""

	#Hay o no frases exactas que buscar?
	if busqueda_exacta=="":
		palabras2 = busqueda_si.replace(" ","+")+"+-"+busqueda_no.replace(" ","+-") 
	else:
		palabras2 = busqueda_si.replace(" ","+")+"%22"+busqueda_exacta.replace(" ","+")+"%22+-"+busqueda_no.replace(" ","+-") 


	archivo = str(datetime.datetime.now()).replace(" ","_").replace(":","-")

	hits = ""

	br = create_browser()

	#Pa despistar...
	htmltext = br.open("https://news.google.com").read()

	links_array = []
	titles_array = []
	nwspp_array = []
	dates_array = []
	abstracts_array = []

	todo_array = []

	for i in range(3):#range(21):
		num = str(i*10)
		print "Procesando hoja " + str(i) + "."
		query = make_query(fecha0,fecha1,busqueda_si,busqueda_no,palabras2,num)
		soup = get_page(query,br)
		news_list = get_all_news(soup)

		if i ==0:
			hits = get_hits(soup)
			primeralinea = str(fecha0+"|"+fecha1+"|"+palabras2+"|"+hits+"|"+query)#"\n")
			#print primeralinea
			todo_array = todo_array + write_1st_line(archivo,primeralinea)
		
		for li in news_list:
			
			soup2 = BeautifulSoup(str(li))
			texto = soup2.findAll('a') 
			source_text = texto[0]
			
			links_array = links_array + get_links(source_text)
			titles_array = titles_array + get_titles(source_text)
			nwspp_array = nwspp_array + get_nwspp(soup2)
			dates_array = dates_array + get_dates(soup2)
			abstracts_array = abstracts_array + get_abstracts(soup)

		print "Llevamos " + str(len(links_array)) + " resultados encontrados.\n"
		
		sleep(10)

	#Concatenamos los links y cosas de todas las noticias del for para poder quitar repetidos	
	write_to_file(archivo,todo_array,dates_array,links_array,nwspp_array,titles_array,abstracts_array)	

		

	print "\""+archivo+"\""

	#Para recuperar las cosas...
	#Primera línea
	print str(hadoopy.readtb(archivo).next())

	#Todo

	for key,value in hadoopy.readtb(archivo):
		print key, "-->", value


# "Search Google with Python Tutorial" en http://www.youtube.com/watch?v=NcrEClpu8b8
# pero para google news

