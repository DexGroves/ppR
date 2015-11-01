#' Train prior period information.
#'
#' Produces a grid of weighted mean and total weight for the preceding period of
#' each group-time combination. All parameters are taken as vectors that are
#' assumed to be associated and in the same order.
#' \code{train_ppgrid} will compute
#' ~ granularity * (max(time_var) - min(time_var) - window_size) distinct
#' aggregations for each distinct \code{id_var}.
#'
#' @export
#' @param id_var Vector identifying the groups.
#' @param time_var Numeric vector of time, there is no support for character
#' time vectors or other datetime datatypes yet.
#' @param response_var Numeric vector of responses to summarise.
#' @param wt_var Optional numeric weight vector. Defaults to 1.0.
#' @param lag Number of units of time to lag the variable accumulation before
#' scoring. Useful if there is a period after data acquisition before the
#' response is known; this parameter can mimic model
#' implementation.
#' @param window_size Number of units of time to aggregate the response and
#' weight variables over.
#' @param granularity How severely to round the input time variable. Times will
#' be rounded to the nearest granularity. Improves runtime at nominal cost to
#' accuracy.
#' @return ppgrid object, containing a \pkg{data.table} containing prior
#' period information as well as some input parameters.
#' @examples
#' set.seed(1234)
#' ppdf <- make_longitudinal_data(1000)
#'
#' ppgrid <- train_ppgrid(ppdf$id,
#'                        ppdf$date,
#'                        ppdf$resp,
#'                        lag = 25,
#'                        window_size = 25,
#'                        granularity = 25)
#'
#' print(ppgrid)
train_ppgrid <- function(id_var, time_var, response_var,
                         wt_var = rep(1, length(response_var)),
                         lag, window_size, granularity) {

  train_dt <- data.table(id_var, time_var, response_var, wt_var, key = "id_var")

  target_grid <- get_target_grid(train_dt$time_var, window_size, granularity)

  train_dt <- reduce_data(train_dt, granularity)

  jit_grid <- summarise_over_windows(target_grid, train_dt, lag, granularity)

  out <- list(dt = jit_grid[, row_id := NULL],
              time_max    = max(jit_grid$score_pt),
              window_size = window_size,
              granularity = granularity,
              lag = lag)
  class(out) <- "ppgrid"
  out
}

reduce_data <- function(train_dt, granularity) {
  train_dt[, .(response_var = fast_wtd_mean(response_var, wt_var),
               wt_var = sum(wt_var)),
           by = .(id_var, time_var = fast_rnd_down(time_var, granularity))]
}

get_target_grid <- function(time_var, window_size, granularity) {
  start <- fast_rnd_down(min(time_var), granularity)
  end   <- fast_rnd_up(max(time_var), granularity)

  starts <- seq(start, end - window_size, by = granularity)
  ends   <- starts + window_size

  data.table(start = starts, end = ends)
}

summarise_over_windows <- function(target_grid, train_dt, lag, granularity) {
  target_grid[, row_id := 1:.N]
  target_grid[, summarise_over_time(train_dt, start, end, lag, granularity),
              by = row_id]
}

summarise_over_time <- function(train_dt, start, end, lag, granularity) {
  train_dt[time_var >= start & time_var < end,
           .(start,
             end,
             response = fast_wtd_mean(response_var, wt_var),
             wt = sum(wt_var),
             score_pt = fast_rnd_up(end + lag, granularity)),
           by = id_var]
}
