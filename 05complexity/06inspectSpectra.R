library(Tetmer)


setwd("~/git_repos/excess-variance/05complexity/")
ff <- dir(pattern = "*outPois.fa.hist" )
spectra <- lapply(ff, read.spectrum)
tetmer(spectra[[1]])
tetmer(spectra[[7]])
tetmer()

sr <- sliderRanges()
sr$gsMax <- 2
sr$gsMin <- 0.25
sr$ymax <- 0.5
setSliderRanges(sr)
