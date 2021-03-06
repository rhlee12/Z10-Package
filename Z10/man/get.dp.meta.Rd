% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_dp_meta.R
\name{get.dp.meta}
\alias{get.dp.meta}
\title{Return NEON data product metadata}
\usage{
get.dp.meta(dp.id)
}
\arguments{
\item{dp.id}{Parameter of class character. The data product code in question.}
}
\value{
Nested lists of data product metadata
}
\description{
Return detailed NEON data product metadata.
}
\examples{
\dontrun{
wind_meta=get.dp.meta(dp.id = "DP1.00002.001")
}
}
\seealso{
Currently none
}
\author{
Robert Lee \email{rhlee@colorado.edu}\cr
}
