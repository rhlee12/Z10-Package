############################################################################################
#' @title Download data for a specified data product

#' @author Robert Lee \email{rhlee@@colorado.edu}\cr

#' @description For the specified dates, site, package parameters,
#' and data product or name of family of data products,
#' data are downloaded and saved to the specifed directory.
#'
#' @param \code{site} Parameter of class character.
#' The NEON site data should be downloaded for.
#' @param \code{dp.id} Parameter of class character. The data product code in question.
#' See \url{http://data.neonscience.org/data-product-catalog} for a complete list.
#' @param \code{month} Parameter of class character. The year-month (e.g. "2017-01")
#' of the month to get data for.d, defaults to basic.
#' @param \code{save.dir} Optional, parameter of class character.
#' The local directory where data files should be saved.

#' @return A list of named data frames
#'
#' @examples
#' cper_wind=get.data(site = "CPER", dp.id = "DP1.00002.001", month = "2017-04")

#' @seealso Currently none

# changelog and author contributions / copyrights
#   Robert Lee (2018-08-10)
#     original creation
#
##############################################################################################


get.data=function(dp.id, site, month, save.dir){

  # Check for data availability
  avail=Z10::dp.avail(dp.id = dp.id)

  if(!(month %in% unlist(avail$months[avail$site==site]))){
    stop(paste0(dp.id, " is not available at ", site, " durring ", month))
  }

  base.url="http://data.neonscience.org/api/v0/"

  dp.meta=rjson::fromJSON(file=paste0(base.url, "products/", dp.id))$data

  if(length(dp_meta)>0){
    team_code=stringr::str_extract(string = dp_meta$productScienceTeam, pattern = "[:upper:]{3}")
  }

  dp_sites=unlist(lapply(dp_meta$siteCodes, "[[", "siteCode"))
  if(site %in% dp_sites){

    months_by_site=lapply(dp_meta$siteCodes, "[[", "availableMonths")
    names(months_by_site)=dp_sites

    valid_months=unlist(months_by_site[site])
    if(!(month %in% valid_months)){stop(paste0(dp.id, " is not available at ", site, " durring ", month))}

  }else{stop(paste0(dp.id, " is not available at ", site))}

  data_meta=rjson::fromJSON(file = paste0(base.url, "data/",  dp.id, "/", site, "/", month))$data
  file_names=lapply(data_meta$files, "[[", "name")
  data_file_indx=intersect(grep(x=file_names, pattern = "basic"),
                           grep(x=file_names, pattern = ".csv"))

  if(team_code %in% c("TIS", "AIS")){
    temp.agr="30"
    data_file_indx=intersect(data_file_indx, grep(x=file_names, pattern = temp.agr))
  }

  data_urls=unlist(lapply(data_meta$files, "[[", "url")[data_file_indx])

  all_data=lapply(data_urls, function(x) as.data.frame(read.csv(as.character(x)), stringsAsFactors = F))

  names(all_data)=unlist(file_names[data_file_indx])

  if(!missing(save.dir)){
    (if(!dir.exists(save.dir)){stop("Invalid save.dir!")})
    lapply(seq(length(all_data)), function(x) write.csv(
      x=x, file=paste0(
        save.dir, "/", names(all_data[x])
      )
    )
    )
  }

  return(all_data)
}

