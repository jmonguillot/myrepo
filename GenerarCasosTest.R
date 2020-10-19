#
# Generar casos de test
#

library(tidyverse)
# library(readxl)

# ruta <- "C:/Users/Joan.Monguillot/Desktop/R/myrepo/"
# filename <- paste(ruta, "ModelTest.xlsx", sep="")
# 
# df <- read_excel(filename)

TCodiPostal <- data.frame( "Classe" = c('G1', 'G2', 'G3'),
                           "Valor"  = c(10, 20, 30))

TEstatCivil <- data.frame( "Classe" = c('S', 'C'),
                           "Valor"  = c(10, 20))

TV3 <- data.frame( "Classe" = c('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'),
                   "Valor"  = c(1, 2, 3, 4, 5, 6, 7, 8))

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

