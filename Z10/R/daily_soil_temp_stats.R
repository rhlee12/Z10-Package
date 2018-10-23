############################################################################################
#' @title Return daily soil temperature statistics

#' @author Robert Lee \email{rhlee@@colorado.edu}\cr

#' @description This function calculates the daily miniumum, mean, and maximum
#' temperature values for a site over its period of record for soil sensors located
#' in plot 1 of the site, in the lowest available A horizon and the
#' uppermost B horizon (excluding AB horizons)
#'
#' @param site Parameter of class character.
#' The NEON site data should be downloaded for.

#' @return A list of min, mean and max net solar radiation
#' values at the site, in watts per meter squared
#'
#' @examples
#' \dontrun{
#' cper=Z10::daily.soil.temp.stats(site = "CPER")
#' }
#' @export

#' @seealso Currently none

# changelog and author contributions / copyrights
#   Robert Lee (2018-10-23)
#     original creation
#
##############################################################################################

daily.soil.temp.stats=function(site){
  mp.id="DP1.00096.001"
  dp.id="DP1.00041.001"
  mp.avail=dp.avail(mp.id)

  if(!(site %in% mp.avail$site)){stop(paste0("Horizon information at ", site, " is not yet available via the API"))}

  mega.data=get.data(dp.id = mp.id, site = site, month = unlist(mp.avail[mp.avail$site==site, "months"]))

  horizon.data=mega.data[grepl(pattern = "perhorizon", x = names(mega.data))][[1]]

  horizon.data=horizon.data[order(horizon.data$horizonTopDepth), ]

  meta=get.site.meta(site)

  sp1.sensors=rjson::fromJSON(
    file=rjson::fromJSON(
      file=meta$location.children.urls[grepl(pattern = "SOILAR", x = meta$location.children.urls)]
    )$data$locationChildrenUrls[1]
  )$data

  temp.locs=sp1.sensors$locationChildrenUrls[grepl(pattern="SOILTP", x=sp1.sensors$locationChildrenUrls)]

  temp.depths=unlist(lapply(temp.locs, function(l) rjson::fromJSON(file = l)$data$zOffset))

  temp.depths=temp.depths[order(temp.depths, decreasing = T)]*-100

  sensor.horizons=data.frame(horizon=unlist(lapply(temp.depths, function(d) horizon.data$horizonName[which(horizon.data$horizonTopDepth<d & d<horizon.data$horizonBottomDepth)])),
                             depth=temp.depths)

  rownames(sensor.horizons)=seq(nrow(sensor.horizons))

  #Lowest A
  a.index=max(which(grepl(pattern = "A", x = sensor.horizons$horizon)&!grepl(pattern = "B", x = sensor.horizons$horizon)))

  #Uppermost non-A B horizon
  b.index=min(which(grepl(pattern = "B", x = sensor.horizons$horizon)&!grepl(pattern = "A", x = sensor.horizons$horizon)))

  avail=dp.avail(dp.id)

  months=unlist(avail$months[avail$site==site])

  # special function that only gets SP1 data for 2 sensor locations
  get.soil.data=function(month, site, dp.id){
    data.meta=rjson::fromJSON(file = base::paste0("http://data.neonscience.org/api/v0/data/",  dp.id, "/", site, "/", month))$data

    file.names=base::lapply(data.meta$files, "[[", "name")
    data.file.indx=base::intersect(grep(x=file.names, pattern = "basic"),
                                   grep(x=file.names, pattern = ".csv"))

    data.file.indx=base::intersect(data.file.indx, grep(x=file.names, pattern = "_30"))
    data.file.indx=base::intersect(data.file.indx,
                                   c(
                                     grep(x=file.names, pattern = paste0(".001.50", a.index)),
                                     grep(x=file.names, pattern = paste0(".001.50", b.index))
                                     )
    )

    data.urls=base::unlist(base::lapply(data.meta$files, "[[", "url")[data.file.indx])

    all.data=base::lapply(data.urls,
                          function(x)
                            as.data.frame(utils::read.csv(as.character(x)), stringsAsFactors = F)
    )

    names(all.data)=unlist(file.names[data.file.indx])
    return(all.data)

  }

  data.out=lapply(months, function(m) get.soil.data(month=m, site=site, dp.id=dp.id))
  data.out=unlist(data.out, recursive = F)

  a.df=data.frame(do.call(rbind,
                          .common.fields(
                            data.out[grep(pattern = paste0("001.50", a.index), x = names(data.out))])),
                  row.names = NULL
                  )
  b.df=data.frame(do.call(rbind,
                          .common.fields(data.out[grep(pattern = paste0("001.50", b.index), x = names(data.out))])),
                  row.names = NULL
                  )

  out=list(.do.basic.stats(x=a.df, field.key="soilTempMean"),
           .do.basic.stats(x=b.df, field.key="soilTempMean"))

  names(out)=c(paste0(sensor.horizons[a.index,1], ": ", sensor.horizons[a.index,2], " cm" ),
               paste0(sensor.horizons[b.index,1], ": ", sensor.horizons[b.index,2], " cm" ))

  return(out)
}



