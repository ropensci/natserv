ns_GET <- function(url, query, ...){
  cli <- crul::HttpClient$new(url = url, opts = list(...))
  temp <- cli$get(query = query)
  if (temp$status_code > 201) {
    stop(sprintf("(%s) - %s", temp$status_code, temp$status_http()$message),
         call. = FALSE)
  }
  #err_catcher(temp)
  temp$parse()
}

# err_catcher <- function(x) {
#   xx <- xml2::read_xml(x$parse())
#   if (any(vapply(c("message", "error"), function(z) z %in% names(xx),
#                  logical(1)))) {
#     stop(xx[[1]], call. = FALSE)
#   }
# }
