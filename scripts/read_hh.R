library(readr)
library(dplyr)

keep_vars <- c("TIMESTAMP_START", "TIMESTAMP_END", "TA_F", "SW_IN_F", "VPD_F", "P_F",
               "NETRAD", "G_F_MDS", "H_F_MDS", "H_F_MDS_QC", "LE_F_MDS", "LE_F_MDS_QC",
               "NEE_VUT_REF", "NEE_VUT_REF_QC", "NEE_CUT_REF", "NEE_CUT_REF_QC",
               "GPP_NT_VUT_REF", "RECO_NT_VUT_REF", "GPP_NT_CUT_REF", "RECO_NT_CUT_REF",
               "GPP_DT_VUT_REF", "RECO_DT_VUT_REF", "GPP_DT_CUT_REF", "RECO_DT_CUT_REF")

read_hh <- function(zip_file, keep = keep_vars) {
  site <- strsplit(basename(zip_file), "_")[[1]][2]

  hh_name <- grep("FLUXMET_HH", unzip(zip_file, list = TRUE)$Name, value = TRUE)
  unzip(zip_file, files = hh_name, exdir = "data/raw/unzipped")

  d <- read_csv(file.path("data/raw/unzipped", hh_name),
                na = "-9999",
                col_select = any_of(keep),
                col_types = cols(TIMESTAMP_START = "c", TIMESTAMP_END = "c", .default = "d"),
                show_col_types = FALSE)

  # Hilfsfunktion: gibt es die Spalte UND stehen Werte drin?
  has_data <- function(col) col %in% names(d) && any(!is.na(d[[col]]))

  # 1. VUT nehmen, wenn vorhanden, sonst CUT
  ustar <- if (has_data("NEE_VUT_REF")) "VUT" else "CUT"
  # 2. Nacht-Methode (NT) nehmen, wenn vorhanden, sonst Tag-Methode (DT)
  partition <- if (has_data(paste0("GPP_NT_", ustar, "_REF"))) "NT" else "DT"

  d |>
    mutate(site      = site,
           time      = as.POSIXct(TIMESTAMP_START, format = "%Y%m%d%H%M", tz = "UTC"),
           ustar     = ustar,
           partition = partition,
           NEE    = .data[[paste0("NEE_", ustar, "_REF")]],
           NEE_QC = .data[[paste0("NEE_", ustar, "_REF_QC")]],
           GPP    = .data[[paste0("GPP_",  partition, "_", ustar, "_REF")]],
           RECO   = .data[[paste0("RECO_", partition, "_", ustar, "_REF")]],
           .before = 1) |>
    select(-starts_with(c("NEE_VUT", "NEE_CUT", "GPP_", "RECO_")))
}
