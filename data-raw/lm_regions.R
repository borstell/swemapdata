# Load packages -----------------------------------------------------------

library(dplyr)
library(sf)
library(geojsonsf)
library(nngeo)



# Download raw data -------------------------------------------------------

# Free geodata from Lantmäteriet can be downloaded from:
# https://geotorget.lantmateriet.se
# Note that this only works as a registered user, but the data is CC0:
# https://www.lantmateriet.se/sv/geodata/vara-produkter/oppna-data#anchor-0

# Landskap borders from Lantmäteriet (originally CC0) were originally
# downloaded from https://github.com/perliedman/svenska-landskap and modified
# as GeoJSON format and released under a CC0 license


# Read data ---------------------------------------------------------------

# Clean the "distrikt" data
distrikt <-
  sf::st_read("data-raw/lm_regions/distrikt.gpkg") |>
  dplyr::rename("code" = "distriktskod",
                "name" = "distriktsnamn",
                "geometry" = "SHAPE") |>
  dplyr::select("code", "name", "geometry") |>
  dplyr::as_tibble() |>
  sf::st_as_sf()



# Clean the "socknar" data
socknar <-
  sf::st_read("data-raw/lm_regions/sockenstad.gpkg") |>
  dplyr::rename("code" = "sockenstadkod",
                "name" = "sockenstadnamn",
                "area_id" = "omradesnummer",
                "main_area" = "huvudomrade",
                "geometry" = "SHAPE") |>
  dplyr::mutate(main_area = dplyr::case_when(
    main_area == "J" ~ TRUE,
    main_area == "N" ~ FALSE,
    .default = NA
  )) |>
  dplyr::select("code", "name", "area_id", "main_area", "geometry") |>
  dplyr::as_tibble() |>
  sf::st_as_sf()



# Clean the "landskap" data
landskap <-
  geojsonsf::geojson_sf("data-raw/lm_regions/landskap.geo.json") |>
  dplyr::rename("code" = "landskapskod",
                "name" = "landskap",
                "landsdel_code" = "landsdelskod",
                "landsdel_name" = "landsdel") |>
  dplyr::as_tibble() |>
  sf::st_as_sf()



# Clean the "landsdelar" data
landsdelar <-
  landskap |>
  dplyr::summarize(geometry = sf::st_union(geometry), .by = c(landsdel_code, landsdel_name)) |>
  dplyr::rename("code" = "landsdel_code",
                "name" = "landsdel_name") |>
  dplyr::as_tibble() |>
  sf::st_as_sf() |>
  nngeo::st_remove_holes()



# Save data ---------------------------------------------------------------

usethis::use_data(distrikt, compress = "xz", overwrite = T)
usethis::use_data(socknar, compress = "xz", overwrite = T)
usethis::use_data(landskap, compress = "xz", overwrite = T)
usethis::use_data(landsdelar, compress = "xz", overwrite = T)



# Remove raw data ---------------------------------------------------------

for (f in list.files("data-raw/lm_regions/", full.names = T, pattern = "gpkg$")) {

  unlink(f)

}
