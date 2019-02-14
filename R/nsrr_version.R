#' NSRR Gem version online
#'
#' @return A character of the version
#' @export
#' @importFrom utils packageVersion
#'
#'
#' @examples
#' nsrr_version()
#' nsrr_gem_version()
#'
nsrr_version = function() {
  # "0.4.0"
  ver = utils::packageVersion("nsrr")
  as.character(ver)
}

#' @export
#' @rdname nsrr_version
#' @importFrom stats na.omit
nsrr_gem_version = function() {
  url = "https://raw.githubusercontent.com/nsrr/nsrr-gem/master/lib/nsrr/version.rb"
  res = httr::GET(url)
  httr::stop_for_status(res)
  cr = httr::content(res)
  ss = strsplit(cr, "\n")[[1]]
  ss = trimws(ss)
  ords = c("MAJOR","MINOR","TINY","BUILD")
  search_string = paste0("^(", paste(ords, collapse = "|"), ")")
  ss = ss[ grepl(search_string, ss)]
  ss = sub("nil", "", ss)
  ss =  sub("#.*", "", ss)
  ss = strsplit(ss, " ")
  n_ss = sapply(ss, function(x) {
    xx = x[grepl(search_string, x)]
    stopifnot(length(xx) <= 1)
    xx
  })
  names(ss) = n_ss
  ss = sapply(ss, function(x) {
    xx = x[!grepl(search_string, x)]
    xx = xx[ xx != "="]
    xx = xx[ xx != ""]
    if (length(xx) == 0) {
      xx = ""
    }
    xx = paste0(xx, collapse = ".")
    xx
  })
  ss
  ss = sub(" = ", "=", ss)
  m = match(names(ss), ords)
  m = stats::na.omit(m)
  ss = ss[ m ]
  ss = paste(ss, collapse = ".")
  ss = sub("[.]$", "", ss)
  ss = gsub("[..]", ".", ss)
  ss
}

