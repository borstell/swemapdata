![](https://github.com/borstell/borstell.github.io/blob/master/media/swemapdata/swemapdata.png)

# swemapdata
A Package of Spatial Data for Sweden - Regions and Cities

Access spatial data for Swedish cities (coordinates) and regions (polygons) from Statistics Sweden (SCB) and Lantmäteriet.

## Installation

```r
devtools::install_github("borstell/swemapdata")
```

## Functionality

The `swemapdata` package contains spatial data for easy mapping of Swedish cities and regions. The package is a fully dataset-based package, containing only data but no standalone functions.

The package contains eight datasets:

- `distrikt`: Swedish _distrikt_ ('districts'; administrative unit; polygon data)
- `kommuner`: Swedish _kommuner_ ('municipalities'; administrative unit; polygon data)
- `lan`: Swedish _län_ ('county'; administrative unit; polygon data)
- `landsdelar`: Swedish _landsdelar_ ('country parts'; informal larger regions; polygon data)
- `lokal_arbetsmarknad`: Swedish _lokal arbetsmarknad_ ('local labor market'; administrative unit; polygon data)
- `nuts{1,2,3}`: Nomenclature des Unités Territoriales Statistiques units of different levels: 1, 2 and 3 (polygon data)
- `socknar`: Swedish _socknar_ ('parishes'; administrative unit (historically church-related); polygon data)
- `tatorter`: Swedish _tätorter_ ('densely (populated) towns'; cities/towns; coordinate data (points))

All datasets are simple features objects, which means they work best with [`sf`](https://r-spatial.github.io/sf/index.html) package functions. For plotting `swemapdata` package data on a map, see, e.g., the [`sf`](https://r-spatial.github.io/sf/index.html) package documentation.

The data comes from Statistics Sweden (SCB) or Lantmäteriet, apart from post-processed data from https://github.com/perliedman/svenska-landskap (originally from Lantmäteriet). 

Note: The `swemapdata` package contains data overlapping with that of the [`swemaps2`](https://github.com/filipwastberg/swemaps2) package.

## Examples


```r
# Load packages
library(dplyr)
library(ggplot2)
library(swemapdata)

# Plot only top-10 cities by population on top of "landsdelar"
tatorter |>
  slice_max(order_by = pop, n = 10) |> 
  ggplot() +
  geom_sf(data = landsdelar) +
  geom_sf()
```

![Example of the 10 most populous cities in Sweden plotted with landsdelar (country parts)](https://github.com/borstell/borstell.github.io/blob/master/media/swemapdata/swemapdata_example1.png)

```r
# Load packages
library(dplyr)
library(ggplot2)
library(swemapdata)

# Plot all the "län" and fill Dalarna in blue
lan |> 
  ggplot() +
  geom_sf() +
  geom_sf(data = \(x) x |> filter(name == "Dalarnas"), fill = "dodgerblue") +
  theme_void()
```
![Example of region fill](https://github.com/borstell/borstell.github.io/blob/master/media/swemapdata/swemapdata_example2.png)

The logo at the top was made with the package itself:

```r
library(dplyr)
library(ggplot2)
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
– [https://www.scb.se/vara-tjanster/oppna-data/](https://www.scb.se/vara-tjanster/oppna-data/)
– [https://www.lantmateriet.se/sv/geodata/vara-produkter/oppna-data/](https://www.lantmateriet.se/sv/geodata/vara-produkter/oppna-data/)
