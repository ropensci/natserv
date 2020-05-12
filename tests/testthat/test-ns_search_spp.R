test_that("ns_search_spp", {
  skip_on_cran()

  vcr::use_cassette("ns_search_spp", {
    aa <- ns_search_spp(text = "robin")
  })

  expect_is(aa, 'list')
  expect_is(aa$results, 'data.frame')
  expect_is(aa$results, 'tbl_df')
  expect_is(aa$resultsSummary, 'data.frame')
  expect_is(attr(aa$resultsSummary, "search_criteria"), 'list')
})

test_that("ns_search_spp fails well", {
  skip_on_cran()

  # text must be character
  expect_error(ns_search_spp(text = 5))
  # text_adv must be character
  expect_error(ns_search_spp(text_adv = 5))
  # status must be character, and in allowed set
  expect_error(ns_search_spp(status = 5))
  expect_error(ns_search_spp(status = "foo"))
  # location must be NULL or a list
  expect_error(ns_search_spp(location = 5))
  expect_error(ns_search_spp(location = list(foobar = "US")))
  expect_error(ns_search_spp(location = list(nation = "US", dub = "d")))
  # species_taxonomy must be NULL or a list, and in allowed set
  expect_error(ns_search_spp(species_taxonomy = 5))
  expect_error(ns_search_spp(species_taxonomy = list(foobar = "US")))
  expect_error(ns_search_spp(species_taxonomy = list(foo = 3, level = 1)))
  # record_subtype must be character, and in allowed set
  expect_error(ns_search_spp(record_subtype = 5))
  expect_error(ns_search_spp(record_subtype = "bear"))
  # modified_since must be character
  expect_error(ns_search_spp(modified_since = 5))
  # paging must be a list, and both must be set if any given
  expect_error(ns_search_spp(page = "d"))
  expect_error(ns_search_spp(per_page = "d"))
  expect_error(ns_search_spp(page = 5))
  expect_error(ns_search_spp(per_page = 5))
})
