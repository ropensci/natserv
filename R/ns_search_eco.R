#' Ecosystem search
#'
#' @export
#' @inheritParams ns_search_comb
#' @param ecosystem_taxonomy (character) the classification code of the
#' higher level (ancestor) ecosystem. E.g.'s: "1" (Class code),
#' "1.B" (Subclass code), "1.B.2" (Formation code), "1.B.2.Nd" (Division code),
#' "M886" (Macrogroup key), "G206" (Group key), "A3328" (Alliance Key)
#' @template ns
#' @family search
#' @examples \dontrun{
#' ns_search_eco(text = "robin")
#' ns_search_eco(text_adv = list(searchToken = "bird",
#'   matchAgainst = "allNames", operator="similarTo"))
#' ns_search_eco(status = "G1")
#' ns_search_eco(location = list(nation = "US"))
#' ns_search_eco(location = list(nation = "US", subnation = "VA"))
#' ns_search_eco(ecosystem_taxonomy = "M067")
#' ns_search_eco(record_subtype = "macrogroup")
#' ns_search_eco(modified_since = "2020-04-30T00:00:00+0000")
#' ns_search_eco(page = 0, per_page = 2)
#' }
ns_search_eco <- function(text = NULL, text_adv = NULL, status = NULL,
  location = NULL, ecosystem_taxonomy = NULL, record_subtype = NULL,
  modified_since = NULL, page = NULL, per_page = NULL, ...) {

  paging <- handle_paging(page, per_page)
  text <- handle_text(text, text_adv)
  status <- handle_status(status)
  location <- handle_location(location)
  ecosystem_taxonomy <- handle_ecotax(ecosystem_taxonomy)
  record_subtype <- handle_subtype(record_subtype)
  assert(modified_since, "character")
  res <- ns_POST(
    url = file.path(ns_base(), 'api/data/ecosystemsSearch'),
    body = list(criteriaType = "ecosystems",
      textCriteria = list(text) %|lst|% NULL,
      statusCriteria = list(status) %|lst|% NULL,
      locationCriteria = list(location) %|lst|% NULL,
      ecosystemsTaxonomyCriteria = list(ecosystem_taxonomy) %|lst|% NULL,
      recordSubtypeCriteria = list(record_subtype) %|lst|% NULL,
      pagingOptions = paging,
      modifiedSince = modified_since
    ),
    ...
  )
  parse_search(res)
}
