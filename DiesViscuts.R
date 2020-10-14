#
# --------------------------------------------------------
#  Calcular els dies viscuts a partir de la data naixement
# --------------------------------------------------------

library(tidyverse)
library(data.table)
library(openxlsx)
library(lubridate)

# Opció 1. Crear dataframe a partir d'un excel
filename = "C:/Users/Joan.Monguillot/Desktop/R/noms.xlsx"
df <- read.xlsx(filename, colNames = TRUE, detectDates = TRUE)


# Opció 2. Crear un dataframe en buit:
df <- data.frame(Nom=character(),
                 DataNaixement=as.Date(character()),
                 stringsAsFactors=FALSE) 
# Afegir files al dataframe:
df <- add_row(df, Nom = "Marc", DataNaixement = as.Date("1993-10-02"))


# Opció 3. Crear un tibble:
tbck <- tribble(
  ~Nom,        ~DataNaixement,
  #-----------|--------------------
  "Joan",      as.Date("1961-01-30"),
  "Cristina",  as.Date("1963-12-01"),
  "Marc",      as.Date("1993-10-02"),
  "Sergi",     as.Date("1998-07-27"),
  "Lurdes",    as.Date("1959-09-23"),
  "Josep",     as.Date("1962-05-15"),
  "Aleix",     as.Date("1967-05-17"),
  "Oriol",     as.Date("1968-12-13"),
  "Muntsa",    as.Date("1970-07-21"),
  "Èlia",      as.Date("1992-02-14"),
  "Pau",       as.Date("1994-05-14"),
  "Ester",     as.Date("1965-02-26"),
  "Marta",     as.Date("1996-04-12"),
  "Max",       as.Date("1999-10-29"),
  "LluísPa",   as.Date("1970-01-11"),
  "LluísFi",   as.Date("2001-05-03"),
  "Ariadna",   as.Date("2006-01-02"),
  "Tieta",     as.Date("1932-10-07"),
  "To",        as.Date("1960-02-25"),
)

t <- tribble(
  ~Nom,        ~DataNaixement,
  #-----------|--------------------
  "Jn", as.Date("1961-01-30"),
  "Cr", as.Date("1963-12-01"),
  "Mc", as.Date("1993-10-02"),
  "Se", as.Date("1998-07-27"),
  "Lu", as.Date("1959-09-23"),
  "Jp", as.Date("1962-05-15"),
  "Al", as.Date("1967-05-17"),
  "Or", as.Date("1968-12-13"),
  "Mu", as.Date("1970-07-21"),
  "Èl", as.Date("1992-02-14"),
  "Pa", as.Date("1994-05-14"),
  "Es", as.Date("1965-02-26"),
  "Mt", as.Date("1996-04-12"),
  "Mx", as.Date("1999-10-29"),
  "LP", as.Date("1970-01-11"),
  "LF", as.Date("2001-05-03"),
  "Ar", as.Date("2006-01-02"),
  "TT", as.Date("1932-10-07"),
  "To", as.Date("1960-02-25"),
)


# Calcular dies viscuts
t <- mutate(t,
            DiesViscuts     = as.numeric(difftime(today(), DataNaixement, units = "days")),
            SegonsViscuts   = as.numeric(difftime(now(), DataNaixement, units = "secs")),
            FaltenDiesMiler = 1000 - DiesViscuts %% 1000,
            ProperMiler     = DiesViscuts + FaltenDiesMiler,
            DataProperMiler = DataNaixement + DiesViscuts + FaltenDiesMiler
            # FaltenSegs100M  = 100000000 - trunc(SegonsViscuts %% 100000000)
)

View(t)

x <- 3400
y <- 1000 - x %% 1000
