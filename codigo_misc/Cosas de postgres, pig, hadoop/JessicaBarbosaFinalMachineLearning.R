#Machine Learning
#Código para el proyecto final.
#Otoño 2012

#Base de datos de abulones feos, divididos en dos clases por edad.

#Ya habíamos corrido bayes, una regresión logística y redes neuronales; todo fatal

#Ahora hay que correr y combinar k vecinos, svm y un árbol y combinarlos. 
#Vamos a utilizar tres métodos, hay dos posibles clases. Se elige por votos.

################################################################################
#Cargamos la base y dividimos en 3 conjuntos
#Train, coef y prueba; coef es para tunnear los modelos.
#datos<-read.table("C:/Documents and Settings/Administrador/Mis documentos/Dropbox/escuela/esponda/PROYECTO2/abulonestrain.csv",sep=",",header=TRUE)
datos<-read.table("/Users/PandoraMac/Downloads/abulones.csv",sep=',',header=TRUE)
#num  sex  length	diameter	height	wholeweight	shuckedweight	visceraweight	shellweight	rings	agegroup
datos$sex<-as.factor(datos$sex)
datos$x1<-as.factor(datos$x1)
datos$agegroup<-as.factor(datos$agegroup)

#Dividimos la base
n<-nrow(datos)
set.seed=4646
idbase<-sample(c(1,2,3),size=n,replace=TRUE,prob=c(.5,.2,.3))
base<-data.frame(cbind(datos,idbase))
head(base)
indajuste<-c(1:n)[idbase==1]
indcoef<-c(1:n)[idbase==2]
indprueba<-c(1:n)[idbase==3]
baseajuste<-base[indajuste,]
basecoef<-base[indcoef,]
baseprueba<-base[indprueba,]


################################################################################
#kvecinos
#install.packages("class")
library("class")

#kvecinos<-knn(baseajuste[,-c(1,2,11,12)],basecoef[,-c(1,2,11,12)],cl=baseajuste[,12],k=4,prob=TRUE)
kvecinos<-knn(baseajuste[,-c(1,2,11,12)],baseprueba[,-c(1,2,11,12)],cl=baseajuste[,12],k=4,prob=FALSE)
#

#kvecinos
#summary(kvecinos)
#mean(kvecinos!=basecoef$agegroup) #porciento de mal clasificados
#table(basecoef$agegroup,kvecinos)

################################################################################
#SVM
#install.packages("kernlab")
library(kernlab)

misvm<-ksvm(x=as.matrix(baseajuste[,-c(1,2,3,11,12,13)]),y=baseajuste$agegroup,kernel="rbfdot",C=10,type="C-svc")

  #predichossvm<-predict(misvm,newdata=as.matrix(basecoef[,-c(1,2,3,11,12,13)]),type="response")
predichossvm<-predict(misvm,newdata=as.matrix(baseprueba[,-c(1,2,3,11,12,13)]),type="response")
#  
#Reales 
#   reales<-basecoef$agegroup
#   cat("Valores predichos\n")
#   print(predichossvm)
#   cat("Valores reales\n")
#   print(reales)
#   table(predichossvm,reales)
# 
#   cat("% mal clasificados\n")
#  print(mean(predichossvm!=basecoef$agegroup))

################################################################################
#árbol
#install.packages("rpart")
library("rpart")


arbolito<-rpart(agegroup~sex+x1+x2+x3+x4+x5+x6+x7+x8,data=baseajuste,method="class")
#arbolito
#summary(arbolito)

#predichosarbol<-predict(arbolito,basecoef[,-12],type="class")
predichosarbol<-predict(arbolito,baseprueba[,-12],type="class")

# predichosarbol
# basecoef[,12]
# table(predichosarbol,basecoef[,12])
# mean(predichosarbol!=basecoef$agegroup)

################################################################################
#Combinamos todo, por votos.
resultados<-cbind(as.integer(predichosarbol)-1,as.integer(predichossvm)-1,as.integer(kvecinos)-1)


definitivo<-rowSums(resultados)
definitivo[definitivo==1]<-0
definitivo[definitivo==2]<-1
definitivo[definitivo==3]<-1

table(definitivo,baseprueba$agegroup)
mean(definitivo!=baseprueba$agegroup)

################################################################################
#Combinamos todo, svm y arbol. si no, k vecinos.
def2<-rowSums(resultados[,1:2])
def2<-cbind(def2,resultados[,3])
def3<-def2[,1]
def3[def3==2]<-1
def3[def3==1]<-def2[(def3==1),2]
table(def3,baseprueba$agegroup)
mean(def3!=baseprueba$agegroup)
