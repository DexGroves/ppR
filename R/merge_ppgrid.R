#' Merge a \code{ppgrid} object to new data.
#'
#' Find the just-in-time summarised response and weight for new data
#' as informed by a \code{ppgrid} object.
#' As \code{\link{train_ppgrid}}, \code{merge_ppgrid} expects ordered vectors.
#'
#' @export
#' @param id_var Vector identifying the groups.
#' @param time_var Numeric vector of time, there is no support for character
#' time vectors or other datetime datatypes yet.
#' @param ppgrid \code{ppgrid} object produced by \code{\link{train_ppgrid}}.
#' @param na_fill Boolean: whether to merge the furthest in the future values
#' from train_ppgrid in the event that the new data's times are more advanced
#' than the trained range.
#' @return list containing the merged mean response and total weight for the
#' input after merging with \code{ppgrid}. Ordered as input vectors.
#' @examples
#' set.seed(1234)
#' ppdf <- make_longitudinal_data(1000)
#' ppdf_train <- ppdf[ppdf$date < 1150, ]
#' ppdf_test <- ppdf[ppdf$date >= 1150, ]
#' ppgrid <- train_ppgrid(ppdf_train$id,
#'                        ppdf_train$date,
#'                        ppdf_train$resp,
#'                        lag = 25,
#'                        window_size = 25,
#'                        granularity = 25)
#'
#' merge_ppgrid(ppdf_test$id,
#'              ppdf_test$date,
#'              ppgrid)
merge_ppgrid <- function(id_var, time_var, ppgrid, na_fill = FALSE) {
  if (na_fill) {
    time_var <- pmin(time_var, ppgrid$time_max)
  }

  score_dt <- data.table(id_var,
                         score_pt = fast_rnd_down(time_var, ppgrid$granularity))
  score_dt[, ori_order := 1:.N]

  out_dt <- merge(score_dt, ppgrid$dt,
                  by = c("id_var", "score_pt"), all.x = TRUE)

  out_dt <- out_dt[order(ori_order)]

  if (nrow(out_dt) == 0) {
    return(list(response = rep(NA, length(id_var)),
                weight = rep(NA, length(id_var))))
  }

  list(response = out_dt$response,
       weight = out_dt$wt)
}
