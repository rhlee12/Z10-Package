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
