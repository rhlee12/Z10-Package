% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/daily_temp_stats.R
\name{daily.temp.stats}
\alias{daily.temp.stats}
\title{Return daily temperature statistics for a site}
\usage{
daily.temp.stats(site, bgn.date, end.date)
}
\arguments{
\item{site}{Parameter of class character.
The NEON site data should be downloaded for.}

\item{bgn.date}{Optional. The start date of the period to generate statistics for.
If not supplied, the first date of NEON data will be used.}

\item{end.date}{Optional. The end date of the period to generate statistics for.
If not supplied, the last date of NEON data will be used.}
}
\value{
A list of min, mean and max temperature
values at the site, in centigrade
}
\description{
This function calculates the daily miniumum, mean, and maximum
temperature values for a site over its period of record.
}
\examples{
\dontrun{
cper=Z10::daily.temp.stats(site = "CPER")
}
}
\seealso{
Currently none
}
\author{
Robert Lee \email{rhlee@colorado.edu}\cr
}
