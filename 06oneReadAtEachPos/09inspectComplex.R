
setwd("~/git_repos/excess-variance/06oneReadAtEachPos//")



ff <- dir(pattern="CPois.fa.hist")
cplx <- as.numeric(sapply(ff, function(x) strsplit(x, "_")[[1]][[2]]))
dd <- as.numeric(sapply(ff, function(x) strsplit(x, "_")[[1]][[3]])) * cplx * 130






spa <- lapply(ff, read.table, header=F, sep="\t")

plot(spa[[1]], xlim=c(0,100), type="l", lwd=2)
points(spa[[2]],col=2, type="l", lwd=2)
points(spa[[3]],col=3, type="l", lwd=2)
points(spa[[4]],col=4, type="l", lwd=2)
points(spa[[5]],col=5, type="l", lwd=2)
points(spa[[6]],col=6, type="l", lwd=2)

points(spa[[7]],col=1, type="l", lwd=2)
points(spa[[8]],col=2, type="l", lwd=2)
points(spa[[9]],col=3, type="l", lwd=2)
points(spa[[10]],col=4, type="l", lwd=2)
points(spa[[11]],col=5, type="l", lwd=2)
points(spa[[12]],col=6, type="l", lwd=2)


grid()


library(MASS)


nbModels <- lapply(1:66, function(x) glm.nb(sample(rep(spa[[x]]$V1, spa[[x]]$V2), 100000) ~ 1))

lapply(nbModels, summary)
coef(nbModels[[1]])
coef(summary(nbModels[[1]]))
str(summary(nbModels[[1]]))

nbModels[[1]]$theta
130/150 * dd
rVec <- sapply(nbModels, function(x) x$theta)
muVec <- sapply(nbModels, function(x) exp(coef(x)))

ssqVec <- muVec^2 / rVec + muVec
pVec <- muVec/ssqVec


df <- data.frame(dd=dd,
          cplx=cplx,
          ssq=ssqVec,
          mu=muVec)

plot(dd ~ cplx)

plot(muVec ~ dd)

dd * cplx
plot(muVec ~ cplx)

factor(round(dd))
plot(ssqVec ~ cplx, col=factor(round(dd)))
grid()

plot(ssqVec ~ dd, col=factor(cplx))
abline(0, 1)
grid()

plot(x=cplx, y=ssqVec, col=factor(round(dd)))
grid()

plot(x=cplx, y=ssqVec/dd, col=factor(round(dd)),
     ylim=c(0.5,10),
     log="")
grid()
abline(h=1)

plot(x=dd, y=ssqVec/muVec, col=factor(cplx),
     ylim=c(0.5,10),
     log="")
grid()

# linear in dd with separate slopes for each complexity level
lm02 <- lm(ssq/mu ~ dd * factor(cplx),
           data=df)
# excellent fit
summary(lm02)
plot(lm02)
lm00 <- lm(muVec ~ dd)
summary(lm00)
#abline(lm00)
#grid()

lm01 <- lm(ssqVec ~ dd + cplx)
summary(lm01)
plot(lm01)
plot(ssqVec ~ dd)




# r=mu^2/(s^2-mu)
# (ssq - mu) r = mu^2
# ssq = mu^2/r + mu