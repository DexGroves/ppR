#' ppR: prior period variable creation
#'
#' Make prior period summary variables from longitudinal data.
#'
#' ppR contains methods to handle the creation and implementation of by-group
#' weighted mean and count variables for preceding records of the same group in
#' data which spans time.
#' The main function for training these variables is \code{\link{train_ppgrid}},
#' which will create a just-in-time summary for each time-group combination.
#' This can be scored on new data with the method \code{\link{merge_ppgrid}},
#' which returns the just-in-time weighted mean and count for a new dataframe as
#' a list.
#'
#' The time variable is currently expected to be strictly a numeric, with other
#' parameters supplied on the same scale. Support of datetime objects is
#' planned.
#'
#' @name ppR
#' @docType package
#' @import data.table
#' @import Rcpp
#' @useDynLib ppR
NULL
