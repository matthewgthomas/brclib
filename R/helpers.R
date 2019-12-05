##
## Helper functions
##

#' Multiply numbers only if at least one of them isn't zero
#'
#' @param x First number
#' @param y Second number
#'
#' @examples
#' 10 %**% 2 # == 20
#' 10 %**% 0 # == 10
#'
#' @export
`%**%` = function(x, y) ifelse(x == 0, 1, x) * ifelse(y == 0, 1, y)  # this is an 'infix' function

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

#' Convert month name to the month's number
#' (e.g. "February" or "Feb" returns 2)
#'
#' @param month String containing the month, either in full (e.g. "February") or abbreviated ("Feb")
#' @param list.of.months Optional list of month names. Defaults to the full names (`month.name`); use `month.abb` for short month names
#'
#' @examples
#' get_month_num("December")
#' get_month_num("Dec", month.abb)
#'
#' @export
get_month_num = function(month, list.of.months = month.name) {
  match(month, list.of.months)
}
