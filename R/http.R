ns_base <- function() 'https://explorer.natureserve.org'

ns_GET <- function(url, query = list(), ...){
  cli <- crul::HttpClient$new(url = url, opts = list(...))
  temp <- cli$get(query = query)
  temp$raise_for_status()
  x <- temp$parse("UTF-8")
  return(x)
}

ns_POST <- function(url, body, query = list(), ...){
  cli <- crul::HttpClient$new(url = url, opts = list(...),
    headers = list(Accept = "application/json"))
  temp <- cli$post(body = body, query = query, encode = "json")
  temp$raise_for_status()
  x <- temp$parse("UTF-8")
  return(x)
}
