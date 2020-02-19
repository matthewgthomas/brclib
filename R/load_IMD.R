#' Load latest Index of Multiple Deprivation data for whole UK
#'
#' This data file is produced by: https://github.com/matthewgthomas/IMD
#'
#' @param url_IMD URL for the .csv file containing all deprivation data
#' @export
#'
load_IMD = function(url_IMD = "https://github.com/matthewgthomas/IMD/raw/master/data/UK%20IMD%20domains.csv") {
  readr::read_csv(url_IMD,
           col_types = readr::cols(
             .default = readr::col_number(),
             LSOA = readr::col_character(),
             Name = readr::col_character(),
             RUC = readr::col_character()
           ))
}

