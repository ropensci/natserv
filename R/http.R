ns_GET <- function(url, query, ...){
  cli <- crul::HttpClient$new(url = url, opts = list(...))
  temp <- cli$get(query = query)
  temp$raise_for_status()
  temp$parse("UTF-8")
}
