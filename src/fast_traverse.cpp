#include <Rcpp.h>
using namespace Rcpp;

//[[Rcpp::export]]
List fast_traverse_totals(NumericVector x, NumericVector w,
                          int buffer, int window) {
  int N = x.size();

  NumericVector resp_out = NumericVector(N);
  NumericVector wt_out = NumericVector(N);
  double total_wx = 0;
  double total_w = 0;

  double* x_ptr = &x[0];
  double* w_ptr = &w[0];
  double* resp_out_ptr = &resp_out[0];
  double* wt_out_ptr = &wt_out[0];

  for (int i = 0; i < window; i++) {
    total_wx += *x_ptr * *w_ptr;
    total_w += *w_ptr;

    w_ptr++;
    x_ptr++;
  }

  for (int i = window ; i < N; i++) {
    *resp_out_ptr = total_wx / total_w;
    *wt_out_ptr = total_w;

    total_wx += *x_ptr * *w_ptr;
    total_w += *w_ptr;

    total_wx -= *(x_ptr - window)* *(w_ptr - window);
    total_w -= *(w_ptr - window);

    w_ptr++;
    x_ptr++;
    resp_out_ptr++;
    wt_out_ptr++;
  }

  *resp_out_ptr = total_wx / total_w;
  *wt_out_ptr = total_w;

  return List::create(_["resp"] = resp_out, _["wt"] = wt_out) ;
}
