# consumercredit-r
An R version of the consumer credit model. Simple logistic regression.

## Platform Info

```
R version 4.1.2 (2021-11-01)
Platform: x86_64-pc-linux-gnu (64-bit)
Running under: Ubuntu 22.04.1 LTS

Matrix products: default
BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.10.0
LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.10.0

locale:
 [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8        LC_COLLATE=C.UTF-8    
 [5] LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8    LC_PAPER=C.UTF-8       LC_NAME=C             
 [9] LC_ADDRESS=C           LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] readr_2.1.3     yardstick_1.1.0 zoo_1.8-11     

loaded via a namespace (and not attached):
 [1] rstudioapi_0.14  magrittr_2.0.3   hms_1.1.2        tidyselect_1.2.0 bit_4.0.5        lattice_0.20-45 
 [7] R6_2.5.1         rlang_1.0.6      fansi_1.0.3      dplyr_1.0.10     tools_4.1.2      parallel_4.1.2  
[13] grid_4.1.2       vroom_1.6.0      utf8_1.2.2       cli_3.4.1        withr_2.5.0      ellipsis_0.3.2  
[19] bit64_4.0.5      tibble_3.1.8     lifecycle_1.0.3  crayon_1.5.2     tzdb_0.3.0       vctrs_0.5.1     
[25] glue_1.6.2       compiler_4.1.2   pillar_1.8.1     generics_0.1.3   jsonlite_1.8.3   pkgconfig_2.0.3 
```

## Running locally
To launch consumer_credit.R, run

```
R
```

Then in the R terminal,
```
source("consumer_credit.R")

library(readr)
library(jsonlite)

init()
```

To produce predictions and write them to file,
```
df_sample = readr::read_csv("sample.csv", show_col_types = FALSE)
write_csv(data.frame(score(df_sample)), "./data/score_output.csv")
```

To compute metrics on scored data and write them to file,
```
metrics_json <- jsonlite::toJSON(metrics(df_sample))
jsonlite::write_json(metrics_json, "metrics_output.json")
```