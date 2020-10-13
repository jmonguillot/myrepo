#
# R for Data Science #2
# Data transformation

library(nycflights13)
library(tidyverse)
library(xlsx)
# library(ggvis) # ampliació de ggplot amb opcions interacives i HTML.

?flights

# FILTER
# 5.2.1 
#1. Flights that:
# had an arrival delay of two or more hours
filter(flights, arr_delay >= 120)  # 10200

# Flew to Houston (IAH or HOU)
filter(flights, dest %in% c('IAH', 'HOU'))  # 9313

# Were operated by United, American, or Delta
filter(airlines, grepl("United", name) | grepl("American", name) | grepl("Delta", name))
filter(flights, carrier %in% c('AA', 'DL', 'UA'))  # 139504

# Departed in summer (July, August, and September)
filter(flights, month %in% c(7, 8, 9))  # 86326
filter(flights, month %in% c(7:9))  # 86326

# Arrived more than two hours late, but didn't leave late
filter(flights, dep_delay <= 0 & arr_delay > 120)  #29

# Were delayed by at least an hour, but made up over 30 minutes in flight
filter(flights, dep_delay >= 60 & (dep_delay - arr_delay) > 30)  #1844

# Departed between midnight and 6am (inclusive)
filter(flights, between(dep_time, 0, 600) | dep_time == 2400)  # 9373

# 5.2.3. How many flights have a missing dep_time
count(filter(flights, is.na(dep_time))) #8255

#What other variables are missing?
summary(flights)



# ARRANGE
# 5.3.1. How could you use arrange() to sort all missing values to the start? (Hint: use is.na()).
arrange(flights, desc(is.na(dep_time)))
# Això és perquè is.na() retorna TRUE o FALSE. Es posiciona primer perquè TRUE > FALSE.

# Sort flights to find the most delayed flights. Find the flights that left earliest.
arrange(flights, desc(dep_delay))

# Sort flights to find the fastest (highest speed) flights.
x <- arrange(flights, desc(distance/air_time))

# Which flights travelled the farthest? Which travelled the shortest?
x <- arrange(flights, desc(distance))
x <- arrange(flights, distance)
filter(airports, faa=='PHL')



# SELECT
# seleccionar totes les columnes excepte algunes
select(flights, -(year:day))

# selecciona columnes que el nom contingui un string
select(flights, contains('time'))
# selecciona columnes que el nom comença amb un string
select(flights, starts_with('dep'))
# selecciona una columna al principi i tota la resta
select(flights, time_hour, everything())


# 5.4.2 What happens if you include the name of a variable multiple times in a select() call?
select(flights, air_time, air_time)

# 5.4.3 What does the any_of() function do? Why might it be helpful in conjunction with this vector?
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, all_of(vars))
select(flights, any_of(vars))

# 5.4.4 How do the select helpers deal with case by default
select(flights, contains("TIME", ignore.case = FALSE))



# MUTATE
# puc afegir variables amb tota mena de funcions, inclosa agregació o anàlisi.
x <- head(select(flights, air_time), 5)
y <- mutate(x, total = sum(air_time), min_rank((air_time)))


# 5.5.2 Currently dep_time and sched_dep_time are convenient to look at, but hard to compute with because they're not really continuous numbers. 
# Convert them to a more convenient representation of number of minutes since midnight.

x <- select(flights, dep_time, sched_dep_time)
x <- mutate(x, 
            dep_minuts = (( (dep_time%%2400) %/%100) * 60) + dep_time%%100,
            sched_dep_minuts = (( (sched_dep_time%%2400) %/%100) * 60) + sched_dep_time%%100)

# Altra opció, del llibre de solucions:
x <- mutate(x, 
            web_minuts = (dep_time %/% 100 * 60 + dep_time %% 100) %% 1440)

# Millor encara, usar una funció:
time2mins <- function(x) {
  (x %/% 100 * 60 + x %% 100) %% 1440
}
x <- select(flights, dep_time)
x <- mutate(x, 
            web_minuts = time2mins(dep_time))



