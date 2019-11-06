#' Download data from Stats Wales (https://statswales.gov.wales)
#'
#' @param url The Stats Wales URL to start gathering from
#' @export
#'
download_wales = function(url) {
  # load initial data
  wimd_curr = jsonlite::fromJSON(RCurl::getURL(url), flatten = T)

  # put data into data.frame
  wimd_dat = wimd_curr$value

  # get url of the first next page
  next_page = wimd_curr$odata.nextLink

  # loop over the .json pages until we run out of data
  while(!is.null(next_page)) {
    wimd_curr = jsonlite::fromJSON(RCurl::getURL(next_page), flatten = T)  # download next batch of data

    wimd_dat = dplyr::bind_rows(wimd_dat, wimd_curr$value)  # append to data.frame
    next_page = wimd_curr$odata.nextLink             # get url of next page (if there is one)

    print(next_page)  # track progress
  }

  wimd_dat
}
