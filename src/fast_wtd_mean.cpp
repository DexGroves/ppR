#include <Rcpp.h>
using namespace Rcpp;

//[[Rcpp::export]]
double fast_wtd_mean(NumericVector x, NumericVector w) {
  double* x_ptr = &x[0];
  double* w_ptr = &w[0];
  int N = x.size();

  double total_wx = 0;
  double total_w = 0;

  for (int i = 0; i < N; i++) {
    total_wx += *x_ptr * *w_ptr;
    total_w += *w_ptr ;
    w_ptr++;
    x_ptr++;
  }

  return(total_wx/total_w);
}
