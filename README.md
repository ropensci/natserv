natserv
=======



[![cran checks](https://cranchecks.info/badges/worst/natserv)](https://cranchecks.info/pkgs/natserv)
[![Build Status](https://travis-ci.org/ropensci/natserv.svg?branch=master)](https://travis-ci.org/ropensci/natserv)
[![Build status](https://ci.appveyor.com/api/projects/status/mvmi4h4jn5ixf3hs?svg=true)](https://ci.appveyor.com/project/sckott/natserv)
[![codecov](https://codecov.io/gh/ropensci/natserv/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/natserv)
[![cran version](http://www.r-pkg.org/badges/version/natserv)](https://cran.r-project.org/package=natserv)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/natserv)](https://github.com/metacran/cranlogs.app)


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

See also the [taxize book](https://taxize.dev/) for 
a manual on working with taxonomic data in R, including with NatureServe data.

## Installation

Stable version from CRAN


```r
install.packages("natserv")
```

Development version


```r
remotes::install_github("ropensci/natserv")
```


```r
library('natserv')
```

## search


```r
ns_search(x = "Helianthus annuus")
#> # A tibble: 1 x 4
#>   globalSpeciesUid   jurisdictionScien… commonName  natureServeExplorerURI      
#>   <chr>              <chr>              <chr>       <chr>                       
#> 1 ELEMENT_GLOBAL.2.… Helianthus annuus  Common Sun… http://explorer.natureserve…
```

## data


```r
res <- ns_data(uid = 'ELEMENT_GLOBAL.2.100925')
names(res$ELEMENT_GLOBAL.2.100925)
#>  [1] "uid"                   "speciesCode"           "natureserve_uri"      
#>  [4] "classification"        "economicAttributes"    "ecologyAndLifeHistory"
#>  [7] "license"               "references"            "conservationStatus"   
#> [10] "managementSummary"     "distribution"
```

dig into distribution in various watersheds


```r
res$ELEMENT_GLOBAL.2.100925$distribution$watersheds
#> # A tibble: 599 x 4
#>    type  watershedName    watershedCode speciesOccurrenceCount
#>    <chr> <chr>            <chr>         <chr>                 
#>  1 HUC-8 Housatonic       01100005      1                     
#>  2 HUC-8 Upper Hudson     02020001      3                     
#>  3 HUC-8 Middle Hudson    02020006      1                     
#>  4 HUC-8 Hudson-Wappinger 02020008      2                     
#>  5 HUC-8 Noxubee          03160108      1                     
#>  6 HUC-8 Lower Leaf       03170005      1                     
#>  7 HUC-8 Pascagoula       03170006      2                     
#>  8 HUC-8 Black            03170007      1                     
#>  9 HUC-8 Escatawpa        03170008      1                     
#> 10 HUC-8 Black            04150101      1                     
#> # … with 589 more rows
```

## image metadata


```r
res <- ns_images(commonName = "*eagle", resolution = 'thumbnail')
res$images[[1]][1:5]
#> $id
#> [1] "15512"
#> 
#> $scientificName
#> [1] "Haliaeetus leucocephalus"
#> 
#> $commonName
#> [1] "Bald Eagle"
#> 
#> $otherCommonName
#> [1] "bald eagle"
#> 
#> $otherCommonName
#> [1] "pygargue à tête blanche"
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/natserv/issues).
* License: MIT
* Get citation information for `natserv` in R doing `citation(package = 'natserv')`
* Please note that this project is released with a [Contributor Code of Conduct][coc]. By participating in this project you agree to abide by its terms.

[![ropensci](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)

[coc]: https://github.com/ropensci/natserv/blob/master/CODE_OF_CONDUCT.md
