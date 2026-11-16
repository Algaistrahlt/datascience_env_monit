library(readr)
library(dplyr)

# Nur diese Spalten einlesen (die Datei hat hunderte)
keep <- c("TIMESTAMP_START", "TIMESTAMP_END", "TA_F", "SW_IN_F", "VPD_F", "P_F",
          "NETRAD", "G_F_MDS", "H_F_MDS", "H_F_MDS_QC", "LE_F_MDS", "LE_F_MDS_QC",
          "NEE_VUT_REF", "NEE_VUT_REF_QC", "GPP_NT_VUT_REF", "RECO_NT_VUT_REF")

# Erste zip-Datei nehmen und darin die Halbstunden-Datei (HH) finden
zip_file <- list.files("data/raw", pattern = "\\.zip$", full.names = TRUE)[1]
hh_name  <- grep("FLUXMET_HH", unzip(zip_file, list = TRUE)$Name, value = TRUE)
unzip(zip_file, files = hh_name, exdir = "data/raw/unzipped")

# Einlesen: -9999 = fehlender Wert, Zeitstempel als Text, Rest als Zahl
hh <- read_csv(file.path("data/raw/unzipped", hh_name),
               na = "-9999",
               col_select = any_of(keep),
               col_types = cols(TIMESTAMP_START = "c", TIMESTAMP_END = "c", .default = "d")) |>
  mutate(time = as.POSIXct(TIMESTAMP_START, format = "%Y%m%d%H%M", tz = "UTC"))

# ---- Checks ----
zip_file                                   # welche Datei?
nrow(hh)                                   # wie viele Zeilen?
range(hh$time)                             # von wann bis wann?
table(format(hh$time, "%Y"))               # Zeilen pro Jahr (17520 bzw. 17568)
sum(duplicated(hh$time))                   # doppelte Zeitstempel? sollte 0 sein
summary(hh$TA_F)                           # Lufttemperatur in °C, kein -9999
mean(hh$NEE_VUT_REF_QC == 0, na.rm = TRUE) # Anteil echt gemessener NEE-Werte


