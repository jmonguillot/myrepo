#
# R for Data Science #3
# Tidy

library(tidyverse)


# 12.3.3 Widen this table.

people <- tribble(
  ~name,             ~names,  ~values,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)

# Aquesta opció no funciona xq l'edat de Phillip està repetida:
people %>%   pivot_wider(names_from = names, values_from = values)

# Solució. Fer un valor únic, p.e. el màxim:
people %>% 
  pivot_wider(names_from = names, values_from = values, values_fn = max)


# 12.3.4 Tidy this table.
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)

preg %>% 
  pivot_longer(c(male, female), names_to = 'sex', values_to = "conta", values_drop_na = TRUE)



x <- mutate(people, name = str_replace(name, "Fustes", "Woods"))
mutate(people, name = str_replace(name, "Woods", "Fustes"))

