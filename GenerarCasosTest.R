#
# Generar casos de test
#

library(tidyverse)
library(data.table)  # per al fread / fwrite
options(scipen=999)  # Evitar notacio cientifica



# Opció 1. Recorregut clàssic en bucle.

# Definir una taula per cada indicador.
TCodiPostal <- data.frame( "Classe" = c('G1', 'G2', 'G3'),
                           "Valor"  = c(10, 20, 30))

TEstatCivil <- data.frame( "Classe" = c('S', 'C'),
                           "Valor"  = c(10, 20))
TV3 <- data.frame( "Classe" = c('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'),
                   "Valor"  = c(1, 2, 3, 4, 5, 6, 7, 8))

# Fem un recorregut clàssic per cada taula per obtenir producte cartesià.
df<-data.frame()

for (v1 in 1:nrow(TCodiPostal)) {
  CodiPostal <- TCodiPostal[v1, "Classe"]
  CPv <- TCodiPostal[v1, "Valor"]
# 
  for (v2 in 1:nrow(TEstatCivil)) {
    EstatCivil <- TEstatCivil[v2, "Classe"]
    ECv <- TEstatCivil[v2, "Valor"]
    #
    for (v3 in 1:nrow(TV3)) {
      CV3 <- TV3[v3, "Classe"]
      VV3 <- TV3[v3, "Valor"]
      #
      Valor <- CPv + ECv + VV3
      df <- rbind(df, c(CodiPostal, EstatCivil, CV3, Valor))
# 
    }
  }
}
colnames(df) <- c('CodiPostal', 'EstatCivil', 'TV3', 'Valor')



# Opció 2. Tècnica expand.grid .

# Definir taula de classe i taula de valor per cada indicador.
CodiPostal_C <- c('G1', 'G2', 'G3')
CodiPostal_V <- c(10, 20, 30) 

EstatCivil_C <- c('S', 'C')
EstatCivil_V <- c(10, 20)

TV3_C <- c('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H')
TV3_V <- c(1, 2, 3, 4, 5, 6, 7, 8)

# Fer el producte cartesià de classes.
model <- expand.grid(CodiPostal=CodiPostal_C, 
                     EstatCivil=EstatCivil_C,
                     TV3=TV3_C)

# Fer el producte cartesià de valors.
df3 <- expand.grid(CodiPostal=CodiPostal_V, 
                   EstatCivil=EstatCivil_V,
                   TV3=TV3_V)

# Calcular el valor total de cada combinació.
df3 <- mutate(df3,Total=
                CodiPostal +
                EstatCivil +
                TV3
                )

# Afegir el valor total al model
model <- mutate(model, Total=df3["Total"])



# Substituir una columna d'un df pels valors d'una altra columna

# Definir df1 amb 1 fila i 5 columnes 
df1 <- data.frame("A" = c(1), "B" = c(2), "C" = c(3), "D" = c(4), "E" = c(5))

# Definir df amb 1 columna i múltiples observacions
# df2 <- data.frame("Z" = c(10,20,30))
df2 <- data.frame("Z" = seq(from=1, length.out=1000))

# replicar la fila del df1 tants cops com files tingui el df2
df1 <- bind_rows(replicate(nrow(df2), df1, simplify = FALSE))

# canviar una columna de df1 amb els valors de df2
df1$A <- df2$Z







deltaname <- "DELTACCFPT_20201018.csv"
delta <- fread(deltaname, integer64 = "numeric", keepLeadingZeros = TRUE, fill=TRUE, sep=",")

# Filtrar una fila
# Hem d'usar backsticks quan els noms de columna tenen espais.
df <- 
  delta %>% 
  filter(`EntradaSDS.SOLICITUD.Fecha primera entrada` == `EntradaSDS.SOLICITUD.Fecha de ultima entrada`
       & `SalidaSDS.RESULTADOS.Decision sistema` == "A") %>% 
  head(1)


# Columnes del delta
names(delta)

# Filtrar noms de columnes del delta
grep("sistema", names(delta), value = TRUE)

# Distribució d'una variable (count)
delta %>% 
  count(`SalidaSDS.RESULTADOS.Decision sistema`)




filename1 <- "PM_Todo_input.csv"



# Desar el fitxer manipulat

fwrite(delta, filename1)

