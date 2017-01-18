context("ns_search")

test_that("ns_search works as expected", {
  skip_on_cran()

  aa <- ns_search(x = "Helianthus annuus")

  expect_is(aa, 'tbl_df')
  expect_is(aa$globalSpeciesUid, 'character')
  expect_is(aa$jurisdictionScientificName, 'character')
  expect_is(aa$commonName, 'character')
  expect_is(aa$natureServeExplorerURI, 'character')

  expect_equal(aa$jurisdictionScientificName, 'Helianthus annuus')
})

test_that("ns_search fails well", {
  skip_on_cran()

  expect_error(ns_search(),
               'argument "x" is missing')
  expect_error(ns_search("asdfasf"),
               'no results found')
})
