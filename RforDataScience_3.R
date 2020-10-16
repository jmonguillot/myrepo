#
# ---------------------------------------------------
# R for Data Science #3
# ---------------------------------------------------

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


# 12.6.1. I claimed that iso2 and iso3 were redundant with country. Confirm this claim.
who %>% 
  group_by(country) %>%
  summarise(count2 = n_distinct(iso2), count3 = n_distinct(iso3)) %>% 
  filter(count2 != 1 | count3 != 1)

# altra opció del llibre de solucions
select(who, country, iso2, iso3) %>% 
  distinct() %>% 
  group_by(country) %>% 
  filter(n() != 1)
  


# 12.6.2 For each country, year, and sex compute the total number of cases of TB.
# Make an informative visualisation of the data

# aquesta és la neteja que es fa al llibre:
who2 <- 
who %>%
  pivot_longer(
    cols = new_sp_m014:newrel_f65, 
    names_to = "key", 
    values_to = "cases", 
    values_drop_na = TRUE
  ) %>% 
  mutate(
    key = stringr::str_replace(key, "newrel", "new_rel")
  ) %>%
  separate(key, c("new", "var", "sexage")) %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(sexage, c("sex", "age"), sep = 1)

# nombre de casos
resum <- 
  who2 %>% 
  filter(var != "sn") %>% 
  group_by(country, year, sex) %>% 
  summarise(cases = sum(cases))


resum %>%
  # filter(country == "Costa Rica") %>% 
  filter(year > 1995) %>% 
  group_by(year, sex) %>% 
  summarise(cases = sum(cases)) %>% 
  ggplot(aes(x = year, y = cases, color=sex)) + 
  geom_line()

