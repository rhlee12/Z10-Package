############################################################################################
#' @title Return Mean Delta values of Stable Isotopes in Litterfall 

#' @author Robert Lee \email{rhlee@@colorado.edu}\cr

#' @description This function calculates the daily miniumum, mean, and maximum
#' net solar radiation values for a site over its period of record.
#'
#' @param site Parameter of class character.
#' The NEON site data should be downloaded for.

#' @return A list of min, mean and max net solar radiation
#' values at the site, in watts per meter squared
#'
#' @examples
#' \dontrun{
#' cper=Z10::site.litter.isotopes(site = "SCBI")
#' }
#' @export

#' @seealso Currently none

# changelog and author contributions / copyrights
#   Robert Lee (2018-10-29)
#     original creation
#
##############################################################################################

site.litter.isotopes=function(site){
    dp.id="DP1.10101.001"
    litter.sites=dp.avail(dp.id)
    if(!(site %in% litter.sites$site)){stop(paste0("Letter stable isotopes is not available at ", site))}
    
    all=lapply(litter.sites$months[litter.sites$site==site], 
           function(m) 
               get.data(site = site, 
                        dp.id = dp.id, 
                        month = m
               )
    )
    flat=unlist(all, recursive = FALSE)
    
    iso.df=data.frame(do.call(rbind, .common.fields(flat)), row.names = NULL)
    out=list(
    d15N=mean(iso.df$d15N, na.rm = T),
    d13C=mean(iso.df$d13C, na.rm = T)
    )
    
    return(out)
}
