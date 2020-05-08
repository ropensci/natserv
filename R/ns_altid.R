#' Get taxon by uid, id, or elCode
#'
#' @export
#' @param uid (character) A NatureServe taxon id (The taxon’s Element Global
#' UID)
#' @param id The primary key value (ELEMENT_GLOBAL_ID) of the record within
#' Central Biotics
#' @param el_code The Biotics Element Code (ELCODE_BCD) of the record
#' @template ns
#' @return A list with lots of elements
#' @details see https://explorer.natureserve.org/api-docs/#_taxon_data_model
#' for details on the response data
#' @examples \dontrun{
#' ns_altid(uid = "ELEMENT_GLOBAL.2.154701")
#' ns_altid(id = "154701")
#' ns_altid(el_code = "PDRAN0F010")
#' }
ns_altid <- function(uid = NULL, id = NULL, el_code = NULL, ...) {
  assert(uid, "character")
  assert(id, "character")
  assert(el_code, "character")
  if (is.null(c(uid, id, el_code)))
    stop("one of `uid`, `id`, or `el_code` must be provided", call. = FALSE)
  if (length(c(uid, id, el_code)) > 1)
    stop("only one of `uid`, `id`, `el_code` can be provided", call. = FALSE)
  res <- ns_GET(
    url = file.path(ns_base(), 'api/data/taxonSearch'),
    query = tc(list(ouSeqUid = uid, id = id, elCode = el_code)),
    ...
  )
  jsonlite::fromJSON(res)
}
