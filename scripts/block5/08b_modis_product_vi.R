# 08b: Fehlende MODIS-Produktbänder (NDVI, EVI) für den Vergleich mit dem
# selbst berechneten NDVI/EVI nachladen. Gleiche Türme, Zeiträume und
# 9x9-Pixel-Fenster wie 08_modis_ndvi_evi.R; nur Pixel mit reliability 0 oder 1.
library(MODISTools)
library(dplyr)
library(readr)
library(tidyr)

files <- list.files("data/external/modis", pattern = "_mod13q1_pixels\\.csv$",
                    full.names = TRUE)

out <- lapply(files, function(f) {
  px <- read_csv(f, show_col_types = FALSE)
  s  <- px$site[1]
  message("==> ", s, ": downloading MODIS NDVI and EVI bands")

  vi <- mt_subset(product   = "MOD13Q1",
                  band      = c("250m_16_days_NDVI", "250m_16_days_EVI"),
                  lat       = px$latitude[1],
                  lon       = px$longitude[1],
                  start     = as.character(min(px$calendar_date)),
                  end       = as.character(max(px$calendar_date)),
                  km_lr     = 1, km_ab = 1,
                  site_name = s, internal = TRUE, progress = TRUE)

  # Reliability aus dem ersten Download, pro Pixel und Datum
  rel <- px |>
    filter(band == "250m_16_days_pixel_reliability") |>
    transmute(calendar_date = as.Date(calendar_date),
              pixel = as.integer(pixel), rel = value)

  vi |>
    transmute(calendar_date = as.Date(calendar_date),
              pixel = as.integer(pixel),
              band,
              value = as.numeric(value) * as.numeric(scale)) |>
    inner_join(rel, by = c("calendar_date", "pixel")) |>
    filter(rel %in% c(0, 1)) |>
    summarise(value = mean(value, na.rm = TRUE), .by = c(calendar_date, band)) |>
    pivot_wider(names_from = band, values_from = value) |>
    transmute(site_id = s, date = calendar_date,
              modis_ndvi = `250m_16_days_NDVI`,
              modis_evi  = `250m_16_days_EVI`)
})

modis_prod <- bind_rows(out)
write_csv(modis_prod, "data/external/modis/modis_product_vi_my_sites.csv")
message("==> Done. File: data/external/modis/modis_product_vi_my_sites.csv")