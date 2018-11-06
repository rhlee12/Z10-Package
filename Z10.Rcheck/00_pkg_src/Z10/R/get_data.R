############################################################################################
#' @title Download data for a specified data product

#' @author Robert Lee \email{rhlee@@colorado.edu}\cr

#' @description For the specified dates, site, package parameters,
#' and data product or name of family of data products,
#' data are downloaded and saved to the specifed directory.
#'
#' @param site Parameter of class character.
#' The NEON site data should be downloaded for.
#' @param dp.id Parameter of class character. The data product code in question.
#' See \url{http://data.neonscience.org/data-product-catalog} for a complete list.
#' @param month Parameter of class character. The year-month (e.g. "2017-01")
#' of the month to get data for.d, defaults to basic.
#' @param save.dir Optional, parameter of class character.
#' The local directory where data files should be saved.

#' @return A list of named data frames
#'
#' @examples
#' \dontrun{
#' cper_wind=Z10::get.data(site = "CPER", dp.id = "DP1.00002.001", month = "2017-04")
#' }
#' @export

#' @seealso Currently none

# changelog and author contributions / copyrights
#   Robert Lee (2018-08-10)
#     original creation
#   Robert Lee (2018-10-15)
#     Formatted for Z10
##############################################################################################


get.data=function(dp.id, site, month, save.dir){
options(stringsAsFactors = FALSE)

  # Check for data availability
  avail=Z10::dp.avail(dp.id = dp.id)

  if(!(month %in% unlist(avail$months[avail$site==site]))){
    stop(paste0(dp.id, " is not available at ", site, " durring ", month))
  }

  dp.meta=Z10::get.dp.meta(dp.id)
  if(length(dp.meta)>0){
    team.code=stringr::str_extract(string = dp.meta$product.science.team, pattern = "[:upper:]{3}")
  }

  data.meta=rjson::fromJSON(file = base::paste0("http://data.neonscience.org/api/v0/data/",  dp.id, "/", site, "/", month))$data

  file.names=base::lapply(data.meta$files, "[[", "name")
  data.file.indx=base::intersect(grep(x=file.names, pattern = "basic"),
                           grep(x=file.names, pattern = ".csv"))
if(!(dp.id %in% c("DP1.00096.001", "DP1.00101.001", "DP1.00013.001"))){
  if(team.code %in% c("TIS", "AIS")){ ## Need to fix this to hanlde funky TIS products like megapits, dust mass!
    temp.agr="30"
    data.file.indx=base::intersect(data.file.indx, grep(x=file.names, pattern = paste0("_", temp.agr)))
  }
  }

  data.urls=base::unlist(base::lapply(data.meta$files, "[[", "url")[data.file.indx])

  all.data=base::lapply(data.urls,
                        function(x)
                          as.data.frame(utils::read.csv(as.character(x)), stringsAsFactors = F)
  )

  names(all.data)=unlist(file.names[data.file.indx])

  if(!missing(save.dir)){
    (if(!dir.exists(save.dir)){stop("Invalid save.dir!")})
    lapply(seq(length(all.data)),
           function(x)
             utils::write.csv(
               x=x,
               file=paste0(save.dir, "/", names(all.data[x])),
               row.names=F)
    )
  }

  return(all.data)
}

