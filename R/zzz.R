##
## Sets options for this package (currently just `brclib.data_path`)
##
brclib_default_options <- list(
  brclib.data_path = "C:/Users/040026704/Documents/Data science/Data"
)

.onLoad <- function(libname, pkgname) {
  op <- options()
  toset <- !(names(brclib_default_options) %in% names(op))
  if (any(toset)) options(brclib_default_options[toset])

  invisible()
}
