# Explore spectra with simulated PCR duplicates

setwd("~/git_repos/excess-variance/03PCRdupl/")
library(Tetmer)
fs <- dir(pattern="no0")
sps <- lapply(fs, function(x) read.spectrum(x, no0=T, nam=x) )
plot(sps[[1]], xlim=c(150, 250))
plot(sps[[2]], xlim=c(150, 250))


plot(sps[[3]], xlim=c(150, 250))
plot(sps[[4]], xlim=c(150, 250))

makeLong <- function(dat){
  rep(dat[,1], dat[,2])
}


pars <- t(sapply(1:12, function(x){
  dat <- makeLong(sps[[x]]@data)
  glm00 <- MASS::glm.nb(dat~1)
  c(mean=exp(coef(summary(glm00))[1]),
    theta=glm00$theta)
}))

varsVR <- apply(pars, 1, function(x) x[1] + x[1]^2/x[2])
df <- data.frame(pars, var=varsVR, run=fs)

df$relVar <- varsVR/varsVR[rep(c(6, 12), each=6)]

df <- df[c(6, 1, 2, 3, 4, 5, 12, 7, 8,9, 10, 11),]
df$rep <- rep(c(0, 0.1, 0.25, 0.4, 0.55, 0.7),2)

#png("repVar.png", width=7, height=5.5, res=150, units="in")
plot(relVar ~ rep,
     data=df,
     xlab="Avg. duplicates per read",
     ylab="Rel. var compared to 0 repetition")
grid()
lm01 <- lm(relVar ~ rep,
           data=df)
summary(lm01)
abline(lm01)
#dev.off()
par(mfrow=c(2,2))
plot(lm01)
par(mfrow=c(1,1))
