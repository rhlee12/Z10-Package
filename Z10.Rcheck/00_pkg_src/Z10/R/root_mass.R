############################################################################################
#' @title Return Mean Root Masses by Depth

#' @author Robert Lee \email{rhlee@@colorado.edu}\cr

#' @description This function summarizes the root masses from all live
#'  roots in 10 cm depth increments
#'
#' @param site Parameter of class character.
#' The NEON site data should be downloaded for.

#' @return Data frame of the average root mass measured in a given depth range
#'
#' @examples
#' \dontrun{
#' SCBI=Z10::root.mass(site = "SCBI")
#' }
#' @export

#' @seealso Currently none

# changelog and author contributions / copyrights
#   Robert Lee (2018-10-31)
#     original creation
#
##############################################################################################

root.mass=function(site){
  
  dp.id="DP1.10066.001"
  
  root.sites=dp.avail(dp.id)
  
  if(!(site %in% root.sites$site)){stop(paste0("Megapit root data is not available at ", site))}
  
  all=lapply(root.sites$months[root.sites$site==site],
             function(m)
               get.data(site = site,
                        dp.id = dp.id,
                        month = m
               )
  )
  
  flat=unlist(all, recursive = FALSE)
  
  by.depth=flat[grepl(pattern = "perrootsample", x = names(flat))][[1]]
  
  sample.spots=do.call(rbind, strsplit(by.depth$depthIncrementID, split = "\\." ))
  
  by.depth$column=sample.spots[,2]
  
  by.depth$top.depth=sample.spots[,3]
  
  temp=lapply(
    unique(by.depth$top.depth), 
    function(d) unlist(lapply(
      unique(by.depth$column), 
      function(c) sum(by.depth$rootDryMass[by.depth$top.depth==d&by.depth$column==c]))
    )
  )
  
  mean.mass=unlist(lapply(temp, mean))
  
  root.df=data.frame(do.call(rbind, .common.fields(flat)), row.names = NULL)
  
  top.depths=as.numeric(unique(by.depth$top.depth))
  top.depths=top.depths[order(top.depths)]
  bottom.depths=c(top.depths[2:length(top.depths)], top.depths[length(top.depths)]+10)
  
  out=data.frame(depths=paste0(top.depths, "-", bottom.depths), root.mass=round(mean.mass, digits = 2))
  return(out)
}
