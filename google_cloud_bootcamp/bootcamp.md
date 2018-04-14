Keynotes de la mañana
==================================
- Let developers code.
- Modelos pre-entrenados de Google.
- Flexibilidad de GCP para que elijas los cores y ram que quieras. No sólo 2^n cosas.



CloudHero
===========================

- Es un alfa. Habrá que dar feedback al final
- 4 stages, 9 challenges. Te dan badges por completar y por ganarle a todos.
- Web app que es un control panel. left hand corner = status of the game.
	- cloud= open coud project
	- leaderboard
- Si nunca he usado gcp, me ayudan los amiguitos si pido ayuda con un pom pom
- Tengo mi código que me abre un projecto. no hay que crear uno.
- Completar challenges me da puntos. No me quita puntos el cagarla. Si no entiendo por qué no completó mi challenge pido ayuda.

- http://hero.gcp.solutions/

- Frank encontró un bug. JC quedó entre los primeros 10. 

Back to Bootcamp de Kubernetes
=======================================

- Raúl algo, Maritza algo y MEt algo
- codelabs.google.com para ejercicios de código
- Lab de kubernetes basics. Hay acceso gratuito dos semanas en qwiklabs.
- Abres la consola de google cloud. El lab va diciendo que a tu cuenta le enablees cosas. 


Algunos conceptos
----------------------

- Deployment. Replica sets con X replicas. Pods con containers que tienen cierta imagen.
- Pod: manda status y health por un puerto distinto del de tráfico normal
- Rolling updates: Creo otro replicaSet con igual X replicas con la nueva versión. Y voy matando las pods del replicaset viejo y prendiendo
pods en el replicaSet nuevo. Se puede pausar ese update y sólo se sube 1 pod en vez de todos o hacer un rollback.
- Canary deployments: Un balanceador de carga manda parte del tráfico al replicaset viejo y parte el replicaset con la versión nueva antes 
de decidir si es el bueno e iniciar un rolling update. Viene de mineros que metían a la mina a un canario para ver si había gases o madres
tóxicas; si sobrevivía la cosa esa, era seguro entrar.
- Blue-green deployments: Saco una copia del replicaSet actual con los mismos X y nueva versión. si todo bien, mato el otro replicaSet. 
Coexisten los dos replicaSets. si algo muere, rolllback.
- K8s en GCP tiene opción a preemtible nodes, que son como spot instances de AWS.

- Stackdriver: Dashboard para monitorear de Google.

- CI/CD: Es un dolor porque o hay cosas monolíticas o hay cosas mal hechas que dificultan la automatización de deploymentes porque hacen
lento el poder probar cosas pequeñas.
- Tendencia a morir de monoliths. Desde SoA :/ que no ha servido para todas las organizaciones y ahora con microservices.
- Jenkins puede deployarse en k8s con un master y workers y tus nodos para escalabilidad.
	- En vez de tener un depa de QA, tienes tus tests automáticos.
	- Antes había diferentes tipos de compus: golden image con dependencias y seguridad setteados,  paid image (algo con el 
	monolito funcionando) y la compu normal sin nada.
- Mejor pensar desde el inicio en esto.
- El que los ambientes de prueba sean triviales de aprovisionar implica que ya no es tu chamba levantarle cosas a los weyes de QA!
	- Si además tienes tus pruebas, vas más seguro al pasar a código los requerimientos: para cada uno haces un test automatizado.

- www.coursera.org/voucher/Bootcamp/Mexico. Tbn para el de machine learning!
