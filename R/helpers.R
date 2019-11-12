##
## Helper functions
##

#' Multiply numbers only if at least one of them isn't zero
#' @param x First number
#' @param y Second number
#' @export
`%**%` = function(x, y) ifelse(x == 0, 1, x) * ifelse(y == 0, 1, y)

#' Convert dates only when they're in Excel (numeric) format
#' @param d The date
#' @export
convert_date = function(d) {
  ifelse( Hmisc::all.is.numeric(d),                                     # check if this row contains a number or a string
          as.character(janitor::excel_numeric_to_date(as.numeric(d))),  # if a number, use janitor::excel...() to convert it
          d )                                                           # if a string, leave it alone
}

#' Convert proportions to %s
#' @param x The proportion
#' @export
as_pc = function(x) round(x * 100, 1)
