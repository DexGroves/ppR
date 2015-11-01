print.ppgrid <- function(jitgrid) {
  invisible(data.table:::print.data.table(jitgrid$dt))
}
