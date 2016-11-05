#' Retrieve desired data on dams from pre-processed NID data
#'
#' @export
#' @importFrom utils data read.csv
#' @importFrom RCurl url.exists getURL
#' @examples
#' 
#' # entire NID data, all the 74000+ records from bitbucket.org/rationshop
#' \dontrun{
#' dams_all <- get_nid()
#' }
#'
get_nid <- function() {
  
    # get complete data from bitbucket
    # code based on three tips - 
    # RCurl example on https
    # <http://stackoverflow.com/questions/19890633/r-produces-unsupported-url-scheme-error-when-getting-data-from-https-sites>
    # <https://answers.atlassian.com/questions/122394/url-to-bitbucket-raw-file-without-commits>

    nid_cleaned <- NULL
    
    nid_url <- "https://bitbucket.org/rationshop/packages/raw/master/nid_cleaned.txt"
    if(RCurl::url.exists(nid_url, ssl.verifypeer = FALSE)) {
      message("downloading data from bitbucket. might take a few moments...")
      nid_data <- RCurl::getURL(nid_url, ssl.verifypeer = FALSE)    
      nid_cleaned <- read.csv(text = nid_data, header = TRUE, quote = "",
                      as.is = TRUE, sep = "\t")
    } else {
      stop("URL for the complete NID data does not exist!")
    }
    
    return (nid_cleaned)
    
}
