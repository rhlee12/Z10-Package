############################################################################################
#' @title Return the Mean Annual Precipitation statistics for a site

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
#' cper=Z10::map(site = "CPER")
#' }
#' @export

#' @seealso Currently none

# changelog and author contributions / copyrights
#   Robert Lee (2018-10-19)
#     original creation
#
##############################################################################################

map=function(site){
  
  dp.id="DP1.00006.001"
  
  avail=dp.avail(dp.id)
  
  months=unlist(avail$months[avail$site==site])
  
  all=lapply(months, function(m) get.data(dp.id = dp.id, site = site, month = m))
  
  ALL=unlist(all, recursive = FALSE)
  
  secondary=ALL[grepl(pattern = "SECPRE", x = names(ALL))]
  primary=ALL[grepl(pattern = "PRIPRE", x = names(ALL))]
  
  if(length(secondary)==0){secondary=list(temp=data.frame(endDateTime=NA, Bulk=NA))}
  if(length(primary)==0){primary=list(temp=data.frame(endDateTime=NA, Bulk=NA))}
  
  sec.df=data.frame(do.call(rbind, .common.fields(secondary)), row.names = NULL)
  pri.df=data.frame(do.call(rbind, .common.fields(primary)), row.names = NULL)
  
  both=list(primary=pri.df, secondary=sec.df)
  # browser()
  out=lapply(both, function(x) .sum.do.basic.stats(x, field.key="Bulk", site=site))
  
  out=c(
    "primary.map"=out$primary[2]*365.25,
    "secondary.map"=out$secondary[2]*365.25
  )
  
  if(!is.na(out[1])){out[2]=NA}
  
  return(out)
}