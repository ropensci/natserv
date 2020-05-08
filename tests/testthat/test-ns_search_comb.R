test_that("ns_search_comb", {
  skip_on_cran()

  vcr::use_cassette("ns_search_comb", {
    aa <- ns_search_comb(text = "robin")
  })

  expect_is(aa, 'list')
  expect_is(aa$results, 'data.frame')
  expect_is(aa$results, 'tbl_df')
  expect_is(aa$resultsSummary, 'data.frame')
  expect_is(attr(aa$resultsSummary, "search_criteria"), 'list')
})

test_that("ns_search_comb fails well", {
  skip_on_cran()

  # text must be character
  expect_error(ns_search_comb(text = 5))
  # text_adv must be character
  expect_error(ns_search_comb(text_adv = 5))
  # status must be character, and in allowed set
  expect_error(ns_search_comb(status = 5))
  expect_error(ns_search_comb(status = "foo"))
  # location must be NULL or a list
  expect_error(ns_search_comb(location = 5))
  expect_error(ns_search_comb(location = list(foobar = "US")))
  expect_error(ns_search_comb(location = list(nation = "US", dub = "d")))
  # record_type must be character, and in allowed set
  expect_error(ns_search_comb(record_type = 5))
  expect_error(ns_search_comb(record_type = "bear"))
  # record_subtype must be character, and in allowed set
  expect_error(ns_search_comb(record_subtype = 5))
  expect_error(ns_search_comb(record_subtype = "bear"))
  # modified_since must be character
  expect_error(ns_search_comb(modified_since = 5))
  # paging must be a list, and both must be set if any given
  expect_error(ns_search_comb(page = "d"))
  expect_error(ns_search_comb(per_page = "d"))
  expect_error(ns_search_comb(page = 5))
  expect_error(ns_search_comb(per_page = 5))
})
