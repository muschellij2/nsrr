#' NSRR All Dataset files
#'
#' @inheritParams nsrr_datasets
#'
#' @param max_files maximum files to return if not wanting to go through
#' all folders recursively.
#' @return A \code{data.frame} of the data sets and their endpoints
#' @export
#'
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#'
#' @examples
#' dataset = "shhs"
#' df = nsrr_all_dataset_files(dataset, max_files = 10)
#' testthat::expect_lte(nrow(df), 20)
#' # keep as donttest - takes a long time
#' \donttest{
#' df = nsrr_all_dataset_files(dataset)
#' }
#'
nsrr_all_dataset_files = function(dataset, token = nsrr_token(),
                                  max_files = Inf) {
  df = nsrr_dataset_files(dataset, path = NULL, token = token)
  df$is_folder = !df$is_file
  while (any(df$is_folder) & nrow(df) <= max_files) {
    ind = which(df$is_folder)[1]
    ipath = df$full_path[ind]
    print(ipath)
    df = df[-ind,]
    res = nsrr_dataset_files(dataset, path = ipath, token = token)
    res$is_folder = !res$is_file
    df = rbind(df, res)
  }
  return(df)
}
