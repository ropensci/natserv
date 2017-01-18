#' NatureServe image metadata
#'
#' @export
#' @template ns
#' @param uid (character) a species UID, e.g., ELEMENT_GLOBAL.2.100925
#' @param scientificName (character) An asterisk (*) wildcarded species
#' scientific name, e.g., 'Aquila chry*'. Name matching is case-insensitive.
#' @param commonName (character) An asterisk (*) wildcarded species common
#' name, e.g., 'g*EAGLE'. Name matching is case-insensitive.
#' @param includeSynonyms (character)	An optional parameter, relevant to
#' scientific or common name queries, that indicates whether to include
#' synonymous names in the query, as follows:
#' \itemize{
#'  \item Y (or y) - search the Primary and all synonymous Scientific and
#'  Common Names
#'  \item Any other value, or omitted - search only the Primary Scientific
#'  and Common Name fields
#' }
#' @param resolution (character)	An optional parameter that restricts output
#' to images at a certain resolution. The value can be of one of the following.
#' \itemize{
#'  \item lowest - return only the lowest resolution version of images
#'  \item highest - return only the highest resolution version of images
#'  \item thumbnail - return only the version NatureServe deems the
#'  'thumbnail image'
#'  \item web - return only the version NatureServe deems the 'web image'
#' }
#' The omission of this parameter leads to the return of metadata for images at
#' all available resolutions.
#' @param ITISNames (character)	An optional parameter, relevant to scientific
#' or common name queries, that will indicate whether to restrict queries to
#' ITIS names, as follows.
#' \itemize{
#'  \item Y (or y) - query using ITIS names
#'  \item Any other value, or omitted - query using NatureServe names
#' }
#' NOTE: This parameter is a placeholder only and will not affect processing.
#' At present, searching by ITIS names is not possible.
#'
#' @details Note that the NatureServer servers apparently want Windows
#' HTML encoding (Windows-1252), instead of UTF-8, so some accents
#' and such may not work
#'
#' @return a list with terms and images
#'
#' @examples \dontrun{
#' # search by uid
#' ns_images(uid = 'ELEMENT_GLOBAL.2.100925')
#'
#' # search by common name and resolutio thumbnail
#' (res <- ns_images(commonName = "*eagle", resolution = 'thumbnail'))
#'
#' # search "Ruby*", all common names [in any language], and highest
#' # resolution only:
#' (res <- ns_images(commonName = "Ruby*", includeSynonyms = 'y',
#'   resolution = 'highest'))
#' }
ns_images <- function(uid = NULL, scientificName = NULL, commonName = NULL,
                      includeSynonyms = NULL, resolution = NULL,
                      ITISNames = NULL, key = NULL, ...) {

  assert(uid, "character")
  check_uid(uid)
  assert(scientificName, "character")
  assert(commonName, "character")
  assert(includeSynonyms, "character")
  assert(resolution, "character")
  assert(ITISNames, "character")
  args <- tc(list(uid = uid, scientificName = scientificName,
                  commonName = commonName, includeSynonyms = includeSynonyms,
                  resolution = resolution,
                  ITISNames = ITISNames, NSAccessKeyId = check_key(key)))
  res <- ns_GET(
    url = paste0(ns_base(), '/v1/globalSpecies/images'),
    query = args,
    err_fxn = err_catch_images,
    ...
  )
  xml <- xml2::read_xml(res)
  list(
    terms = strtrim(xml2::xml_text(
      xml2::xml_find_first(xml, "d1:termsAndConditions"))),
    images = lapply(xml2::xml_find_all(xml, "d1:image"), function(w) {
      d1 <- xml2::xml_find_all(w, "d1:*")
      d1 <- d1[which(xml2::xml_name(d1) != "imagePermission")]
      c(
        sapply(d1, function(y) as.list(stats::setNames(xml2::xml_text(y),
                                                       xml2::xml_name(y)))),
        list(
          imagePermission =
            sapply(
              xml2::xml_children((xml2::xml_find_all(w, "d1:imagePermission"))),
              function(y) as.list(stats::setNames(xml2::xml_text(y),
                                                  xml2::xml_name(y))))),
        sapply(xml2::xml_find_all(w, "dc:*"), function(y)
          as.list(stats::setNames(xml2::xml_text(y), xml2::xml_name(y))))
      )
    })
  )
}
