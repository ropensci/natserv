context("ns_data")

test_that("ns_data works as expected", {
  skip_on_cran()

  aa <- ns_data(uid = 'ELEMENT_GLOBAL.2.100925')

  expect_is(aa, 'list')
  expect_is(aa[[1]], 'list')
  expect_is(aa[[1]]$distribution, 'list')
  expect_is(aa[[1]]$distribution$countyDistribution$US$AZ, 'data.frame')

  expect_match(aa[[1]]$natureserve_uri, 'explorer.natureserve.org')
})
