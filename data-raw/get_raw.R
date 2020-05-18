library(dplyr)
library(readxl)
library(janitor)
library(dams)

nid_raw <- get_nid(dest = "data-raw/NID2019_U.xlsx", overwrite = FALSE)

nid_cleaned   <- nid_raw %>%
  dplyr::select(-contains("cong_")) %>%
  dplyr::select(-contains("fed_")) %>%
  janitor::remove_empty(which = "cols")

# test <- apply(nid_cleaned, 2, function(x) sum(is.na(x)))
# test[order(test)]

# only include cols with less than 5 percent missing
complete_cols <- apply(nid_cleaned, 2, function(x) sum(is.na(x)))
complete_cols <- c(names(complete_cols[complete_cols < 5000]), "year_completed")
nid_cleaned   <- nid_cleaned[,names(nid_cleaned) %in% complete_cols]

use_data(nid_cleaned, compress = "xz", overwrite = TRUE)

# system("fsizemb data/nid_cleaned.rda")
