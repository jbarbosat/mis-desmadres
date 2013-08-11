Julio 22, 2013
---------------

Nos vimos Adolfo, David y yo para ver q onda.
Dropbox con una muestra de los datos que básicamente corresponden a dos días.

David se va a ir de viaje así q estos días hay que espiar los datos y tener ideas inteligentes.

Próxima semana nos veremos pero Adolfo se va.

Son datos de ventas de medicinas entre los laboratorios y las farmacias, etc. Hay intermediarios que hacen eso.
Hacen promociones y cosas así. Hay que decir cosas interesantes para que se conserven esos datos. 


Miércoles Julio 31, 2013
-------------------------

Nos vimos David y yo para rebotar ideas y ver qué onda. 
El viernes en Santa Fe vamos a ver a Arias que tbn tiene propuestas interesantes.

Necesitamos enfocarnos en que se ahorren baro si hacen tal o cual cosa. O que ganen más baro si hacen bla bla. 


Ideas:

- Se nos ocurrió que de tener la matriz de productos-facturas podríamos factorizarla como vimos con Felipe y chance sirva.

- Tbn pensamos que se podría hacer market basket analysis.


Tarea:

-Necesito hacer una gráfica de clientes y tipos de transacciones y que el grosor de las aristas esté dado por
la suma de los importes que caen en ese tipo de operación: venta, descuento o promoción (importe >0, <0 ó =0)
(aunq en la base todo es positivo... así que podría hacerse no por tipo sino tal cual por importe)

- Tbn ver qué puedo hacer por grupo de clientes. C, M, P, etc.


Problemas y preguntas:

- David dijo que venta, descuento o promoción (importe >0, <0 ó =0) pero en la base todo es positivo. 
    FALSO! Estaba transformándose mal. Ya se solucionó.
- Tenemos una muestra cero representativa...
- Haace falta entender mejor las variables para ver qué es importante.



Viernes Agosto 2, 2013
-------------------------

Reunión con Arias en Intellego. Se me hizo tarde. David me dio ride a Santa Fe. 

- De qué son los importes que tengo? Son importes totales de la factura? O son precios por producto en la factura? 
Porque si es esto segundo, entonces esos importes/cantidad me dan el precio unitario del producto en la factua.
Y si no, si tengo importes por producto por factura por condición... Necesito sumar todos los movimientos 
de un producto en una factura para sacar el precio total porque es posible que por producto tengan "precio del grupo
de productos", "descuento tipo 1", "descuento tipo 2", bla bla... de tal forma que lo que de hecho pagó el cliente por
un conjunto de productos de debe obtener sumando productos en una factura.

- Así tengo dos posibles modos de analizar esto. Las operaciones desagregadas o tal cual los precios en el tiempo.
    - Para operaciones desagregadas puedo hacer lo que hice... A quién le estás haciendo más descuentos de 
    tipo no sé qué madres y de importes más altos?
    - Para precios en el tiempo hay que agregar las operaciones.

- Broncota: Nuestros datos son chacas! Necesitamos o una canasta de productos en el tiempo o un set de clientes.

- Diferentes sectores de clientes => diferentes descuentos y políticas. Eso ya lo saben esos weyes así que no es muy
interesante. No son combinables entre sectores.

- Necesito que me digan qué sector analizar o qué tipo de productos analizar. 


Tarea:

- Ver al dude de la base de datos el martes próximo. Entender bien qué datos hay. 
- Jueves: tener una lista de brainstorms de cosas que se pueden hacer con los datos que hay.
- Próxima semana: feedback de las cosas que se nos ocurrieron que se pueden hacer.



Martes Agosto 6, 2013
----------------------

Vimos a Salvador Diaz Alcantara, el dude de Intellego que está trabajando con los de Nadro.
Nos vimos a las 9am en el ITAM y de ahí David me dio ride al Starbucks frente a Nadro (Santa Fe, x la Ibero).

- Hasta ahora tienen información a nivel factura; cosas como cuánto vendieron este mes; cuánto de su venta fue descuentos, etc.

- Sería valioso poder aportar información a un nivel más específico para un head y un tail de las ventas: 
    - A nivel producto
    - A nivel tipo de costo
    - A nivel tipo de descuento
Ahorita no lo pueden hacer porque BW (pertenece a SAP) no da. Si además pudiéramos comparar con años anteriores estaría chido.

- Cada presentación de Aspirina es un MATERIAL distinto. Agrupan esas cosas a manita. De querer hacerlo automáticamente
habría que pedirle a la gente de Nadro un catálogo; no es pedo.

- En la base, condición = 0KNART y el importe = 0KNVAL. Cada producto tiene distintas condiciones para cada cliente.
Hay muchas condiciones que no importan para lo que queremos hacer; Salvador sugiere quedarnos con las de la muestra.
Tenemos una muestra que es básicamente de 2 días no completos (500 K registros). De ahí sacar las condiciones.
Al final nos interesan las que hablen de costos y de descuentos.

- También sería valioso aportar rentabilidad de los productos más y menos vendidos. 

- Quizá en algún lugar de la basesota exista "familia de producto", as in: antibióticos, antipiréticos, analgésicos, etc. 
Podríamos hacer análisis dentro de cada familia de producto.

- Tienen datos de hasta 3 años atrás pero para otros modelos; es decir, igual y no tienen todos los campos que necesitamos.
Para los datos tal cual como los de la muestra, tenemos desde enero de 2013.

- En promedio hay 60 productos por factura y hay 60 K facturas al mes

