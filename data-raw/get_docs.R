library(pdftools)
library(dams)

data("nid_subset")
nid_all <- get_nid(dest = "data-raw/NID2019_U.xlsx", overwrite = FALSE)

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
res <- dplyr::mutate(res, field = gsub("\n", "", field))
res <- data.frame(res)

name_match <- function(x, y = names(nid_all), max_dist = 50){
  # x <- res$field[47]; max_dist <- 30; y <- names(nid_all)
  x <- tolower(x)
  x <- stringr::str_extract(x, "^(.+?)(?=\\s\\()")
  
  x <- gsub("nearest downstream ", "", x)
  x <- gsub("downstream ", "", x)
  x <- gsub("lock ", "", x)
  if (length(grep(",", x)) > 0) {
    x <- stringr::str_extract(x, "^(.+?)(?=,)")
  }
  
  y <- y[substring(y, 0, 1) == substring(tolower(x), 0, 1)]
  
  ind <- 1
  while (
    length(which(
      agrepl(x, y,
         ignore.case = TRUE,
         max.distance = list(all = max_dist + 1))
      )) > 1 & 
    max_dist > 0
    ) {
    
    ind <- which(agrepl(x, y,
           ignore.case = TRUE,
           max.distance = list(all = max_dist)))
    # print(ind)
    # print(paste0("max_dist = ", max_dist))
    max_dist <- max_dist - 1
  }
  res_name <- y[ind]
  res_name <- res_name[!is.na(res_name)]
  if (length(res_name) > 1) {
    res_name <- res_name[nchar(res_name) == nchar(x)]
  }
  return(res_name[1])
}

# name_match(res$field[1], max_dist = 30)
# name_match(res$field[2], max_dist = 30)
# name_match(res$field[10], max_dist = 30)
# name_match(res$field[13], max_dist = 30)
# name_match(res$field[36], max_dist = 30)
# name_match(res$field[47], max_dist = 30)
# name_match(res$field[50], max_dist = 30)
# name_match(res$field[66], max_dist = 30)

field_names <- sapply(res$field, function(x) name_match(x, max_dist = 30))
field_names <- as.character(field_names)
field_names[which(field_names == "character(0)")] <- NA
# sum(!is.na(field_names)) / length(names(nid_all))
# names(nid_all)[!(names(nid_all) %in% field_names)]
res <- cbind(field_names, res)
res <- res[!is.na(res[,1]),]
# View(res)

# convert to pasteable markdown pkg docs
tabular <- function(df, ...) {
  stopifnot(is.data.frame(df))
  
  align <- function(x) if (is.numeric(x)) "r" else "l"
  col_align <- vapply(df, align, character(1))
  
  cols <- lapply(df, format, ...)
  contents <- do.call("paste",
                      c(cols, list(sep = " \\tab ", collapse = "\\cr\n  ")))
  
  paste("\\tabular{", paste(col_align, collapse = ""), "}{\n  ",
        contents, "\n}\n", sep = "")
}

test <- paste0("#' ", readLines(textConnection(
  tabular(
    setNames(data.frame(res), c("Field", "Description"))
    )
  )))
clipr::write_clip(test)