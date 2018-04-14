# Día 1

## Keynote: A Community of Builders: CloudNativeCon Opening Keynote - Dan Kohn, Executive Director, Cloud Native Computing Foundation

- La Cloud Native Computing Foundation tiene dos años. Surgió a partir de que Google donara Kubernetes, a.k.a k8s, y fue el primer proyecto aceptado por ellos.
- El año pasado tenían 4 proyectos; hoy, 14. Hay más sponsors (dieron 103 diversity scholarships versus 30 que tenían pensadas porque google aflojó más lana).
- El número de gente en las conferencias ha explotado cabrón. Aquí hay 4K gentes que es más que en las 3 conferencias anteriores juntas. Próximamente hay en europa y china (para que frank mande plática :P)
- Hay un curso en edx y certificación de k8s.
- El wey de la Alibaba Cloud usa k8s.

- [Diapositivas](presentaciones/Keynote - Dan Kohn - KCCNC NA 2017 FINAL.pdf)
- [Youtube](https://youtu.be/Z3aBWkNXnhw)


## Keynote: CNCF Project Updates - Michelle Noorali, Senior Software Engineer, Microsoft Azure

```
Project representatives will share their updates:
- Linkerd update, presented by Oliver Gould (Oliver is the CTO of Buoyant, where he leads open source development efforts. Prior to joining Buoyant, he was a staff infrastructure engineer at Twitter, where he was the tech lead of Observability, Traffic, and Configuration & Coordination teams. He is the creator of linkerd).
- Fluentd update, presented by Eduardo Silva (Open Source Engineer at Treasure Data. He currently leads the efforts to make logging more scalable in Containerized and Orchestrated systems such as Kubernetes).
- Prometheus update, presented by Tom Wilkie (Tom is the founder of Kausal, a new company working on Prometheus & Cortex. Previously he worked at companies such as Weaveworks, Google, Acunu and XenSource. In his spare time, Tom likes to make craft beer and build home automation systems).
```

- Hablaron de los 14 proyectos que tienen en la CNCF. Hay unos de cosas muy de kubernetes (algo de dns, containerd, rkt,cni), cosas de logs (prometheus, fluentd,opentracing,jaeger), cosas de comunicación entre servicios (linkerd, conduit, envoy, gRPC) y cosas de seguridad (TUF, notary)

- [Diapositivas](presentaciones/.pdf)
- [Youtube](https://youtu.be/zPOlDe-J9ZA)


## Keynote: Accelerating the Digital Transformation - Imad Sousou, VP, Software Services Group & GM, OpenSource Technology Center, Intel Corporation

```
What happens when you need to get software to run reliably when moving from one computing environment to another? Imad Sousou, Vice President of the Software and Services Group and General Manager of the Open Source Technology Center for Intel Corporation, will highlight how we can use open source software to support our rapidly changing world.
```

- [Diapositivas](presentaciones/.pdf)
- [Youtube](https://youtu.be/pqoDF4QCRy8)

- katacontainers, unos contenedores optimizados en hardware que son seguros y no sé qué más.


## Keynote: Cloud Native CD: Spinnaker and the Culture Behind the Tech - Dianne Marsh, Director of Engineering, Netflix

```
Created at Netflix, Spinnaker is an open source, multi-cloud continuous delivery and infrastructure management platform for releasing software changes with high velocity and confidence. Spinnaker’s open source community includes Netflix, Google, Microsoft, Oracle, Target, Kenzan, Schibsted, and many others.

In this keynote, you’ll learn how various aspects of Netflix culture, and open source have shaped Spinnaker and how Spinnaker, in turn, has influenced the engineering culture at Netflix. We’ll discuss how lessons learned from an earlier open source product, Asgard, influenced us and drove a Cloud Native first approach.
```

- [Diapositivas](presentaciones/.pdf)
- [Youtube](https://youtu.be/mfFtfaulCtg)

* Culture y tecnología. Habló de Spinnaker (una madre para continous delivery en netflix) que se desarrolló a partir de una necesidad interna y tiene cosas muy de cultura de netflix (freedom and responsibility): te deja hacer deploys a todas las regiones a la vez pero es tu responsabilidad si lo haces; te da dashboards con info para que veas qué no funciona y no decidas a lo pendejo. Ahí cultura => tecnología pero, por otro lado, hay que ver si la tecnología que eliges refuerza tu cultura empresarial o la frena. 


## Keynote: Cloud Native at AWS - Adrian Cockcroft, Vice President Cloud Architecture Strategy, Amazon Web Services

- [Diapositivas](presentaciones/.pdf)
- [Youtube](https://youtu.be/5U-6sxR5DaQ)
* Próximamente, K8s en AWS <3. Y bien hecho: pullean directo del código de k8s, no van a hacer la mamada de tener su propia versión basada en la cosa open source. Eso va a implicar que cambien su modo de cobrar (vía algo que aún no está que se llamará Fargate): ya cobran por compu y por lambda functons; ahora hay que cobrar x container. Saldría más barato para Arquímedes que nunca tiene evaluaciones de modelos. Va a permitir todo el desmadre de aws: tener roles en los pods, tener clusters en diferentes availability zones, auth con las llaves del IAM de AWS...


## When the Going Gets Tough, Get TUF Going! [I] - David Lawrence & Ashwini Oruganti, Docker

```
Software distribution and packaging systems are rapidly becoming the weak link in the software lifecycle. In this talk we will look at the security landscape of existing software update systems and signing strategies. We will then introduce The Update Framework (TUF), a new signing framework that looks to address many of the challenges found in existing systems and more.

TUF provides protections against data tampering, rollbacks, key compromise, and other more esoteric attacks. We will investigate how it achieves these protections and show you how to start using it today.

While TUF is a general signing framework, we will also address use cases specific to the Cloud Native Ecosystem. These include how to use TUF signing to de-privilege cluster managers and attach metadata to images and containers in a decentralized manner which can be leveraged for policy management.
```

- [Diapositivas](presentaciones/.pdf)
- [Youtube](https://youtu.be/JfAil-15YJw)
* TUF y Notary: Seguridad en containers. Cuando updateo software (tipo paquetes de python o tipo versiones nuevas de software para mis cosas deployadas), cómo sé que tengo la versión más actualizada y que no está comprometido lo que ejecuto? Este show es un desmadre de llaves para firmar las actualizaciones y saber que lo que corres es legal. Tiene diferentes niveles de llaves y hay todo un pipeline para firmar cosas. Existe en docker enterprise. Puedes firmar con tus propias llaves o el coso genera cosas con RSA y otro algoritmo de encripción. Es sencillo porque hace todo por ti y te avisa si el codigo que bajaste no tiene una llave chida.


## How We Built a Framework at Twitter to Solve Service Ownership & Improve Infrastructure Utilization at Scale [I] - Vinu Charanya, Twitter
```
Twitter is powered by thousands of microservices that run on our internal Cloud platform which consists of a suite of multi-tenant platform services that offer Compute, Storage, Messaging, Monitoring, etc as a service. These platforms have thousands of tenants and run atop hundreds of thousands of servers, across on-prem & the public cloud. The scale & diversity in multi-tenant infrastructure services makes it extremely difficult to effectively forecast capacity, compute resource utilization & cost and drive efficiency.

In this talk, I would like to share how my team is building a system (Kite - A unified service manager) to help define, model, provision, meter & charge infrastructure resources. The infrastructure resources include primitive bare metal servers / VMs on the public cloud and abstract resources offered by multi-tenant services such as our Compute platform (powered by Apache Aurora/Mesos), Storage (Manhattan for key/val, Cache, RDBMS), Observability. Along with how we solved this problem, I also intend to share a few case-studies on how we were able to use this data to better plan capacity & drive a cultural change in engineering that helped improve overall resource utilization & drive significant savings in infrastructure spend.
```

- [Diapositivas](presentaciones/.pdf)
- [Youtube](https://youtu.be/C6Tv8brYGwo)
* Una chava de Twitter con una plática vergas sobre una herramienta interna para poder ver cuántos recursos ocupan los equipos internamente. Todo vía logs. Dos modelos de entidades: resources y clientes. 1) Un resource tiene tags y pertenece a un proyecto; ej: un core de un CPU que le rento a amazon que uso para evaluar el modelo de chillis. A ese recurso se le calcula un costo unitario (cuánto le pago a amazon más qué tan eficientemente lo uso para incentivar uso eficiente de cosas). En Twitter, los ejemplos eran recursos que un equipo producía y otro consumía (tipo llamadas al API). Y luego hay un pipeline de logs que saca costos y hace reportes para que cada área sepa q tan eficiente es. Tuvieron pedos con la calidad de datos: qué pasa si hay días sin logs? 2) Luego vieron que a veces la gente se mueve de equipos tonces hicieron un catálogo de gente con su modelo de entidades muy bonito. El chiste es que todo es función del tiempo: qué recursos usaba DS en enero? quién llevaba olive garden en 2016? Hay interfaz gráfica para que la gente dé de alta sus proyectos y peticiones de recursos, para cambiar metadatos de cosas, para levantar alarmas de uso raro de recursos, para dar de baja recursos, para dar de baja clientes.... Fue muy bonito, nos gustan los modelos de datos. Fue mandato de los jefes que todos usaran esa herramienta en Twitter. Tonces, cada que hay proyectos nuevos, ellos van con el equipo para garantizar que sus logs se generen y vayan a dar a cierto lado y para ayudarles a usar la herramienta interna tal que den de alta el proyecto en la aplicación y vean los reportes que genera.


## The Art of Documentation and Readme.md for Open Source Projects - Ben Hall, Katacoda

```
The Readme is becoming essential to successful Open Source projects. The Readme is a gateway to welcoming new users and potential contributors. It defines the tone of the project, how to get started and most importantly, the aim. 

While many Open Source projects have amazing code-bases, the Readme and documentation are letting them down and as a result they are losing influence and opportunities for adoption and feedback. 

In this talk, Ben uses his expertise of building an Interactive Learning Platform to highlight The Art of Documentation and the Readme file. The aim of the talk is to help open source contributors understand how small changes to their documentation approach can have an enormous impact on how users get started. 

Ben will discuss: 
- How to create engaging documentation 
- Defining technical details in an accessible way 
- Building documentation that encourages users to get started 
- How to manage documentation and keeping it up-to-date and relevant 

In the end, attendees will have an understanding of how to build beautiful, useful documentation. This will be backed by examples from some of the best open source projects.
```

- [Diapositivas](presentaciones/Kubecon - ArtofDocs - Ben Hall - Katacoda.pptx)
- [Youtube](https://youtu.be/-EaJEnFhwjs)
* Algo sobre documentación de cosas (particularmente cosas open source). Diferentes niveles y pasos en el tiempo. Los primeros cambian menos porque son más generales. Los últimos pasos cambian más y hay que automatizar la generación de snippets y cosas que pongas en tu sitio web. Tonces, pasos: 1) en mi landing page, qué es este pedo? why should i care? 2) Getting started: no haces que bajen una máquina virtual de 10GB! tienen que ver los usuarios qué hace tu cosa. 3) Docs más largos para responder cómo solucionas un problema. Se sugieren code snippets en vez de kilómetros de explicación. 4) Qué más hace mi proyecto? Problemas particulares, mostrar lo que la comunidad hace con tu proycto. 5) Documentación más específica y larguísima que conviene automatizar. 0) Y el README.md? Para decir metas de tu proyecto, cómo instalar, cómo correrlo, en qué status está tu proyecto, quién lo mantiene, cómo contribuir, code of conduct, license. LA documentación: instructivos de legos!!! 


