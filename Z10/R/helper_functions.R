.camel.to.dot=function(string){
  substring(text=string, first=regexec(pattern="[A-Z]", text=string, ignore.case = FALSE)[[1]][1])


    dot.string=paste0(
    unlist(stringr::str_split(string, pattern = "[A-Z]")),
    ".",
    tolower(unlist(stringr::str_extract_all(string, pattern = "[A-Z]"))),
    collapse = "")

    dot.string=substr(x=dot.string, start=1, stop = (nchar(dot.string)-2))

  return(dot.string)
}

.handle.dates=function(date.time){
    out=as.POSIXct(gsub(x = date.time, pattern = "T|Z", replacement = " "), tz="UTC")
    return(out)
}

.common.fields=function(df.list){
    temp=unique(lapply(df.list, colnames))
    if(length(temp)>1){
    common=do.call(dplyr::intersect, temp)
    out=lapply(df.list, function(x) x[,which(colnames(x) %in% common)])
    }else{out=df.list}
    return(out)
}

.sum.do.basic.stats=function(x, field.key){
  merged.df=x

  min=NA
  max=NA
  mean=NA

  site.meta=get.site.meta(site)

  if(nrow(merged.df)>1){

    merged.df$endDateTime=.handle.dates(merged.df$endDateTime)

    merged.df$endDateTime=lubridate::with_tz(merged.df$endDateTime, tzone = site.meta$location.properties$locationPropertyValue[site.meta$location.properties$locationPropertyName=="Value for Site Timezone"])

    merged.df$day= cut(x=merged.df$endDateTime, breaks = "1 day")

    mean=mean(unlist(lapply(unique(merged.df$day), function(d) sum(merged.df[merged.df$day==d, grepl(pattern = field.key, x = colnames(merged.df))], na.rm = T))))
    min=min(unlist(lapply(unique(merged.df$day), function(d) sum(merged.df[merged.df$day==d, grepl(pattern = field.key, x = colnames(merged.df))], na.rm = T))))
    max=max(unlist(lapply(unique(merged.df$day), function(d) sum(merged.df[merged.df$day==d, grepl(pattern = field.key, x = colnames(merged.df))], na.rm = T))))

    out=c("minimum"=min, "mean"=mean, "maximum"=max)
  }
  return(c("minimum"=min, "mean"=mean, "maximum"=max))
}

.do.basic.stats=function(x, field.key){
  merged.df=x

  min=NA
  max=NA
  mean=NA

  site.meta=get.site.meta(site)

  if(nrow(merged.df)>1){

    merged.df$endDateTime=.handle.dates(merged.df$endDateTime)

    merged.df$endDateTime=lubridate::with_tz(merged.df$endDateTime, tzone = site.meta$location.properties$locationPropertyValue[site.meta$location.properties$locationPropertyName=="Value for Site Timezone"])

    merged.df$day= cut(x=merged.df$endDateTime, breaks = "1 day")

    mean=mean(unlist(lapply(unique(merged.df$day), function(d) merged.df[merged.df$day==d, grepl(pattern = field.key, x = colnames(merged.df))])), na.rm = T)
    min=min(unlist(lapply(unique(merged.df$day), function(d) merged.df[merged.df$day==d, grepl(pattern = field.key, x = colnames(merged.df))])), na.rm = T)
    max=max(unlist(lapply(unique(merged.df$day), function(d) merged.df[merged.df$day==d, grepl(pattern = field.key, x = colnames(merged.df))])), na.rm = T)

    out=c("minimum"=min, "mean"=mean, "maximum"=max)
  }
  return(c("minimum"=min, "mean"=mean, "maximum"=max))
}


