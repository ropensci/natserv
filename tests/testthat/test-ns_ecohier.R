test_that("ns_ecohier", {
  skip_on_cran()

  vcr::use_cassette("ns_ecohier", {
    aa <- ns_ecohier("ELEMENT_GLOBAL.2.683060")
  })

  expect_is(aa, 'data.frame')
  expect_is(aa$uniqueId, 'character')
  expect_is(aa$name, 'character')
  expect_is(aa$nsxUrl, 'character')
  expect_is(aa$ecosystemType, 'character')
  expect_is(aa$classificationCode, 'character')
})

test_that("ns_ecohier fails well", {
  skip_on_cran()

  # an id must be given
  expect_error(ns_ecohier())
  # only 1 id can be given
  expect_error(ns_ecohier("a", "b"))
  # type wrong
  expect_error(ns_ecohier(5))
})
