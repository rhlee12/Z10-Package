############################################################################################
#' @title Return daily total radiation statistics for a site

#' @author Robert Lee \email{rhlee@@colorado.edu}\cr

#' @description This function calculates the daily daylight mean and maximum
#' total solar radiation values for a site over the specified date range.
#'
#' @param site Parameter of class character.
#' The NEON site data should be downloaded for.
#' @param bgn.date Optional. The start date of the period to generate statistics for.
#'  If not supplied, the first date of NEON data will be used. 
#' @param end.date Optional. The end date of the period to generate statistics for.
#'  If not supplied, the last date of NEON data will be used. 
#'  
#' @return Mean and maximum daylight total solar radiation values by date,
#' in watts per meter squared.
#'
#' @examples
#' \dontrun{
#' # Return radiaiton stats for CPER over the summer solstice
#' cper=Z10::daily.rad.stats(site = "CPER")
#' # More information on the radiation data product used:
#' Z10::get.dp.meta("DP1.00014.001")$product.abstract
#' }
#' @export
#' @importFrom magrittr %>%
#' @seealso Currently none

# changelog and author contributions / copyrights
#   Robert Lee (2018-10-22)
#     original creation
#   Robert Lee (2018-11-05)
#     Refactoring out for granular stats
#
##############################################################################################

daily.rad.stats=function(site, bgn.date, end.date){
  
  dp.id="DP1.00014.001"
  
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
  
  tower.top=flat[grepl(pattern = ".0\\d0.030", x = names(flat))]
  
  rad.df=data.frame(do.call(rbind, .common.fields(tower.top)), row.names = NULL)
  
  rad.df=rad.df[which(rad.df$gloRadMean>0),]
  
  mean.rad=unlist(lapply(.dayify(df=.set.tz(rad.df, site = site)), function(d) mean(d[,"gloRadMean"], na.rm=T)))
  max.rad=unlist(lapply(.dayify(df=.set.tz(rad.df, site = site)), function(d) max(d[,"gloRadMean"], na.rm=T)))
  
  data.frame("Date"=names(mean.rad), "Mean"=mean.rad, "Maximum"=max.rad) %>% `rownames<-`(NULL) -> out
  
  out=out[out$Date %in% as.character(date.seq),]
  
  return(out)
}