- Posición/10 = lugar en el ticket en que aparece el producto (puede servir para construir id del movimiento de un producto
en una factura, como decía David).


Resumen:

- Dar info en un nivel más bajo que factura: por producto, por tipo de descuento, por tipo de costo, por cliente... Y sus cruces.


Propuestas extras:

- Análisis de precios de productos en el tiempo o de acuerdo con el cliente o cosas así.
- En cuanto a market basket, sí está chido pero primero responder sus preguntas; luego viene todo eso extra.

- Antes de hacerlo en serio, serio con TODOS los datos (HANA, de SAP), podríamos tener algo para 3 meses para 20 productos.
Esto podríamos montarlo o en Postgres o en un Hadoopsín, chance en Amazon. Si es Postgres, con un script que corramos desde R
o desde el mismo Postgres sale hasta el reporte. Si es Hadoop, habrá que decidir en qué trepamos la base (Hive, supongo) 
y luego mandar los datos filtrados a R para que produzca el reporte solito. 


Pendiente:

- Que Salvador nos pase el catálogo de productos (material en la base de datos)


Tarea:

- Necesitamos un prototipo de reporte y revisarlo con Salvador antes de ir con la gente de Nadro y pedir los tres meses d info.
- El reporte debería tener para 20 productos info sobre los descuentos que se aplican ( x tipo ), sobre los costos (x tipo),
sobre su rentabilidad. Poder agrupar por región o sucursal. Gráficas encimadas con las de ventas totales.
- Pregunta: Es como decía Arias que puede que un mismo producto aparezca en la misma factura pero con distintas condiciones?
Supongo que sí pero no es mala idea verificar.
- También es buena idea echarle un ojo a las condiciones que tenemos en la base de datos e ir identificando el tipo de
costos y de descuentos que tenemos so far.



Viernes Agosto 9, 2013
----------------------

Reunión en Intellego con David, Salvador, Margoth, Armando y Rocío. 


Salvador
--------

Salvador hace reportitos para muchas areas (ventas, inventarios, etc.) en Nadro.
Condiciones de precio basados en facturas. Ventas netas, devoluciones, descuentos, 
rentabilidad (so far x sucursal de Nadro, grupo de clientes).

Queremos rentabilidad por proveedor tbn (expediente del proveedor) pero esa es otra historia.
Por producto y por mostrador lo puedo sacar con lo que tengo.
So far veo de cada factura: Total neto, costo promedio, utilidad total.

PD: Su clasificación de mostrador > cadena > subgrupo > grupo está pésima. So far damos info hasta cadena y ya tarda.
Walmart da rentabilidad del -0.7 a 1 %. Todo Nadro tiene margen neto de utilidad de como el 1% y venta neta mensual es
de 1,700 millones de pesos al mes.

Nadro generan precios con base en una herramienta Vistex que pronostica demanda. 

Precio Nadro (lo que les costó a ellos), precio público (casi siempre es sobre este precio que aplican descuentos y cosas),
precio farmacia (el de la cajita de la medicina).

Descuentos comerciales, financieros, corporativos, por pronto pago.

Costo promedio (costo del lote), cedido (costo a que lo trasladas las cosas al cliente), total.

HANA. Convertir mis datos en cuánto dinero se van a ahorrar tal que valga la pena invertir 20 millones de dólares en esa madre...




Miércoles tarde o jueves temprano cita con un dude de Nadro. Un power point.



Venta neta / Costo.

Prec. factura interna es costo.


Tarea:

- Armar el Shiny. Grafiquitas en R susceptibles de ser puestas en un ppt. 


Sábado Agosto 10, 2013
-----------------------

Aprendizajes de Shiny.

- Tengo un filtro cuyas opciones determinan las opciones de otro. Para ello use updateSelectInput.
Salía error de Error : evaluaci'on anidada demasiado profunda; recursi'on infinita options(expressions= )?
y era porque sobreescribí objetos. Hay que ponerles nombres disitntos y ya.

- En un futuro todas las opciones pueden determinarse a partir de las cosas en la base de datos... 
Suponiendo que voy a hacer una selección de productos y personas y escupirlos en un csv que pueda jalar desde R o algo así.
Si no, quizá a R le conviene leer como catálogos y ya :)

- Para filtrar fue un problema el que se seleccionara la opción "TODO". Tenía que tener un if sobre los inputs 
y se hizo un relajo. Con isolate el if jalaba pero no se actualizaban las cosas.

```r
aux<-input$cliente
if(isolate(cliente()!="Todo")) 
```

Intenté darle la vuelta filtrando poco a poco y si en algún momento me quedaba sin registros, regresar al anterior.
Es decir, controlar este desmadre a partir del número de renglones. Pero iba a ser un problema si de hecho un producto
no estaba para algún cliente o cosas así.

Solución:

https://github.com/wch/testapp/blob/master/setinput/ui.R
https://github.com/wch/testapp/blob/master/setinput/server.R

Utilizar sprintf para cachar el contenido de los cosos inputeados!!! Así ya puede hacer ifs felices:

```r
Material<-sprintf(reactive({input$material})())
if(Material!="Todo"){
  datos3<-reactive({datos2()[datos2()$producto==Material]})
}
else{
  datos3<-datos2
}
```

- Ya tengo dos tabs con pocas tablas y pocos datos y tarda pinche mil años! Así que se me ocurre calcular una vez 
tablas con agregados y de ellas plottear columnas. 
Aparentemente la bronca es que estaba usando el mismo chunchito para que fuera output en dos pestañas! Santo remedio.
