
#' NSRR data sets
#'
#' @inheritParams nsrr_token
#'
#' @return A \code{data.frame} of the data sets and their endpoints
#' @export
#'
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#'
#' @examples
#' df = nsrr_datasets()
#' testthat::expect_is(df, "data.frame")
nsrr_datasets = function(token = nsrr_token()) {
  website = nsrr_website()
  datasets = paste0(website, "/datasets.json")
  query = list()
  query$auth_token = token
  res = httr::GET(datasets, query = query)
  x = httr::content(res, as = "text")
  x = jsonlite::fromJSON(x, flatten = TRUE)
  x$slug = sub("/datasets/", "", trimws(x$path))
  x$slug = sub(".json$", "", x$slug)
  x$files = sub(".json", "", x$path)
  x$files = paste0("/api/v1", x$files, "/files.json")

  return(x)
}

