#' NatureServe taxonomic name search
#'
#' @export
#' @param x (character) A name to search for. An asterisk (*) wildcarded
#' species name, e.g., 'Aquila chry*'. Name matching is case-insensitive
#' and all of the primary and synonymous scientific names, along with
#' all common names, are matched. required.
#' @template ns
#' @return A tibble (data.frame), with columns:
#'
#' - jurisdictionScientificName - Scientfic name
#' - commonName - Common name
#' - globalSpeciesUid - UID - the taxonomic identifier NatureServe uses
#' - natureServeExplorerURI - URL to get to info online for the taxon
#' - taxonomicComments - comments about the taxon, if any
#'
#' @examples \dontrun{
#' ns_search(x = "Ruby*")
#' ns_search(x = "Helianthus annuus")
#' ns_search(x = "Ursus americanus")
#' }
ns_search <- function(x, key = NULL, ...) {
  assert(x, "character")
  res <- ns_GET(
    url = paste0(ns_base(), '/v1/globalSpecies/list/nameSearch'),
    query = list(name = x, NSAccessKeyId = check_key(key)),
    err_fxn = err_catch_search,
    ...
  )
  xml <- xml2::read_xml(res)
  kids <- xml2::xml_children(xml2::xml_children(xml)[[2]])
  dat <- lapply(kids, function(z) {
    data.frame(sapply(xml2::xml_children(z), function(x) {
      as.list(stats::setNames(xml2::xml_text(x), xml2::xml_name(x)))
    }), stringsAsFactors = FALSE)
  })
  df <- data.table::setDF(data.table::rbindlist(dat, use.names = TRUE, fill = TRUE))
  df <- move_col2(df, "natureServeExplorerURI")
  tibble::as_tibble(df)
}
