#' Search exports
#'
#' @export
#' @param text (character) basic text search, equiavalent to `text_adv`
#' with `matchAgainst="allNames"` and `operator="similarTo"`
#' @param text_adv (list) advanced search, must specify the following three
#' elements: `searchToken`, `matchAgainst`, and `operator`. see 
#' https://explorer.natureserve.org/api-docs/#_advanced_text_search_parameter
#' @param status (character) conservation status, one of G1, G2, G3, G4,
#' G5, GH, GX, GNR, GNA, GU. case insensitive
#' @param location (list) location, country and sub-country. specify either
#' `nation` OR `nation` and `subnation`. each expects a two-letter ISO code
#' @param record_type (character) limit results by record type, one of
#' "species" or "ecosystem"
#' @param record_subtype (character) limit results by record sub-type, one of:
#' "class", "subclass", "formation", "division", "macrogroup", "group",
#' "alliance", "association", "terrestrial_ecological_system"
#' @param modified_since (character) search for records modified since a
#' given time. value must be a date and time with a UTC offset in ISO 8601
#' format. optional
#' @param format (character) output format, one of "json" or "xlsx"
#' @param lang (character) language, one of "en", "es", or "fr"
#' @param id (character) a job id, from output of `ns_export()`
#' @template ns
#' @return `ns_export()` returns a single character string (a job id)
#' `ns_export_status()` returns a list of metadata concerning the 
#' status of the export
#' @examples \dontrun{
#' x <- ns_export(text = "robin")
#' res <- ns_export_status(x)
#' str(res)
#' res$state
#' res$data$errorMessage
#' res$data$url
#' 
#' w <- ns_export(text_adv = list(searchToken = "western",
#'   matchAgainst="allScientificNames", operator="startsWith"))
#' m <- ns_export_status(w)
#' head(jsonlite::fromJSON(m$data$url))
#' }
ns_export <- function(text = NULL, text_adv = NULL, status = NULL,
  location = NULL, record_type = NULL, record_subtype = NULL,
  modified_since = NULL, format = "json", lang = "en", ...) {

  text <- handle_text(text, text_adv)
  status <- handle_status(status)
  location <- handle_location(location)
  record_type <- handle_type(record_type)
  record_subtype <- handle_subtype(record_subtype)
  assert(format, "character")
  stopifnot(format %in% c("json", "xlsx"))
  format <- paste0("summary_", format)
  assert(lang, "character")
  stopifnot(tolower(lang) %in% c("en", "es", "fr"))
  assert(modified_since, "character")
  res <- ns_POST(
    url = file.path(ns_base(), 'api/export/taxonSearch'),
    body = list(
      criteria = tc(list(
        criteriaType = "combined",
        textCriteria = list(text) %|lst|% list(),
        statusCriteria = list(status) %|lst|% list(),
        locationCriteria = list(location) %|lst|% list(),
        recordTypeCriteria = list(record_type) %|lst|% list(),
        recordSubtypeCriteria = list(record_subtype) %|lst|% list(),
        modifiedSince = modified_since %||% NULL
      )),
      exportFormat = format,
      exportLanguage = lang
    ),
    ...
  )
  jsonlite::fromJSON(res)$jobId
}

#' @export
#' @rdname ns_export
ns_export_status <- function(id, ...) {
  assert(id, "character")
  res <- ns_GET(file.path(ns_base(), 'api/job', id), ...)
  jsonlite::fromJSON(res)
}
