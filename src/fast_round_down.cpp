#include <Rcpp.h>
#include <math.h>
using namespace Rcpp;

//[[Rcpp::export]]
NumericVector fast_rnd_down(NumericVector x, double granularity) {
  double* x_ptr = &x[0];
  int N = x.size();

  for (int i = 0; i < N; i++) {
    *x_ptr = floor(*x_ptr / granularity) * granularity;
    x_ptr++;
  }

  return(x);
}
