#' The NSRR Website URL
#'
#' @return A character value of the website
#' @export
#'
#' @examples
#' nsrr_website()
nsrr_website = function() {
  website = "https://sleepdata.org"
  website
}

#' @export
#' @rdname nsrr_website
nsrr_api_url = function() {
  website = nsrr_website()
  url = paste0(website, "/api/", nsrr_api_version())
  url
}

#' NSRR API Functionality
#'
#' @param path path to endpoint for NSRR API
#' @param token Authorization Token for NSRR, passed to
#' \code{\link{nsrr_token}}
#' @param query query to pass to \code{\link{GET}}
#' @param ... additional arguments to pass to \code{\link{GET}}
#'
#' @return A response object
#' @export
nsrr_api = function(path, query = list(), token = NULL,
                    ...) {
  token = nsrr_token(token = token)

  url = paste0(nsrr_api_url(), path)

  query$auth_token = token
  res = httr::with_config(
    config = httr::config(ssl_verifypeer = FALSE),
    httr::GET(url, query = query, ...)
  )
  res
}

