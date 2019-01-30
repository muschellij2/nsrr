
#' NSRR data sets
#'
#' @inheritParams nsrr_token
#'
#' @return A \code{data.frame} of the data sets and their endpoints
#' @export
#'
#' @examples
#' nsrr_datasets()
nsrr_datasets = function(token = nsrr_token()) {
  website = nsrr_website()
  datasets = paste0(website, "/datasets.json")
  query = list()
  query$auth_token = token
  res = httr::GET(datasets, query = query)
  x = httr::content(res, as = "text")
  x = jsonlite::fromJSON(x, flatten = TRUE)
  return(x)
}
