############################################################################################
#' @title Return daily temperature statistics for a site

#' @author Robert Lee \email{rhlee@@colorado.edu}\cr

#' @description This function calculates the daily miniumum, mean, and maximum
#' temperature values for a site over its period of record.
#'
#' @param site Parameter of class character.
#' The NEON site data should be downloaded for.

#' @return A list of min, mean and max temperature
#' values at the site, in centigrade
#'
#' @examples
#' \dontrun{
#' cper=Z10::daily.temp.stats(site = "CPER")
#' }
#' @export

#' @seealso Currently none

# changelog and author contributions / copyrights
#   Robert Lee (2018-10-22)
#     original creation
#
##############################################################################################

daily.temp.stats=function(site){

  dp.id="DP1.00002.001"

  avail=dp.avail(dp.id)

  months=unlist(avail$months[avail$site==site])

  all=lapply(months, function(m) get.data(dp.id = dp.id, site = site, month = m))

  flat=unlist(all, recursive = FALSE)

  ml2=flat[grepl(pattern = ".020.030", x = names(flat))] #ML 2 measurements

  temp.df=data.frame(do.call(rbind, .common.fields(ml2)), row.names = NULL)

  out=.do.basic.stats(x=temp.df, field.key="tempSingleMean")

  return(out)
}

