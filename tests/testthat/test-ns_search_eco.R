test_that("ns_search_eco", {
  skip_on_cran()

  vcr::use_cassette("ns_search_eco", {
    aa <- ns_search_eco(text = "robin")
  })

  expect_is(aa, 'list')
  expect_is(aa$results, 'data.frame')
  expect_is(aa$results, 'tbl_df')
  expect_is(aa$resultsSummary, 'data.frame')
  expect_is(attr(aa$resultsSummary, "search_criteria"), 'list')
})

test_that("ns_search_eco fails well", {
  skip_on_cran()

  # text must be character
  expect_error(ns_search_eco(text = 5))
  # text_adv must be character
  expect_error(ns_search_eco(text_adv = 5))
  # status must be character, and in allowed set
  expect_error(ns_search_eco(status = 5))
  expect_error(ns_search_eco(status = "foo"))
  # location must be NULL or a list
  expect_error(ns_search_eco(location = 5))
  expect_error(ns_search_eco(location = list(foobar = "US")))
  expect_error(ns_search_eco(location = list(nation = "US", dub = "d")))
  # ecosystem_taxonomy must be character
  expect_error(ns_search_eco(ecosystem_taxonomy = 5))
  # record_subtype must be character, and in allowed set
  expect_error(ns_search_eco(record_subtype = 5))
  expect_error(ns_search_eco(record_subtype = "bear"))
  # modified_since must be character
  expect_error(ns_search_eco(modified_since = 5))
  # paging must be a list, and both must be set if any given
  expect_error(ns_search_eco(page = "d"))
  expect_error(ns_search_eco(per_page = "d"))
  expect_error(ns_search_eco(page = 5))
  expect_error(ns_search_eco(per_page = 5))
})
