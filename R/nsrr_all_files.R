#' NSRR All Dataset files
#'
#' @inheritParams nsrr_datasets
#'
#' @return A \code{data.frame} of the data sets and their endpoints
#' @export
#'
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#'
#' @examples
#' \dontrun{
#' dataset = "shhs"
#' df = nsrr_all_dataset_files(dataset)
#' }
nsrr_all_dataset_files = function(dataset, token = nsrr_token()) {
  df = nsrr_dataset_files(dataset, path = NULL, token = token)
  df$is_folder = !df$is_file
  while (any(df$is_folder)) {
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
