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

`%||%` <- function(x, y) if (is.null(x) || length(x) == 0) y else x
`%|lst|%` <- function(x, y) if (length(unlist(x)) == 0) y else x

strtrim <- function(str) {
  gsub("^\\s+|\\s+$", "", str)
}

str_extrct <- function(string, pattern) {
  regmatches(string, regexpr(pattern, string))
}

assert <- function(x, y) {
  if (!is.null(x)) {
    if (!class(x) %in% y) {
      stop(deparse(substitute(x)), " must be of class ",
           paste0(y, collapse = ", "), call. = FALSE)
    }
  }
}

check_uid <- function(x) {
  if (!is.null(x)) {
    greps <- grepl("ELEMENT_GLOBAL", x)
    if (any(!greps)) {
      stop("one or more 'uid's appear not to be NatureServe ID's:\n",
        paste0(x[!greps], collapse=", "),
        call. = FALSE)
    }
  }
}
