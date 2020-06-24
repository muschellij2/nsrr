#' NSRR Download file
#'
#' @inheritParams nsrr_datasets
#' @param path full path to the file.
#'
#' @return A \code{data.frame} of the data sets and their endpoints
#' @export
#' @importFrom httr progress write_disk
#' @importFrom tools file_ext
#'
#' @examples
#' if (requireNamespace("xml2", quietly = TRUE) &
#'     requireNamespace("rvest", quietly = TRUE)) {
#'   res = httr::with_config(
#'     config = httr::config(ssl_verifypeer = FALSE),
#'     httr::GET("https://sleepdata.org/datasets/shhs/files/datasets")
#'   )
#'   doc = httr::content(res)
#'   tab = rvest::html_table(doc)[[1]]
#'   path = tab$X2
#'   path = path[ grepl("shhs-data-dictionary-.*-domains", path)]
#'   path = path[1]
#'   path = paste0("datasets/", path)
#' } else {
#'   path = "datasets/shhs-data-dictionary-0.14.0-domains.csv"
#' }
#' dataset = "shhs"
#' nsrr_download_url(dataset, path, token = "")
#' if (nsrr_have_token()) {
#' res = nsrr_download_file(dataset, path)
#' testthat::expect_true(res$success)
#' path = "biostatistics-with-r/shhs1.txt"
#' res = nsrr_download_file(dataset, path)
#' }
#' url = nsrr_download_url("shhs", path = "datasets/CHANGELOG.md",
#' token = NULL)
#' res = nsrr_download_file("shhs", path = "datasets/CHANGELOG.md",
#' token = NULL)
#' testthat::expect_true(res$correct_md5)
#' res = nsrr_download_file("shhs", path = "datasets/CHANGELOG.md",
#' token = NULL, check_md5 = FALSE)
#' testthat::expect_null(res$correct_md5)
nsrr_download_url = function(
  dataset,
  path,
  token = nsrr_token()
) {
  # stopifnot(!is.null(token))
  # stopifnot(length(token) == 1)
  ver = nsrr_version()

  if (!is.null(token)) {
    if (token == "") {
      token = NULL
    }
  }
  fname = paste(
    nsrr_website(),
    "datasets",
    dataset,
    "files", sep = "/")
  if (!is.null(token)) {
    fname = paste(fname, paste0("a/", token), sep = "/")
  }
  fname = paste(
    fname,
    "m",
    paste0("nsrr-r-v", gsub("[.]", "-", ver)),
    # paste0("nsrr-gem-v", gsub("[.]", "-", ver)),
    path, sep = "/")
  return(fname)
}

#' @export
#' @rdname nsrr_download_url
#' @param check_md5 check if MD5 checksum agrees when downloaded
#' @importFrom digest digest
nsrr_download_file = function(
  dataset, path,
  token = nsrr_token(),
  check_md5 = TRUE
) {
  stopifnot(length(path) == 1)
  url = nsrr_download_url(dataset, path, token = token)
  file_size = nsrr_dataset_files(dataset, path = path, token = token)
  file_md5 = file_size$file_checksum_md5
  file_size = file_size$file_size
  ext = tools::file_ext(url)
  tfile = tempfile(fileext = paste0(".", ext))
  query = list()
  query$auth_token = token
  res = httr::with_config(
    config = httr::config(ssl_verifypeer = FALSE),
    httr::GET(
      url,
      if (interactive()) httr::progress(),
      httr::write_disk(path = tfile),
      query = query
    )
  )
  raw_content = httr::content(res, as = "raw")
  size <- length(raw_content)
  correct_size = size == file_size
  if (check_md5) {
    md5 = digest::digest(tfile, file = TRUE, algo = "md5")
    correct_md5 = md5 == file_md5
    if (length(correct_md5) == 0) {
      warnings("MD5 file size not found, reporting TRUE")
      correct_md5 = TRUE
    }
  } else {
    correct_md5 = TRUE
  }


  success = httr::status_code(res) < 400 &
    correct_md5 & correct_size
  if (!success) {
    warning(paste0("Not successful download - ",
                   "likely not authorized for resource"))
  }
  L = list(response = res,
           outfile = tfile,
           correct_size = correct_size,
           success = success
  )
  if (check_md5) {
    L$correct_md5 = correct_md5
  }
  return(L)
}
