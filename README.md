natserv
=======



[![cran checks](https://cranchecks.info/badges/worst/natserv)](https://cranchecks.info/pkgs/natserv)
[![Build Status](https://travis-ci.org/ropensci/natserv.svg?branch=master)](https://travis-ci.org/ropensci/natserv)
[![Build status](https://ci.appveyor.com/api/projects/status/mvmi4h4jn5ixf3hs?svg=true)](https://ci.appveyor.com/project/sckott/natserv)
[![codecov](https://codecov.io/gh/ropensci/natserv/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/natserv)
[![cran version](https://www.r-pkg.org/badges/version/natserv)](https://cran.r-project.org/package=natserv)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/natserv)](https://github.com/metacran/cranlogs.app)


`natserv` NatureServe R client

NatureServe is a non-profit organization that provides wildlife conservation related data to various groups including the public.

* NatureServe site: https://services.natureserve.org
* NatureServe API docs: https://explorer.natureserve.org/api-docs/

All functions in this package are prefixed with `ns_` to prevent
collision with other pkgs.

You no longer need an API key.

See also the taxize book (https://taxize.dev/) for 
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

## Search


```r
ns_search_comb(text = "robin", page = 0, per_page = 5)
#> $results
#> # A tibble: 5 x 14
#>   recordType elementGlobalId uniqueId nsxUrl elcode scientificName
#>   <chr>                <int> <chr>    <chr>  <chr>  <chr>         
#> 1 SPECIES             100637 ELEMENT… /Taxo… ABPBJ… Copsychus sau…
#> 2 SPECIES             102323 ELEMENT… /Taxo… ABPBJ… Turdus grayi  
#> 3 SPECIES             102179 ELEMENT… /Taxo… ABPBJ… Turdus migrat…
#> 4 SPECIES             105536 ELEMENT… /Taxo… ABPBJ… Turdus migrat…
#> 5 SPECIES             105850 ELEMENT… /Taxo… ABPBJ… Turdus rufopa…
#> # … with 22 more variables: formattedScientificName <chr>,
#> #   primaryCommonName <chr>, primaryCommonNameLanguage <chr>,
#> #   roundedGRank <chr>, nations <list>, lastModified <chr>,
#> #   speciesGlobal$usesaCode <lgl>, $cosewicCode <lgl>, $saraCode <lgl>,
#> #   $synonyms <list>, $otherCommonNames <list>, $kingdom <chr>, $phylum <chr>,
#> #   $taxclass <chr>, $taxorder <chr>, $family <chr>, $genus <chr>,
#> #   $taxonomicComments <chr>, $informalTaxonomy <chr>, $infraspecies <lgl>,
#> #   $completeDistribution <lgl>, gRank <chr>
#> 
#> $resultsSummary
#>                            name value
#> 1                          page     0
#> 2                recordsPerPage     5
#> 3                    totalPages    26
#> 4                  totalResults   126
#> 5                 species_total   103
#> 6                         total    23
#> 7                       classes     0
#> 8                    subclasses     0
#> 9                    formations     0
#> 10                    divisions     0
#> 11                  macrogroups     1
#> 12                       groups     1
#> 13                    alliances     3
#> 14                 associations    18
#> 15 terrestrialEcologicalSystems     0
```

See the vignette (https://docs.ropensci.org/natserv/articles/natserv.html) for more examples.

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/natserv/issues).
* License: MIT
* Get citation information for `natserv` in R doing `citation(package = 'natserv')`
* Please note that this project is released with a [Contributor Code of Conduct][coc]. By participating in this project you agree to abide by its terms.

[![ropensci](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)

[coc]: https://github.com/ropensci/natserv/blob/master/CODE_OF_CONDUCT.md
