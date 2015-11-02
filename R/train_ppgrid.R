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

  train_dt <- reduce_data(train_dt, granularity)
  setkey(train_dt, time_var)

  starts_grid <- get_starts_table(time_var, granularity)

  buffer <- fast_rnd_up(lag, granularity) / granularity
  window_i <- fast_rnd_up(window_size, granularity) / granularity
  max_score_pt <- fast_rnd_up(max(time_var), granularity) +
                    (buffer * granularity)

  summary_table <- get_summary_table(starts_grid, train_dt)

  summary_table[, c("response", "wt") := fast_traverse_totals(response_var,
                                                              wt_var,
                                                              buffer,
                                                              window_i),
                by = id_var]
  summary_table[, score_pt := time_var + (buffer + window_i) * granularity]

  out <- list(dt = summary_table[score_pt <= max_score_pt,
                                 .(id_var,
                                   start = time_var,
                                   end = time_var + window_i * granularity,
                                   response, wt, score_pt)],
              time_max    = max_score_pt,
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

get_summary_table <- function(starts_grid, train_dt) {
  summary_table <- merge(starts_grid, train_dt, by = "time_var",
                         all.x = TRUE, allow.cartesian = TRUE)
  summary_table[is.na(response_var), response_var := 0]
  summary_table[is.na(response_var), wt_var := 0]

  setkey(summary_table, id_var, time_var)
  summary_table
}

get_starts_table <- function(time_var, granularity) {
  start <- fast_rnd_down(min(time_var), granularity)
  end   <- fast_rnd_up(max(time_var), granularity)
  data.table(time_var = seq(start, end, by = granularity),
             key = "time_var")
}
