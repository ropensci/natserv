context("ns_images")

test_that("ns_images works as expected", {
  skip_on_cran()

  aa <- ns_images(uid = 'ELEMENT_GLOBAL.2.100925')

  expect_is(aa, 'list')
  expect_named(aa, c('terms', 'images'))
  expect_is(aa$terms, 'character')
  expect_is(aa$images, 'list')
  expect_is(aa$images[[1]], 'list')
  expect_is(aa$images[[1]]$id, 'character')
})

test_that("ns_images fails well", {
  skip_on_cran()

  expect_error(ns_images("adfdf"),
               'no results found')
  expect_error(ns_images(scientificName = "asdfasf"),
               'no results found')
  expect_error(ns_images(commonName = "asdfasf"),
               'no results found')
})