# 5.5.3 Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What do you need to do to fix it?
x <- select(flights, dep_time, arr_time, air_time)
# Convertir a minuts:
x <- mutate(x, 
       dep_minuts = time2mins(dep_time),
       arr_minuts = time2mins(arr_time),
       diff = arr_minuts - dep_minuts,
       air_time_diff = air_time - diff)
# Aquí falla pel canvi de dia. Pendent de resoldre!
y <- filter(x, arr_time < dep_time)


# 5.5.4 Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?
x <- select(flights, dep_time, sched_dep_time, dep_delay)
x <- mutate(x, 
            dep_minuts = time2mins(dep_time),
            sched_dep_minuts = time2mins(sched_dep_time),
            diff = dep_minuts - sched_dep_minuts,
            qa = diff - dep_delay)
y <- filter(x, qa!=0)
ggplot(y, 
       mapping = aes(x = qa, y = sched_dep_minuts)) + 
  geom_point()
  
# 5.5.5 Find the 10 most delayed flights using a ranking function. 
# How do you want to handle ties? Carefully read the documentation for min_rank()
arrange(flights, desc(dep_delay))
x <- mutate(flights, posicio=min_rank(desc(dep_delay)))
arrange(filter (x, posicio <= 10), posicio)


# SUMMARISE
by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm=TRUE))

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)

# millor usant la pipa:
delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

ggplot(delays, mapping = aes(x=dist, y=delay)) +
  geom_point(aes(size=count), alpha=1/3) +
  geom_smooth(se=FALSE)

# eliminar valors nuls:
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

# afegir un rang pel dep_time, agrupant per dia.
x <- not_cancelled %>% 
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time)))

y <- filter(x, month==12, day==2)

# Afegir un rang pel dep_time, agrupant per dia. Mostrar el primer i el darrer (range retorna dos valors)
x <- not_cancelled %>% 
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time))) %>% 
  filter(r %in% range(r))

y <- filter(x, month==1)

# Usar el distinct
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))


# COUNT
not_cancelled %>% 
  count(carrier)
# és equivalent a 
not_cancelled %>% 
  group_by(carrier) %>%
  summarise(count = n())
# o també a 
not_cancelled %>% 
  group_by(carrier) %>%
  summarise(count = length(carrier))
# o també a 
not_cancelled %>% 
  group_by(carrier) %>%
  tally()
# ordenar pel comptatge
not_cancelled %>% 
  count(carrier, sort=TRUE)


# se li pot afegir un weight per sumar alguna altra variable
not_cancelled %>% 
  count(tailnum, wt=distance) %>%
  arrange(desc(n))

# Comptatge amb condicions. 
# El valor lògic es transforma en 1 o 0. Així no cal afegir variables amb MUTATE.
not_cancelled %>% 
  group_by(dest) %>% 
  summarise( x = sum(dep_time < 500))


# Proporció de casos. Aquí s'usa la funció mean.
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(hour_prop = mean(arr_delay > 60))



# 5.6.1 
# A flight is 15 minutes early 50% of the time, and 15 minutes late 50% of the time.
x <- not_cancelled %>% 
  group_by(carrier, flight) %>% 
  count()
  
x <- filter(not_cancelled, carrier=='9E', flight==3416)
write.xlsx(x, "C:/Users/Joan.Monguillot/Desktop/R/xxx.xlsx")

x <- arrange(select(flights, carrier, flight, origin, dest), carrier, flight)
x <- filter(flights, month==10, day==3, origin=='JFK') %>% arrange(desc(carrier))
x <- filter(flights, tailnum=='N522MQ')



df <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay)) %>%
  select(time_hour, carrier, flight, arr_delay)

# vols que estan per sota la mediana de -15 minuts
ex1 <- df %>%
  group_by(carrier, flight) %>%
  summarise (conta = n(), 
             md = median(arr_delay)) %>%
  filter(conta >= 25, md <= -15)

