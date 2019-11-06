##
## Getter and setter methods for the user's data directory
##
pkg.env = new.env(parent = emptyenv())
pkg.env$data.dir = "."

#' Set path containing data files
#'
#' @param path The path
#' @export
#'
set_data_dir = function(path) {
  pkg.env$data.dir = path
}

#' Get path containing data files
#'
#' @export
#'
get_data_dir = function() {
  pkg.env$data.dir
}

# another option is to use `options`:
# options("data.dir" = "../data")
# getOption("data.dir")
# .Options
