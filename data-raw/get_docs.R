library(pdftools)

data("nid_cleaned")

pdf_path <- "data-raw/NID_DataDictionary.pdf"
if (!file.exists(pdf_path)) {
  download.file("https://nid.sec.usace.army.mil/ords/NID_R.downloadFile?InFileName=NID_DataDictionary.pdf", pdf_path
                )
}

txt <- pdf_text(pdf_path)
# txt <- paste0(txt, collapse = "")

x <- c(
  "\n(1) apples and oranges (1) and   \n     pears and bananas",
  "pineapples and \n(2) mangos and guavas"
)

clean_text <- function(x){
  # x <- txt[1]
  # x <- stringr::str_squish(x)
  
  x   <- gsub(" \n ", " ", x)
  while (length(grep("  ", x)) > 0) {
    x <- gsub("  ", " ", x)
  }
  
  paste0(paste0(x, collapse = " "), "\n(99)") %>% 
    stringr::str_extract_all("(?<=\\n\\(\\d{1,2}\\))(.*?)(?=\\n\\(\\d{1,2}\\))") %>%
    unlist() %>% as.list() %>%
    lapply(trimws)
}

clean_text(fruits)
test <- clean_text(txt[1])
