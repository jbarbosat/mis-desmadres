# Día 2

## Keynote: KubeCon Opening Keynote - Project Update - Kelsey Hightower, Staff Developer Advocate, Google

- [Diapositivas](presentaciones/.pdf)
- [Youtube](https://youtu.be/07jq-5VbBVQ)

* Kelsey Hightower: Update de cosas q se pueden hacer en k8s. Los features nuevos son aburridos sobre k8s! Hay que llegar a ese punto en toda tecnología porque significa que eres estabe y feliz. Levantó un cluster de k8s en la nube de Google desde el teléfono con un "OK Google bla bla". El cluster ya tenía código corriendo; hizo cambios y los deployó al cluster. El pipeline de continous delivery se ve como sigue: hago push al github en mi branch, mergeo a master, taggeo y eso triggerea un build y deploy a un ambiente de QA. La configuración para el deploy de cosas vive en otro repo (como nosotros con modelos_ds vs. opi-infraestructura). Tienes un dashboard de métricas (Istio) tbn. Con el build se actualizó el tag de versión en el repo de infraestructura para que apunte a la versión nueva. Ya que todo está bien , deploy a producción. Es importante no rebuildear! Si la imagen que probaste en QA funciona, no rebuildees!!! Qué tal que hay errores o cosas? para qué sirvió probarla si vas a deployar otra cosa. Cosas de performance o diferencias entre staging y prodcción no viven en el docker de tu contenedor! Las mandas a otros archivos para que tenga sentido hacer eso.




## Keynote: Kubernetes Secret Superpower - Chen Goldberg & Anthony Yeh, Google

- [Diapositivas](presentaciones/.pdf)
- [Youtube](https://youtu.be/1kjgwXP_N7A)


* Chen Goldberg, que trabaja en el equipo dentro de Google que aporta cosas al k8s open source. Antes de que k8s saliera, tenían un proyecto interno como pre-k8s para hacer más productivos a los desarrolladores pero no era flexible (cada que querían usar software diferente era un pedo) y era una blackbox para la gente (estaba bien hasta que se rompía y los desarrolladores no sabía por qué había fallado el pre-k8s que usaban). Ahora, k8s es extensible! Los features en la base de k8s son aburridos pero las cosas para hacerlo extensible siguen cambiando y las extensiones sobre el tbn. 
 - Parte de esta extensibilidad es el kube-metacontroller que permite extender k8s base sin pegarle al código core: defines tu propio cosito (StatefulSet, por ejemplo, pero custom) y lo utilizas sin pegarle al codigo base de k8s. 




## Keynote: Red Hat: Making Containers Boring (again) - Clayton Coleman, Architect, Kubernetes and OpenShift, Red Hat

```
By ensuring everything about containers is standardized and boring, we can now focus on the overall Kubernetes experience when it comes to actually running containers. Freeing Kubernetes to just focus on orchestrating containers from now on and setting the stage for exponential growth. We'll take a brief look at how Kubernetes is prepared to explode in usage because the foundation has been solidified. From container standards to customer-resource definitions to pluggable hardware, Kubernetes is ready for broad usage patterns. 
```


- [Diapositivas](presentaciones/.pdf)
- [Youtube](https://youtu.be/AE0gZlA2sZ8)

* Clayton Coleman de redhat. Tienen un OpenShift Online Starter que es gratis para que la gente pueda levantar clusters de k8s y jugar. Pedos al proveer de tantos clusters a usuarios les ayudaron a mejorar cosas en k8s: tenían chingos de eventos y logs que no eran necesarios y lo corrigieron y tbn tenían chingos de archivos de los secrets (llaves, passwords) de la gente repetidos y pesaban un chingo y tbn lo corrigieron y lo aportaron al k8s base.


## Keynote: Pushing the Limits of Kubernetes with Game of Thrones - Zihao Yu & Illya Chekrygin, HBO

```
Do you want to know what it is like to run 15,000 pods in production? Are you interested in seeing how Kubernetes stands up to the record-breaking viewership and a login rate that is beyond belief on Game of Thrones Season 7 premiere? Come and see things we have done for the Game of Thrones preparation. We will talk about how we provision Kubernetes clusters on AWS, and how we monitor them and microservices that are running on the clusters.

In this talk, we will also go over how HBO Go went from deploying and running microservices on virtual machines in AWS EC2 to running the very same services inside the Kubernetes clusters. We were able to dramatically increase the productivity of our engineering teams and efficiency of resource utilization in the process. It wasn’t always a smooth ride and it wasn’t a one shot deal. Instead, it was a long and at times challenging journey starting from operating a reliable, production-ready Kubernetes cluster in AWS, advancing to gradually deploying select services into Kubernetes clusters, load testing them, and running them in parallel to our current EC2 installations, and finally going live. Come and learn some helpful tips and mistakes we made along the way, which could help your organization embrace the Kubernetes world.
```


- [Diapositivas](presentaciones/KubeCon_Keynote_HBO.pdf)
- [Youtube](https://youtu.be/7skInj_vqN0)

* HBO vivía como nosotros con ELBs y EC2s donde vivían servicios en APIs en NodeJS. Los pedos con eso eran que en las compusitas no se usaba la mitad del CPU y el autoescalamiento es tardado. Probaron Mesos, swarm y eligieron k8s. Pero hacerlo en aws era un pedo!!! 
- Existe terraform que permite tener templates para tus masters y tus mijos. Pero los pods de Prometheus se morían y tardaban en revivir. Además, amazon tardaba en darles compus que necesitaban que se solucionó creando tres tipos de mijitos: los mijos normales, los de backup y los reservados. Si un mijo normal moría, entaba un backup. Si necesitaban escalar, entraban los reservados y se iban creando nuevos. 
- Usaron Flannel para tunnear cosas de redes con los ELBs; diferentes configuraciones con ELBs.
- Usaron kube-dns. En la config le dice al cluster dónde buscar las IPS de los mijitos. Tunnearon cosas para guardar IPs en caché y no tener que buscar en todos lados y tunnearon para que las peticiones inválidas al DNS no se hicieran; que no se buscara en la lista de IPs y cosas.


## Keynote: Progress Toward Zero Trust Kubernetes Networks - Spike Curtis, Senior Software Engineer, Tigera

```
Tigera’s Spike Curtis will share how enterprises are starting to embrace a zero trust network security posture, and demonstrate how such an approach can be enabled within an orchestrated environment such as Kubernetes by combining service mesh and network policy with a multi-factor authentication, authorization and encryption strategy.
```


- [Diapositivas](presentaciones/KubeCon2017_SpikeCurtis-Keynote.pdf)
- [Youtube](https://youtu.be/Agxt9Vg-YP4)

* Zero trust K8s networks. Con estos desmadres se necesita que todo sea seguro: que nadie ataque mis pods y que nadie ataque la red. Istio soluciona el primero y el K8s network policy soluciona el segundo. HIbieron Calico para integrar K8s e Istio y manejarlo tal que definas un calico policy y eso implique policies en k8s y el istio y todo sea feliz porque sólo definiste cosas en un lado. Existe Tigera, una compañía que hace seguridad de k8s como para empresas, con cosas muy piquis de cada empresa. 


## Keynote: The Road Ahead on the Kubernetes Journey - Craig McLuckie, CEO, Heptio

```
It has been amazing to watch Kubernetes emerge as a standard operating environment for distributed systems development over the past few years. In a short few years it has become embraced by almost every significant vendor in the ecosystem and is going from strength to strength. It is emerging not only as a way to not only solve hard problems deploying and running applications, but is supporting the development of new approaches to building and running applications that power the world.  

 During this session, Craig McLuckie, one of the Kubernetes founders and CEO of Heptio will look ahead to the coming years and talk about some important trends in the ecosystem that will continue to support and drive the success of the project. We will focus on the emergence of expert operations and talk about how Kubernetes is starting to change the organizations that build and manage distributed systems. This will touch on how SRE values are starting to find their way into modern development teams, what tools are still needed to drive ops maturity and the overall value of this trend to companies adopting cloud native technologies. We will discuss the value of continued focus on modularity and extensibility in the cloud native ecosystem as a way to foster innovation in the ecosystem, and also discuss the the emerging role Kubernetes is playing in the increasingly heterogeneous world of cloud.
```


- [Diapositivas](presentaciones/.pdf)
- [Youtube](https://youtu.be/3FR82H7NwAw)

* K8s rode ahead. Tres ideas importantes
- Developer productivity matters. Operations tiene que funcionar cabrón para que esos weyes sigan haciendo lo suyo (tipo DS vs nosotros para deployar sus modelos).
- Multicloud. Necesitamos que se puedan levantar cosas en diferentes nubes sin que me importe en cuál y que haya estándares. La CNCF certifica cuando alguna implementación de k8s está bien hecha o no. No sólo basta con que el cluster levante en cualquier nube sino que los temas de governance tbn estén integrados; que yo ponga configuración en un lado y entonces tenga os mismos settings en todas las nubes y el mismo comportamiento esperado.
- Aplicar estas cosas en empresas es complicado por lo que tienen que pensar en la etensibilidad de k8s. Ningún único vendor va a solucionar todos los pedos de la empresa; tonces, k8s tiene que conectarse bien con todo.
Hay una paradoja de no sé quién: si haces algo más eficiente, se espera que la gente consuma menos de lo que lo alimenta pero no! cuando hubo máquinas eficientes, en vez de que se redujera el uso del carbón, aumentó cabrón. Así tiene que ser acá. Hay que solucionar esos tres pedos para que k8s jale cabrón.




```
```


- [Diapositivas](presentaciones/.pdf)
- [Youtube]()


* Hubo una sesión como de mentoring donde le preguntabas cosas a gente y luego un lunch con temas de diversidad. Estuvo interesante porque todos tienen los mismos pedos, no importa en dónde estemos: contratar, comunicarse entre equipos, procesos... Todo el mundo está en lo mismo. Hablé con un wey en intel que hace cosas de scheduling en k8s y ahora está en el equipo de IA en intel para que cosas de machine learning estén bien scheduleadas sobre hardware custom de intel. Tbn conocí a un tipo mamón que aporta a k8s y una chava trans que trabaja en Word Press que está migrando a k8s y empezaron por el API y usan Cassandra para guardar cosas (tipo imágenes procesadas o así porque cassandra es rapidísima y sale mejor que volver a procesar imágenes).


## ''Hot Dogs or Not" - At Scale with Kubernetes [I] - Vish Kannan & David Aronchick, Google

```
Kubernetes promises to be a multi workload platform. This talk will explore how Kubernetes can be easily leveraged to build a complete Deep Learning pipelines starting all the way from data ingestion/aggregation, pre-processing, ML training, and serving with the mighty Kubernetes APIs. This talk will use Tensorflow and other other ML frameworks to highlight the value that Kubernetes brings to Machine Learning. Along the way, key infrastructure features introduced to abstract and handle hardware accelerators which make Machine Learning possible will also be presented.
```


- [Diapositivas](presentaciones/.pdf)
- [Youtube](https://youtu.be/R3dVF5wWz-g)


* Machine learning con kubernetes. Hablaron de cosas que hace kubeflow, una cosa sobre k8s, para que hacer machine learning sea más fácil. Permite orquestar deploys a diferentes ambientes sin cambios en código; incluso de mi compu hacia GPUs. Permite priorizar los recursos tal que el intern no mate el trabajo del senior DS. Tiene jupyter, tensor flow. Deja trainear y validar los modelos. Hicieron un demo que incluye una GUI para crear un manifest que pide trabajos a un cluster de k8s. 

## The Elements of Kubernetes - Foundational Concepts for Apps Running on Kubernetes [I] - Aaron Schlesinger, Microsoft Azure

```
“The Elements of Style” is one of the most important and foundational guidelines on how to write well. It has effectively summarized, in a list of seminal guidelines, how to harness the power of the English language to write high quality prose of almost any kind.

In computing, we have similar guides for various technologies. Python offers “The Zen Of Python”, Ruby has “The Rails Doctrine”, and so on...

One of the powers these documents wield is that they help serve as a “north star” that guides an entire community toward the same goals.

I believe we need a similar guide for Kubernetes. It would describe how app developers and operators should think about and use the features in Kubernetes to build and deploy reliable, stable apps. Armed with such a guide, we could all hope to better understand the “essence” of Kubernetes in pursuit of building better cloud native apps.

We don’t have anything like this today, but many in the Kubernetes community have strong, detailed opinions for what should go in this guide. Much of it is tribal knowledge or scattered in blog posts. 

In this talk, I’ll try to bring many of these opinions together and lay out an “Elements of Kubernetes” guide for app developers and operators alike. I’ll do so by relating each “element” to stories and details I’ve seen in the community that reveal what makes a good Kubernetes and cloud native app.
```


- [Diapositivas](presentaciones/The_Elements_of_Kubernetes.pdf)
- [Youtube](https://youtu.be/S9l2MWhIBhc)


* Principios y algunas buenas prácticas de k8s para desarrolladores. Observabilidad: k8s ve tu app y tú le setteas límites de uso para que los pods escalen horizontalmente; además, tu ves tus logs para tunnear las condiciones de escalamiento de los pods. Crash first principle: en vez de tener un chingo de ifs que controlen los reintentos de hacer cosas dentro de tu app (tipo conectarte a una DB), que se muera el pod (exit status 1), mande logs y k8s lo reviva. Unordered is better than ordered: es mejor no depender del orden pero si hay que hacerlo hay opciones; x ej, matar pods con versión vieja de recursos y revivir con versión nueva via algo que pones en el código o tener "init containers" que hagan cosas antes de tu app (algo que se enchufe a la DB antes de que se levante la app completa). Loose coupling: que los pods no se hablen entre sí; para eso hay servicios porque los nombres de las pods cambian (tipo aws que asigna ips al azar) y se tiene que acceder a recursos vía sus labels. Tight coupling: las cosas que dependan unas de otras van en un mismo pod, como el coso que manda logs (esos otros pods son los mentados side cars). Manage configuration: usar helm (una heramienta) para que tus manifestos queden en el github en un solo lugar y cuando se updateen versiones de software, se cambien cosas en el manifesto y se pusheen al git. Ask for the least amount of resources, tal que k8s pueda asignar recursos mejor (no pidas chingos de disco y chingos de ram y chingos de todo siempre; una apo puede necesitar más disco pero los logs más memoria y otra mádre más cpu). Do not reinvent the wheel: echarle ojo a los muchos proyectos alrededor de k8s como fluentd, helm, traefik, etc. 


## Running MySQL on Kubernetes [I] - Patrick Galbraith, Consultant

```
MySQL is the world's most popular open source database and there are a number of ways to run it on Kubernetes. This talk will cover each type of MySQL deployment strategy starting from a simple MySQL pod, to a asynchronous replicated master-slave, synchronous Galera cluster, and on to a Vitess clustering system which allows for horizontal scaling of MySQL and innately has built-in sharding, explaining how each is deployed, what features are available, and what type of application they lend themselves to. 
```


- [Diapositivas](presentaciones/MySQL_on_Kubernetes.pdf)
- [Youtube](https://youtu.be/J7h0F34iBx0)



* MySQL on K8s. Una DB es como una mascota versus un pod que es como cerdo de matadero :( . Para solucionar eso inventaron los StatefulSets que permiten que 1) no se asignen ips a lo pendejo a los pods, 2) que las cosas levanten y mueran en orden y 3) Stable storage (?). Para poder enchufar crear y configurar cosas con K8s, hay operators. Existe un mysql operator que permite usar comandos del kubeclt para prender y apagar pods con mysql que tengan backup a persisten storage (prende otro pod de backup). Hablaron de Vitess, una cosa basa en mysql pero mega shardeada que usan youtube y slack, entre otros. Igual que otras dbs distribuidas, el Vitess tiene un server donde guarda info de los shards para saber q hay en cada lugar y hay mecanismos para elegir un nuevo master si es que el original se muere. 


## Accelerating Humanitarian Relief with Kubernetes [I] - Erik Schlegel & Christoph Schittko, Microsoft

```
How can UN humanitarian aid field experts use social media to gain insight, understand trends and track key humanitarian issues? Through a collaboration with Microsoft and UN OCHA, Project Fortis was created to accelerate the surveillance around humanitarian disasters and health epidemics around the world.

This talk discusses the architecture of a high-available native spark pipeline running across multiple Kubernetes clusters to support Fortis customers.
```


- [Diapositivas](presentaciones/Kubecon_2017_Humanitarian_Aid_Multi_Cloud.pdf)
- [Youtube](https://youtu.be/UywgL70FQ3s)


* Accelerating humanitarian relief con k8s. Unos compas de microsoft tienen un Project Fortis (github.com/catalystcode/project-fortis-pipeline) que hace lo que yo tenía para tesis de maestría: un pipeline de datos de diferentes fuentes, procesados y geolocalizados y dumpeados a diferentes lugares para análisis. Un dato que entra tarda 15 segundos en verse en dashboard (incluye speech recognition para audio tomado de transmisiones por radio y cosas como geolocalización de cosas con lat y lon!) Usan spark streaming para meter datos y lucene para hacer topic extraction. De ahí, mandan info por tile (tipo tile de mapbox) a cassandra para que se agregue; no usan jerarquías geopolíticas sino tiles de mapas. Existe en proyecto spark-native para enchufar k8s y spark en el que k8s se usa en lugar del zookeeper. Compilas jars que son los que se mandan a los pods para trabajos. En k8s se levantan dos namespaces al menos: el de spark y el de cassandra. Cassandra tiene que ser highly available así que se replica y todo. Eso está chido porque puedo tener datos de mi proyecto sobre zonas difíciles e inaccesibles replicados por todo el mundo. 





