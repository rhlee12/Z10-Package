
############################################################################################
#' @title Return data product IDs based on a search keyword

#' @author Robert Lee \email{rhlee@@colorado.edu}\cr

#' @description For a given keyword or search string, a data frame of possible
#' data products will be returned. The search is performed against the data product names,
#' not full data product descriptions.
#' If the R session is interactive, candidate
#' data product information will also print in the console.
#' The data product IDs are used in other Z10 functions to return data.
#'
#' @param keyword Parameter of class character.
#' The search phrase used when searching through data product names.
#'
#' @return A data frame of data product names and their associated data product IDs
#'
#' @examples
#' \dontrun{
#' names=Z10::dp.search(keyword="fish")
#' }
#' @export

#' @seealso Currently none

# changelog and author contributions / copyrights
#   Robert Lee (2018-10-17)
#     original creation
#
##############################################################################################

dp.search=function(keyword){
  dp.info=rjson::fromJSON(file="http://data.neonscience.org/api/v0/products/")$data
  dp.ids=unlist(lapply(dp.info, "[[", "productCode"))
  dp.names=unlist(lapply(dp.info, "[[", "productName"))

  ref.set=data.frame("dp.name"=dp.names, "dp.id"=dp.ids)

  out=ref.set[grepl(pattern = tolower(keyword), x = ref.set$dp.name, ignore.case = TRUE),]

  if(interactive()){
    message("Possible data products:")
    message(paste0(out$dp.name, ": ", out$dp.id, collapse = "\n "))
  }
  return(out)
}
