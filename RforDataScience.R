#
# =========================
# R for Data Science
# =========================

# Basat en el llibre online https://r4ds.had.co.nz/
# Les solucions als exercicis estan a https://jrnold.github.io/r4ds-exercise-solutions/

library(tidyverse)

# mpg és un data frame dins del package tidyverse. Significa 'miles per gallon'

# Comptatge d'una variable:
mpg %>%count(cty)
  
  
  

# capacitat per eficiència:
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# capacitat per eficiència, mostrant color per classe:
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color=class))

# ... i tamany per cilindrada:
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color=class, size=cyl))

# o transparència:
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha=class))
# Warning message: Using alpha for a discrete variable is not advised. 

# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))



# 3.2.1. Run ggplot(data = mpg). What do you see?
# Nothing, an empty plot.
# 
# 3.2.2. How many rows are in mpg? How many columns?
dim(mpg)
glimpse(mpg)

# 3.2.3. What does the drv variable describe? Read the help for ?mpg to find out.
# The type of drive train, where f = front-wheel drive, r = rear wheel drive, 4 = 4wd

# 3.2.4. Make a scatterplot of hwy vs cyl.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = hwy, y = cyl))

# 3.2.5. What happens if you make a scatterplot of class vs drv? Why is the plot not useful?
  ggplot(data = mpg) + 
  geom_point(mapping = aes(x = class, y = drv))
# There are few points. class and drv are categorical variables. 
# Scatterplots work best for plotting continuous variables.

# Altra manera de visualitzar, amb tamany dels punts:
  ggplot(mpg, aes(x = class, y = drv)) +
    geom_count()

# Altra manera de visualitzar, amb colors:
  mpg %>%
    count(class, drv) %>%
    ggplot(aes(x = class, y = drv)) +
    geom_tile(mapping = aes(fill = n))+
    scale_fill_gradient(low="white", high="blue")
  
# Altra manera de visualitzar, amb colors i completant nulls:
  mpg %>%
    count(class, drv) %>%
    complete(class, drv, fill = list(n = 0)) %>%
    ggplot(aes(x = class, y = drv)) +
    geom_tile(mapping = aes(fill = n))+
    scale_fill_gradient(low="white", high="blue")
  
  
  
# 3.3 Aesthetic mappings

# 3.3.1. What's gone wrong with this code? Why are the points not blue?
  ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy, colour = "blue"))
# Estètica de color que no afecta a les variables. Ha d'estar fora de l'aes:
  ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy), color="blue")

# 3.3.2. Which variables in mpg are categorical? Which variables are continuous?
# Per defecte es considera que les variables de tipus char són categòriques, les de tipus int o dbl són contínues.  
  
# 3.3.4. Map a continuous variable to color, size, and shape. 
# How do these aesthetics behave differently for categorical vs. continuous variables?
  ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy, color=displ, size=displ))
# En general, és redundant. Ens ho podem estalviar perquè no aporta més informació. 
# Per les estètiques color i size funciona, però no per shape.
  
# 3.3.5. What does the stroke aesthetic do? What shapes does it work with? (Hint: use ?geom_point)
  ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy), shape=1, stroke=3)
# Stroke changes the size of the border for shapes. 
  
# 3.3.6. What happens if you map an aesthetic to something other than a variable name, like aes(colour = displ < 5)? Note, you'll also need to specify x and y.  
  ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy, color=displ<5))
# Permet color TRUE/FALSE.
  
  
# Facets, una variable
  ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy)) + 
    # facet_wrap(~ class, nrow = 2)
    facet_wrap(~ class)
  
# Facets, 2 variables
  ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy)) + 
    facet_grid(drv ~ cyl)

  
    
# 3.5 Facets

# 3.5.1. What happens if you facet on a continuous variable?
  ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy)) + 
    facet_grid(. ~ cty)
# Converteix continu a discret.
  
# 3.5.2. What do the empty cells in plot with facet_grid(drv ~ cyl) mean? How do they relate to this plot?
  ggplot(data = mpg) + 
    geom_point(mapping = aes(x = drv, y = cyl))
# A facet_grid(drv ~ cyl) les cel·les buides significa que no existeix cap observació amb la combinació. 
# No hi  apareix cyl=7 xq es considera variable categòrica.
  
# 3.5.3. What plots does the following code make? What does . do?
  ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy)) +
    facet_grid(drv ~ .)
# només files  
  ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy)) +
    facet_grid(. ~ cyl)
