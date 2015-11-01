set.seed(1234)
jit_data <- data.table(make_longitudinal_data(1000))

train_jit <- jit_data[date < 1100]
test_jit  <- jit_data[date >= 1100]


jit_grid <- train_ppgrid(train_jit$id, train_jit$date, train_jit$resp,
                         lag = 10, window_size = 50,
                         granularity = 25)

test_that("merge_ppgrid working with na_fill.", {
  test_out <- merge_ppgrid(test_jit$id, test_jit$date, jit_grid, FALSE)
  train_out <- merge_ppgrid(train_jit$id, train_jit$date, jit_grid, FALSE)

  expect_equal(round(sum(train_out$response, na.rm = TRUE), 4), 67.3663)
  expect_equal(round(sd(train_out$response, na.rm = TRUE), 6), 0.009309)
  expect_equal(sum(train_out$weight, na.rm = TRUE), 15716)

  expect_equal(round(sum(test_out$response, na.rm = TRUE), 4), 131.2054)
  expect_equal(round(sd(test_out$response, na.rm = TRUE), 6), 0.016311)
  expect_equal(sum(test_out$weight, na.rm = TRUE), 34395)
})

test_that("Acting reasonably with weights.", {
  test_out <- merge_ppgrid(test_jit$id, test_jit$date, jit_grid, TRUE)
  train_out <- merge_ppgrid(train_jit$id, train_jit$date, jit_grid, TRUE)

  expect_equal(round(sum(train_out$response, na.rm = TRUE), 4), 67.3663)
  expect_equal(round(sd(train_out$response, na.rm = TRUE), 6), 0.009309)
  expect_equal(sum(train_out$weight, na.rm = TRUE), 15716)

  expect_equal(round(sum(test_out$response, na.rm = TRUE), 4), 248.0381)
  expect_equal(round(sd(test_out$response, na.rm = TRUE), 6), 0.015942)
  expect_equal(sum(test_out$weight, na.rm = TRUE), 63453)
})
