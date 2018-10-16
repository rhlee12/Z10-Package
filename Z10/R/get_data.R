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

  dp.meta=Z10::get.dp.meta(dp.id)
  if(length(dp.meta)>0){
    team.code=stringr::str_extract(string = dp.meta$product.science.team, pattern = "[:upper:]{3}")
  }

  data.meta=rjson::fromJSON(file = paste0(base.url, "data/",  dp.id, "/", site, "/", month))$data

  file.names=lapply(data.meta$files, "[[", "name")
  data.file.indx=intersect(grep(x=file.names, pattern = "basic"),
                           grep(x=file.names, pattern = ".csv"))

  if(team.code %in% c("TIS", "AIS")){
    temp.agr="30"
    data.file.indx=intersect(data.file.indx, grep(x=file.names, pattern = temp.agr))
  }

  data.urls=unlist(lapply(data.meta$files, "[[", "url")[data.file.indx])

  all.data=lapply(data.urls, function(x) as.data.frame(read.csv(as.character(x)), stringsAsFactors = F))

  names(all.data)=unlist(file.names[data.file.indx])

  if(!missing(save.dir)){
    (if(!dir.exists(save.dir)){stop("Invalid save.dir!")})
    lapply(seq(length(all.data)), function(x) write.csv(
      x=x, file=paste0(
        save.dir, "/", names(all.data[x])
      )
    )
    )
  }

  return(all.data)
}

