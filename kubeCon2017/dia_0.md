# Día 0

Lightning talks: pláticas de 5 minutos de muchos temas diferentes.

## Lightning Talk: Building Scalable Test Infrastructure with Kubernetes [I] - Allan Schiebold, Codefresh

```
In this talk I'll quickly cover how we build scalable test infrastructure with Kubernetes. I'll cover common practices, and present some new ways to approach them.
```

- **Notas**: Usuarios corren su código para probarlo en diferentes environments. Usan k8s para eso y aguanta bien con las imágenes sobre google cloud y toda su infraestructura tbn en google.

- **Diapositivas**:
- **Youtube**:



## Lightning Talk: How to Contribute to Kubernetes [B] - Nikhita Raghunath, Student

```
Do you want to contribute to Kubernetes? Not sure how or where to begin? It can be overwhelming! But fear not - you can join the thousands of successful contributors too!

In this talk we’ll explore the different parts of Kubernetes and how they work, see how the various components are related, discuss the skills you need to get started and learn the best ways to get your first Pull Request accepted.

You don’t have to be an expert; even mere mortals like us can make contributions. This talk will also walk through how I implemented my Google Summer of Code project even though I was completely new to Kubernetes. Once you see how easy it is, you’ll want to do it too!
```

- **Notas**: Cómo contribuir a k8s. Habló del slack, de que hay Special Interest Groups que uno puede seguir en github y en slack, de que hay que leer las design proposal de cosas para ver qué quieren hacer y que pronto habrá un mentoring program de k8s para contribuir y aprender.

- [Diapositivas](presentaciones/nikitaKubeCon-Contribute-To-Kubernetes.pdf)
- **Youtube**:



## Lightning Talk: Essentials for Building Your Own Database-as-a-Service [B] - Balachandran Chandrasekaran, Dell EMC

```
This session will discuss about essential blueprint for building and operating a database platform as a service by taking advantage of Kubernetes and its persistent storage support for stateful containerized applications.
```

- **Notas**: DBs as a service: está bueno tenerlas en containers pero es un pedo el tema de que se pierdan datos. Tonces los weyes de thecodeteam.com tienen algo para persistir los datos en algún lado y nomás matar los containers de las bases.

- [Diapositivas]("presentaciones/Essentials for building DBaaS v3.0.pdf")
- **Youtube**:


## Lightning Talk: How Kubernetes is Helpful for Accelerating Machine Learning Research and Engineering [I] - Hitoshi Mitake, NTT Labs

```
In this lightning talk, the presenter shares his experience on helping machine learning research and engineering with kubernetes. k8s is not only a tool for managing microservices but also helpful for executing batch jobs like learning phase of deep learning frameworks and stateful services that provides data for the learning tasks. The presenter and his collaborators has been building and managing k8s cluster for TensorFlow learning tasks and HDFS as its learning data source. In addition, thanks to the pluggable scheduler architecture of k8s, their custom scheduler enshorts execution the learning tasks effecitvely and hides usage of network equipments and complex heterogeneous computational devices (e.g. GPUs) from researchers.
```

- **Notas**: Si quiero probar cosas como Tensor Flow y entrenar mil cosas de deep learning, en vez de joderme con lo que ofrece Google (no puedo mover el basecode de lo que ofrece!) o tener un cluster fisico de compus y tener que mantenerlas, estos compas hicieron un scheduler diferente para kubernetes para que se adapte mejor a lo que necesita algo de machine learning (era un pedo levantar diferentes tasks con el scheduler normal).

- [Diapositivas](presentaciones/kc_cnc_na17_mitake.pdf)
- **Youtube**:



## Lightning Talk: Cluster Insights [B] - Xin Ma, eBay

```
As the footprint of our K8 clusters increased across eBay data centers, many work loads were on boarded onto these clusters. With different work loads running across different clusters, cluster operations and insights into these applications has become an interesting problem. We wanted to know the footprint of these applications across different clusters in our data centers. One of the most obvious solutions is to query against different api servers and derive insights. However as the scale increased querying api servers has become a challenge and we could not get data in real time. To solve these problems, we developed an application called kube watch. Kube watch helps collects data for various resources from different clusters and persists into data stores. By building different dashboards using this data it helped us gain insights into the clusters in real time. During this talk we shall go through the kube watch system, its architecture and the problems it has helped us to solve.
```

- **Notas**: Los de ebay desarrollaron tess.IO que se basa en kubernetes para manejar sus clusters, escupen logs a elasticsearch (que es tipo solr) y a postgres :heart: y luego arman dashboards con quantum (basado en kibana) que van a abrir al público el próximo año.
- [Diapositivas](presentaciones/.pdf)
- **Youtube**:


## Lightning Talk: Watch This! - Johnathon Rippy, NetApp

```
Rippy will demonstrate Docker running on his rooted Android Wear watch. 
To get this working required Docker, OpenEmbedded, Yocto, and AsteroidOS which he'll explain. If all goes well with the demonstration, he'll add the watch as a Kubernetes node and schedule a pod to run on it.

Rippy's initial tweet about Docker running on his watch:
https://twitter.com/jkrippy/status/826661130693128194
```

