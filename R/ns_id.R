#' Get taxon by uid
#'
#' @export
#' @param uid (character) A NatureServe taxon id (The taxon’s Element Global
#' UID). required.
#' @template ns
#' @return A list with lots of elements
#' @details see https://explorer.natureserve.org/api-docs/#_taxon_data_model
#' for details on the response data
#' @examples \dontrun{
#' ns_id("ELEMENT_GLOBAL.2.154701")
#' }
ns_id <- function(uid, ...) {
  assert(uid, "character")
  stopifnot("`uid` must be length 1" = length(uid) == 1)
  res <- ns_GET(
    url = file.path(ns_base(), 'api/data/taxon', uid),
    ...
  )
  jsonlite::fromJSON(res)
}
