#' Map NatureServe data
#'
#' @export
#' @name ns_map
#' @param x the result of a call to \code{\link{ns_data}}
#' @param ... ignored
#' @examples \dontrun{
#' # Aquila chrysaetos
#' x <- ns_data(uid = 'ELEMENT_GLOBAL.2.100925')
#' ns_map_county(x)
#' ns_map_cons(x)
#' ns_map_stpr(x)
#'
#' # Ursus americanus
#' x <- ns_data('ELEMENT_GLOBAL.2.100661')
#' ns_map_county(x)
#' ns_map_cons(x)
#' ns_map_stpr(x)
#' }
ns_map_county <- function(x, ...) {
  chek_pk("mapproj")
  chek_pk("ggplot2")
  chek_pk("maps")
  stopifnot(inherits(x, "list"))
  co <- x[[1]]$distribution$countyDistribution
  if (length(co) == 0) stop("no county distribution data", call. = FALSE)
  co <- co[[1]]
  co <- Map(function(x, y) {
    x$state <- y
    x
  }, co, names(co))
  dat <- data.table::setDF(
    data.table::rbindlist(co, fill = TRUE, use.names = TRUE)
  )
  dat$countyName <- tolower(dat$countyName)
  dat$maximumLastObservedYear <- as.numeric(dat$maximumLastObservedYear)
  dat$speciesOccurrenceCount <- as.numeric(dat$speciesOccurrenceCount)

  dat <- merge(dat, nat_states, by = "state")

  counties <- ggplot2::map_data("county")
  counties_plus <- merge(
    counties,
    dat,
    by.x = c('region', 'subregion'),
    by.y = c('state_name', 'countyName'),
    all = TRUE)
  counties_plus <- counties_plus[order(counties_plus$order),]
  states <- ggplot2::map_data("state")
  ggplot2::ggplot(counties_plus, ggplot2::aes(long, lat, group = group)) +
    ggplot2::geom_polygon(ggplot2::aes(fill = speciesOccurrenceCount)) +
    ggplot2::coord_map(projection = "azequalarea") +
    ggplot2::scale_fill_gradient2("", na.value = "lightgrey", low = "white", high = "steelblue") +
    ggplot2::geom_path(data = counties, colour = "grey", size = .3, alpha = .4) +
    ggplot2::geom_path(data = states, colour = "grey", size = .4) +
    ggplot2::theme_bw(base_size = 14) +
    ggplot2::labs(x = "", y = "") +
    map_blanktheme() +
    ggplot2::scale_x_continuous(expand = c(0,0)) +
    ggplot2::scale_y_continuous(expand = c(0,0))
}

#' @export
#' @rdname ns_map
ns_map_cons <- function(x, ...) {
  chek_pk("mapproj")
  chek_pk("ggplot2")
  chek_pk("maps")
  nst <- x[[1]]$conservationStatus$natureserve$nationalStatuses
  nst <- Filter(function(x) NROW(x) > 0, Map(function(a, b) {
    tmp <- lapply(a$subnationalStatuses, function(x) {
      utils::modifyList(x, list(rank = status_pick(strsplit(x$rank, ",")[[1]][[1]]) ))
    })
    df <- data.table::setDF(
      data.table::rbindlist(tmp, fill = TRUE, use.names = TRUE)
    )
    if (NROW(df) > 0 ) df$country <- b
    df
  }, nst, names(nst)))
  nst <- do.call("rbind", unname(nst))
  nst$subnationName <- tolower(nst$subnationName)
  states <- ggplot2::map_data("state")
  st_plus <- merge(states, nst, by.x = 'region', by.y = 'subnationName', all.x = TRUE)
  st_plus <- st_plus[order(st_plus$order), ]
  ggplot2::ggplot(st_plus, ggplot2::aes(long, lat, group = group)) +
    ggplot2::geom_polygon(ggplot2::aes(fill = rank)) +
    ggplot2::coord_map(projection = "azequalarea") +
    ggplot2::geom_path(data = st_plus, colour = "grey", size = .4) +
    ggplot2::theme_bw(base_size = 14) +
    ggplot2::labs(x = "", y = "") +
    map_blanktheme() +
    ggplot2::scale_x_continuous(expand = c(0,0)) +
    ggplot2::scale_y_continuous(expand = c(0,0))
}

#' @export
#' @rdname ns_map
ns_map_stpr <- function(x, ...) {
  chek_pk("mapproj")
  chek_pk("ggplot2")
  chek_pk("maps")
  na <- x[[1]]$distribution$nations
  na <- Filter(function(x) NROW(x) > 0, Map(function(a, b) {
    df <- data.table::setDF(
      data.table::rbindlist(a$subnations, fill = TRUE, use.names = TRUE)
    )
    if (NROW(df) > 0 ) df$country <- b
    df
  }, na, names(na)))
  na <- do.call("rbind", unname(na))
  na$subnationName <- tolower(na$subnationName)
  na$currentPresenceAbsence <- gsub("Present", "1", na$currentPresenceAbsence)
  na$currentPresenceAbsence <- gsub("Absent", "0", na$currentPresenceAbsence)
  na$currentPresenceAbsence <- as.numeric(na$currentPresenceAbsence)
  states <- ggplot2::map_data("state")
  st_plus <- merge(states, na, by.x = 'region', by.y = 'subnationName', all.x = TRUE)
  st_plus <- st_plus[order(st_plus$order),]

  ggplot2::ggplot(st_plus, ggplot2::aes(long, lat, group = group)) +
    ggplot2::geom_polygon(ggplot2::aes(fill = currentPresenceAbsence)) +
    ggplot2::coord_map(projection = "azequalarea") +
    ggplot2::geom_path(data = states, colour = "grey", size = .4) +
    ggplot2::theme_bw(base_size = 14) +
    ggplot2::labs(x = "", y = "") +
    map_blanktheme() +
    ggplot2::scale_x_continuous(expand = c(0,0)) +
    ggplot2::scale_y_continuous(expand = c(0,0))
}

status_pick <- function(w) {
  stats <- c("SX","SH","S1","S2","S3","S4","S5","SNR","SU","SNA",
             "SXB", "SHB", "S1B", "S2B", "S3B", "S4B",
             "S5B", "SNRB", "SUB", "SNAB", "SXN", "SHN",
             "S1N", "S2N", "S3N", "S4N", "S5N", "SNRN",
             "SUN", "SNAN", "SXM", "SHM", "S1M", "S2M",
             "S3M", "S4M", "S5M", "SNRM", "SUM", "SNAM")
  mm <- Filter(
    function(x) length(x) > 0,
    sapply(stats, function(z) str_extrct(w, z)))
  tmp <- if (length(mm) == 0) {
    NA_character_
  } else {
    mm[[1]]
  }
  if (tmp %in% c('SNR', 'SU', 'SNA')) NA else tmp
}

