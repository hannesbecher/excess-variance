
setwd("~/git_repos/excess-variance/06oneReadAtEachPos//")



ff <- dir(pattern="Pois.fa.hist")
readNums <- as.numeric(sapply(ff, function(x) strsplit(x, "_")[[1]][[2]]))
oo <- order(readNums)
readNums <- readNums[oo]
dd <- readNums*150

ff <- ff[oo]




spa <- lapply(ff, read.table, header=F, sep="\t")

plot(spa[[1]], xlim=c(0,100), type="l", lwd=2)
points(spa[[2]],col=2, type="l", lwd=2)
points(spa[[3]],col=3, type="l", lwd=2)
points(spa[[4]],col=4, type="l", lwd=2)
points(spa[[5]],col=5, type="l", lwd=2)
points(spa[[6]],col=6, type="l", lwd=2)
grid()
legend("topright", lty=1, lwd=2, col=1:8,legend = cplx)




library(MASS)


nbModels <- lapply(1:6, function(x) glm.nb(sample(rep(spa[[x]]$V1, spa[[x]]$V2), 100000) ~ 1))

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

points(0:100, dnbinom(0:100, prob = p07, size = r07) * sum(spa[[7]]$V2))

plot(muVec ~ dd)
lm00 <- lm(muVec ~ dd)
abline(lm00)
grid()

plot(ssqVec ~ dd)




# r=mu^2/(s^2-mu)
# (ssq - mu) r = mu^2
# ssq = mu^2/r + mu