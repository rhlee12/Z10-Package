pkgname <- "Z10"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('Z10')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("daily.precip.totals")
### * daily.precip.totals

flush(stderr()); flush(stdout())

### Name: daily.precip.totals
### Title: Return daily precipitation statistics for a site
### Aliases: daily.precip.totals

### ** Examples

## Not run: 
##D cper=Z10::daily.precip.stats(site = "CPER")
## End(Not run)



cleanEx()
nameEx("daily.rad.stats")
### * daily.rad.stats

flush(stderr()); flush(stdout())

### Name: daily.rad.stats
### Title: Return daily solar radiation statistics for a site
### Aliases: daily.rad.stats

### ** Examples

## Not run: 
##D cper=Z10::daily.rad.stats(site = "CPER")
## End(Not run)



cleanEx()
nameEx("daily.soil.temp.mean")
### * daily.soil.temp.mean

flush(stderr()); flush(stdout())

### Name: daily.soil.temp.mean
### Title: Return daily soil temperature means by horizon
### Aliases: daily.soil.temp.mean

### ** Examples

## Not run: 
##D cper=Z10::daily.soil.temp.mean(site = "CPER")
## End(Not run)



cleanEx()
nameEx("daily.temp.stats")
### * daily.temp.stats

flush(stderr()); flush(stdout())

### Name: daily.temp.stats
### Title: Return daily temperature statistics for a site
### Aliases: daily.temp.stats

### ** Examples

## Not run: 
##D cper=Z10::daily.temp.stats(site = "CPER")
## End(Not run)



cleanEx()
nameEx("dp.avail")
### * dp.avail

flush(stderr()); flush(stdout())

### Name: dp.avail
### Title: Query for data product availability
### Aliases: dp.avail

### ** Examples

## Not run: 
##D wind=Z10::dp.avail(dp.id = "DP1.00002.001")
## End(Not run)



cleanEx()
nameEx("dp.search")
### * dp.search

flush(stderr()); flush(stdout())

### Name: dp.search
### Title: Return data product IDs based on a search keyword
### Aliases: dp.search

### ** Examples

## Not run: 
##D names=Z10::dp.search(keyword="fish")
## End(Not run)



cleanEx()
nameEx("get.data")
### * get.data

flush(stderr()); flush(stdout())

### Name: get.data
### Title: Download data for a specified data product
### Aliases: get.data

### ** Examples

## Not run: 
##D cper_wind=Z10::get.data(site = "CPER", dp.id = "DP1.00002.001", month = "2017-04")
## End(Not run)



cleanEx()
nameEx("get.dp.meta")
### * get.dp.meta

flush(stderr()); flush(stdout())

### Name: get.dp.meta
### Title: Return NEON data product metadata
### Aliases: get.dp.meta

### ** Examples

## Not run: 
##D wind_meta=get.dp.meta(dp.id = "DP1.00002.001")
## End(Not run)



cleanEx()
nameEx("get.site.meta")
### * get.site.meta

flush(stderr()); flush(stdout())

### Name: get.site.meta
### Title: Return NEON site metadata
### Aliases: get.site.meta

### ** Examples

## Not run: 
##D cper=Z10::get.site.meta(site = "CPER")
## End(Not run)



cleanEx()
nameEx("map")
### * map

flush(stderr()); flush(stdout())

### Name: map
### Title: Return daily precipitation statistics for a site
### Aliases: map

### ** Examples

## Not run: 
##D cper=Z10::daily.precip.stats(site = "CPER")
## End(Not run)



cleanEx()
nameEx("mat")
### * mat

flush(stderr()); flush(stdout())

### Name: mat
### Title: Return temperature statistics for a site over the period of
###   record
### Aliases: mat

### ** Examples

## Not run: 
##D cper=Z10::mat(site = "CPER")
## End(Not run)



cleanEx()
nameEx("site.litter.isotopes")
### * site.litter.isotopes

flush(stderr()); flush(stdout())

### Name: site.litter.isotopes
### Title: Return Mean Delta Values of Stable Isotopes in Litterfall
### Aliases: site.litter.isotopes

### ** Examples

## Not run: 
##D cper=Z10::site.litter.isotopes(site = "SCBI")
## End(Not run)



cleanEx()
nameEx("summary.root.mass")
### * summary.root.mass

flush(stderr()); flush(stdout())

### Name: summary.root.mass
### Title: Return Mean Root Masses by Depth
### Aliases: summary.root.mass

### ** Examples

## Not run: 
##D SCBI=Z10::summary.root.mass(site = "SCBI")
## End(Not run)



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
