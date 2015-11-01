test_that("fast_wtd_mean behaving as weighted.mean.", {
  set.seed(1234)
  test_vec <- rnorm(1000) * 10
  test_wt <- runif(1000)

  expect_equal(weighted.mean(test_vec, test_wt),
               fast_wtd_mean(test_vec, test_wt))
})

test_that("c++ round methods behaving as custom R round methods.", {
  set.seed(1234)
  test_vec <- rnorm(1000) * 10
  rnddwn_test_vec <- round_down(test_vec, 2)

  expect_equal(rnddwn_test_vec, fast_rnd_down(test_vec, 2))

  set.seed(1234)
  test_vec <- rnorm(1000) * 10
  rndup_test_vec <- round_up(test_vec, 2)

  expect_equal(rndup_test_vec, fast_rnd_up(test_vec, 2))
})

test_that("c++ round methods behaving as base R round method.", {
  set.seed(1234)
  test_vec <- rnorm(1000) * 10
  rnd_test_vec <- round(test_vec - 0.5)

  expect_equal(rnd_test_vec, fast_rnd_down(test_vec, 1))
})
