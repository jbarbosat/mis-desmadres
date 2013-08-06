Julio 22, 2013
---------------

Nos vimos Adolfo, David y yo para ver q onda.
Dropbox con una muestra de los datos que básicamente corresponden a dos días.

David se va a ir de viaje así q estos días hay que espiar los datos y tener ideas inteligentes.

Próxima semana nos veremos.

Son datos de ventas de medicinas entre los laboratorios y las farmacias. Hay intermediarios que hacen eso.
Hay promociones y cosas así. Hay que decir cosas interesantes para que se conserven esos datos. 


Miércoles Julio 31, 2013
-------------------------

Nos vimos David y yo para rebotar ideas y ver qué onda. 
EL viernes en Santa Fe vamos a ver a Arias que tbn tiene propuestas interesantes.

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

Vimos a Salvador Diaz Alcantara, el dude de Nadro de la base de datos. 9am en el ITAM y de ahí David me dio ride a Nadro. 
Santa Fe, frente a la Ibero.


