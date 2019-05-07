
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

  site.meta=append(site.meta, rjson::fromJSON(file=paste0("http://data.neonscience.org/api/v0/locations/", site))$data)

  names(site.meta)=unlist(lapply(names(site.meta), function(x) .camel.to.dot(x)))

  site.meta$location.properties=data.frame(do.call(rbind, site.meta$location.properties))
  class(site.meta$location.properties[,1])="character"
  class(site.meta$location.properties[,2])="character"


  return(site.meta)
  }
