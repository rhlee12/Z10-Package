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