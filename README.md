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