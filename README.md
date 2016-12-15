natserv
=======



[![Build Status](https://travis-ci.org/ropensci/natserv.svg?branch=master)](https://travis-ci.org/ropensci/natserv)
[![codecov](https://codecov.io/gh/ropensci/natserv/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/natserv)
[![cran version](http://www.r-pkg.org/badges/version/natserv)](https://cran.r-project.org/package=natserv)


`natserv` NatureServe R client

NatureServe is a non-profit organization that provides wildlife conservation related data to various groups including the public.

* [NatureServe site](https://services.natureserve.org)
* [NatureServe API docs](https://services.natureserve.org/BrowseServices/getSpeciesData/getSpeciesListREST.jsp)

All functions in this package are prefixed with `ns_` to prevent
collision with other pkgs.

Three NatureServe web services are available in this package:

* Name lookup (`ns_search`) lookup species Unique IDs (UID) by name. These UIDs are required for access to the more detailed services.
* Image lookup (`ns_images`) search for metadata for NatureServe images, including the URL's for the image files themselves.
* Fetch data (`ns_data`) on over 70,000 of the plant and animal species of the United States and Canada.

You'll need an API key to use this package. Get one by signing up at
<https://services.natureserve.org/developer/index.jsp>

## Installation

Stable version from CRAN


```r
install.packages("natserv")
```

Development version


```r
install.packages("devtools")
devtools::install_github("ropensci/natserv")
```


```r
library('natserv')
```

## search


```r
ns_search(x = "Helianthus annuus")
#> # A tibble: 1 × 4
#>          globalSpeciesUid jurisdictionScientificName       commonName
#>                     <chr>                      <chr>            <chr>
#> 1 ELEMENT_GLOBAL.2.134717          Helianthus annuus Common Sunflower
#> # ... with 1 more variables: natureServeExplorerURI <chr>
```

## data


```r
res <- ns_data(uid = 'ELEMENT_GLOBAL.2.100925')
names(res$ELEMENT_GLOBAL.2.100925)
#>  [1] "uid"                "speciesCode"        "natureserve_uri"
#>  [4] "classification"     "economicAttributes" "license"
#>  [7] "references"         "conservationStatus" "managementSummary"
#> [10] "distribution"
```

dig into distribution in various watersheds


```r
res$ELEMENT_GLOBAL.2.100925$distribution$watersheds
#> # A tibble: 458 × 4
#>     type         watershedName watershedCode speciesOccurrenceCount
#>    <chr>                 <chr>         <chr>                  <chr>
#> 1  HUC-8              Allagash      01010002                      1
#> 2  HUC-8 East Branch Penobscot      01020002                      1
#> 3  HUC-8        Upper Kennebec      01030001                      1
#> 4  HUC-8                  Dead      01030002                      7
#> 5  HUC-8        Lower Kennebec      01030003                      1
#> 6  HUC-8    Upper Androscoggin      01040001                      2
#> 7  HUC-8    Lower Androscoggin      01040002                      2
#> 8  HUC-8                  Saco      01060002                      4
#> 9  HUC-8          Upper Hudson      02020001                      3
#> 10 HUC-8      Hudson-Wappinger      02020008                      2
#> # ... with 448 more rows
```

## image metadata


```r
res <- ns_images(commonName = "*eagle", resolution = 'thumbnail')
res$images[[1]][1:5]
#> $id
#> [1] "16968"
#>
#> $scientificName
#> [1] "Haliaeetus leucocephalus"
#>
#> $commonName
#> [1] "Bald Eagle"
#>
#> $otherCommonName
#> [1] "pygargue à tête blanche"
#>
#> $otherCommonName
#> [1] "Águila Cabeza Blanca"
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/natserv/issues).
* License: MIT
* Get citation information for `natserv` in R doing `citation(package = 'natserv')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
