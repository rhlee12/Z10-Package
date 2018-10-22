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
    
    do.stats=function(merged.df){
        
        min=NA 
        max=NA
        mean=NA
        
        if(nrow(merged.df)>1){
        merged.df$endDateTime=.handle.dates(merged.df$endDateTime)
        
        merged.df$endDateTime=lubridate::with_tz(merged.df$endDateTime, tzone = site.meta$location.properties$locationPropertyValue[site.meta$location.properties$locationPropertyName=="Value for Site Timezone"])
        
        merged.df$day= cut(x=merged.df$endDateTime, breaks = "1 day")
        
        mean=mean(unlist(lapply(unique(merged.df$day), function(d) sum(merged.df[merged.df$day==d, grepl(pattern = "Bulk", x = colnames(merged.df))], na.rm = T))))
        min=min(unlist(lapply(unique(merged.df$day), function(d) sum(merged.df[merged.df$day==d, grepl(pattern = "Bulk", x = colnames(merged.df))], na.rm = T))))
        max=max(unlist(lapply(unique(merged.df$day), function(d) sum(merged.df[merged.df$day==d, grepl(pattern = "Bulk", x = colnames(merged.df))], na.rm = T))))
        
        out=c("minimum"=min, "mean"=mean, "maximum"=max)
        }
        return(c("minimum"=min, "mean"=mean, "maximum"=max))
    }
    
    out=lapply(both, do.stats)
    
    return(out)
}

