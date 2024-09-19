
# Load packages -----------------------------------------------------------

library(dplyr)
library(sf)



# Download raw data -------------------------------------------------------

if (length(list.files("data-raw/scb_regions/")) == 0) {
  tmp <- tempfile(fileext = ".zip")
  download.file("https://www.scb.se/contentassets/3443fea3fa6640f7a57ea15d9a372d33/shape_svenska_240517.zip", tmp, quiet = TRUE)
  unzip(tmp, exdir = "data-raw/scb_regions")
  unlink(tmp)
}



# Unzip data --------------------------------------------------------------

for (zipped_file in list.files("data-raw/scb_regions", full.names = T)) {

  unzip(zipped_file, exdir = "data-raw/scb_regions")

}



# Process data ------------------------------------------------------------

# Clean the "kommun" data
kommuner <-
  sf::st_read("data-raw/scb_regions/Kommun_Sweref99TM.shp") |>
  dplyr::rename("code" = "KnKod",
                "name" = "KnNamn") |>
  dplyr::as_tibble() |>
  sf::st_as_sf()



# Clean the "län" data
lan <-
  sf::st_read("data-raw/scb_regions/Lan_Sweref99TM_region.shp") |>
  dplyr::rename("code" = "LnKod",
                "name" = "LnNamn") |>
  dplyr::as_tibble() |>
  sf::st_as_sf()



# Make "nuts" data
nuts <-
  lan |>
  dplyr::mutate("code" = dplyr::case_when(
    code == "01" ~ "SE110",
    code == "03" ~ "SE121",
    code == "04" ~ "SE122",
    code == "05" ~ "SE123",
    code == "18" ~ "SE124",
    code == "19" ~ "SE125",

    code == "06" ~ "SE211",
    code == "07" ~ "SE212",
    code == "08" ~ "SE213",
    code == "09" ~ "SE214",
    code == "10" ~ "SE221",
    code == "12" ~ "SE224",
    code == "13" ~ "SE231",
    code == "14" ~ "SE232",

    code == "17" ~ "SE311",
    code == "20" ~ "SE312",
    code == "21" ~ "SE313",
    code == "22" ~ "SE321",
    code == "23" ~ "SE322",
    code == "24" ~ "SE331",
    code == "25" ~ "SE332"
  )) |>
  dplyr::mutate(nuts1 = substr(code, 1, 3),
                nuts2 = substr(code, 1, 4),
                nuts3 = substr(code, 1, 5))

# Make NUTS1
nuts1 <-
  nuts |>
  dplyr::summarize(geometry = sf::st_union(geometry), .by = c("nuts1")) |>
  dplyr::rename("code" = "nuts1") |>
  dplyr::mutate("name" = dplyr::case_when(
    code == "SE1" ~ "Östra Sverige",
    code == "SE2" ~ "Södra Sverige",
    code == "SE3" ~ "Norra Sverige"
  )) |>
  dplyr::select("code", "name", "geometry") |>
  dplyr::as_tibble() |>
  sf::st_as_sf()

# Make NUTS2
nuts2 <-
  nuts |>
  dplyr::summarize(geometry = sf::st_union(geometry), .by = c("nuts2")) |>
  dplyr::rename("code" = "nuts2") |>
  dplyr::mutate("name" = dplyr::case_when(
    code == "SE11" ~ "Stockholm",
    code == "SE12" ~ "Östra Mellansverige",

    code == "SE21" ~ "Småland med öarna",
    code == "SE22" ~ "Sydsverige",
    code == "SE23" ~ "Västsverige",

    code == "SE31" ~ "Norra Mellansverige",
    code == "SE32" ~ "Mellersta Norrland",
    code == "SE33" ~ "Övre Norrland"
  )) |>
  dplyr::select("code", "name", "geometry") |>
  dplyr::as_tibble() |>
  sf::st_as_sf()

# Make NUTS3
nuts3 <-
  nuts |>
  dplyr::select(-c("nuts1", "nuts2", "nuts3")) |>
  dplyr::as_tibble() |>
  sf::st_as_sf()



# Clean the "lokal arbetsmarknad" data
lokal_arbetsmarknad <-
  sf::st_read("data-raw/scb_regions/LAomraden_2022.shp") |>
  dplyr::rename("code" = "Lakod",
                "name" = "Namn") |>
  dplyr::as_tibble() |>
  sf::st_as_sf()



# Save data ---------------------------------------------------------------

usethis::use_data(kommuner, compress = "xz", overwrite = T)
usethis::use_data(lan, compress = "xz", overwrite = T)
usethis::use_data(nuts1, compress = "xz", overwrite = T)
usethis::use_data(nuts2, compress = "xz", overwrite = T)
usethis::use_data(nuts3, compress = "xz", overwrite = T)
usethis::use_data(lokal_arbetsmarknad, compress = "xz", overwrite = T)



# Remove raw data ---------------------------------------------------------

for (f in list.files("data-raw/scb_regions/", full.names = T)) {

  unlink(f)

}
