Telcel
=============

05-abr-2016

Hubo cambios a la página de telcel.


06-dic-2013

Código que obtiene de la página de mitelcel.com el saldo amigo y el de regalo. 
Corremos `telcel/src/telcel.py` en la consola de python.

Requiere de un archivo `parametros.yaml` con el siguiente formato:

```
- numero: xxxxx
  password: xxxx
  out: ../xxx.out
- numero: xxxxx
  password: xxxx
  out: ../xxx.out  
```

con la info correspondiente a los datos de la cuenta en mitelcel.com y
al archivo .out en donde queremos guardar la info para cada uno de los
números telefónicos que estén en el archivo yaml

En `datos.out` hay un ejemplo de los datos que obtuve. La última columna 
son notitas mías sobre el tipo de uso que hice pero lo escribí a mano.
Eventualmente estaría bien correr esto todos los días automáticamente 
pero antes de programar eso estoy viendo si corre.
