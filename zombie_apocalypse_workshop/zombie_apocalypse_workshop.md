Zombie Apocalypse Workshop
==================================

- Oficinas de Amazon en Santa Fe
- 08-marzo-2018

Setup
--------------------------

- Qwiklabs
- Twilio para SMSs
- Slack
- sofiaro@amazon.com

Goals
--------------------------

- API Gatway, Labda, serveless architectures


Serverless
--------------------------
- No me toca a mí manejar servidores
	- RDS es maomeno eso pero no porque controlo el tamaño del servidor
- Sólo pagas por tiempo de cómputo que usas (en ms!)
	- No tengo que hacer capaciy planning
- Chat web serverless con API Gateway, LAmbda y S3.
- Ejemplo: Con Lambda podría pasar mis archivos .doc a .pdf sin pagar compu ni licencia
- API Gateway: hay caché y más cosas par evitar que tiren tu aplicación por aquí
- Amazon Cognito: Authentication custom o vía third parties (federated) en chinga.
	- Todo usa tokens en JSON que van cifrados
	- Se puede personalizar por usuario cosas como colores

Intro
--------------------------
- Terminar un chat web, authenticated con amazon cognito
	- Estático
	- Se conecta a muchas cosas (iot (si da tiempo), sms (via twilio), slack)
	- Se ve en tiempor real qué escribes
- Que se conecte con S3 y, via el API Gateway, Lambda y un DynamoDB
	- En el dynamo DB se guardan los mensajes escrito históricamente
- No todo es copy paste, hay que debuggear y avisarle a Sofía si eso sí es truculento

Plan:
- Pool de usuarios: Federated Identity Pool 
- SMSs vía twilio
- Búsqueda de mensajes
- Slack
- Si da tiempo, IoT

- Cambiar fuente, ponerle mugritas extras al chat, kinesis, recognition de imágenes de persona vs zombie, hacer differentes canales, hacer un storage de comida, etc. para informar a los usuarios de niveles de recursos almacenados.

Código
--------------------------
- https://github.com/aws-samples/aws-lambda-zombie-workshop
- Template de cloud formation
	- JSON o yaml que levanta cosas de AWS en alguna región
	- Incluye cosas como AMI ids
	- Ya existen templates de cosas

Notas
--------------------------
- Existe un systems manager y ahí un parameter store que te permite guardar secrets cifrados.
- acm manejador de certificados
	- se le pueden poner a balanceadores y otras cosas
	- no se pone sobre compus para temas de escalabilidad y para que tengan menos chamba
- Chaos monkey: tipo lo que netflix usa para matar cosas random y probar resiliencia
	- Caso de uso de spot instances
	- Tbn para cómputo distribuido, que salga muy barato! EMR instances pueden ser spot felices
- Storage de bloque y objeto
	- Bloque = file system
	- Objeto = el S3
	- Cuando edito un caracter de un archivón, en bloque muevo un cachito. En el storage de objeto tengo que matar y volver a insertar todo.
	- Si subo un html a un S3 es como si estuviera en un apache. La url que me da ya está chido.
- Importante tener un DNS para que si tienes picos de requests, no te caigas
	- CloudFront permite bloquear ips malas, no recibir paquetes malformados tal que no se caiga su sitio
	- Pa que el DNS está cabrón porque existe en todas las edge locations
- Logs de Lambda
	- CloudWatch: un cachito de eso se ve en los logs de Lambda.
	- El cachito con editor de código y logs de ejecución en una como consola son aportación de Cloud9, una empresa que AWS compró
	- En monitoring, jumo to logs me lleva al cloud watch
