
# Load packages -----------------------------------------------------------

library(dplyr)
library(sf)



# Download raw data -------------------------------------------------------

if (length(list.files("data-raw/scb_cities")) == 0) {
  tmp <- tempfile(fileext = ".zip")
  download.file("https://www.scb.se/contentassets/3ee03ca6db1e48ff808b3c8d2c87d470/tatorter_1980_20202.zip", tmp, quiet = TRUE)
  unzip(tmp, exdir = "data-raw/scb_cities")
  unlink(tmp)
}



# Process data ------------------------------------------------------------

tatorter <-
  sf::st_read("data-raw/scb_cities/Tatorter_1980_2020.gpkg", layer = "To2020_SR99TM") |>
  dplyr::rename("id" = "OBJECTID",
                "uu_id" = "UUID",
                "code" = "TATORTSKOD",
                "name" = "TATORT",
                "mun_code" = "KOMMUN",
                "mun_name" = "KOMMUNNAMN",
                "lan_code" = "LAN",
                "lan_name" = "LANNAMN",
                "area" = "AREA_HA",
                "pop" = "BEF",
                "year" = "AR",
                "x" = "X_koord",
                "y" = "Y_koord",
                "geometry" = "geom") |>
  dplyr::as_tibble() |>
  dplyr::select(-c("ValidFrom", "ValidTo", "geometry")) |>
  sf::st_as_sf(coords = c("x", "y"), crs = 3006)



# Save data ---------------------------------------------------------------

usethis::use_data(tatorter, compress = "xz", overwrite = T)



# Remove raw data ---------------------------------------------------------

for (f in list.files("data-raw/scb_cities/", full.names = T)) {

  unlink(f)

}
