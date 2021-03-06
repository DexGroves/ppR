// This file was generated by Rcpp::compileAttributes
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// fast_rnd_down
NumericVector fast_rnd_down(NumericVector x, double granularity);
RcppExport SEXP ppR_fast_rnd_down(SEXP xSEXP, SEXP granularitySEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< NumericVector >::type x(xSEXP);
    Rcpp::traits::input_parameter< double >::type granularity(granularitySEXP);
    __result = Rcpp::wrap(fast_rnd_down(x, granularity));
    return __result;
END_RCPP
}
// fast_rnd_up
NumericVector fast_rnd_up(NumericVector x, double granularity);
RcppExport SEXP ppR_fast_rnd_up(SEXP xSEXP, SEXP granularitySEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< NumericVector >::type x(xSEXP);
    Rcpp::traits::input_parameter< double >::type granularity(granularitySEXP);
    __result = Rcpp::wrap(fast_rnd_up(x, granularity));
    return __result;
END_RCPP
}
// fast_traverse_totals
List fast_traverse_totals(NumericVector x, NumericVector w, int buffer, int window);
RcppExport SEXP ppR_fast_traverse_totals(SEXP xSEXP, SEXP wSEXP, SEXP bufferSEXP, SEXP windowSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< NumericVector >::type x(xSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type w(wSEXP);
    Rcpp::traits::input_parameter< int >::type buffer(bufferSEXP);
    Rcpp::traits::input_parameter< int >::type window(windowSEXP);
    __result = Rcpp::wrap(fast_traverse_totals(x, w, buffer, window));
    return __result;
END_RCPP
}
// fast_wtd_mean
double fast_wtd_mean(NumericVector x, NumericVector w);
RcppExport SEXP ppR_fast_wtd_mean(SEXP xSEXP, SEXP wSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< NumericVector >::type x(xSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type w(wSEXP);
    __result = Rcpp::wrap(fast_wtd_mean(x, w));
    return __result;
END_RCPP
}
