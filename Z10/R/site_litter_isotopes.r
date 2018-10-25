site.litter.isotopes=function(site){
  dp.id="DP1.10101.001"
  litter.sites=dp.avail(dp.id)
  if(!(site %in% litter.sites$site)){stop(paste0("Letter stable isotopes is not available at ", site))}

  lapply(, function(s) get.data(site = )

}
