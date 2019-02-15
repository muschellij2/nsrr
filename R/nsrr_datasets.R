
#' NSRR data sets
#'
#' @inheritParams nsrr_token
#' @param page which page to grab.  Increment over successive requests to
#' retrieve all datasets. A request that return NULL or a number of datasets
#' less than 18 indicates the last page.
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
#' slugs = c("shhs", "chat", "heartbeat", "cfs", "sof", "mros", "ccshs",
#' "hchs", "haassa", "mesa", "learn", "homepap")
#' testthat::expect_true(all(slugs %in% df$slug))
nsrr_datasets = function(token = nsrr_token(),
                         page = NULL) {
  website = nsrr_api_url()
  datasets = paste0(website, "/datasets.json")
  query = list()
  query$auth_token = token
  query$page = page
  res = httr::GET(datasets, query = query)
  x = httr::content(res, as = "text")
  x = jsonlite::fromJSON(x, flatten = TRUE)
  x$slug = sub("/datasets/", "", trimws(x$path))
  x$slug = sub(".json$", "", x$slug)
  x$files = sub(".json", "", x$path)
  x$files = paste0(x$files, "/files.json")

  return(x)
}

#' @export
#' @rdname nsrr_datasets
#' @examples
#' nsrr_dataset(dataset = "shhs", token = "")
nsrr_dataset = function(
  dataset = NULL,
  token = nsrr_token()) {

  website = nsrr_api_url()
  datasets = paste0(website, "/datasets/", dataset, ".json")
  query = list()
  query$auth_token = token
  res = httr::GET(datasets, query = query)
  x = httr::content(res, as = "text")
  x = jsonlite::fromJSON(x, flatten = TRUE)
  return(x)
}

#' @export
#' @rdname nsrr_datasets
#' @param dataset a dataset \code{"slug"}, one from
#' \code{\link{nsrr_datasets}}
#' @param path a folder or file path inside the dataset
#' @examples
#' dataset = "shhs"
#' token = NULL
#' df = nsrr_dataset_files(dataset)
#' ddf = nsrr_dataset_files(dataset, path = df$full_path[1])
#'
#'
#' dataset = "shhs"
#' token = NULL
#' df = nsrr_dataset_files(dataset)
#' nsrr_dataset_files("wecare")
nsrr_dataset_files = function(
  dataset = NULL,
  path = NULL,
  token = nsrr_token()) {
  msg = "Need to specify one data set"
  if (is.null(dataset)) {
    stop(msg)
  }
  if (length(dataset) > 1) {
    stop(msg)
  }
  df = nsrr_datasets(token = token)
  url = nsrr_api_url()
  if (!dataset %in% df$slug) {
    warning("Dataset not in set from NSRR")
    url = paste0(url, "/datasets/", dataset, "/files.json")
  } else {
    idf = df[ df$slug %in% dataset, ]
    url = paste0(url, idf$files)
  }
  query = list()
  query$auth_token = token
  query$path = path
  res = httr::GET(url, query = query)
  httr::stop_for_status(res)
  cr = httr::content(res)
  if (is.null(cr)) {
    warning("Content was NULL, returning the response for debuggin")
    return(res)
  }
  x = httr::content(res, as = "text")
  x = jsonlite::fromJSON(x, flatten = TRUE)
  return(x)
}