# vols que estan per sobre de la mediana de +15 minuts
ex2 <- df %>%
  group_by(carrier, flight) %>%
  summarise (conta = n(), 
             md = median(arr_delay)) %>%
  filter(conta >= 25, md >= 15)

# vols que sempre té +10 minuts de retard
ex3 <- df %>%
  group_by(carrier, flight) %>%
  mutate(r = min_rank(arr_delay), conta = n() ) %>%
  filter(r == 1, arr_delay >= 10) %>%
  arrange(carrier, flight, r)
  
# vols amb 99% de puntualitat
ex4 <- df %>%
  group_by(carrier, flight) %>%
  mutate(pr = percent_rank(arr_delay), conta = n() ) %>%
#   filter(r == 1, arr_delay >= 10) %>%
  filter(pr >= 0.99, arr_delay <= 0) %>%
  arrange(carrier, flight, pr)


# 5.6.4 Look at the number of cancelled flights per day. 
# Is there a pattern? Is the proportion of cancelled flights related to the average delay?
z <- filter(flights, month==1, day==1)

x <- flights %>%
  group_by(year, month, day) %>%
  summarise(total = n(),
            cancelats = sum(is.na(arr_delay)),
            temps_mig_delay = mean(arr_delay, na.rm=TRUE)
            )

filter(x, between(cancelats,5,300)) %>%
ggplot(x,
       mapping = aes(x = cancelats, y = temps_mig_delay)) + 
  geom_point(alpha=0.2, color="blue") +
  geom_smooth(se = FALSE, color="green")

# solució del llibre
x <- flights %>%
  mutate(cancelat = is.na(arr_delay)) %>%
  group_by(year, month, day) %>%
  summarise(
    cancelats_perc = mean(cancelat),
    temps_mig_delay = mean(arr_delay, na.rm=TRUE)    
  ) %>%
  ungroup()
  
ggplot(x) +
  geom_point(aes(x = temps_mig_delay, y=cancelats_perc))


# 5.6.5. Which carrier has the worst delays?
flights %>%
  group_by(carrier) %>%
  summarise (md = mean(arr_delay, na.rm=TRUE)) %>%
  filter (md == max(md))



# 5.7 Grouped mutates and filters
# trobar els x pitjors de cada grup
flights %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) <= 3)

# 5.7.2. Which plane (tailnum) has the worst on-time record?
x <- flights %>%
  filter(!is.na(arr_delay)) %>%
  group_by(tailnum) %>%
  summarise (md = mean(arr_delay, na.rm=TRUE)) %>%
  filter (md == max(md))

# 5.7.3. What time of day should you fly if you want to avoid delays as much as possible?
x <- flights %>%
  filter(!is.na(arr_delay)) %>%
  group_by(hour) %>%
  summarise (md = mean(arr_delay, na.rm=TRUE)) %>%
  filter (md == min(md))

# 5.7.4. For each destination, compute the total minutes of delay.
x <- flights %>%
  filter(!is.na(arr_delay)) %>%
  group_by(dest) %>%
  summarise (total_delay = sum(arr_delay, na.rm=TRUE))

# For each flight, compute the proportion of the total delay for its destination.  
y <- flights %>%
  filter(!is.na(arr_delay)) %>%
  select (carrier, flight, dest, arr_delay) %>%
  group_by(dest) %>%
  mutate(total_delay_dest = sum(arr_delay)) %>%
  group_by(carrier, flight, dest, total_delay_dest) %>%
  summarise(partial_delay_dest = sum(arr_delay)) %>%
  mutate(prop_delay = partial_delay_dest / total_delay_dest)

# 5.7.7. Find all destinations that are flown by at least two carriers. 
# Use that information to rank the carriers
x <- flights %>%
  filter(!is.na(arr_delay)) %>%
  group_by(dest) %>%
  summarise (carriers = n_distinct(carrier)) %>%
  filter(carriers > 1)
  

