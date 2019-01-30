#' NSRR Token
#'
#' @param token Token for NSRR resources.  Found at
#' \url{https://sleepdata.org/token}
#'
#' @return A character vector or NULL
#' @export
#'
#' @examples
#' is.null(nsrr_token())
#' if (!is.null(nsrr_token())) {
#'    res = nsrr_auth()
#'    res$authenticated
#' }
#' bad_res = nsrr_auth("")
#' bad_res$authenticated

nsrr_token = function(token = NULL) {
  if (is.null(token)) {
    token = Sys.getenv("NSRR_TOKEN")
  }
  if (length(token) > 0) {
    if (token == "") {
      token = NULL
    }
  }
  token = trimws(token)
  if (length(token) == 0) {
    token = NULL
  }
  token
}

#' @export
#' @rdname nsrr_token
nsrr_auth = function(token = NULL) {
  token = nsrr_token(token = token)

  website = nsrr_website()
  url = paste0(website, "/api/v1/account/profile.json")

  query = list()
  query$auth_token = token
  res = httr::GET(url, query = query)
  result = httr::content(res)
  result
}
