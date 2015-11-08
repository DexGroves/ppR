set.seed(1234)
jit_data <- make_longitudinal_data(1000)

jit_data_wt <- copy(jit_data)
jit_data_wt$wt <- runif(1000)

test_that("Acting reasonably without weights.", {
  jit_grid <- train_ppgrid(jit_data$id, jit_data$date, jit_data$resp,
                           lag = 10, window_size = 100, granularity = 50)

  expect_equal(round(jit_grid$dt$response, 4),
                c(0.5287, 0.4784, 0.4756, 0.5336, 0.5171, 0.5096))
  expect_equal(jit_grid$dt$wt,
                c(261, 255, 225, 253, 263, 261))


})

test_that("Acting reasonably with weights.", {
  jit_grid <- train_ppgrid(jit_data_wt$id, jit_data_wt$date, jit_data_wt$resp,
                           jit_data_wt$wt, lag = 10, window_size = 100,
                           granularity = 50)

  expect_equal(round(jit_grid$dt$response, 4),
                c(0.5405, 0.4767, 0.4385, 0.5418, 0.5025, 0.5042))
  expect_equal(round(jit_grid$dt$wt, 4),
                c(131.8131, 119.1166, 105.0173, 131.2385, 136.1911, 129.0213))

})

test_that("Working for a very simple example", {
  d <- data.frame(id   = as.factor(c(rep("a", 5), rep("b", 5))),
                  time = c(seq(1, 5), seq(1, 5)),
                  resp = c(seq(10, 50, 10), seq(10, 50, 10)))


  pp <- train_ppgrid(d$id, d$time, d$resp, lag = 1.0,
                     window_size = 1.0, granularity = 1.0)

  expected <- data.table(id_var   = as.factor(c(rep("a", 4),   rep("b", 4))),
                         start_ge = c(seq(1, 4),   seq(1, 4)),
                         end_lt   = c(seq(2, 5),   seq(2, 5)),
                         response = c(seq(10, 40, 10), seq(10, 40, 10)),
                         wt       = rep(1, 8),
                         score_pt = c(seq(3, 6), seq(3, 6)))

  expect_equal(pp$dt, expected)
})
