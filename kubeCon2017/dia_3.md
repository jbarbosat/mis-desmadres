# Día 3


## Keynote: Kubernetes Community - Sarah Novotny, Head of Open Source Strategy, Google Cloud Platform, Google

- [Diapositivas](presentaciones/.pdf)
- [Youtube](https://youtu.be/_yzw_ce1_Xo)
- [Youtube](g https://youtu.be/-5R_GbGg1nI)


* Sarah Novotnry sobre qué pedo con la comunidad de k8s. HAce 2 años hubo 400 personas en el kubecon vs 4K ahora! Analogía: tenemos un camión al que le estamos haciendo alitas de cartón pero alguien le pegó un cochete. Sin embargo, todos los principios se intentan mantener (tienen un comité para decidir cosas)


## Keynote: Kubernetes at GitHub - Jesse Newland, Principal Site Reliability Engineer, GitHub

```
In this talk, Jesse will provide an overview of the on-premesis Kubernetes deployments that currently power 20% of GitHub's production services. He'll also review the challenges GitHub has faced and overcome so far during their Kubernetes journey, and highlight ongoing and future Kubernetes enhancements that GitHub is excited about.
```


- [Diapositivas](presentaciones/kubernetes-at-github.pdf)
- [Youtube](https://youtu.be/OgRHIZt8Yy8)


* Alguien de github sobre su uso de k8s. Cuando migraron cosas a su propio data center dijeron "tenemos tantito tiempo libre, q hacemos?" y pensaron en algo como k8s pero cuando lo rebotaron con otros equipos internos les dijeron: están pendejos, eso va a tomar siglos. Así que no lo pudieron hacer pero ahora usan k8s para el 20% de sus servicios, incluyendo lo que powerea la web interface. Esa cosa está en rails y usan un nginx. Sus deploys incluyen un chatbot para ver el status de cosas. También incluyen levantar un ambiente para code review. Usan "canary deploys" que es taggear cierto número de pods con la tag "canary" tal que se usen como ejemplo para ver si en producción el deploy nuevo no volvió todo más lento (no es un tema de errores de código sino de performance en vivo: chance cambiaron de librería y la nueva tarda más en cargar). Si en las canary pods todo jala, se libera el deploy y conforme va pasando el tiempo todos van teniendo la nueva version. Próximamente van a partir la app de ruby en cachitos y quizá open sourceen cosas. 




## Keynote: Manage the App on Kubernetes - Brandon Philips, CTO, CoreOS

```
Kubernetes has yet to close the developer gap from source code to app running in a production Kubernetes cluster. Many build bespoke tools. How can the Kubernetes community come together to build decomposable solutions that help people define their app, deploy it, and manage its lifecycle over time? Learn about the progress we are making together to elevate the conversation from container orchestration to application lifecycles management.
```


- [Diapositivas](presentaciones/Keynote_ Manage the App on Kubernetes - Brandon Philips, CTO, CoreOS KubeCon Austin 2017.pdf)
- [Youtube](https://youtu.be/ul624nYC8pw)


* Brandon Phillips de CoreOS presentó un dashboard, techtonic, que permite ver recursos por apps. Ya tienes tus desmadres de k8s para muchas apps pero no tienes dónde ver todo lo que usas. Para eso sirve su dashboard: para ver qué tienes deployado y cómo se comporta. 


## Keynote: What's Next? Getting Excited about Kubernetes in 2018 - Clayton Coleman, Architect, Kubernetes and OpenShift, Red Hat

```
The Kubernetes ecosystem has grown tremendously over the last three years.  Each release pushes the boundaries of what we can accomplish and brings new participants and new success stories.  That success has a price: how do we do what's best for the community and for our users, and what's on deck for 2018?
```


- [Diapositivas](presentaciones/.pdf)
- [Youtube](https://youtu.be/lUnD9SJDgo8)

* Clayton algo que habló el día anterior sobre hacer k8s aburrido, ahora habló sobre cosas que existen alrededor de k8s para diferentes temas. Habló de que Rails partió madres porque hizo todo más facil y que k8s busca llegar al mismo punto. Dio un repaso de muchas herramientas sobre k8s para cosas de red, de observabilidad, etc. etc.

## Keynote: What is Kubernetes? - Brian Grant, Principal Engineer, Google

```
Kubernetes has been described many different ways. How should one think about the platform? It partly depends on the problems you are trying to solve with it. I will discuss 10 ways to view Kubernetes based on use cases, how those uses relate to its features and architecture, how Kubernetes supports the features, and how the architecture is evolving to support them better. 
```


- [Diapositivas](presentaciones/.pdf)
- [Youtube](https://youtu.be/cHkXOeP8rQ0)

* Brian Grant. Mencionó Board o algo así que parece ser el proyecto interno de google que era k8s antes de que se abriera pero no estoy segura. Qué es k8s? Muchos modos de verlo. 1) Una plataforma de contenedores. 2) API declarativa de cosas (la línea de comandos que es el kubectl). 3) Un configuration distribution system (tipo el zookeeper). 4) Container infrastructure as a service: k8s tiene primitives que me permiten armar mi aplicación según la topología que tenga, tipo legos. 5) Platform para automatizar management de aplicaciones. 6) Services as a platform: k8s tiene una lista de servicios que puedes usar (open service broker) tipo etls, conexiones a bases de datos, mandar mails... 7) Portable cloud abstraction: k8s es portable porque los cloud providers se certifican con la CNCF para que garanticen que su version de k8s sea buena; así ya no te preocupa con cuál cloud trabajes. Además, se puede usar para diferentes tipos de workloads, incluso bases de datos con los StatefulSets. 8) Family of proyects, toolkit y ecosistema.

