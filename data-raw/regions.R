
# Load packages -----------------------------------------------------------

library(dplyr)
library(readr)
library(sf)



# Download raw data -------------------------------------------------------

if (length(list.files("data-raw/regions/")) == 0) {
  tmp <- tempfile(fileext = ".zip")
  download.file("https://www.scb.se/contentassets/3443fea3fa6640f7a57ea15d9a372d33/shape_svenska_240517.zip", tmp, quiet = TRUE)
  unzip(tmp, exdir = "data-raw/regions")
  unlink(tmp)
}



# Unzip data --------------------------------------------------------------

for (zipped_file in list.files("data-raw/regions", full.names = T)) {

  unzip(zipped_file, exdir = "data-raw/regions")

}



# Process data ------------------------------------------------------------

# Clean the "kommun" data
kommuner <-
  sf::st_read("data-raw/regions/Kommun_Sweref99TM.shp") |>
  dplyr::rename("code" = "KnKod",
                "name" = "KnNamn") |>
  dplyr::as_tibble() |>
  sf::st_as_sf()



# Clean the "län" data
lan <-
  sf::st_read("data-raw/regions/Lan_Sweref99TM_region.shp") |>
  dplyr::rename("code" = "LnKod",
                "name" = "LnNamn") |>
  dplyr::mutate(group = dplyr::case_when(
    name %in% c("Blekinge", "Gotlands",  "Hallands",
                "Jönköpings", "Kalmar", "Kronobergs",
                "Skåne", "Småland", "Västra Götalands",
                "Östergötlands") ~ "Götaland",
    name %in% c("Dalarnas", "Stockholms", "Södermanlands",
                "Uppsala", "Värmlands", "Västmanlands",
                "Örebro") ~ "Svealand",
    name %in% c( "Gävleborgs", "Jämtlands", "Norrbottens",
                 "Västerbottens", "Västernorrlands") ~ "Norrland",
    .default = NA
  )) |>
  dplyr::relocate("group", .before = 3) |>
  dplyr::as_tibble() |>
  sf::st_as_sf()



# Merge polygons for "landsdel" groupings
landsdelar <-
  lan |>
  dplyr::summarize(geometry = sf::st_union(geometry), .by = c(group)) |>
  dplyr::rename("name" = group) |>
  dplyr::as_tibble() |>
  sf::st_as_sf()



# Clean the "lokal arbetsmarknad" data
lokal_arbetsmarknad <-
  sf::st_read("data-raw/regions/LAomraden_2022.shp") |>
  dplyr::rename("code" = "Lakod",
                "name" = "Namn") |>
  dplyr::as_tibble() |>
  sf::st_as_sf()



# Save data ---------------------------------------------------------------

usethis::use_data(kommuner, compress = "xz", overwrite = T)
usethis::use_data(lan, compress = "xz", overwrite = T)
usethis::use_data(landsdelar, compress = "xz", overwrite = T)
usethis::use_data(lokal_arbetsmarknad, compress = "xz", overwrite = T)



# Remove raw data ---------------------------------------------------------

for (f in list.files("data-raw/regions/", full.names = T)) {

  unlink(f)

}
