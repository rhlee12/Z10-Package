############################################################################################
#' @title Return daily soil temperature means by horizon

#' @author Robert Lee \email{rhlee@@colorado.edu}\cr

#' @description This function calculates the daily miniumum, mean, and maximum
#' temperature values for a site over its period of record for soil sensors located
#' in plot 1 of the site, at the lowest available instrument in each soil horizon.
#'
#' @param site Parameter of class character.
#' The NEON site data should be downloaded for.
#' @param bgn.date Optional. The start date of the period to generate statistics for.
#'  If not supplied, the first date of NEON data will be used. 
#' @param end.date Optional. The end date of the period to generate statistics for.
#'  If not supplied, the last date of NEON data will be used. 

#' @return A mean daily soil temperatures, by soil horizon, in degrees centigrade.
#'
#' @examples
#' \dontrun{
#' cper=Z10::daily.soil.temp.mean(site = "CPER")
#' }
#' @export

#' @seealso Currently none

# changelog and author contributions / copyrights
#   Robert Lee (2018-10-23)
#     original creation
#   Robert Lee (2018-11-05)
#     Refactoring out for granular stats
#
##############################################################################################

daily.soil.temp.mean=function(site,  bgn.date, end.date){
  mp.id="DP1.00096.001"
  dp.id="DP1.00041.001"
  mp.avail=dp.avail(mp.id)
  
  if(missing(bgn.date)){
    bgn.date=paste0(months[1], "-01")
  }
  
  if(missing(end.date)){
    end.month=months[length(months)]
    last.day=lubridate::days_in_month(as.Date(paste0(end.month, "-01")))
    end.date=paste0(end.month, "-", last.day)
  }
  
  if(!(site %in% mp.avail$site)){stop(paste0("Horizon information at ", site, " is not yet available via the API"))}
  
  mega.data=get.data(dp.id = mp.id, site = site, month = unlist(mp.avail[mp.avail$site==site, "months"]))
  
  horizon.data=mega.data[grepl(pattern = "perhorizon", x = names(mega.data))][[1]]
  
  horizon.data=horizon.data[order(horizon.data$horizonTopDepth), ]
  
  meta=get.site.meta(site)
  
  sp1.sensors=rjson::fromJSON(
    file=rjson::fromJSON(
      file=meta$location.children.urls[grepl(pattern = "SOILAR", x = meta$location.children.urls)]
    )$data$locationChildrenUrls[1]
  )$data
  
  temp.locs=sp1.sensors$locationChildrenUrls[grepl(pattern="SOILTP", x=sp1.sensors$locationChildrenUrls)]
  
  temp.depths=unlist(lapply(temp.locs, function(l) rjson::fromJSON(file = l)$data$zOffset))
  
  temp.depths=temp.depths[order(temp.depths, decreasing = T)]*-100
  
  sensor.horizons=data.frame(
    horizon=unlist(lapply(temp.depths, function(d)
      horizon.data$horizonName[which(horizon.data$horizonTopDepth<d & d<horizon.data$horizonBottomDepth)])),
    depth=temp.depths)
  
  rownames(sensor.horizons)=seq(nrow(sensor.horizons))
  
  avail=dp.avail(dp.id)
  
  months=unlist(avail$months[avail$site==site])
  
  req.months=unique(substr(seq.Date(from=as.Date(bgn.date), to=as.Date(end.date), by = '1 month'), start = 1, stop = 7))
  
  months=req.months[req.months %in% months]
  
  date.seq=seq.Date(from=as.Date(bgn.date), to=as.Date(end.date), by = "1 day")
  
  data.out=unlist(lapply(months, function(m) get.data(dp.id = dp.id, site = site, month = m)), recursive = FALSE)
  
  hor.dfs=lapply(unique(sensor.horizons$horizon), 
                 function(h) data.frame(do.call(rbind,
                                                .common.fields(
                                                  data.out[grep(pattern = paste0("001.50", rownames(sensor.horizons[sensor.horizons$horizon==h,])[1]), x = names(data.out))])),
                                        row.names = NULL
                 )) 
  lst.hor.dfs=lapply(hor.dfs, function(h) .dayify(df=.set.tz(h, site = site)))
  
  
  temp=data.frame(do.call(cbind, lapply(lst.hor.dfs, function(h) unlist(lapply(h, function(d) mean(d[,"soilTempMean"], na.rm = T))))))
  
  data.frame(date=rownames(temp), temp) %>% `colnames<-`(value=c("Date", unique(sensor.horizons$horizon)))-> out
  
  out=out[out$Date %in% as.character(date.seq),]
  
  return(out)
}



