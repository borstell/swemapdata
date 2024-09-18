# swemapdata
A Package of Spatial Data for Sweden (regions and cities)

Access spatial data for Swedish cities (coordinates) and regions (polygons) from Statistics Sweden (SCB) directly.

## Functionality

The `swemapdata` package contains spatial data for easy mapping of Swedish cities and regions. The package is a fully dataset-based package, containing only data but no standalone functions.

The package contains five datasets:

- `kommuner`: Swedish municipalities (administrative unit; polygon data)
- `lan`: Swedish _län_ (administrative unit; polygon data)
- `landsdelar`: Swedish _landsdelar_ ('country parts'; informal larger regions; polygon data)
- `lokal_arbetsmarknad`: Swedish labor market areas (administrative unit; polygon data)
- `tatorter`: Swedish _tätorter_ ('densely populated locations'; cities/towns; coordinate data (points))

For plotting `swemapdata` package data on a map, see, e.g., the [`sf`](https://r-spatial.github.io/sf/index.html) package documentation.

Note: The `swemapdata` package contains similar data as the [`swemaps2`](https://github.com/filipwastberg/swemaps2) package, which is not updated for the most recent R version.

## Examples

```r
# Load packages
library(tidyverse)
library(swemapdata)

# Slice to only the 10 biggest cities by population
big_cities <-
  tatorter |>
    slice_max(order_by = pop, n = 10)

# Plot landsdelar and big cities
ggplot() +
  geom_sf(data = landsdelar) +
  geom_sf(data = big_cities)
```

![Example of the 10 most populous cities in Sweden plotted with landsdelar (country parts)]()

## Source

Original data licensed CC0, see: [https://www.scb.se/vara-tjanster/oppna-data/](https://www.scb.se/vara-tjanster/oppna-data/).