- **Notas**: Un compa levantó un cluster de kubernetes con 3 smart watches. Cada uno corriendo AsteroidOS. Para hacerlo, copió y pego mil herramientas que ya había. Las pantallitas se veían rojas y ya que estaban levantados los noditos se ponían azules y todos aplaudían.
- [Diapositivas](presentaciones/KC_NA17_WATCH_THIS_RIPPY.pdf)
- **Youtube**:


## Lightning Talk: Why is Community so Important? [B] - Yeni Capote Diaz, Samsung SDS

```
I believe one of the reasons Kubernetes has grown in popularity so rapidly in the past few years has a bit to do with its community. I want to share my experience as a member of the Kubernetes community and discuss how the interactions I've had have contributed towards my development as an engineer. As a woman of color and a recent graduate of a bootcamp, I know firsthand the power of a strong community. I also want to cover what helps a beginner engineer such as myself to thrive, contribute, and be successful in this industry. I want to share some important qualities that I have experienced in the Kubernetes community and where we can potentially improve.
```

- **Notas**: Habló de lo chido de la comunidad de k8s. Estuvo bueno porque no tiene carrera; era niñera y ahora es intern de DevOps en Samsung SDS (?) gracias a Ada Developers Academy, que es tipo Laboratoria y está en Seattle. Hay gente que dona su tiempo para mentorear chicas programadoras.
- [Diapositivas](presentaciones/Yeni-Capote-Diaz.key)
- **Youtube**:


## Lightning Talk: Stupid Kubectl Tricks - Jordan Liggitt, Red Hat

```
A whirlwind tour of some of the most useful, interesting, and under-sold features the Kubernetes command-line has to offer.
```

- **Notas**: Tricks del kubectl, que frank podría usar jejeje; comandos y flags no tan conocidos. Luego otro hizo algo parecido sobre el minikube.
- [Diapositivas](presentaciones/Stupid Kubectl Tricks.pdf)
- **Youtube**:


## Lightning Talk: Telepresence: Local Development & Debugging of Remote Kubernetes Services - Abhay Saxena, Datawire

```
Developers who use Kubernetes for multi-container applications face a conundrum: develop locally or on a remote Kubernetes cluster. Local development adds complexity to your development environment, since you have to run (and maintain!) your entire multi-container app locally. On the other hand, a remote Kubernetes cluster doesn’t lend itself to live coding and debugging. 

In this talk, we will talk about Telepresence (https://www.telepresence.io), an open source tool for Kubernetes that lets you develop and debug a service locally, while setting up a bidirectional proxy to a remote Kubernetes cluster. With Telepresence, you can make a quick change to a service, save, and test it -- while that service has full access to Kubernetes environment variables, ConfigMap, secrets, and other services running in your Kubernetes cluster.
```

- **Notas**: Telepresence: un proxy frente a tu compu tal que pueda estar como parte del cluster y los cambios a tu código se vean en vivo, sin esperar a que se buildeen imágenes, se deployen y todo.

- [Diapositivas](presentaciones/Telepresence Fast, realistic development for Kubernetes services.pdf)
- **Youtube**:


## Lightning Talk: Templating K8s: Easily Managing Applications via Common Configuration [B] - Don Steffy & Anubhav Aaeron, Oath

```
Like many other companies, Yahoo is working to containerize many legacy applications, managed with Kubernetes. In order to onboard several hundred applications and libraries, Kubernetes configuration files are created for each application and multiple CI/CD environments, which leads to thousands of similar YAML files across all applications.

In order to onboard all applications seamlessly, and also be able to centrally make incremental updates to the Kubernetes configuration files with no disruption to customers, some kind of standardization is required. We tested many existing options, looking for a tradeoff between simplicity and power, and decided on centrally-managed templates for the configuration files.

A very simple yaml interface with standard technical verbiage was provided for customers to onboard their applications. This paper describes the design, user experience, and outcomes of creating these templates, which allowed developers with no Kubernetes experience to onboard their application quickly, often in less than a day.
```

- **Notas**: Una herramienta de templates de k8s: la gente no iniciada hace unos yamls via un CLI que los valida y modifica así configuración de las aplicaciones que deployan. En vez de tener los chorromil archivos de configuración, guardan templates que se ven modificados a partir de los yamls personalizados de la gente.
- [Diapositivas](presentaciones/KubeCon_Templating_K8s_Final.pdf)
- **Youtube**:


## Lightning Talk: Testing Kubernetes Patches with kube-spawn, the a local, multi-node Kubernetes Cluster Tool [B] - Chris Kuhl, Kinvolk

```
kube-spawn is a tool for running local, multi-node Kubernetes clusters on Linux machines. It was originally created as a means to test Kubernetes patches locally in a multi-node environment. Unlike other tools of its kind, it does not use VMs nor Docker app containers. Instead, it utilizes OS containers run with systemd-nspawn. As such, one can run a local, many-node cluster on modest hardware, with each node running a full OS, by default CoreOS's Container Linux.
```

