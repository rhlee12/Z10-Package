
############################################################################################
#' @title Return NEON site metadata

#' @author Robert Lee \email{rhlee@@colorado.edu}\cr

#' @description Return detailed NEON site metadata.
#'
#' @param \code{site} Parameter of class character.
#' The NEON site data should be downloaded for.


#' @return A list of named data frames
#'
#' @examples
#' \dontrun{
#' cper_wind=get.data(site = "CPER", dp.id = "DP1.00002.001", month = "2017-04")
#' }

#' @seealso Currently none

# changelog and author contributions / copyrights
#   Robert Lee (2018-10-16)
#     original creation
#
##############################################################################################

get.site.meta=function(site){
  base_url="http://data.neonscience.org/api/v0/"
  site.meta=rjson::fromJSON(file=paste0(base_url, "sites/", site))$data

}
