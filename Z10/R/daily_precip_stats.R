############################################################################################
#' @title Return daily precipitation statistics for a site

#' @author Robert Lee \email{rhlee@@colorado.edu}\cr

#' @description This function calculates the daily miniumum, mean, and maximum
#' precipitation values for a site over its period of record.
#'
#' @param site Parameter of class character.
#' The NEON site data should be downloaded for.

#' @return A list of min, mean and max precipitaiton
#' values at the site, in milimeters
#'
#' @examples
#' \dontrun{
#' cper=Z10::daily.precip.stats(site = "CPER")
#' }
#' @export

#' @seealso Currently none

# changelog and author contributions / copyrights
#   Robert Lee (2018-10-19)
#     original creation
#
##############################################################################################

daily.precip.stats=function(site){

  dp.id="DP1.00006.001"

  site.meta=get.site.meta(site)

  avail=Z10::dp.avail(dp.id)

  months=unlist(avail$months[avail$site==site])

  all=lapply(months, function(m) Z10::get.data(dp.id = dp.id, site = site, month = m))

  ALL=unlist(all, recursive = FALSE)

  merged.df=data.frame(do.call(rbind, ALL), row.names = NULL)

  merged.df$startDateTime=as.POSIXct(gsub(x = merged.df$startDateTime, pattern = "T|Z", replacement = " "), tz="UTC")
  merged.df$endDateTime=as.POSIXct(gsub(x = merged.df$endDateTime, pattern = "T|Z", replacement = " "), tz="UTC")

  merged.df$endDateTime=lubridate::with_tz(merged.df$endDateTime, tzone = site.meta$location.properties$locationPropertyValue[site.meta$location.properties$locationPropertyName=="Value for Site Timezone"])

  merged.df$day= cut(x=merged.df$endDateTime, breaks = "1 day")

  mean=mean(unlist(lapply(unique(merged.df$day), function(d) sum(merged.df$priPrecipBulk[merged.df$day==d], na.rm = T))))
  min=min(unlist(lapply(unique(merged.df$day), function(d) sum(merged.df$priPrecipBulk[merged.df$day==d], na.rm = T))))
  max=max(unlist(lapply(unique(merged.df$day), function(d) sum(merged.df$priPrecipBulk[merged.df$day==d], na.rm = T))))

  return(c("minimum"=min, "mean"=mean, "maximum"=max))
  }

