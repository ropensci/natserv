test_that("ns_id", {
  skip_on_cran()

  vcr::use_cassette("ns_id", {
    aa <- ns_id("ELEMENT_GLOBAL.2.154701")
  })

  expect_is(aa, 'list')
  expect_is(aa$iucn, 'list')
  expect_equal(aa$iucn$iucnCode, 'VU')
  expect_is(aa$scientificName, 'character')
  expect_equal(aa$scientificName, 'Hydrastis canadensis')
  expect_is(aa$elementNationals, 'data.frame')
  expect_is(aa$speciesCharacteristics, 'list')
})

test_that("ns_id fails well", {
  skip_on_cran()

  # uid required
  expect_error(ns_id())
  # type wrong
  expect_error(ns_id(5))
  # uid must be length 1
  expect_error(ns_id(letters[1:3]))
})
