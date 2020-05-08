test_that("internal tooling", {
  # tc
  expect_error(tc())
  expect_equal(tc(5), 5)
  expect_equal(tc(list(5, NULL)), list(5))

  # pluck
  x <- list(list(foo = 5, stuff = 4), list(foo = 5), list(foo = 7, bar = 5))
  expect_error(pluck())
  expect_equal(pluck(x, "foo"), list(5, 5, 7))
  expect_equal(pluck(x, "foo", 1), c(5, 5, 7))

  # %||%
  expect_equal(5 %||% 6, 5)
  expect_equal(NULL %||% 5, 5)

  # %|lst|%
  expect_equal(list() %|lst|% 6, 6)
  expect_equal(list(list()) %|lst|% 6, 6)

  # strtrim
  expect_equal(strtrim(" adf "), "adf")

  # str_extrct
  expect_equal(str_extrct("stuff -things", "-.+"), "-things")

  # assert
  z <- 5L
  expect_error(assert(z, "character"))
  expect_null(assert(z, "integer"))
})
