Calcular dies
================
Joan
13/10/2020

## Codi

Carregar la taula amb les dates.

``` r
library(tidyverse)
```

    ## -- Attaching packages ------------------------------------------------------------------------------------------ tidyverse 1.3.0 --

    ## v ggplot2 3.3.2     v purrr   0.3.4
    ## v tibble  3.0.3     v dplyr   1.0.2
    ## v tidyr   1.1.2     v stringr 1.4.0
    ## v readr   1.3.1     v forcats 0.5.0

    ## -- Conflicts --------------------------------------------------------------------------------------------- tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(lubridate)
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following objects are masked from 'package:base':
    ## 
    ##     date, intersect, setdiff, union

``` r
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
```

Calcular els dies.

``` r
t <- mutate(t,
            DiesViscuts     = as.numeric(difftime(today(), DataNaixement, units = "days")),
            SegonsViscuts   = as.numeric(difftime(now(), DataNaixement, units = "secs")),
            FaltenDiesMiler = 1000 - DiesViscuts %% 1000,
            ProperMiler     = DiesViscuts + FaltenDiesMiler,
            DataProperMiler = DataNaixement + DiesViscuts + FaltenDiesMiler
            # FaltenSegs100M  = 100000000 - trunc(SegonsViscuts %% 100000000)
)
```

Mostrar el resultat.

``` r
print(t)
```

    ## # A tibble: 19 x 7
    ##    Nom   DataNaixement DiesViscuts SegonsViscuts FaltenDiesMiler ProperMiler
    ##    <chr> <date>              <dbl>         <dbl>           <dbl>       <dbl>
    ##  1 Jn    1961-01-30          21807   1884165032.             193       22000
    ##  2 Cr    1963-12-01          20772   1794741032.             228       21000
    ##  3 Mc    1993-10-02           9874    853153832.             126       10000
    ##  4 Se    1998-07-27           8115    701176232.             885        9000
    ##  5 Lu    1959-09-23          22302   1926933032.             698       23000
    ##  6 Jp    1962-05-15          21337   1843557032.             663       22000
    ##  7 Al    1967-05-17          19509   1685617832.             491       20000
    ##  8 Or    1968-12-13          18933   1635851432.              67       19000
    ##  9 Mu    1970-07-21          18348   1585307432.             652       19000
    ## 10 Èl    1992-02-14          10470    904648232.             530       11000
    ## 11 Pa    1994-05-14           9650    833800232.             350       10000
    ## 12 Es    1965-02-26          20319   1755601832.             681       21000
    ## 13 Mt    1996-04-12           8951    773406632.              49        9000
    ## 14 Mx    1999-10-29           7656    661518632.             344        8000
    ## 15 LP    1970-01-11          18539   1601809832.             461       19000
    ## 16 LF    2001-05-03           7104    613825832.             896        8000
    ## 17 Ar    2006-01-02           5399    466513832.             601        6000
    ## 18 TT    1932-10-07          32149   2777713832.             851       33000
    ## 19 To    1960-02-25          22147   1913541032.             853       23000
    ## # ... with 1 more variable: DataProperMiler <date>