## Modern Big Data Pipelines over Kubernetes [I] - Eliran Bivas, Iguazio

```
Big data used to be synonymous with Hadoop, but our ecosystem has evolved over time with new database, streaming and machine learning solutions which don’t necessarily benefit from the Hadoop deployment model of Map/Reduce, YARN and HDFS. These solutions require a generic cluster scheduling layer to host multiple workloads such as Kafka, Spark and TensorFlow, alongside databases such as Cassandra, Elasticsearch and cloud-based storage. 

Eliran Bivas is a senior big data architect with years of hands-on experience working on both big data and cloud native solutions. Eliran will go over a common solution framework to create cloud native end-to-end analytics applications. It involves using Kubernetes as an alternative to Yarn, running Spark, Presto, machine learning frameworks (TensorFlow, Python and Spark ML kits) and serverless functions coupled with local and cloud-based storage. The session will showcase customer use-cases from IoT, automotive, cloud SaaS and finance. It will also include a live solution demo which demonstrates the benefits of using big data and analytics over a cloud native architecture, eliminating the existing challenges of complexity and moving towards a continuous integration and development architecture for big data.
```


- [Diapositivas](presentaciones/KubeCon2017Bivas.pdf)
- [Youtube](https://youtu.be/8tIcisyXWDU)

* Big data pipelines. Alguien presentó github.com/nuclio/nuclio. Dio un ejemplo de datos que llegan geolocalizados y se pintan en un heatmap. Levantó un spark, un zeppelin y su coso para lograrlo. Con Helm administras todas las configuraciones de todo y levantas con un comando, en vez de hacer mil comandos y tener mil archivos. Las cosas de configuración van en un ConfigMap, no en archivos dentro del pod. 


## Kafka Operator: Managing and Operating Kafka Clusters in Kubernetes [A] - Nenad Bogojevic, Amadeus

```
In this talk we will demonstrate an approach to management of kafka clusters in kubernetes deployments. We will show how we can provision kafka clusters and configure it using kubernetes concepts and an operator process. The kafka and zookeeper cluster elements will be provisioned using StatefulSet. As these applications benefit from high performance storage, we will also show how we can use node selectors or persistent volume claims to schedule instances on correct hardware. In order for clients to use it, the necessary message topics have to be configured in kafka cluster. We will show how using an operator process, based on kubernetes custom resources or ConfigMaps we can manage this configuration in descriptive manner and ensure consistent configuration across different development and operations stages as well as cluster restarts. Finally we will discuss how all this ties in with service catalog. 
```

- [Diapositivas](presentaciones/KubeCon-2017-Kafka-Operator.pdf)
- [Youtube](https://youtu.be/jAz8sdO1rgE)

* Kafka en K8s. Aquí tbn se usan los StatefulSets para replicar la estructura de master y workers. Dio un ejemplo de pipeline en kafka donde creó un producer y un consumer de kafka también vía Helm. Los datos de kafka se distribuyen en diferentes compus (sí, pods dentro de diferentes compus) gracias a un pedo de antiaffinity que tiene el k8s. Para que no se pierdan datos, el cluster de kafka levanta con redundancia, igual que si se levanta solo. Es importante que el producer sólo escriba su stream de datos en el topic que le toca (concepto de Kafka); los permisos y todo se asignan mediante un Operator, igual que en otra platica pasada alguien dijo. Estos compas hicieron un operator open source. Tiene pedos de seguridad y tuvieron pedos cuando kafka subió de versión.

## Distributed Database DevOps Dilemmas? Kubernetes to the Rescue - Denis Magda, GridGain

```
Distributed databases can make so many things easier for a developer... but not always for DevOps.  OK, almost never for DevOps.  Kubernetes has come to the rescue with an easy application orchestration!  

It’s straightforward to do the orchestration leaning on relational databases as a data layer. However, it’s becoming a bit trickier to do the same when a distributed SQL database or other kind of distributed storage is used instead. 

In this talk you will learn how Kubernetes can orchestrate distributed database like Apache Ignite, in particular: 
- Cluster Assembling - database nodes auto-discovery in Kubernetes.
- Database Resilience - automated horizontal scalability.
- Database Availability - what’s the role of Kubernetes and the database.
- Utilizing both RAM and disk - set up Apache Ignite in a way to get in-memory performance with durability of disk.

```


- [Diapositivas](presentaciones/distributed_database_deployment_with_kubernetes.pptx)
- [Youtube](ttps://youtu.be/k1y0Uoqepak)

* Distributed databases en k8s, en particular Apache Ignite. El Ignite maneja la comunicación dentro de sus nodos para que no se pierdan datos y bla bla, pero k8s ayuda mediante los StatefulSets a que cada nodo nuevo que entra al cluster sepa con quién debe conectarse. Hizo un demo donde levantó un cluster de k8s con ignite adentro y vimos cómo cada nodo nuevo podía conectarse al cluster gracias a k8s. 

## Democratizing Machine Learning on Kubernetes [I] - Joy Qiao & Lachlan Evenson, Microsoft

```
One of the largest challenges facing the machine learning community today is understanding how to build a platform to run common open-source machine learning libraries such as Tensorflow. Both Joy and Lachie are both passionate about making machine learning accessible to the masses using Kubernetes. In this session they'll share how to deploy a distributed Tensorflow training cluster complete with GPU scheduling on Kubernetes. We’ll also share how distributed Tensorflow training works, various options for distributed training, and when to choose what option. We’ll also share some best practices on using distributed Tensorflow on top of Kubernetes, based on our latest performance tests performed on public cloud providers. All work presented in this session will be accessible via a public Github repository.

```

- [Diapositivas](presentaciones/Democratizing_Machine_Learning_on_Kubernetes.pdf)
- [Youtube](https://youtu.be/gvuZpRmCzTM)



* Tensorflow en k8s en microsoft. Un ingeniero de infraestructura y una chava DS platicaron sobre lo que hicieron para que los tensor flows de ella jalaran chido en k8s. Hay dos tipos de paralelización en DS: o corres a la vez entrenamientos completos con sets de parámetros diferentes o paralelizas cachitos dentro de un entrenamiento dado, mueves parámetros y vuelves a probar. El de ella es el segundo tipo. Tienen unos GPUs que querían usar con K8s. Él pensó que con echarle más GPUs funcionaría pero no! Ella le explicó qué implicaba paralelizar en su mundo y él pudo organizar mejor el k8s (github.com/joyq-github/TensorFlowonK8s) tal que los GPUs se usaran al 100%. Todo esto porque el spark es disk intensive pero en cosas como tensor flow, lo que te da en la madre es la latencia de red. Hay papers de deep gradient compression (?). Microsoft sacó una cosa open source que da un dashboard para correr entrenamientos, incluyendo jupyter notebooks y ver los jobs y todo que le mando al K8s con o sin GPUs.


## Kube-native Postgres [I] - Josh Berkus, RedHat

```
Database systems remain the last frontier for Kubernetes, and at the Patroni Project we're working on conquering it. Having fully automated PostgreSQL clusters using Patroni, the project is now working on making Patroni more "Kubernetes native", so that SQL databases can be seen simply as a PostgreSQL resource.

In this talk, we will explain and demonstrate the current projects integrating Patroni PostgreSQL with Kubernetes, including:

* Patroni Operator, using the CoreOS Operator pattern
* Kube-native Patroni, which uses the Kubernetes controller instead of its own management

These works in progress will both acquaint attendees with tools they can use for their own high-availability database architectures, and explore some areas where Kubernetes could improve to support database systems better.
``` 

- [Youtube](https://youtu.be/Zn1vd7sQ_bc)

NOTAS


## Don’t Hassle Me, I’m Stateful - Jeff Bornemann & Michael Surbey, Red Hat

```
Stateless, cloud-ready applications are the future for many enterprise users, but what do you do about legacy monoliths, and existing vendor applications? New StatefulSet features within Kubernetes allow developers and administrators to work with these types of applications, and still reap the many rewards of a containerized platform. This session will explore some of these features by deploying a full MongoDB cluster on-top of OpenShift.
```

- [Diapositivas](presentaciones/Don't_Hassle Me_I'm_Stateful.pdf)
- [Youtube](https://youtu.be/yUfPd39-jHo)

