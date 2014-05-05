\name{extract_nid}
\alias{extract_nid}
\title{Extract desired data on dams from pre-processed NID data}
\usage{
  extract_nid(sample_only = TRUE)
}
\arguments{
  \item{sample_only}{logical flag indicating the desire to
  get only a sample of the NID data (which comes with this
  package) or the entire dataset}
}
\description{
  Extract desired data on dams from pre-processed NID data
}
\examples{
# sample NID data, 100 records only
dams_sample <- extract_nid()

# entire NID data, all the 74000+ records from bitbucket.org/rationshop
\dontrun{
dams_all <- extract_nid(sample_only = FALSE)
}
}

