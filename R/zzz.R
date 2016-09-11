con_utf8 <- function(x) httr::content(x, "text", encoding = "UTF-8")

mssg <- function(v, ...) if (v) message(...)
tc <- function(l) Filter(Negate(is.null), l)
tcnull <- function(x) if (all(sapply(x, is.null))) NULL else x

pluck <- function(x, name, type) {
  if (missing(type)) {
    lapply(x, "[[", name)
  } else {
    vapply(x, "[[", name, FUN.VALUE = type)
  }
}

strtrim <- function(str) {
  gsub("^\\s+|\\s+$", "", str)
}

move_col <- function(tt, y){
  tt[ c(names(tt)[ -sapply(y, function(m) grep(m, names(tt))) ], y) ]
}

move_col2 <- function(x, y) x[ c(names(x)[-grep(y, names(x))], y) ]

which_name <- function(x, var) {
  x[which(xml_name(x) == var)]
}

parse_if <- function(x, y) {
  z <- which_name(x, y)
  if (length(z) == 0) list() else as_list_(z)
}

parse_if_1 <- function(x, y) {
  z <- which_name(x, y)
  if (length(z) == 0) list() else as_list_(z[[1]])
}

as_list_ <- function(x, y) {
  unlist(as_list(x), recursive = FALSE)
}

ns_base <- function() 'https://services.natureserve.org/idd/rest/ns'

check_key <- function(x) {
  tmp <- if (is.null(x)) Sys.getenv("NATURE_SERVE_KEY", "") else x
  if (tmp == "") getOption("NatureServeKey", stop("You need an API key for NatureServe")) else tmp
}
