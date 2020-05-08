#' Species search
#'
#' @export
#' @param text (character) xxxx
#' @param text_adv (list) xxxx
#' @param status (character) conservation status
#' @param location (list) location, country and sub-country
#' @param species_taxonomy (character) species taxonomy
#' @param record_subtype (character) limit results by record sub-type
#' @param modified_since (character) search for records modified since a
#' given time. value must be a date and time with a UTC offset in ISO 8601
#' format. optional
#' @param page (integer) Zero-indexed page number; default: 0. optional
#' @param per_page (integer) Records per page; default: 20. optional
#' @template ns
#' @family search
#' @examples \dontrun{
#' ns_search_spp(text = "robin")
#' ns_search_spp(text_adv = list(searchToken = "bird", matchAgainst = "allNames", operator="similarTo"))
#' ns_search_spp(status = "G1")
#' ns_search_spp(location = list(nation = "US"))
#' ns_search_spp(location = list(nation = "US", subnation = "VA"))
#' ns_search_spp(species_taxonomy = list(speciesTaxonomy = "Animalia", level = "kingdom"))
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
  jsonlite::fromJSON(res)
}

