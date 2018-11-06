#Convert camel case names to dot case
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

#Convert dates from ISO to POSIXct time (UTC)
.handle.dates=function(date.time){
  out=as.POSIXct(gsub(x = date.time, pattern = "T|Z", replacement = " "), tz="UTC")
  return(out)
}

# find the fields (columns) common to all data frames in a list
.common.fields=function(df.list){
  temp=unique(lapply(df.list, colnames))
  if(length(temp)>1){
    common=do.call(dplyr::intersect, temp)
    out=lapply(df.list, function(x) x[,which(colnames(x) %in% common)])
  }else{out=df.list}
  return(out)
}

#Function to get sums on a flat data frame
.sum.do.basic.stats=function(x, field.key, site){
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

# function to get min/max/mean on a flat data frame
.do.basic.stats=function(x, field.key, site){
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

# funciton to only pull SP1 data
.get.sp1.data=function(month, site, dp.id){
  data.meta=rjson::fromJSON(file = base::paste0("http://data.neonscience.org/api/v0/data/",  dp.id, "/", site, "/", month))$data
  
  file.names=base::lapply(data.meta$files, "[[", "name")
  data.file.indx=base::intersect(grep(x=file.names, pattern = "basic"),
                                 grep(x=file.names, pattern = ".csv"))
  
  data.file.indx=base::intersect(data.file.indx, grep(x=file.names, pattern = "_30"))
  data.file.indx=base::intersect(data.file.indx, grep(x=file.names, pattern = paste0(".001.50"))
  )
  
  data.urls=base::unlist(base::lapply(data.meta$files, "[[", "url")[data.file.indx])
  
  all.data=base::lapply(data.urls,
                        function(x)
                          as.data.frame(utils::read.csv(as.character(x)), stringsAsFactors = F)
  )
  
  names(all.data)=unlist(file.names[data.file.indx])
  return(all.data)
}

# Convert date-time columns from UTC to local time
.set.tz=function(df, site){
  site.meta=get.site.meta(site)
  time.indx=grep(x = colnames(df), pattern = "time", ignore.case = T)
  for(i in 1:length(time.indx)){
    if(!class(df[,i])[1]=="POSIXct"){
      df[,i]=.handle.dates(df[,i])
    }
    df[,time.indx[i]]=lubridate::with_tz(df[,time.indx[i]], 
                                         tzone = site.meta$location.properties$locationPropertyValue[site.meta$location.properties$locationPropertyName=="Value for Site Timezone"])
  }
  return(df)
}

# Turn data frame into list of data frames by date
.dayify=function(df){

  df$date=cut.Date(x=as.Date(substr(df$endDateTime, start = 1, 10)), breaks = "1 day")
  
  listed.df=split(x=df, f=df$date)
  
  return(listed.df)
}


