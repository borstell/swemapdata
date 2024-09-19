#' Distrikt (districts)
#'
#' Data originally from Lantmäteriet:
#' https://geotorget.lantmateriet.se
#'
#' @format An SF object of Swedish districts, with three variables:
#'   \code{code}, \code{name} and \code{geometry}.
"distrikt"

#' Kommuner (municipality)
#'
#' Data originally from Statistics Sweden (SCB):
#' https://www.scb.se/hitta-statistik/regional-statistik-och-kartor/regionala-indelningar/digitala-granser/
#'
#' @format An SF object of Swedish municipalities, with three variables:
#'   \code{code}, \code{name} and \code{geometry}.
"kommuner"

#' Län (administrative region)
#'
#' Data originally from Statistics Sweden (SCB):
#' https://www.scb.se/hitta-statistik/regional-statistik-och-kartor/regionala-indelningar/digitala-granser/
#'
#' @format An SF object of Swedish "län" regions, with four variables:
#'   \code{code}, \code{name}, \code{group} and \code{geometry}.
"lan"

#' Landsdelar (informal region; 'country parts')
#'
#' Data originally from Lantmäteriet (as CC0), but reworked by:
#' https://github.com/perliedman/svenska-landskap
#'
#' @format An SF object of Swedish "landsdelar" regions, with three variables:
#'   \code{code}, \code{name} and \code{geometry}.
"landsdelar"

#' Landskap (informal region; 'country regions')
#'
#' Data originally from Lantmäteriet (as CC0), but reworked by:
#' https://github.com/perliedman/svenska-landskap
#'
#' @format An SF object of Swedish "landskap" regions, with three variables:
#'   \code{code}, \code{name} and \code{geometry}.
"landskap"

#' Lokal arbetsmarknad (administrative region; 'local labor market')
#'
#' Data originally from Statistics Sweden (SCB):
#' https://www.scb.se/hitta-statistik/regional-statistik-och-kartor/regionala-indelningar/digitala-granser/
#'
#' @format An SF object of Swedish "lokal arbetsmarknad" regions, with three variables:
#'   \code{code}, \code{name} and \code{geometry}.
"lokal_arbetsmarknad"

#' NUTS1 (Nomenclature des Unités Territoriales Statistiques)
#'
#' Data originally from Statistics Sweden (SCB):
#' https://www.scb.se/vara-tjanster/oppna-data/oppna-geodata/tatorter/
#'
#' @format An SF object of Swedish NUTS regions, with three variables:
#'   \code{code}, \code{name} and \code{geometry}.
"nuts1"

#' NUTS2 (Nomenclature des Unités Territoriales Statistiques)
#'
#' Data originally from Statistics Sweden (SCB):
#' https://www.scb.se/vara-tjanster/oppna-data/oppna-geodata/tatorter/
#'
#' @format An SF object of Swedish NUTS regions, with three variables:
#'   \code{code}, \code{name} and \code{geometry}.
"nuts2"

#' NUTS3 (Nomenclature des Unités Territoriales Statistiques). NB: same as "län"
#'
#' Data originally from Statistics Sweden (SCB):
#' https://www.scb.se/vara-tjanster/oppna-data/oppna-geodata/tatorter/
#'
#' @format An SF object of Swedish NUTS regions, with three variables:
#'   \code{code}, \code{name} and \code{geometry}.
"nuts3"

#' Socknar (parishes)
#'
#' Data originally from Lantmäteriet:
#' https://geotorget.lantmateriet.se
#'
#' @format An SF object of Swedish church parishes, with five variables:
#'   \code{code}, \code{name}, \code{area_id}, \code{main_area} and \code{geometry}.
"socknar"

#' Tätorter (towns; 'densely populated locations')
#'
#' Data originally from Statistics Sweden (SCB):
#' https://www.scb.se/vara-tjanster/oppna-data/oppna-geodata/tatorter/
#'
#' @format An SF object of Swedish "tätorter" ('cities'), with 12 variables:
#'   \code{id}, \code{uu_id}, \code{code}, \code{name},
#'   \code{mun_code}, \code{mun_name}, \code{lan_code}, \code{lan_name},
#'   \code{area}, \code{pop}, \code{year} and \code{geometry}.
"tatorter"
