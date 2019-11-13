############################################################################################
#' @title Return daily precipitation totals for a site

#' @author Robert Lee \email{rhlee@@colorado.edu}\cr
#' @author Cody Flagg \email{cody.flagg@@gmail.com}

#' @description This function calculates the daily precipitation totals over the
#'  specified date range
#'
#' @param site Parameter of class character.
#' The NEON site data should be downloaded for.
#' @param bgn.date Optional. The start date of the period to generate statistics for.
#'  If not supplied, the first date of NEON data will be used. 
#' @param end.date Optional. The end date of the period to generate statistics for.
#'  If not supplied, the last date of NEON data will be used. 

#' @return A data frame of primary and secondary precipitation totals by date. 
#' Totals are in millimeters.
#'
#' @examples
#' \dontrun{
#' # Return the entire period of record at CPER
#' cper=Z10::daily.precip.totals(site = "CPER")
#' }
#' @export

#' @seealso Currently none

# changelog and author contributions / copyrights
#   Robert Lee (2018-10-19)
#     original creation
#   Robert Lee (2018-11-05)
#     More granular data return and option to select period of data return
#
##############################################################################################

daily.precip.totals=function(site, bgn.date, end.date){
  # browser()
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
    Secondary=data.frame(do.call(rbind, .common.fields(secondary)), row.names = NULL),
    Primary=data.frame(do.call(rbind, .common.fields(primary)), row.names = NULL)
  )
  
  day.slices=lapply(both, function(d) .dayify(.set.tz(df = d, site=site)))
  #browser()
  temp=lapply(day.slices, 
              function(l) data.frame(do.call(rbind, lapply(l, 
                                                           function(d) {
                                                             #browser()
                                                             if(!is.null(d)){
                                                               if(!all(is.na(d[,1]))){
                                                                 sum(d[,grepl(pattern = "Bulk", x = colnames(d))], na.rm=T)
                                                               }else{
                                                                 # Return NA if date (`d`) is bereft of data
                                                                 NA
                                                               }
                                                               
                                                             }
                                                           }
              )
              ), date=names(l)
              )
  )
  #browser()
  if(nrow(temp$Secondary)>0 & nrow(temp$Primary)>0){
    out=merge(x=temp$Primary, y=temp$Secondary, by="date")
    
    colnames(out)=c("Date", "Primary", "Secondary")
  }else{
    out=temp[lapply(temp, nrow)>0] %>%
      unlist(recursive = F) %>%
      as.data.frame() %>%
      `colnames<-`(value=c(names(temp[lapply(temp, nrow)>0]), "Date"))
  }
  
  return(out)
}


