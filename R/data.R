
#' Kommuner (municipality)
#'
#' Data originally from Statistics Sweden (SCB):
#' https://www.scb.se/hitta-statistik/regional-statistik-och-kartor/regionala-indelningar/digitala-granser/
#'
#' @format A data frame of Swedish municipalities, with three variables:
#'   \code{code}, \code{name} and \code{geometry}.
"kommuner"

#' Län (administrative region)
#'
#' Data originally from Statistics Sweden (SCB):
#' https://www.scb.se/hitta-statistik/regional-statistik-och-kartor/regionala-indelningar/digitala-granser/
#'
#' @format A data frame of Swedish "län" regions, with four variables:
#'   \code{code}, \code{name}, \code{group} and \code{geometry}.
"lan"

#' Landsdelar (informal region; 'country parts')
#'
#' Data originally from Statistics Sweden (SCB), but reworked for new grouping:
#' https://www.scb.se/hitta-statistik/regional-statistik-och-kartor/regionala-indelningar/digitala-granser/
#'
#' @format A data frame of Swedish "landsdelar" regions, with two variables:
#'   \code{name} and \code{geometry}.
"landsdelar"

#' Lokal arbetsmarknad (administrative region; 'local labor market')
#'
#' Data originally from Statistics Sweden (SCB):
#' https://www.scb.se/hitta-statistik/regional-statistik-och-kartor/regionala-indelningar/digitala-granser/
#'
#' @format A data frame of Swedish "lokal arbetsmarknad" regions, with three variables:
#'   \code{code}, \code{name} and \code{geometry}.
"lokal_arbetsmarknad"

#' Tätorter (cities; 'densely populated locations')
#'
#' Data originally from Statistics Sweden (SCB):
#' https://www.scb.se/vara-tjanster/oppna-data/oppna-geodata/tatorter/
#'
#' @format A data frame of Swedish "tätorter" ('cities'), with 12 variables:
#'   \code{id}, \code{uu_id}, \code{code}, \code{name},
#'   \code{mun_code}, \code{mun_name}, \code{lan_code}, \code{lan_name},
#'   \code{area}, \code{pop}, \code{year} and \code{geometry}.
"tatorter"
