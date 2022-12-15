# Varying insert size


# Load data ---------------------------------------------------------------

library(Tetmer)
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


# fit nb model to peaks ---------------------------------------------------
makeLong <- function(dat){
  rep(dat[,1], dat[,2])
}
head(sps[[1]]@data)
dat1 <- makeLong(sps[[1]]@data)
pars <- t(sapply(1:7, function(x){
  dat <- makeLong(sps[[x]]@data)
  glm00 <- MASS::glm.nb(dat~1)
  c(mean=exp(coef(summary(glm00))[1]),
    theta=glm00$theta)
}))

pars <- as.data.frame(pars)
plot(1:7, pars$theta)


# according to Venables and Ripley 2002, var should be mean + mean^2/theta
vars <- sapply(sps, function(x){
  var(makeLong(x@data))
})
vars
varsVR <- apply(pars, 1, function(x) x[1] + x[1]^2/x[2])
plot(vars, varsVR, log="") # looks like it's true
abline(0,1, lty=2)
plot(vars ~ seq(200, 500, by=50),
     xlab="IS",
     ylab="Variance",
     ylim=c(200, 330))
points(varsVR ~ seq(200, 500, by=50), pch=2)
grid()
legend("topright",
       pch=1:2,
       legend=c("obs", "fit"))

abline(h=200)

# Quantify overlap --------------------------------------------------------
dir()

curve(pnorm(x, 200, 50), 50, 350)
abline(h=c(1/40, 39/40), lty=2)

sapply(is.range, function(x) pnorm(300, x, 50))*100
