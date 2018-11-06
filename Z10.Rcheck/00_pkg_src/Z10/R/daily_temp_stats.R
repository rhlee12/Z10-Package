############################################################################################
#' @title Return daily temperature statistics for a site

#' @author Robert Lee \email{rhlee@@colorado.edu}\cr

#' @description This function calculates the daily miniumum, mean, and maximum
#' temperature values for a site over its period of record.
#'
#' @param site Parameter of class character.
#' The NEON site data should be downloaded for.
#' @param bgn.date Optional. The start date of the period to generate statistics for.
#'  If not supplied, the first date of NEON data will be used. 
#' @param end.date Optional. The end date of the period to generate statistics for.
#'  If not supplied, the last date of NEON data will be used. 

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

daily.temp.stats=function(site, bgn.date, end.date){

  dp.id="DP1.00002.001"

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
  
  req.months=unique(substr(seq.Date(from=as.Date(bgn.date), to=as.Date(end.date), by = '1 month'), start = 1, stop = 7))
  
  months=req.months[req.months %in% months]
  
  date.seq=seq.Date(from=as.Date(bgn.date), to=as.Date(end.date), by = "1 day")
  
  flat=unlist(lapply(months, function(m) get.data(dp.id = dp.id, site = site, month = m)), recursive = FALSE)

  ml2=flat[grepl(pattern = ".020.030", x = names(flat))] #ML 2 measurements

  temp.df=data.frame(do.call(rbind, .common.fields(ml2)), row.names = NULL)

  min.temp=unlist(lapply(.dayify(df=.set.tz(temp.df, site = site)), function(d) min(d[,"tempSingleMean"], na.rm=T)))  
  mean.temp=unlist(lapply(.dayify(df=.set.tz(temp.df, site = site)), function(d) mean(d[,"tempSingleMean"], na.rm=T)))
  max.temp=unlist(lapply(.dayify(df=.set.tz(temp.df, site = site)), function(d) max(d[,"tempSingleMean"], na.rm=T)))
  
  data.frame("Date"=names(mean.temp), "Minimum"=min.temp, "Mean"=mean.temp, "Maximum"=max.temp) %>% `rownames<-`(NULL) -> out
  
  out=out[out$Date %in% as.character(date.seq),]
  
  return(out)
}

