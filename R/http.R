ns_GET <- function(url, query, err_fxn, ...){
  cli <- crul::HttpClient$new(url = url, opts = list(...))
  # cli <- crul::HttpClient$new(url = url)
  temp <- cli$get(query = query)
  temp$raise_for_status()
  x <- temp$parse("UTF-8")
  err_fxn(x)
  return(x)
}

err_catch_search <- function(x) {
  xml <- xml2::read_xml(x)
  if (length(xml2::xml_children(xml2::xml_children(xml)[[2]])) == 0) {
    stop("no results found", call. = FALSE)
  }
}

err_catch_data <- function(x) {
  xml <- xml2::read_xml(x)
  if (length(xml2::xml_children(xml)) == 0) {
    stop("no results found", call. = FALSE)
  }
}

err_catch_images <- function(x) {
  xml <- xml2::read_xml(x)
  if (length(xml2::xml_find_all(xml, "//d1:image")) == 0) {
    stop("no results found", call. = FALSE)
  }
}
