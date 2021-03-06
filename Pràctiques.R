#
# =========================
# Pr�ctiques diverses amb R
# =========================

library(tidyverse)

# --------------------------------------------
# Shortcuts
# --------------------------------------------

# Alt -       Inserta el s�mbol <-
# Ctl-Maj-M   Inserta el s�mbol %>%
# 
# Ctl Enter   Executar tot el seleccionat.
# Alt Enter   Executar la l�nia on est� el cursor.
# Ctrl-Maj-C  Comentar l�nies.
# 
# Alt-Maj-K   Mostrar tots els shortcuts.
# Ctl-Alt-K   Des d'on est� el cursor, mostrar les mateixes paraules.
# Ctl 1       Anar a panell Source.
# Ctl 2       Anar a panell Console.
# 
# (x <- filter(df, xxx==1))  Entre par�ntesi, genera resultat i el mostra alhora
  

# --------------------------------------------
# Temes diversos
# --------------------------------------------

# Canviar valor amb mutate.
# Usem el mateix nom de variable, en aquest exemple la variable "name".
x <- mutate(people, name = str_replace(name, "Woods", "Fustes"))


# Validar n�meros propers:
near()
# Exemple:
# sqrt(2) == 2        ==> FALSE
# near(sqrt(2)^2, 2)  ==> TRUE


# Si el nom d'una columna no comen�a amb lletra m'hi he de referenciar amb backstick (`).











# Exercicis del curs d'estad�stica de Cristina
# --------------------------------------------

## 1
xa <- c(-5,7,9,25,130)

# N�meros enters del 10 al 50
xb <- seq(10,50,1)

xc <- seq(10,50,5)

xd <- c(seq(10,50,1), seq(120,150,1))

# 100 n�meros del 0 al 4pi igualment espaiats
xe <- seq(from=0, to=4*pi, length.out=100)

# 100 n�meros a partir del 0 espaiats 0.4
xf <- seq(from=0, by=0.4, length.out=100)

# n�meros enters de 100 a 100, tants com lletres a l'alfabet angl�s
xg <- seq(from=100, by=100, length.out=length(letters))
xg2 <- seq(from=100, by=100, along.with = letters)

# 100 n�meros aleatoris entre 0 i 10.
# llavor 1234 significa que sempre donar� el mateix resultat amb la mateixa llavor
# replace=T significa permetre valors repetits, replace=F han de ser valors diferents
set.seed(1234)
xh <- sample(0:10, size=100, replace=T)
# Versi� amb runif(random uniform distribution)
xh2<-runif(100,0,10)
plot(xh2)

sum(xh)
mean(xh)
sum(xh^2)
sd(xh)   # desviaci� est�ndard

## 2
# Matriu 3x3 amb els primers 9 n�meros, per files
A<- matrix(c(1:9), nrow=3, ncol=3, byrow = T)
# Matriu 3x3 amb els primers 9 n�meros, per columnes
B<- matrix(c(1:9), nrow=3, ncol=3, byrow = F)
# Matriu de 4 columnes amb els primers 100 n�meros parells per files
C <- matrix(seq(from=0, by=2, length.out = 100), ncol=4, byrow=T)
# Matriu diagonal amb els 10 primers n�meros enters
diag(c(1:10))



## 3
# Matriu 4 x 4 amb 16 n�meros arbitraris
A<-matrix(sample(20, size=16, replace=F), nrow=4, ncol=4)
A2<-matrix(1:16, nrow=4)

# Producte de la matriu per ella mateixa
A%*%A

# Definir noms de les columnes
colnames(A) <- c('Col a', 'Col b', 'Col c', 'Col d')

# Extreure submatriu
B<- A[c(1:2), c(2:4)]
B2<- A[1:2, 2:4]

# Comprovar que sigui matriu
is.matrix(B)

# Dimensions de la matriu
dim(B)

# Convertir a data frame
C<-as.data.frame(A)

# Multiplicar data frame per ell mateix
# Cal convertir primer a matrix
as.matrix(C)%*%as.matrix(C)


##4
a<-matrix(1:12, ncol=4)
b<-matrix(21:35, ncol=5)
c<-cbind(a,b)   # es pot combinar xq les matrius tenen el mateix nombre de files
d<-rbind(a,b)   # no es pot combinar

a<-matrix(1:12, ncol=4)
b<-matrix(21:35, ncol=3)
c<-cbind(a,b)   # no es pot combinar
d<-rbind(a,b)   # no es pot combinar

a<-matrix(1:39, ncol=3)
b<-matrix(LETTERS, ncol=2)
c<-cbind(a,b)   # es pot combinar
d<-rbind(a,b)   # no es pot combinar

##5
df <- data.frame(
  "Name" = c('Alex', 'Lilly'),
  "Age"  = c(25,31),
  "Height"=c(177,163),
  "Weight"=c(57,69),
  "Sex"=c('F','F'),
  stringsAsFactors=FALSE)

df2 <- data.frame(
  "Name" = c('Alex', 'Lilly', 'Pepa'),
  "Working"  = c("Yes", "No", "what"),
  stringsAsFactors=FALSE)

df3 <- cbind(df, df2)

typeof(df)
class(df)
str(df)
typeof(df2)
class(df2)
str(df2)




