#'@export
print.ppgrid <- function(ppgrid) {
  cat("ppgrid object\n")
  data.table:::print.data.table(ppgrid$dt)
  cat(paste0("Max scoring date:\t", ppgrid$time_max), "\n")
  cat(paste0("Window size:\t\t", ppgrid$window_size), "\n")
  cat(paste0("Granularity:\t\t", ppgrid$granularity), "\n")
  cat(paste0("Lag:\t\t\t", ppgrid$lag), "\n")
  invisible()
}
