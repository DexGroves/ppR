make_longitudinal_data <- function(N, Nid = 2) {
  ids <- stringi::stri_rand_strings(Nid, length=8, pattern="[A-Za-z0-9]")
  data.frame(id = sample(ids, N, TRUE),
             date = round(runif(N) * 200) + 1000,
             resp = round(runif(N)))

}
