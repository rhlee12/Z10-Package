############################################################################################
#' @title Return daily precipitation statistics for a site

#' @author Robert Lee \email{rhlee@@colorado.edu}\cr

#' @description This function calculates the daily miniumum, mean, and maximum
#' precipitation values for a site over its period of record.
#'
#' @param site Parameter of class character.
#' The NEON site data should be downloaded for.
#' @param bgn.date Optional. The start date of the period to generate statistics for.
#'  If not supplied, the first date of NEON data will be used. 
#' @param end.date Optional. The end date of the period to generate statistics for.
#'  If not supplied, the last date of NEON data will be used. 

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

daily.precip.totals=function(site, bgn.date, end.date){
  
  dp.id="DP1.00006.001"
  
  avail=dp.avail(dp.id)
  
  months=unlist(avail$months[avail$site==site])
  if(missing(bgn.date)){
    bgn.date=paste0(months[1], "-01")
  }
  
  if(missing(end.date)){
    end.month=months[length(months)]
    last.day=lubridate::days_in_month(as.Date(paste0(end.month, "-01")))
    end.date=paste0(end.month, "-", last.day)
  }
  
  req.months=substr(seq.Date(from=as.Date(bgn.date), to=as.Date(end.date), by = '1 month'), start = 1, stop = 7)
  
  months=req.months[req.months %in% months]
  
  date.seq=seq.Date(from=as.Date(bgn.date), to=as.Date(end.date), by = "1 day")
  
  ALL=unlist(lapply(months, function(m) get.data(dp.id = dp.id, site = site, month = m)), recursive = FALSE)
  
  secondary=ALL[grepl(pattern = "SECPRE", x = names(ALL))]
  primary=ALL[grepl(pattern = "PRIPRE", x = names(ALL))]
  
  if(length(secondary)==0){secondary=list(temp=data.frame(endDateTime=NA, Bulk=NA))}
  if(length(primary)==0){primary=list(temp=data.frame(endDateTime=NA, Bulk=NA))}
  
  both=list(
    primary=data.frame(do.call(rbind, .common.fields(secondary)), row.names = NULL),
    secondary=data.frame(do.call(rbind, .common.fields(primary)), row.names = NULL)
  )
  
  day.slices=lapply(both, function(d) .dayify(.set.tz(df = d, site=site)))
  
  temp=lapply(day.slices, 
              function(l) data.frame(do.call(rbind, lapply(l, 
                                                           function(d) sum(d[,grepl(pattern = "Bulk", x = colnames(d))], na.rm=T))), date=names(l)
              )
  )
  
  out=merge(x=temp$primary, y=temp$secondary, by="date")
  
  colnames(out)=c("Date", "Primary", "Secondary")
  
  return(out)
}


