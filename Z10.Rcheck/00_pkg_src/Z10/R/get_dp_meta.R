
############################################################################################
#' @title Return NEON data product metadata

#' @author Robert Lee \email{rhlee@@colorado.edu}\cr

#' @description Return detailed NEON data product metadata.
#'
#' @param dp.id Parameter of class character. The data product code in question.
#'
#' @return Nested lists of data product metadata
#'
#' @examples
#' \dontrun{
#' wind_meta=get.dp.meta(dp.id = "DP1.00002.001")
#' }
#' @export

#' @seealso Currently none

# changelog and author contributions / copyrights
#   Robert Lee (2018-10-16)
#     original creation
#
##############################################################################################

get.dp.meta=function(dp.id){

  dp.meta=rjson::fromJSON(file=paste0("http://data.neonscience.org/api/v0/products/", dp.id))$data
  names(dp.meta)=unlist(lapply(names(dp.meta), function(x) .camel.to.dot(x)))
  return(dp.meta)
}
