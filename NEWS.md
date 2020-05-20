dams 0.3.0
===============

### NEW FEATURES

* The raw NID data can now be pulled directly from the USACE rather than via a third party.

### MINOR IMPROVEMENTS

* `nid_clean` has been replaced by `nid_subset` and the process for deriving this subset is now fully documented (#1, #2).

dams 0.2
===============

### NEW FEATURES

* External data was compressed, columns removed to fit under CRAN size limits, moved inside package

### MINOR IMPROVEMENTS

* Converted vignette to Rmd

* Remade docs with roxygen2

* Package no longer contains data sample subset and `extract_nid` no longer references it.

* Added a `NEWS.md` file to track changes to the package.

dams 0.1
===============

* Data from NID was downloaded in March 2014.

* NID's website claims to have more than 80,000 dams; however, only 74,000 dams could be obtained from the website's UI.

* Package comes with sample data; entire dataset available on bitbucket.org/rationshop
