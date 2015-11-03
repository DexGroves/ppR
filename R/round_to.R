round_to <- function(var, granularity, fn = round) {
  fn(var / granularity) * granularity
}

round_up <- function(var, granularity) {
  round_to(var, granularity, ceiling)
}

round_down <- function(var, granularity) {
  round_to(var, granularity, floor)
}
