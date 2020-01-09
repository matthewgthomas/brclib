#' Add risk quantiles to a dataframe for the given column.
#' @param d The data
#' @param risk.col String specifying the name of the column to quantise
#' @param output.col String specifying the name of the column to add (defaults to the same as risk.col)
#' @param quants Number of quantiles (default: 5)
#' @param style Method to use for calculating quantiles (passed to classIntervals; default: Fisher). One of "fixed", "sd", "equal", "pretty", "quantile", "kmeans", "hclust", "bclust", "fisher", "jenks" or "dpih"
#' @param samp_prop The proportion of samples to use, if slicing using "fisher" or "jenks" (passed to classIntervals; default: 100%)
#' @return A dataframe with two columns added: one for the risk quantile (output.col_q) and one containing labels for the risk quantile (output.col_q_name)
#'
#' @export
#'
add_risk_quantiles = function(d, risk.col, output.col = risk.col, quants = 5, style = "fisher", samp_prop = 1) {
  # calculate the quantile breaks
  q_breaks = classInt::classIntervals(d[[risk.col]], quants, style = style, samp_prop = samp_prop, largeN = nrow(d))

  d[[paste0(output.col, "_q")]]      = as.integer(cut(d[[risk.col]], breaks = q_breaks$brks, include.lowest = T))  # create a column with the risk quantiles as a number (e.g. from 1 to 5, if using quintiles)
  d[[paste0(output.col, "_q_name")]] =            cut(d[[risk.col]], breaks = q_breaks$brks, include.lowest = T)   # create a column with the risk quantiles as labels

  d[[paste0(output.col, "_q")]] = (quants + 1) - d[[paste0(output.col, "_q")]]  # reverse the quantile scoring so 1 = highest risk

  d  # return the dataframe
}
