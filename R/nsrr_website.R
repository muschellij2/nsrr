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
  url = paste0(website, "/api/v1/")
  url
}

