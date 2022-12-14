# Varying insert size


# Load data ---------------------------------------------------------------


setwd("~/git_repos/excess-variance/02readOverlap/")
#getwd()
is.range <- c(200, 250, 300, 350, 400, 450, 500)
sps <- lapply(is.range, function(x){
  read.spectrum(paste0("ref1M.fa.IS", x, ".FR.hist.no0"),
                no0=T,
                nam=paste0("IS ", x))
}
)
length(sps)

# Plot spectra ------------------------------------------------------------


plot(sps[[7]],
     type="l",
     log="",
     xlim=c(150, 250),
     main="Spectra",
     col=7)
for(i in 6:1){
  lines(sps[[i]]@data,
        col=i)
}
legend("topleft",
       col=7:1,
       lty=1,
       legend=rev(is.range),
       title="Insert size")


# genome size
getGs <- function(sp, dep){
  sum(sp@data[,1] * sp@data[,2])/dep
}
sapply(sps, getGs, dep=200)
# each is 999960
sps[[1]]@data
sdFromSp <- function(sp){
  dat <- sp@data
  sd(rep(dat[,1], dat[,2]))
}
sds <- sapply(sps, sdFromSp)
plot(sds, seq(200, 500, by=50))
plot(sds, seq(200, 500, by=50),
     log="")


# Quantify overlap --------------------------------------------------------
dir()

curve(pnorm(x, 200, 50), 50, 350)
abline(h=c(1/40, 39/40), lty=2)

sapply(is.range, function(x) pnorm(300, x, 50))*100
