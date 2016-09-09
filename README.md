natserv
=======



`natserv` NatureServe R client

## Installation

### Stable version from CRAN


```r
install.packages("devtools")
devtools::install_github("ropenscilabs/natserv")
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
#> [1] "natureserve_uri"    "classification"     "economicAttributes"
#> [4] "license"            "references"         "conservationStatus"
#> [7] "managementSummary"  "distribution"
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

* Please [report any issues or bugs](https://github.com/ropenscilabs/natserv/issues).
* License: MIT
* Get citation information for `natserv` in R doing `citation(package = 'natserv')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
