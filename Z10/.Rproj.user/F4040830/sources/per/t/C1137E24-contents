############################################################################################
#' @title Query for data product availability

#' @author Robert Lee \email{rhlee@@colorado.edu}\cr

#' @description Get dates of data product availability by NEON site.
#'
#' @param \code{dp.id} Parameter of class character. The data product code in question. See
#' \url{http://data.neonscience.org/data-product-catalog} for a complete list.

#' @return A list of named data frames
#'
#' @examples
#' wind=dp.avail(dp.id = "DP1.00002.001")

#' @seealso Currently none

# changelog and author contributions / copyrights
#   Robert Lee (2018-08-10)
#     original creation
#
##############################################################################################

dp.avail=function(dp.id){

    avail=data.frame(do.call(rbind, jsonlite::read_json(paste0("http://data.neonscience.org/api/v0/products/", dp.id))$data$siteCodes))[,1:2]

    colnames(avail)=c("site", "months")

    # #NEONstrt <- base::as.POSIXct("2014-01-01",tz="GMT",format="%Y-%m-%d")
    #
    # # Date of the function call, endcap on returned data frame
    # now <- base::as.POSIXct(base::Sys.Date())
    #
    # # Make a sequence of months between start and now
    # months<-base::seq(NEONstrt, currMon, by = "month")
    #
    # # Get those icky posix times to nice year-month dates
    # refMonths <- zoo::as.yearmon(months)
    #
    # # Return the availaiblity of a data product, as far as the API is concerned
    # availability=data.frame(do.call(rbind, jsonlite::read_json(paste0("http://data.neonscience.org/api/v0/products/", dpID))$data$siteCodes))
    #
    # availDF <-data.frame(refMonths)
    # dataPrd <- base::unlist(tis_pri_vars$dp.name[match(dpID, tis_pri_vars$dpID)])
    # dfNames <- c("Month", unlist(availability$siteCode))
    #
    # #Wrap around the API availability by site, to make data frame
    # for(i in 1:length(availability$siteCode)){
    #     site <- availability$siteCode[i]
    #     availMonths <- zoo::as.yearmon(unlist(availability$availableMonths[i]))
    #     gotData <- refMonths %in% availMonths
    #     #Uncomment below to plot only 'x's when data available
    #
    #     char<-base::as.character(gotData)
    #     temp<-sub("TRUE", "x", char)
    #     availOut <- sub("FALSE", "", temp)
    #     availDF <- base::cbind(availDF, availOut)
    #
    #     # Also COMMENT the line below to get only 'x's.
    #     #availDF <- cbind(availDF, gotData)
    # }
    #
    # # Pretty up the output, and return it
    # colnames(availDF)<-dfNames
    # return(availDF)
    return(avail)
}
