# Cluster hello

newline

Bootstraps a synthetic GPP series and prints a 95% interval.

## Run
Rscript scripts/cluster_hello.R 200

## Files
scripts/  the analysis code
jobs/     Slurm job scripts
docs/     notes and templates

## Author
Matti Allgaier
newline
Matti Allgaier, 06.11.2026

## Block 4: Data summary report

1. Download the data (student number 01) into `data/raw`:
   in R, run `source("get_my_towers.R")` with `my_student <- "01"`.
2. Install the R packages:
   `install.packages(c("readr", "dplyr", "tidyr", "ggplot2", "knitr", "rmarkdown", "maps"))`
3. Render the report from the project folder:
   `quarto render reports/block4_data_summary.qmd`

The report is written to `reports/block4_data_summary.html`.

## Block 5: The neighbourhood of my five towers

1. Have the Block 4 data in `data/raw` (see above).
2. Set `my_student <- "01"` in `scripts/block5/block5_sites.R`.
3. Install the R packages:
   `install.packages(c("httr2", "jsonlite", "terra", "geodata", "MODISTools", "ecmwfr", "dplyr", "tidyr", "readr", "ggrepel"))`
4. From the project folder, run in R:
   `source("scripts/block5/02_worldclim.R")`,
   `source("scripts/block5/04_soilgrids.R")`,
   `source("scripts/block5/05_planttraits.R")`,
   `source("scripts/block5/07_inaturalist.R")`,
   `source("scripts/block5/08_modis_ndvi_evi.R")`,
   `source("scripts/block5/08b_modis_product_vi.R")`,
   `source("scripts/block5/09_merge.R")`
5. Render the report:
   `quarto render reports/w05_ma447_neighbours.qmd`

On Windows, if the MODIS download fails with an SSL certificate error, add the
line `CURL_SSL_BACKEND=openssl` to `~/.Renviron` and restart R.