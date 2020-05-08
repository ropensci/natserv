handle_paging <- function(page, per_page) {
  assert(page, c('numeric', 'integer'))
  assert(per_page, c('numeric', 'integer'))
  if (!is.null(page) || !is.null(per_page)) {
    if (length(c(page, per_page)) != 2)
      stop("if `page` given, `per_page` must be given, and vice versa",
        call. = FALSE)
  }
  paging <- tcnull(list(page = page, recordsPerPage = per_page))
  return(paging)
}
handle_text <- function(text, text_adv) {
  assert(text, "character")
  assert(text_adv, "list")
  if (length(tc(list(text, text_adv))) > 0)
    stopifnot(xor(is.null(text), is.null(text_adv)))
  if (!is.null(text)) text <- list(paramType="quickSearch", searchToken=text)
  if (!is.null(text_adv)) {
    txt_adv_names = c("searchToken", "matchAgainst", "operator")
    assert(text_adv, "list")
    if (!all(names(text_adv) %in% txt_adv_names)) {
      stop("text_adv format incorrect; see ns_search_comb docs",
        call. = FALSE)
    }
    text <- c(paramType="textSearch", text_adv)
  }
  return(text)
}
p <- function(x) paste0(x, collapse = ", ")
handle_status <- function(status) {
  assert(status, "character")
  if (!is.null(status)) {
    z <- c("G1", "G2", "G3", "G4", "G5", "GH", "GX", "GNR", "GNA", "GU")
    if (!tolower(status) %in% tolower(z))
      stop("`status` must be one of ", p(z), call. = FALSE)
    status <- list(paramType="globalRank", globalRank=status)
  }
  return(status)
}
handle_location <- function(location) {
  assert(location, "list")
  if (!is.null(location)) {
    if (!all(names(location) %in% c("nation", "subnation"))) {
      stop("`location` must be a list w/ 'nation' or 'nation' and 'subnation'",
        call. = FALSE)
    }
    pt <- if ("subnation" %in% names(location)) "subnation" else "nation"
    location <- c(paramType=pt, location)
  }
  return(location)
}
handle_type <- function(record_type) {
  assert(record_type, "character")
  if (!is.null(record_type)) {
    z <- c("species", "ecosystem")
    if (!tolower(record_type) %in% z)
      stop("`record_type` must be one of ", p(z),call. = FALSE)
    record_type <- list(paramType="recordType", recordType=record_type)
  }
  return(record_type)
}
handle_subtype <- function(record_subtype) {
  assert(record_subtype, "character")
  if (!is.null(record_subtype)) {
    z <- c("class", "subclass", "formation", "division", "macrogroup", "group",
      "alliance", "association", "terrestrial_ecological_system")
    if (!tolower(record_subtype) %in% z)
      stop("`record_subtype` must be one of ", p(z),call. = FALSE)
    return(list(paramType="ecosystemType", ecosystemType=record_subtype))
  }
  return(record_subtype)
}
handle_sptax <- function(st) {
  if (!is.null(st)) {
    pt <- if ("informalTaxonomy" %in% names(st)) "informalTaxonomy" else "scientificTaxonomy"
    st <- c(paramType=pt, st)
  }
  return(st)
}
handle_ecotax <- function(x) {
  if (!is.null(x)) {
    return(list(paramType="ecosystemHierarchyAncestor", classificationCode=x))
  }
  return(x)
}
