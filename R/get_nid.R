#' Retrieve [nid_all] from the official NID site
#'
#' @param dest destination file path
#' @param overwrite logical. overwrite.
#' 
#' @export
#' @importFrom crul ok
#' @importFrom fauxpas http200
#' @importFrom janitor clean_names
#' @importFrom readxl read_excel
#' @importFrom utils download.file
#' 
#' @return [nid_all] entire NID data, all the 74000+ records from <http://nid.usace.army.mil/>
#' 
#' @examples
#' \dontrun{
#' dams_all <- get_nid()
#' }
#'
get_nid <- function(dest = "NID2019_U.xlsx", overwrite = FALSE){
  
  if (!file.exists("data-raw/NID2019_U.xlsx")) {
    download.file("https://nid.sec.usace.army.mil/ords/NID_R.DOWNLOADFILE?InFileName=NID2019_U.xlsx", 
                  "data-raw/NID2019_U.xlsx")
  }
  
    nid_cleaned <- NULL
    nid_url     <- "https://nid.sec.usace.army.mil/ords/NID_R.DOWNLOADFILE?InFileName=NID2019_U.xlsx"
    
    if (crul::ok(nid_url)) {
      if (!file.exists(dest) | overwrite) {
      message("downloading data. might take a few moments...")
        download.file(nid_url, dest)
      }
    }else{
      stop("URL for the complete NID data does not exist!")
    }
    
    nid_raw <- readxl::read_excel(dest)
    nid_raw <- janitor::clean_names(nid_raw)
    
    return(nid_raw)
}
