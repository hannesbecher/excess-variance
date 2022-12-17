# Explore spectra with simulated PCR duplicates

setwd("~/git_repos/excess-variance/03PCRdupl/")
library(Tetmer)
fs <- dir(pattern="no0")
sps <- lapply(fs, function(x) read.spectrum(x, no0=T, nam=x) )
plot(sps[[1]], xlim=c(150, 250))
plot(sps[[2]], xlim=c(150, 250))


plot(sps[[3]], xlim=c(150, 250))
plot(sps[[4]], xlim=c(150, 250))
plot(sps[[11]], xlim=c(150, 250))
plot(sps[[12]], xlim=c(150, 250))
plot(sps[[23]], xlim=c(150, 250))
plot(sps[[24]], xlim=c(150, 250))
plot(sps[[25]], xlim=c(150, 250))

makeLong <- function(dat){
  rep(dat[,1], dat[,2])
}


pars <- t(sapply(1:length(fs), function(x){
  dat <- makeLong(sps[[x]]@data)
  glm00 <- MASS::glm.nb(dat~1)
  c(mean=exp(coef(summary(glm00))[1]),
    theta=glm00$theta)
}))

varsVR <- apply(pars, 1, function(x) x[1] + x[1]^2/x[2])
df <- data.frame(pars, var=varsVR, run=fs)
df$relVar <- varsVR/varsVR[rep(c(13, 26), each=13)]
df <- df[c(13, 1, 2, 3, 4, 5, 7, 6, 9, 11, 8, 10, 12, c(13, 1, 2, 3, 4, 5, 7, 6, 9, 11, 8, 10, 12)+13),]
df$rep <- rep(c(0, 0.1, 0.25, 0.4, 0.55, 0.7, 1, 1.5, 2.5, 5, 10, 20, 50),2)

#png("repVar.png", width=7, height=5.5, res=150, units="in")
plot(relVar ~ rep,
     data=df,
     xlab="Avg. duplicates per read",
     ylab="Rel. var compared to 0 repetition",
     col=rep(c(1, 2), each=13),
     log="")
grid()
lm01 <- lm(relVar ~ rep,
           data=df)
lm02 <- lm(relVar ~ rep + I(rep^2),
           data=df)
summary(lm01)
summary(lm02)

abline(lm01)
xVals <- seq(0, 50, 0.05)
predY <- predict(lm02, data.frame(rep=xVals))
lines(xVals, predY)

#dev.off()
par(mfrow=c(2,2))
plot(lm01)
plot(lm02)

par(mfrow=c(1,1))