## Microservices Patterns with NGINX Proxy in an Istio Services Mesh [I] - A.J. Hunyady, NGINX Inc

```
Building a cloud native application is only half the battle; running it reliably is the other half. 

NGINX, the leading provider of ingress controller functionality in Kubernetes environments, has partnered with Istio to enhance Sidecar proxy capabilities in the Istio' Services Mesh architecture. 

A service mesh is highly dependent on the strength of the proxy, and NGINX is the most powerful service proxy in the market. It offers a small footprint high performance engine with advance load balancing algorithms, caching, SSL termination, API gateway, extensibility through broad range of third-party modules, sciptability with Lau and nginScript and various security features with granular access control. 

Microservices also require a Web Server to be deployed side-by-side with the service proxy. While optional, deploying NGINX as Web Server technology provides additional benefits in performance, manageability, security and the overall monitoring of the Application. 

NGINX is already used by more than half of the top 100,000 websites and this talk will describe how NGINX in Istio environments is a natural extension of this technology. 

Our demo will show a sample application running in a Kubernetes/Istio/NGINX environment and we will answer questions from the audience.
```

- [Diapositivas](presentaciones/.pdf)
- [Youtube](https://youtu.be/hr-euazYG88)
* Patrones de microservicios con alguien de NGINX. Hay el modelo de proxy en el que nginx cacha todo el trafico y no interviene; todos los servicios se conectan entre sí. Hay router mesh donde las peticiones les llegan a un hginx que manda a otro que se conecta directo con todos los servicios y cosas; no se conectan entre sí los servicios, es un snowflake y el nginx es el centro. Y el service mesh: cada uno de mis servicios tiene un nginx como "side car" (?); o sea, levanto mis pods con un nginx adentro. Estuvo ruda la plática. 


## How Netflix Is Solving Authorization Across Their Cloud [I] - Manish Mehta & Torin Sandall, Netflix

```
Since 2008, Netflix has been on the cutting edge of cloud-based microservices deployments. In 2017, Netflix is recognized as one of the industry leaders at building and operating “cloud native” systems at scale. Like many organizations, Netflix has unique security requirements for many of their workloads. This variety requires a holistic approach to authorization to address “who can do what” across a range of resources, enforcement points, and execution environments.

In this talk, Manish Mehta (Senior Security Software Engineer at Netflix) and Torin Sandall (Technical Lead of the Open Policy Agent project) will present how Netflix is solving authorization across the stack in cloud native environments. The presentation shows how Netflix enforces authorization decisions at scale across various kinds of resources (e.g., HTTP APIs, gRPC methods, SSH), enforcement points (e.g., microservices, proxies, host-level daemons), and execution environments (e.g., VMs, containers) without introducing unreasonable latency. The presentation includes a deep dive into the architecture of the cloud native authorization system at Netflix as well as how authorization decisions can be offloaded to an open source, general-purpose policy engine (Open Policy Agent).

This talk is targeted at engineers building and operating cloud native systems who are interested in security and authorization. The audience can expect to take away fresh ideas about how to enforce fine-grained authorization policies across stackthe cloud environment.
```
- [Diapositivas](presentaciones/Manish Mehta Netflix AuthZ V4.pdf)
- [Youtube](https://youtu.be/R6tUNpRpdnY)
* Netflix y cómo solucionar pedos de permisos de los servicios o personas de hacer cosas. Open Policy Agent: una cosa en go que permite escribir policies pensadas como "este Identity puede/nopuede hacer esta Operación sobre este Recurso" y tiene un como Totoro donde la gente arma sus policies y luego las testea!!! Escribes tests sobre tus policies y se corren antes de que deployes tus policies. Entonces, cada servicio tiene un AuthAgent, que es el que se pelea con una base de datos de policies que se generaron con el Open Policy Agent.


## A Practical Guide to Prometheus for App Developers [B] - Ilya Dmitrichenko, Weaveworks

```
Ilya will first briefly outline how Weaveworks run cloud-native apps in production on Kubernetes, and how they use Prometheus for monitoring, as well as some of the open-source tools the team has built to implement continuous delivery.

In the main section Ilya will turn the spotlight on Prometheus and demonstrate step-by-step how simple it is to instrument an app, using a very generic Node.js app as reference.
```

- [Diapositivas](presentaciones/.pdf)
- [Youtube](https://youtu.be/-7fO99IiTpY)
* Intro a Prometheus. Esa madre hace que las cosas escupan logs y luego se vean en dashboards. Pésima plática peeero muy chido repo: https://github.com/errordeveloper/prom-nodejs-demo/tree/v0-start . Cada branch es un paso más que hace cambios a código y configuración hasta que ya tienes una app en Node y un prometheus y un dashboard con logs.





## Keynote: Service Meshes and Observability - Ben Sigelman, Co-founder & CEO, Lightstep

```
Service mesh technology facilitates the discovery, interconnection, and authentication of microservices. While it’s straightforward to use a service mesh to measure peer performance, actually explaining the behavior of transactions in a microservices deployment requires distributed tracing.

In this keynote, Ben will explain why distributed tracing is important, where the service mesh comes into play, and how OpenTracing makes it all elegant and portable. We will illustrate these concepts with a live, audience-interactive demo, and provide guidance for those who want to add these technologies to their own microservice deployments.
```


- [Diapositivas](presentaciones/.pdf)
- [Youtube](https://youtu.be/RGT5XHH_Gis)
* Ben Siegelman y Open Tracing. Existe un estándar de tracing. No es sólo loggear; es saber qué entró y qué salió de cada servicio. Tipo los logs en base de datos de Arquimedes que guardan qué entro y que salió de cada endpoint. Eso es mejor que nomás los logs que dicen qué pasó pero no dicen qué petición ocasionó ese log. Para poder tener esto, instalas cositos en tus pods a modo de "side cars"  que escupen estos logs a algún lado. Jaeger es un cosito que hace dashboards chidos con logs. Estaba hablando de que en el mundo ideal, tener chingos de microservicios es como una parvada de pájaros que se mueve junta y es bonito y salió de la nada una como paloma en el escenario volando; fue cagado porque la siguiente diapsitiva fue que esa versión ideal es falsa y los microservices se portan mal (una foto de pájaros atacando a alguien).



## Keynote: Kubernetes: This Job is Too Hard: Building New Tools, Patterns and Paradigms to Democratize Distributed System Development - Brendan Burns, Distinguished Engineer, Microsoft

```
The simple truth is that there are more reliable online systems that need to be built then there are people who know how to build them. Building a distributed system is bespoke, manual and hard.

Fortunately, with the development of containers and Kubernetes, a foundation has been created for a new type of development environment to make building systems dramatically easier and more modular. But containers and Kubernetes, while necessary, are not sufficient. In this talk I introduce Metaparticle, a new standard library for easy distributed systems development on Kubernetes.

Metaparticle uses familiar, standard programming languages to enable developers and architects to design, develop and deploy their application from a single, easy to use environment.
```


- [Diapositivas](presentaciones/.pdf)
- [Youtube](https://youtu.be/gCQfFXSHSxw)
* Metaparticle y Brendan Burns: están desarrollando una abstracción que permita hacer containers y pushear a clusters con comandos en el mismo lenguaje en vez de todo el cagadero que es hoy. Por ejemplo, annotations en python o javascript o lo que sea que transformen el código en un container y que lo pusheen a otro lado. Está cabrón y están en proceso. 


## Keynote: Can 100 Million Developers Use Kubernetes? - Alexis Richardson, CEO, Weaveworks

```
What is the potential for Kubernetes? Is it like Openstack and Hadoop, a technology for expert operators in the enterprise? Or is it like cloud and mobile, a way for every developer to move the business? What is needed for Kubernetes to have an impact equal to the web? Can 100 million people use Kubernetes?
```

- [Diapositivas](presentaciones/.pdf)
- [Youtube](ttps://youtu.be/21l8v6eObcc)

- Otro compa habló de un bot que le pone colores a fotos en blanco y negro en twitter que funciona gracias a Open Functions as a Service (OpenFaaS) y que desarolló un vato de 17 años. cómo? conectando cositas! Hay que desarrollar pensando en eso, en legos. 

