#' @param key (character) API key. Required. See \strong{Authentication} below
#' for more.
#' @param ... Curl options passed on to \code{\link[crul]{HttpClient}}
#'
#' @references \url{https://services.natureserve.org/index.jsp}
#'
#' @section Authentication:
#' Get an API key from NatureServe at
#' \url{https://services.natureserve.org/developer/index.jsp}.
#' You can pass your token in as an argument or store it one of two places:
#'
#' \itemize{
#'   \item your .Rprofile file with an entry like
#'   \code{options(NatureServeKey = "your-natureserve-key")}
#'   \item your .Renviron file with an entry like
#'   \code{NATURE_SERVE_KEY=your-natureserve-key}
#' }
#'
#' See \code{\link{Startup}} for information on how to create/find your
#' .Rrofile and .Renviron files
