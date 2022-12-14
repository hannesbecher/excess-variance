
# FW and RW ---------------------------------------------------------------

# after running 05*bash
getwd()
prefs <- c("21", "150", "1k")
sps <- lapply(prefs, function(x){
  read.spectrum(paste0("ref1M.fa.", x, ".FR.hist.no0"), no0 = T, nam = x)
})
plot(sps[[1]], type="l")
lines(sps[[2]]@data,
      col=2)
lines(sps[[3]]@data,
      col=3)
lines(sps[[3]]@data[,1], sps[[3]]@data[,2]/2,
      col=4)
sum(sps[[1]]@data[,1] * sps[[1]]@data[,2])/200
getGs <- function(sp, dep){
  sum(sp@data[,1] * sp@data[,2])/dep
}
getGs(sps[[1]], 200)
getGs(sps[[2]], 200)
getGs(sps[[3]], 200)
sps[[3]]@data

sdTwoCol <- function(dat){
  sd(rep(dat[,2], dat[,1]))
}
sdTwoCol(sps[[1]]@data)
sdTwoCol(sps[[2]]@data)
sdTwoCol(sps[[3]]@data)/sqrt(2)