# només columnes

  
# 3.5.4. Take the first faceted plot in this section
  ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy)) + 
    facet_wrap(~ class, nrow = 2)
# What are the advantages to using faceting instead of the colour aesthetic? focus on a specific subset, compare easily 2 subsets.
# What are the disadvantages? too many subplots
# How might the balance change if you had a larger dataset? facet could be better
  
# 3.5.5. Read ?facet_wrap. What does nrow do? What does ncol do? 
# What other options control the layout of the individual panels? Why doesn't facet_grid() have nrow and ncol arguments?

# 3.5.6. When using facet_grid() you should usually put the variable with more unique levels in the columns. Why?

  
  
# 3.6. Geometric objects
# ggplot2 provides over 40 geoms, ex: geom_smooth.
  ggplot(data = mpg) + 
    geom_smooth(mapping = aes(x = displ, y = hwy))
  
# separar per categoria, distingir per tipus línia
  ggplot(data = mpg) + 
    geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

# separar per categoria, distingir per color línia
  ggplot(data = mpg) + 
    geom_smooth(mapping = aes(x = displ, y = hwy, color = drv))

# separar per categoria, no distingir tipus línia
  ggplot(data = mpg) +
    geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))
  
# podem fer diversos geoms en el mateix plot:
  ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy)) +
    geom_smooth(mapping = aes(x = displ, y = hwy))
  
# així més elegant:
  ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
    geom_point() +
    geom_smooth()
  
# 3.6.1. What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?
  # line chart: geom_line()
  # boxplot: geom_boxplot()
  # histogram: geom_histogram()
  # area chart: geom_area()  
  
# 3.6.2. Run this code in your head and predict what the output will look like. Then, run the code in R and check your predictions.
  ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
    geom_point() + 
    geom_smooth(se = FALSE)
  
# 3.6.6. Recreate the R code necessary to generate the following graphs.
  ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
    geom_point() +
    geom_smooth(se = FALSE)
  
  ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
    geom_point() +
    geom_smooth(mapping=aes(group=drv), se=FALSE)
  
  ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color=drv)) + 
    geom_point() +
    geom_smooth(se = FALSE)
  
  ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
    geom_point(mapping=aes(color=drv)) +
    geom_smooth(se = FALSE)
  
  ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
    geom_point(mapping=aes(color=drv)) +
    geom_smooth(mapping=aes(linetype=drv), se = FALSE)
  
  ggplot(mpg, aes(x = displ, y = hwy)) +
    geom_point(size = 10, color = "grey") +
    geom_point(aes(colour = drv))

   
     
# 3.7. Statistical transformations
  glimpse(diamonds)
  
  ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut))
  
# 3.7.1. What is the default geom associated with stat_summary()?
# is geom_pointrange
  ggplot(data = diamonds) + 
    geom_pointrange(mapping = aes(x = cut, y=depth), stat = "summary",
                    fun.min = min,
                    fun.max = max,
                    fun = median)

# 3.7.5. In our proportion bar chart, we need to set group = 1.
  ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, y = after_stat(prop), group=1))

    ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, fill = color, y = after_stat(count)/sum(after_stat(count))))
    
    
    
# 3.8 Position adjustments
  ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, fill = clarity))
# a cada pila es sobreposen els colors:  
# The identity position adjustment is more useful for 2d geoms, like points, where it is the default
  ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
   geom_bar(alpha = 1/5, position = "identity")
# queda més clar la position="dodge":
  ggplot(data = diamonds) + 
   geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")
# Amb position="fill" es fan stacked bars al 100%:  
  ggplot(data = diamonds) + 
   geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")
# La position="jitter" va bé quan mostrem punts, lleugerament distorsionant la posició per veure on s'acumulen.

# 3.8.1 What is the problem with this plot? How could you improve it?
  ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
   geom_point()
# millora:
  ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
   geom_point(position="jitter")

# 3.8.4 What's the default position adjustment for geom_boxplot()?
  ggplot(data = mpg) + 
   geom_boxplot(mapping = aes(x = class, y = hwy))
  
  
# 3.9 Coordinate systems  
library(maps)
  nz <- map_data("nz")

  ggplot(nz, aes(long, lat, group = group)) +
   geom_polygon(fill = "white", colour = "black")
  
  ggplot(nz, aes(long, lat, group = group)) +
   geom_polygon(fill = "white", colour = "black") +
   coord_quickmap()

