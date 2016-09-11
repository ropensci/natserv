#' NatureServe data
#'
#' @export
#' @template ns
#' @param uid (character) a species UID, e.g., ELEMENT_GLOBAL.2.100925
#' @template status
#'
#' @return a named list, with possible slots:
#' \itemize{
#'  \item natureserve_uri
#'  \item classification
#'  \item economicAttributes
#'  \item license
#'  \item references
#'  \item conservationStatus
#'  \item managementSummary
#'  \item distribution
#' }
#'
#' @examples \dontrun{
#' ## single id
#' res <- ns_data(uid = 'ELEMENT_GLOBAL.2.100925')
#' ## many ids at once
#' res <- ns_data(uid = c('ELEMENT_GLOBAL.2.100925', 'ELEMENT_GLOBAL.2.104470'))
#' res$ELEMENT_GLOBAL.2.100925
#' res$ELEMENT_GLOBAL.2.104470
#' }
ns_data <- function(uid, key = NULL, ...) {
  x <- httr::GET(paste0(ns_base(), '/v1.1/globalSpecies/comprehensive'),
                 query = list(
                   uid = paste0(uid, collapse = ","),
                   NSAccessKeyId = check_key(key)), ...)
  httr::stop_for_status(x)
  xml <- read_xml(con_utf8(x), encoding = "UTF-8")
  xml <- xml_children(xml)
  stats::setNames(lapply(xml, function(m) {
    nsuri <- xml_text(xml_find_first(m, ".//d1:natureServeExplorerURI"))
    class <- as_list(xml_find_first(m, ".//d1:classification"))
    ecostat <- xml_text(xml_find_first(m, ".//d1:economicAttributes"))
    license <- strtrim(xml_text(xml_find_first(m, ".//d1:license")))
    refs <- xml_text(xml_children(xml_find_first(m, "//d1:references")))
    constat <- xml_find_first(m, ".//d1:conservationStatus")
    constat_c <- xml_children(xml_find_first(constat, './/d1:otherStatuses'))
    constat_other <- stats::setNames(lapply(constat_c, function(z) {
      sapply(xml_children(z), function(x) as.list(stats::setNames(xml_text(x), xml_name(x))))
    }), xml_attr(constat_c, "name"))
    constat_ns <- parse_nss(xml_find_first(constat, './/d1:natureServeStatus'))
    ms <- as_list_(xml_find_first(m, ".//d1:managementSummary"))
    dist <- parse_dist(xml_find_first(m, ".//d1:distribution"))
    list(
      natureserve_uri = nsuri,
      classification = class,
      economicAttributes = ecostat,
      license = license,
      references = refs,
      conservationStatus = list(other = constat_other, natureserve = constat_ns),
      managementSummary = ms,
      distribution = dist
    )
  }), uid)
}

# parsers
parse_dist <- function(x) {
  tmp <- xml_children(x)
  list(
    conservationStatusMap = xml_text(which_name(tmp, "conservationStatusMap")),
    globalRange = parse_if_1(tmp, "globalRange"),
    rangeMap = xml_text(which_name(tmp, "rangeMap")),
    endemism = parse_if_1(tmp, "endemism"),
    nations = {
      ch <- xml_children(which_name(tmp, "nations"))
      stats::setNames(lapply(ch, function(z) {
        if (xml_length(z) == 0) {
          list()
        } else {
          list(
            nationalDistributions = {
              as_list_(xml_child(which_name(xml_children(z), "nationalDistributions")[[1]]))
            },
            subnations = {
              kids <- xml_children(which_name(xml_children(z), "subnations")[[1]])
              lapply(kids, function(z) {
                c(
                  as.list(xml_attrs(z)),
                  as_list_(xml_find_first(z, "//d1:subnationalDistribution"))
                )
              })
            }
          )
        }
      }), xml_attr(ch, "nationCode"))
    },
    watersheds = {
      ch <- xml_children(which_name(tmp, "watersheds"))
      tibble::as_data_frame(data.table::rbindlist(lapply(xml_children(ch), function(w) {
        list(
          type = xml_attr(w, "type"),
          watershedName = xml_text(xml_find_first(w, "d1:watershedName")),
          watershedCode = xml_text(xml_find_first(w, ".//d1:watershedCode")),
          speciesOccurrenceCount = xml_text(xml_find_first(w, "d1:speciesOccurrenceCount"))
        )
      }), use.names = TRUE, fill = TRUE))
    },
    countyDistribution = {
      ch <- xml_children(xml_find_first(which_name(tmp, "countyDistribution"), "d1:occurrenceNations"))
      stats::setNames(lapply(ch, function(z) {
        st <- xml_children(xml_find_first(z, "d1:occurrenceStates"))
        stats::setNames(lapply(st, function(g) {
          data.table::setDF(data.table::rbindlist(
            lapply(xml_children(xml_find_first(g, "d1:occurrenceCounties")), as_list_),
            fill = TRUE,
            use.names = TRUE
          ))
        }), xml_attr(st, "code"))
      }), xml_attr(ch, "code"))
    }
  )
}

parse_nss <- function(x) {
  tmp <- xml_children(xml_find_first(x, "d1:globalStatus"))
  list(
    rank = xml_text(which_name(tmp, "rank")),
    roundedRank = as_list(which_name(tmp, "roundedRank")[[1]]),
    statusLastReviewed = xml_text(which_name(tmp, "statusLastReviewed")),
    statusLastChanged = xml_text(which_name(tmp, "statusLastChanged")),
    reasons = xml_text(which_name(tmp, "reasons")),
    conservationStatusFactors = {
      ch <- xml_children(which_name(tmp, "conservationStatusFactors"))
      if (length(ch) == 0) {
        list()
      } else {
        list(
          globalAbundance = parse_if_1(ch, "globalAbundance"),
          estimatedNumberOfOccurrences = parse_if_1(ch, "estimatedNumberOfOccurrences"),
          globalShortTermTrend = xml_text(which_name(ch, "globalShortTermTrend")),
          globalLongTermTrend = xml_text(which_name(ch, "globalLongTermTrend")),
          globalProtection = parse_if_1(ch, "globalProtection"),
          threat = xml_text(which_name(ch, "threat"))
        )
      }
    },
    nationalStatuses = {
      ch <- xml_children(which_name(tmp, "nationalStatuses")[[1]])
      stats::setNames(lapply(ch, function(w) {
        w <- xml_children(w)
        list(
          rank = xml_text(which_name(w, "rank")),
          roundedRank = xml_text(which_name(w, "roundedRank")),
          statusLastReviewed = xml_text(which_name(w, "statusLastReviewed")),
          subnationalStatuses = {
            subst <- xml_children(which_name(w, "subnationalStatuses"))
            lapply(subst, function(z) {
              c(
                as.list(xml_attrs(z)),
                rank = xml_text(which_name(xml_children(z), "rank")),
                roundedRank = xml_text(which_name(xml_children(z), "roundedRank"))
              )
            })
          }
        )
      }), xml_attr(ch, "nationCode"))
    }
  )
}

