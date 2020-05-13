test_that("ns_export", {
  skip_on_cran()

  vcr::use_cassette("ns_export", {
    aa <- ns_export(text = "tanager")
  })

  expect_is(aa, 'character')
  expect_match(aa, '[0-9a-z].+')
  expect_gt(nchar(aa), 30)

  vcr::use_cassette("ns_export_status", {
    res <- ns_export_status(aa)
  })

  expect_is(res, 'list')
  expect_named(res)
  expect_is(res$state, 'character')
  expect_is(res$data$url, 'character')
})

test_that("ns_export fails well", {
  skip_on_cran()

  # text must be character
  expect_error(ns_export(text = 5))
  # text_adv must be character
  expect_error(ns_export(text_adv = 5))
  # status must be character, and in allowed set
  expect_error(ns_export(status = 5))
  expect_error(ns_export(status = "foo"))
  # location must be NULL or a list
  expect_error(ns_export(location = 5))
  expect_error(ns_export(location = list(foobar = "US")))
  expect_error(ns_export(location = list(nation = "US", dub = "d")))
  # record_type must be character, and in allowed set
  expect_error(ns_export(record_type = 5))
  expect_error(ns_export(record_type = "bear"))
  # record_subtype must be character, and in allowed set
  expect_error(ns_export(record_subtype = 5))
  expect_error(ns_export(record_subtype = "bear"))
  # modified_since must be character
  expect_error(ns_export(modified_since = 5))
})
