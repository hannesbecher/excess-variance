library(Tetmer)

setwd("~/git_repos/excess-variance/01withinReads/")
sp21 <- read.spectrum("ref1M.fa.21FW.hist.no0", no0 = T)
sp130 <- read.spectrum("ref1M.fa.150FW.hist.no0", no0 = T)
sp980 <- read.spectrum("ref1M.fa.1kFW.hist.no0", no0 = T)
colSums(sp21@data)/1000000
colSums(sp130@data)/1000000
colSums(sp980@data)/1000000

plot(sp21, type="l", main="FW only", log="")
points(sp130@data, col=2, type="l")
points(sp980@data, col=3, type="l")
legend("topright",
       col=c(1,2),
       lty=1,
       legend=c(21, 130),
       title = "k")


plot(sp21, type="l", main="k=21", log="y")
points(sp130@data, col=2, type="l")
points(sp980@data, col=3, type="l")
makeLong <- function(dat){
  rep(dat[,1], dat[,2])
}
summary(glm(makeLong(sp130@data) ~1))
summary(glm(makeLong(sp21@data) ~1))
var(makeLong(sp130@data))
var(makeLong(sp21@data))


