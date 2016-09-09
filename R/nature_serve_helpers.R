which_name <- function(x, var) {
  x[which(xml_name(x) == var)]
}

as_list_ <- function(x, y) {
  unlist(as_list(x), recursive = FALSE)
}

ns_base <- function() 'https://services.natureserve.org/idd/rest/ns'

check_key <- function(x) {
  tmp <- if (is.null(x)) Sys.getenv("NATURE_SERVE_KEY", "") else x
  if (tmp == "") getOption("NatureServeKey", stop("You need an API key for NatureServe")) else tmp
}
