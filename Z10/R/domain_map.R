domain.map=function(domain){
  domain.sites=rjson::fromJSON(file=paste0("http://data.neonscience.org/api/v0/locations/", domain))$data$locationChildren

  dp.id="DP1.00006.001"

  pcip.avail=dp.avail(dp.id)
  domain.avail=pcip.avail[pcip.avail$site %in% domain.sites,]

  lapply(Z10::daily.precip.stats())

}
