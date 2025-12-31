![](https://github.com/borstell/borstell.github.io/blob/master/media/swemapdata/swemapdata.png)

# swemapdata
A Package of Spatial Data for Sweden - Regions and Cities

Access spatial data for Swedish cities (coordinates) and regions (polygons) from Statistics Sweden (SCB) and Lantmäteriet.

## Installation

```r
devtools::install_github("borstell/swemapdata")
```

## Functionality

The `swemapdata` package contains spatial data for easy mapping of Swedish cities and regions. The package is a fully dataset-based package, containing only data but no standalone functions. Note that the data uses the Swedish standard [SWEREF 99 TM](https://www.lantmateriet.se/sv/geodata/gps-geodesi-och-swepos/Referenssystem/Tvadimensionella-system/SWEREF-99-projektioner/), which means that combining the data with other coordinate reference systems (CRS) may require conversion prior to visualization (see examples below).

The package contains eight datasets:

- `distrikt`: Swedish _distrikt_ ('districts'; administrative unit; polygon data)
- `kommuner`: Swedish _kommuner_ ('municipalities'; administrative unit; polygon data)
- `lan`: Swedish _län_ ('county'; administrative unit; polygon data)
- `landsdelar`: Swedish _landsdelar_ ('country parts'; informal larger regions; polygon data)
- `lokal_arbetsmarknad`: Swedish _lokal arbetsmarknad_ ('local labor market'; administrative unit; polygon data)
- `nuts{1,2,3}`: Nomenclature des Unités Territoriales Statistiques units of different levels: 1, 2 and 3 (polygon data)
- `socknar`: Swedish _socknar_ ('parishes'; administrative unit (historically church-related); polygon data)
- `tatorter`: Swedish _tätorter_ ('densely (populated) towns'; cities/towns; coordinate data (points))

All datasets are simple features (SF) objects, which means they require something like the [`sf`](https://r-spatial.github.io/sf/index.html) package to be interpreted correctly. For plotting `swemapdata` package data on a map, see, e.g., the [`sf`](https://r-spatial.github.io/sf/index.html) package documentation for how to work with SF objects.

The data comes from Statistics Sweden (SCB) and Lantmäteriet, apart from post-processed data from [https://github.com/perliedman/svenska-landskap](https://github.com/perliedman/svenska-landskap) (originally from Lantmäteriet). 

Note: The `swemapdata` package contains data overlapping with that of the [`swemaps2`](https://github.com/filipwastberg/swemaps2) package.

## Examples


```r
# Load packages
library(dplyr)
library(ggplot2)
library(sf)
library(swemapdata)

# Plot only top-10 cities by population on top of "landsdelar"
tatorter |>
  slice_max(order_by = pop, n = 10) |> 
  ggplot() +
  geom_sf(data = landsdelar) +
  geom_sf(shape = 21, color = "white", fill = "grey20")
```

![Example of the 10 most populous cities in Sweden plotted with landsdelar (country parts)](https://github.com/borstell/borstell.github.io/blob/master/media/swemapdata/swemapdata_example1.png)

```r
# Load packages
library(dplyr)
library(ggplot2)
library(sf)
library(swemapdata)

# Plot all the "landskap" and fill Dalarna in blue
landskap |> 
  ggplot() +
  geom_sf() +
  geom_sf(data = \(x) x |> filter(name == "Dalarna"), fill = "dodgerblue") +
  theme_void()
```
![Example of region fill](https://github.com/borstell/borstell.github.io/blob/master/media/swemapdata/swemapdata_example2.png)

Note that the lakes are somewhat distorted (or missing) in the `landskap` and `landsdelar` datasets, likely due to some merging of polygons from somewhat incomplete data in the original dataset.

You can easily match other datasets to the spatial data, to plot things like statistics. For example, there is a longstanding "joke" of the non-existent [_Kalle Anka-partiet_ ('Donald Duck Party')](https://en.wikipedia.org/wiki/Donald_Duck_Party) receiving votes in Swedish elections. Here is the "party's" regional results from the 2024 European Parliament elections:

```r
library(dplyr)
library(ggplot2)
library(sf)
library(stringr)
library(swemapdata)
library(tidyr)

# Download election data from:
# "https://www.val.se/download/18.5acd32d818deefef85c7131/1718718968853/slutligt-valresultat-europaparlamentet-2024-vallokalernas-rostrakning.xlsx"
eu_val_2024 <- 
  readxl::read_excel("slutligt-valresultat-europaparlamentet-2024-vallokalernas-rostrakning.xlsx", sheet = 2) |> 
  mutate(party = str_to_lower(Parti)) |> 
  mutate(kalle_anka = str_detect(party, "kalle") & str_detect(party, "anka")) |> 
  summarize(n = sum(Röster), .by = c(Län, kalle_anka)) |> 
  pivot_wider(names_from = kalle_anka, values_from = n) |> 
  rename("kalle" = `TRUE`,
         "not_kalle" = `FALSE`) |> 
  mutate(kalle = if_else(is.na(kalle), 0, kalle)) |> 
  mutate(kalle_anka = kalle/(kalle+not_kalle))

lan |> 
  mutate(Län = sub("s$", "", name)) |> 
  left_join(eu_val_2024) |> 
  ggplot() +
  geom_sf(aes(fill = kalle_anka*100000)) +
  scale_fill_gradient(low = "white", high = "dodgerblue4") +
  labs(fill = "How many votes did\nDonald Duck receive\nper 100,000 votes?",
       title = "European Parliament elections 2024\n(Sweden)") +
  theme_void() +
  theme(legend.position = "right",
        legend.title.position = "top",
        legend.direction = "horizontal")
```
![Example of region fill](https://github.com/borstell/borstell.github.io/blob/master/media/swemapdata/swemapdata_example3.png)

If you want to combine data in another format and/or in another coordinate reference system (CRS), you may have to do some preprocessing to convert and combine that data into an SF object that is easily compatible for plotting. For example, here the `ggplot2::map_data` is combined in a plot with the `swemapdata::lan` dataset:

```
library(dplyr)
library(ggplot2)
library(sf)
library(swemapdata)

da_fi_no <- 
  
  # Get the ggplot2 map_data
  map_data("world") |> 
  
  # Filter to Scandinavian neighbors
  filter(region %in% c("Denmark", "Finland", "Norway")) |> 
  
  # Filter out Norwegian northern islands (Svalbard etc.)
  filter(group < 1087) |> 
  
  # Convert coordinates to the correct system
  st_as_sf(coords = c("long", "lat"), crs = st_crs(4326)) |>
  
  # Group correct groupings together and combine geometry to polygon data
  group_by(group, region, subregion) |> 
  summarize(geometry = st_combine(geometry)) |> 
  st_cast("POLYGON")

# Plot together with Swedish "län"
lan |> 
  ggplot() +
  geom_sf() +
  geom_sf(data = da_fi_no) +
  theme_minimal()
```
![Example of region fill](https://github.com/borstell/borstell.github.io/blob/master/media/swemapdata/swemapdata_example4.png)

The lakes in the `landsdelar` and `landskap` datasets are not great. One way around this is to superimpose lakes from some other dataset, e.g. `{rnaturalearth}`:

```r
# Load packages
library(dplyr)
library(ggplot2)
library(sf)
library(swemapdata)
library(rnaturalearth)

# Get country map of Sweden
sweden <- 
  rnaturalearth::ne_countries(country = c("Sweden"), scale = 10)

# Download lakes
lakes <- 
  rnaturalearth::ne_download(scale = 10, type = "lakes", category = "physical", returnclass = "sf") 

# Change the type in {sf}
sf::sf_use_s2(FALSE)

# Find lakes within Sweden's borders
swelake_id <- 
  sf::st_contains(sweden, lakes)

# Only include lakes inside Sweden's borders
swelakes <- 
  lakes |> 
  filter(row_number() %in% unlist(swelake_id)) |> 
  
  # Remove Mälaren (otherwise it plots over islands)
  filter(name != "Mälaren")

# Plot Sweden with better lakes
ggplot() +
  geom_sf(data = swemapdata::landskap) +
  geom_sf(data = swelakes |> filter(scalerank < 8), fill = "white") +
  coord_sf()+
  theme_void()
```
![Example of better lakes](https://github.com/borstell/borstell.github.io/blob/master/media/swemapdata/swemapdata_example5.png)

The logo at the top was made with the package itself:

```r
library(dplyr)
library(ggplot2)
library(sf)
library(swemapdata)
library(ggtext)

ggplot() +
  geom_sf(data = landsdelar |> filter(name == "Norrland"), 
          fill = "#005293", color = "transparent") +
  geom_sf(data = landsdelar |> filter(name == "Götaland"), 
          fill = "#005293", color = "transparent") +
  geom_sf(data = landsdelar |> filter(name == "Svealand"), fill = "#FFCD00", color = "transparent") +
  geom_richtext(aes(x = 16.1, y = 59.8, label = "swe<span style='color:#005293'>map</span>data"),
                angle = -25, label.color = "transparent", fill = "transparent",
                family = "Righteous", size = 5, color = "grey10") +
  xlim(8, 25) +
  theme_void()
```

## Source

Original data licensed CC0, see: 
- [https://www.scb.se/vara-tjanster/oppna-data/](https://www.scb.se/vara-tjanster/oppna-data/)
- [https://www.lantmateriet.se/sv/geodata/vara-produkter/oppna-data/](https://www.lantmateriet.se/sv/geodata/vara-produkter/oppna-data/)
- [https://github.com/perliedman/svenska-landskap](https://github.com/perliedman/svenska-landskap) (originally from Lantmäteriet)