- **Notas**: Sacaron kube-spawn que permite hacer un cluster de más de un nodo en mi compu local (ya existe minukube que sólo permite un cluster de mentis de un nodo; estos permiten más nodos locales). EL compa habló de cosas low level de containers y sólo existe en linux.
- [Diapositivas](presentaciones/.pdf)
- **Youtube**:



## Lightning Talk: CRI Proxy: Solving the Chicken-and-Egg Problem of Running a CRI Implementation as a DaemonSet [I] - Piotr Skamruk, Mirantis

```
CRI allows for special-purpose CRI implementations such as Virtlet, which makes it possible to run VMs as if they were containers. Still, deployment of these CRI implementations may bring us back to pre-container days, because we run into problems with additional required software such as libvirt, the need to configure the operating system on the node in different ways, and so on. We can also have problems with upgrading the CRI implementation apps, because unlike other components, they require special treatment. It would be nice if we could use the deployment power of k8s to install these apps on some of the nodes.
Further complicating matters is the fact that if your CRI doesn't support Docker images, and is too different from Docker, you need to install Kubernetes components such as kube-proxy and a CNI plugin in a special way, meaning that you have to prepare special-purpose CRI nodes in a very special way. 
Even if you just want to create a quick demo of your CRI that runs on Kubernetes clusters deployed using a popular tool such as kubeadm, you may need to tweak the node config just a bit to make this happen.

DaemonSet seems like it might be the right choice for a CRI implementation, but here we run into the chicken-and-egg problem, as a CRI implementation is required to be running on the node in order to run any pods there. 
Enter CRI Proxy. CRI requests that deal with plain pods are handled by the primary CRI implementation (such as docker-shim), while requests that are marked in special way (using pod annotations and image name conventions) get directed to the special-purpose CRI implementation. This way, the deployment headache almost goes away - all you have to do is install CRI Proxy on the node, and the proxy has minimal dependencies. For demo installations, the proxy provides “bootstrap” mode, which automagically installs CRI Proxy on clusters installed with kubeadm, and possibly some other cluster setup tools, too.

(If we have time, I may also say a few words about hyper’s approach; they have something like CRI proxy built into their CRI implementation, which solves problem of running k8s components on the node, though it doesn’t help much with deployment problem.)
```

- **Notas**: ???
- [Diapositivas](presentaciones/criproxy_lightning.pdf)
- **Youtube**:


## Lightning Talk: REST, RPC, and Brokered Messaging - Nathan Murthy, Tesla

```
Effective communication between distributed and heterogeneous components is essential for modern service-oriented architectures to work well. REST, RPC, and brokered messaging are the most popular communication styles for achieving this, but when is it appropriate for choosing one style over the other? A well-defined microservice architecture should be accompanied by a well-defined communications semantics. This talk draws on my personal experience defining these semantics for systems I’ve built at Tesla.
```


- **Notas**: con k8s pueden tener diferentes tipos de comunicación entre cosas que desarrollan: REST, RPC y cosas como message queues; cada tipo de comunicación para l oque es adecuado.
- [Diapositivas](presentaciones/.pdf)
- **Youtube**:

## Lightning Talk: Minikube Developer Workflow and Advanced Tips [B] - Matt Rickard, Google

```
A brief overview of the tools available in minikube to simplify building and testing your applications on a local Kubernetes cluster. 

- Bootstrapping minikube with kubeadm,
- Running minikube in TravisCI
- Minikube addons (ingress controller, registry credentials helper)
- Preloading and caching images in minikube, and other tips to help you develop your applications on top of Kubernetes even faster.
```

- **Notas**:
- [Diapositivas](presentaciones/.pdf)
- **Youtube**:



## Lightning Talk: Moving Fast with Microservices: Building and Deploying Containerized Applications in a Cloud-Native World - Micha Hernandez van Leuffen, Wercker

```
As software becomes more and more complex, we, as software developers, have been splitting up our code into smaller and smaller components. This is also true for the environment in which we run our code: going from bare metal, to VMs to the modern-day Cloud Native world of containers, schedulers and microservices.While we have figured out how to run containerized applications in the cloud using schedulers, we've yet to come up with a good solution to bridge the gap between getting your containers from your laptop to the cloud.

How do we build software for containers? How do we ship containers? How do we do all of it without shooting ourselves in the foot? In this talk, we'll explore how current delivery systems are falling behind, and how we need to change the mental model, create new best-practices and treat containers as a first-class citizen.
```

- **Notas**: Alguien de Wercker habló de cómo cuando levantas muchos micro services es un pedo, tonces hacen como acuerdos via API para que no se rompa nada, pero es un pedo tener tests. Entonces hicieron un como blueprint de servicios, que no entiendo bien qué hace peeero sonaba chido ajajaja
- [Diapositivas](presentaciones/.pdf)
- **Youtube**:

