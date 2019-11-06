#' Load all worksheets in an Excel file into a single dataframe
#'
#' @param path The Excel file to read
#'
#' @export
#'
read_excel_entirely = function(path) {
  readxl::excel_sheets(path) %>%
    purrr::set_names() %>%
    purrr::map_df(~ readxl::read_excel(path = path, sheet = .x), .id = "sheet")
}
