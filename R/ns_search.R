#' NatureServe taxonomic name search
#'
#' @export
#' @param x (character) A name to search for. An asterisk (*) wildcarded species
#' name, e.g., 'Aquila chry*'. Name matching is case-insensitive and all of
#' the primary and synonymous scientific names, along with all common names,
#' are matched. Required.
#' @template ns
#'
#' @return A data.frame, with columns:
#' \itemize{
#'  \item jurisdictionScientificName - Scientfic name
#'  \item commonName - Common name
#'  \item globalSpeciesUid - UID - the taxonomic identifier NatureServe uses
#'  \item natureServeExplorerURI - URL to get to info online for the taxon
#'  \item taxonomicComments - comments about the taxon, if any
#' }
#'
#' @examples \dontrun{
#' ns_search(x = "Ruby*")
#' ns_search(x = "Helianthus annuus")
#' }
ns_search <- function(x, key = NULL, ...) {
  x <- httr::GET(paste0(ns_base(), '/v1/globalSpecies/list/nameSearch'),
           query = list(name = x, NSAccessKeyId = check_key(key)), ...)
  httr::stop_for_status(x)
  xml <- xml2::read_xml(con_utf8(x))
  kids <- xml2::xml_children(xml2::xml_children(xml)[[2]])
  dat <- lapply(kids, function(z) {
    data.frame(sapply(xml_children(z), function(x) {
      as.list(setNames(xml_text(x), xml_name(x)))
    }), stringsAsFactors = FALSE)
  })
  df <- plyr::rbind.fill(dat)
  df <- move_col2(df, "natureServeExplorerURI")
  tibble::as_data_frame(df)
}
