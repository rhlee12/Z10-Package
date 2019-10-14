############################################################################################
#' @title Query for data product availability

#' @author Robert Lee \email{rhlee@@colorado.edu}\cr

#' @description Get dates of data product availability by NEON site.
#'
#' @param dp.id Parameter of class character. The data product code in question. See
#' \url{http://data.neonscience.org/data-product-catalog} for a complete list.

#' @return A list of named data frames
#'
#' @examples
#' \dontrun{
#' wind=Z10::dp.avail(dp.id = "DP1.00002.001")
#' }
#' @export

#' @seealso Currently none

# changelog and author contributions / copyrights
#   Robert Lee (2017-07-18)
#     original creation
#   Robert Lee (2018-10-15)
#     Formatted for Z10
##############################################################################################

dp.avail=function(dp.id){
  
  avail=data.frame(
    do.call(cbind,
            .api.return(url = paste0("https://data.neonscience.org/api/v0/products/", dp.id))$data$siteCodes[,1:2]
    )
    
  )
  
  colnames(avail)=c("site", "months")
  
  return(avail)
}
