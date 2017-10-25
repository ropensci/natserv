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
#'  \item ecologyAndLifeHistory
#' }
#'
#' @examples \dontrun{
#' ## single id
#' (res <- ns_data(uid = 'ELEMENT_GLOBAL.2.100925'))
#' ## many ids at once
#' res <- ns_data(uid = c('ELEMENT_GLOBAL.2.100925', 'ELEMENT_GLOBAL.2.104470'))
#' res$ELEMENT_GLOBAL.2.100925
#' res$ELEMENT_GLOBAL.2.104470
#'
#' ns_data(uid = 'ELEMENT_GLOBAL.2.101998')
#' }
ns_data <- function(uid, key = NULL, ...) {
  assert(uid, "character")
  uid <- toupper(uid)
  check_uid(uid)

  res <- ns_GET(
    url = paste0(ns_base(), '/v1.1/globalSpecies/comprehensive'),
    query = list(
      uid = paste0(uid, collapse = ","),
      NSAccessKeyId = check_key(key)),
    err_fxn = err_catch_data,
    ...
  )
  xml <- xml2::read_xml(res, encoding = "UTF-8")
  xml <- xml2::xml_children(xml)
  stats::setNames(lapply(xml, function(m) {
    nsuri <- xml2::xml_text(xml2::xml_find_first(m, ".//d1:natureServeExplorerURI"))
    class <- xml2::as_list(xml2::xml_find_first(m, ".//d1:classification"))
    ecostat <- xml2::xml_text(xml2::xml_find_first(m, ".//d1:economicAttributes"))
    ecology <- xml2::as_list(xml2::xml_find_first(m, ".//d1:ecologyAndLifeHistory"))
    license <- strtrim(xml2::xml_text(xml2::xml_find_first(m, ".//d1:license")))
    refs <- xml2::xml_text(xml2::xml_children(xml2::xml_find_first(m, "//d1:references")))
    constat <- xml2::xml_find_first(m, ".//d1:conservationStatus")
    constat_c <- xml2::xml_children(xml2::xml_find_first(constat, './/d1:otherStatuses'))
    constat_other <- stats::setNames(lapply(constat_c, function(z) {
      sapply(xml2::xml_children(z), function(x)
        as.list(stats::setNames(xml2::xml_text(x), xml2::xml_name(x))))
    }), xml2::xml_attr(constat_c, "name"))
    constat_ns <- parse_nss(xml2::xml_find_first(constat, './/d1:natureServeStatus'))
    ms <- as_list_(xml2::xml_find_first(m, ".//d1:managementSummary"))
    dist <- parse_dist(xml2::xml_find_first(m, ".//d1:distribution"))
    list(
      uid = xml2::xml_attr(m, "uid"),
      speciesCode = xml2::xml_attr(m, "speciesCode"),
      natureserve_uri = nsuri,
      classification = class,
      economicAttributes = ecostat,
      ecologyAndLifeHistory = ecology,
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
  tmp <- xml2::xml_children(x)
  list(
    conservationStatusMap = xml2::xml_text(which_name(tmp, "conservationStatusMap")),
    globalRange = parse_if_1(tmp, "globalRange"),
    rangeMap = xml2::xml_text(which_name(tmp, "rangeMap")),
    endemism = parse_if_1(tmp, "endemism"),
    nations = {
      ch <- xml2::xml_children(which_name(tmp, "nations"))
      stats::setNames(lapply(ch, function(z) {
        if (xml2::xml_length(z) == 0) {
          list()
        } else {
          list(
            nationalDistributions = {
              as_list_(xml2::xml_child(which_name(xml2::xml_children(z), "nationalDistributions")[[1]]))
            },
            subnations = {
              sbn <- which_name(xml2::xml_children(z), "subnations")
              if (length(sbn) == 0) return(list())
              kids <- xml2::xml_children(sbn[[1]])
              lapply(kids, function(z) {
                c(
                  as.list(xml2::xml_attrs(z)),
                  as_list_(xml2::xml_find_first(z, "//d1:subnationalDistribution"))
                )
              })
            }
          )
        }
      }), xml2::xml_attr(ch, "nationCode"))
    },
    watersheds = {
      ch <- xml2::xml_children(which_name(tmp, "watersheds"))
      tibble::as_data_frame(data.table::rbindlist(lapply(xml2::xml_children(ch), function(w) {
        list(
          type = xml2::xml_attr(w, "type"),
          watershedName = xml2::xml_text(xml2::xml_find_first(w, "d1:watershedName")),
          watershedCode = xml2::xml_text(xml2::xml_find_first(w, ".//d1:watershedCode")),
          speciesOccurrenceCount = xml2::xml_text(xml2::xml_find_first(w, "d1:speciesOccurrenceCount"))
        )
      }), use.names = TRUE, fill = TRUE))
    },
    countyDistribution = {
      ch <- xml2::xml_children(xml2::xml_find_first(which_name(tmp, "countyDistribution"), "d1:occurrenceNations"))
      stats::setNames(lapply(ch, function(z) {
        st <- xml2::xml_children(xml2::xml_find_first(z, "d1:occurrenceStates"))
        stats::setNames(lapply(st, function(g) {
          data.table::setDF(data.table::rbindlist(
            lapply(xml2::xml_children(xml2::xml_find_first(g, "d1:occurrenceCounties")), as_list_),
            fill = TRUE,
            use.names = TRUE
          ))
        }), xml2::xml_attr(st, "code"))
      }), xml2::xml_attr(ch, "code"))
    }
  )
}

parse_nss <- function(x) {
  tmp <- xml2::xml_children(xml2::xml_find_first(x, "d1:globalStatus"))
  list(
    rank = xml2::xml_text(which_name(tmp, "rank")),
    roundedRank = xml2::as_list(which_name(tmp, "roundedRank")[[1]]),
    statusLastReviewed = xml2::xml_text(which_name(tmp, "statusLastReviewed")),
    statusLastChanged = xml2::xml_text(which_name(tmp, "statusLastChanged")),
    reasons = xml2::xml_text(which_name(tmp, "reasons")),
    conservationStatusFactors = {
      ch <- xml2::xml_children(which_name(tmp, "conservationStatusFactors"))
      if (length(ch) == 0) {
        list()
      } else {
        list(
          globalAbundance = parse_if_1(ch, "globalAbundance"),
          estimatedNumberOfOccurrences = parse_if_1(ch, "estimatedNumberOfOccurrences"),
          globalShortTermTrend = xml2::xml_text(which_name(ch, "globalShortTermTrend")),
          globalLongTermTrend = xml2::xml_text(which_name(ch, "globalLongTermTrend")),
          globalProtection = parse_if_1(ch, "globalProtection"),
          threat = xml2::xml_text(which_name(ch, "threat"))
        )
      }
    },
    nationalStatuses = {
      ch <- xml2::xml_children(which_name(tmp, "nationalStatuses")[[1]])
      stats::setNames(lapply(ch, function(w) {
        w <- xml2::xml_children(w)
        list(
          rank = xml2::xml_text(which_name(w, "rank")),
          roundedRank = xml2::xml_text(which_name(w, "roundedRank")),
          statusLastReviewed = xml2::xml_text(which_name(w, "statusLastReviewed")),
          subnationalStatuses = {
            subst <- xml2::xml_children(which_name(w, "subnationalStatuses"))
            lapply(subst, function(z) {
              c(
                as.list(xml2::xml_attrs(z)),
                rank = xml2::xml_text(which_name(xml2::xml_children(z), "rank")),
                roundedRank = xml2::xml_text(which_name(xml2::xml_children(z), "roundedRank"))
              )
            })
          }
        )
      }), xml2::xml_attr(ch, "nationCode"))
    }
  )
}

