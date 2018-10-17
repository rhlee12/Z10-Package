
############################################################################################
#' @title Return NEON site metadata

#' @author Robert Lee \email{rhlee@@colorado.edu}\cr

#' @description Return detailed NEON site metadata.
#'
#' @param site Parameter of class character.
#' The NEON site data should be downloaded for.

#' @return A list of named data frames
#'
#' @examples
#' \dontrun{
#' cper=Z10::get.site.meta(site = "CPER")
#' }
#' @export

#' @seealso Currently none

# changelog and author contributions / copyrights
#   Robert Lee (2018-10-16)
#     original creation
#
##############################################################################################

get.site.meta=function(site){

  site.meta=rjson::fromJSON(file=paste0("http://data.neonscience.org/api/v0/sites/", site))$data

  site.meta=site.meta[-which(names(site.meta)=="dataProducts")]

  names(site.meta)=unlist(lapply(names(site.meta), function(x) .camel.to.dot(x)))

  return(site.meta)
  }
