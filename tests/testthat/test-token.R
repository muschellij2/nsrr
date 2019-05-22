testthat::context(desc = "Testing data sets")


testthat::test_that(
  "Testing if data sets returns a data.frame if not authenticated", {

    df = nsrr_datasets(token = NULL)

    if (all(attributes(df)$status_code == 200)) {
      testthat::expect_is(df, "data.frame")
    }

  })

testthat::test_that("Testing if data sets returns a data.frame", {

  token = nsrr_token()
  if (!is.null(token)) {
    df = nsrr_datasets(token = token)
    if (all(attributes(df)$status_code == 200)) {
      testthat::expect_is(df, "data.frame")
    }
  }

})
