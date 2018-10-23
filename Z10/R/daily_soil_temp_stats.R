############################################################################################
#' @title Return daily soil temperature statistics for a site

#' @author Robert Lee \email{rhlee@@colorado.edu}\cr

#' @description This function calculates the daily miniumum, mean, and maximum
#' soil temperature values at 50 cm depth for a site over its period of record.
#'
#' @param site Parameter of class character.
#' The NEON site data should be downloaded for.

#' @return A list of min, mean and max soil temperature
#' values at the site from 50 cm depth, in centigrade
#'
#' @examples
#' \dontrun{
#' cper=Z10::daily.rad.stats(site = "CPER")
#' }
#' @export

#' @seealso Currently none

# changelog and author contributions / copyrights
#   Robert Lee (2018-10-22)
#     original creation
#
##############################################################################################

daily.temp.stats=function(site){

  dp.id="DP1.00041.001"

  avail=dp.avail(dp.id)

  months=unlist(avail$months[avail$site==site])

  all=lapply(months, function(m) get.data(dp.id = dp.id, site = site, month = m))

  flat=unlist(all, recursive = FALSE)

  tower.top=flat[grepl(pattern = ".0\\d0.030", x = names(flat))]

  rad.df=data.frame(do.call(rbind, .common.fields(tower.top)), row.names = NULL)

  rad.df=rad.df[which(rad.df$inSWMean>0),]

  out=.do.basic.stats(x=rad.df, field.key="inSWMean")

  out=out[c("mean", "maximum")]
  return(out)
}

