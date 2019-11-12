#' Load BRC's bespoke postcode directory
#'
#' @param postcode.path Where the postcodes file is stored
#' @param postcode.name Name of the postcodes file
#'
#' @examples
#' \dontrun{
#' if (!exists("postcodes")) postcodes = load_postcodes()
#' }
#'
#' @export
#'
load_postcodes = function(postcode.path = file.path(options("brclib.data_path"), "Postcodes"),
                          postcode.name = "National_Statistics_Postcode_Lookup - BRC.csv") {

  readr::read_csv(file.path(postcode.path, postcode.name),
           col_types = readr::cols(
             Postcode = readr::col_character(),
             Longitude = readr::col_double(),
             Latitude = readr::col_double(),
             Country = readr::col_character(),
             CountryName = readr::col_character(),
             `Output Area` = readr::col_character(),
             LSOA = readr::col_character(),
             `Local Authority Code` = readr::col_character(),
             `Primary Care Trust` = readr::col_character(),
             `Rural or Urban?` = readr::col_character(),
             `Rural Urban classification` = readr::col_character(),
             IMD = readr::col_integer(),
             IMD.Decile = readr::col_integer(),
             IMD.Decile.Name = readr::col_character(),
             `Rurality index` = readr::col_double()
           ))
}


#' Regular expression to match postcodes (allowing lowercase and unlimited spaces)
#' source: https://stackoverflow.com/a/7259020
#' see also: page 6 of https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/488478/Bulk_Data_Transfer_-_additional_validation_valid_from_12_November_2015.pdf
#'
#' @export
#'
postcode_regex = function() {
  "(([gG][iI][rR] {0,}0[aA]{2})|((([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y]?[0-9][0-9]?)|(([a-pr-uwyzA-PR-UWYZ][0-9][a-hjkstuwA-HJKSTUW])|([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y][0-9][abehmnprv-yABEHMNPRV-Y]))) {0,}[0-9][abd-hjlnp-uw-zABD-HJLNP-UW-Z]{2}))"
}


#' Lookup coordinates for UK postcodes that aren't in the ONS postcode directory (tends to be Guernsey, Jersey and Isle of Man), scraping them from https://checkmypostcode.uk/ where necessary.
#' This function also saves the postcodes and coordinates into `islands_file` to prevent needless re-scraping in future.
#'
#' @param islands_postcodes A vector of postcodes to lookup. Note that these shouldn't contain spaces.
#' @param islands_path Folder where the `islands_file` is stored
#' @param islands_file Filename for where to store the postcodes and coordinates.
#' @return A data_frame containing postcodes and coordinates.
#'
#' @export
#'
lookup_islands_postcodes = function(islands_postcodes,
                                    islands_path = file.path(options("brclib.data_path"), "Postcodes"),
                                    islands_file = "UK Islands postcodes.csv") {

  channel_file = file.path(islands_path, islands_file)

  # track existing postcodes already scraped
  existing_pc = c()

  # load Islands postcodes we previously stored (if it exists)
  if (file.exists(channel_file)) {
    channel = readr::read_csv(channel_file)
    existing_pc = channel$Postcode2
  }

  # get rid of spaces (just in case not already done)
  islands_postcodes = gsub(" ", "", islands_postcodes)

  # get postcodes not in our current list
  channel_new = tibble::tibble(
    Postcode2 = islands_postcodes[!islands_postcodes %in% existing_pc],  # filter out postcodes we've looked up in the past
    Longitude = 0.0,
    Latitude = 0.0
  )

  # set user agent
  ua = httr::user_agent("https://redcross.org.uk")

  # scrape coordinates for each postcode
  if (nrow(channel_new) > 0) {  #... only if there are new postcodes to scrape
    print("Scraping new postcodes...")

    for (i in 1:nrow(channel_new)) {

      pc = channel_new$Postcode2[i]

      # get webpage data
      req = httr::GET(paste0("https://checkmypostcode.uk/", pc), ua)

      # load html
      out = httr::content(req, "text")
      doc = xml2::read_html(out)

      # get list of coordinates
      coords = doc %>%
        rvest::html_nodes(".small") %>%
        rvest::html_text()

      lat = as.numeric(stringr::str_extract(coords[1], "-?[0-9]+\\.[0-9]+"))
      lon = as.numeric(stringr::str_extract(coords[2], "-?[0-9]+\\.[0-9]+"))

      channel_new$Longitude[i] = lon
      channel_new$Latitude[i]  = lat

      Sys.sleep(0.75)  # scrape responsibly
    }
  } else {
    print("No new postcodes to scrape")
  }

  # add new postcodes and save
  if (exists("channel")) {
    channel = dplyr::bind_rows(channel, channel_new)
  } else {
    channel = channel_new
  }

  readr::write_csv(channel, channel_file)

  channel  # return the postcodes
}
