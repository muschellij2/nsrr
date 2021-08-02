
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
#' if (attributes(df)$status_code == 200) {
#'   testthat::expect_is(df, "data.frame")
#'   slugs = c("abc", "bestair", "chat", "ccshs", "cfs",
#'             "heartbeat", "hchs", "homepap", "haassa", "learn")
#'   testthat::expect_true(all(slugs %in% df$slug))
#' }
#' on_cran = !identical(Sys.getenv("NOT_CRAN"), "true")
#' on_ci <- nzchar(Sys.getenv("CI"))
#' local_run = grepl("musch", tolower(Sys.info()[["user"]]))
#' run_example = !on_cran || on_ci || local_run
#' if (run_example) {
#'   df = nsrr_datasets(page = 1)
#' }
nsrr_datasets = function(token = nsrr_token(),
                         page = NULL) {
  # website = nsrr_api_url()
  # datasets = paste0(website, "/datasets.json")
  max_pages = 100
  check_max = TRUE
  if (is.null(page)) {
    pages = 1:max_pages
  } else {
    pages = page
    check_max = FALSE
  }
  df = vector(mode = "list", length = length(pages))
  for (ipage in seq_along(pages)) {
    page = pages[ipage]
    query = list()
    query$page = page
    res = nsrr_api(
      path = "/datasets.json",
      query = query,
      token = token)
    if (httr::status_code(res) == 500) {
      warning(
        paste0(
          "Please contact the NSRR Team - the server",
          " has indicated an error, returning NULL"
          ))
      return(NULL)
    }
    # res = httr::GET(datasets, query = query)
    httr::stop_for_status(res)
    x = httr::content(res, as = "text")
    x = jsonlite::fromJSON(x, flatten = TRUE)
    if (NROW(x) > 0) {
      x$slug = sub("/datasets/", "", trimws(x$path))
      x$slug = sub(".json$", "", x$slug)
      x$files = sub(".json", "", x$path)
      x$files = paste0(x$files, "/files.json")
      x$status_code = httr::status_code(res)
      x$page = ipage
      df[[ipage]] = x
    } else {
      break
    }
  }
  if (check_max && ipage >= max_pages) {
    warning(
      paste0(
        "May not have received all data - pass in page",
        " argument to paginate through")
    )
  }
  x = do.call("rbind", df)
  attr(x, "status_code") = unique(x$status_code)
  x$status_code = NULL

  return(x)
}

#' @export
#' @rdname nsrr_datasets
#' @examples
#' nsrr_dataset(dataset = "shhs", token = "")
nsrr_dataset = function(
  dataset = NULL,
  token = nsrr_token()) {

  res = nsrr_api(
    path = paste0("/datasets/", dataset, ".json"),
    token = token)

  x = httr::content(res, as = "text")
  x = jsonlite::fromJSON(x, flatten = TRUE)
  attr(x, "status_code") = httr::status_code(res)
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
#' nsrr_dataset_files(dataset = "wecare")
#'
#' testthat::expect_error(nsrr_dataset_files(), "one data")
#' testthat::expect_error(nsrr_dataset_files(c("shhs", "chat")), "one data")
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
  if (!dataset %in% df$slug) {
    warning("Dataset not in set from NSRR")
    run_path = paste0("/datasets/", dataset, "/files.json")
  } else {
    idf = df[ df$slug %in% dataset, ]
    run_path = idf$files
  }
  query = list()
  query$path = path
  res = nsrr_api(
    path = run_path,
    query = query,
    token = token)

  httr::stop_for_status(res)
  cr = httr::content(res)
  x = httr::content(res, as = "text")
  if (is.null(cr) ||
      (is.character(x) && all(x == ""))) {
    warning("Content was NULL, returning the response for debugging")
    return(res)
  }

  x = jsonlite::fromJSON(x, flatten = TRUE)
  attr(x, "status_code") = httr::status_code(res)
  return(x)
}


