#' Species search
#'
#' @export
#' @inheritParams ns_search_comb
#' @param species_taxonomy (list) species taxonomy. either a list with `level`,
#'   `scientificTaxonomy` (a scientific name), and optionally, `kingdom`, or
#'   with just `informalTaxonomy` (a vernacular name). If a `level!="kingdom"`, 
#'   `kingdom` must be supplied in list when using
#'   `scientificTaxonomy`. Possible `level` values:
#'   "kingdom", "phylum", "class", "order", "family", "genus".
#' @template ns
#' @family search
#' @examples \dontrun{
#' ns_search_spp(text = "robin")
#' ns_search_spp(text_adv = list(searchToken = "bird", 
#'   matchAgainst = "allNames", operator="similarTo"))
#' ns_search_spp(status = "G1")
#' ns_search_spp(location = list(nation = "US"))
#' ns_search_spp(location = list(nation = "US", subnation = "VA"))
#' ns_search_spp(species_taxonomy = list(scientificTaxonomy = "Animalia"
#'      , level = "kingdom"))
#' ns_search_spp(species_taxonomy = list(scientificTaxonomy = "Lepidoptera"
#'      , level = "order", kingdom = "Animalia")) 
#' ns_search_spp(species_taxonomy = list(informalTaxonomy = "birds"))
#' ns_search_spp(record_subtype = "macrogroup")
#' ns_search_spp(modified_since = "2020-04-30T00:00:00+0000")
#' ns_search_spp(page = 0, per_page = 2)
#' }
ns_search_spp <- function(text = NULL, text_adv = NULL, status = NULL,
  location = NULL, species_taxonomy = NULL, record_subtype = NULL,
  modified_since = NULL, page = NULL, per_page = NULL, ...) {

  paging <- handle_paging(page, per_page)
  text <- handle_text(text, text_adv)
  status <- handle_status(status)
  location <- handle_location(location)
  species_taxonomy <- handle_sptax(species_taxonomy)
  record_subtype <- handle_subtype(record_subtype)
  assert(modified_since, "character")
  res <- ns_POST(
    url = file.path(ns_base(), 'api/data/speciesSearch'),
    body = list(criteriaType = "species",
      textCriteria = list(text) %|lst|% NULL,
      statusCriteria = list(status) %|lst|% NULL,
      locationCriteria = list(location) %|lst|% NULL,
      speciesTaxonomyCriteria = list(species_taxonomy) %|lst|% NULL,
      recordSubtypeCriteria = list(record_subtype) %|lst|% NULL,
      pagingOptions = paging,
      modifiedSince = modified_since
    ),
    ...
  )
  parse_search(res)
}
