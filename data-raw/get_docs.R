library(pdftools)

data("nid_cleaned")

pdf_path <- "data-raw/NID_DataDictionary.pdf"
# if (!file.exists(pdf_path)) {
#   download.file("https://nid.sec.usace.army.mil/ords/NID_R.downloadFile?InFileName=NID_DataDictionary.pdf", pdf_path
#                 )
# }

# system(paste0("ok ", pdf_path))
txt <- pdf_text(pdf_path)

clean_text <- function(x, strip_begin = FALSE){
  # x <- txt[2]
  # strip_begin <- FALSE
  
  # cleanup double spaces to fix regex errors
  x   <- gsub(" \n ", " ", x)
  while (length(grep("  ", x)) > 0) {
    x <- gsub("  ", " ", x)
  }
  # avoid fighting with newline characters
  x <- gsub("\n\\(", " !", x)
  # strip beginning from some entries, others add beginning anchor
  if (strip_begin) {
    x <- substring(x, stringr::str_locate(x, "!")[1], nchar(x))
  }else{
    x <- paste0("!", substring(x, 2))
  }
  # add ending anchor
  x <- paste0(x, " !99) ")
  
  res <- list()
  i <- 1
  while (
    !is.na(stringr::str_locate(x, "\\!")[1]) & nchar(x) > 5
    ) {
    cut_interval <- stringr::str_locate_all(x, "\\!\\d{1,2}\\)\\s")[[1]][c(1,2), 2]
    cut_interval[1] <- cut_interval[1] + 1
    cut_interval[2] <- cut_interval[2] - 6
    res[[i]] <- substring(x, cut_interval[1], cut_interval[2])
    x <- substring(x, cut_interval[2] + 2)
    i <- i + 1
  }
 res 
}

res <- list()
for (i in seq_along(txt)) {
  print(i)
  if (i == 1) {
    res[[i]] <- clean_text(txt[i], strip_begin = TRUE)
  }else{
    res[[i]] <- clean_text(txt[i])
  }
}

res <- do.call("c", res)
res <- tibble::enframe(unlist(res))
res <- dplyr::select(res,  field = value)

