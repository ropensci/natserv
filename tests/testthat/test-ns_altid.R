test_that("ns_altid", {
  skip_on_cran()

  vcr::use_cassette("ns_altid", {
    aa <- ns_altid(id = "154701")
  })

  expect_is(aa, 'list')
  expect_is(aa$iucn, 'list')
  expect_equal(aa$iucn$iucnCode, 'VU')
  expect_is(aa$scientificName, 'character')
  expect_equal(aa$scientificName, 'Hydrastis canadensis')
  expect_is(aa$elementNationals, 'data.frame')
  expect_is(aa$speciesCharacteristics, 'list')
})

test_that("ns_altid fails well", {
  skip_on_cran()

  # an id must be given
  expect_error(ns_altid())
  # only 1 id can be given
  expect_error(ns_altid("a", "b"))
  # type wrong
  expect_error(ns_altid(5))
  # uid must be length 1
  expect_error(ns_altid(letters[1:3]))
})
