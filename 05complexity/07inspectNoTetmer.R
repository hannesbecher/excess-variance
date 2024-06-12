
setwd("~/git_repos/excess-variance/05complexity/")



ff <- dir(pattern="Pois.fa.hist")
readNums <- as.numeric(sapply(ff, function(x) substr(strsplit(x, "[.]")[[1]][[1]], 3, 100)))
oo <- order(readNums, decreasing = T)
readNums <- readNums[oo]
cplx <- readNums/1000000

ff <- ff[oo]



spa <- lapply(ff, read.table, header=F, sep="\t")

plot(spa[[1]], xlim=c(0,100), type="l", lwd=2)
points(spa[[2]],col=2, type="l", lwd=2)
points(spa[[3]],col=3, type="l", lwd=2)
points(spa[[4]],col=4, type="l", lwd=2)
points(spa[[5]],col=5, type="l", lwd=2)
points(spa[[6]],col=6, type="l", lwd=2)
points(spa[[7]],col=7, type="l", lwd=2)
points(spa[[8]],col=8, type="l", lwd=2)
points(spa[[9]],col=8, type="l", lwd=2)
points(spa[[10]],col=8, type="l", lwd=2)
points(spa[[11]],col=8, type="l", lwd=2)
points(spa[[12]],col=8, type="l", lwd=2)
points(spa[[13]],col=8, type="l", lwd=2)
points(spa[[14]],col=8, type="l", lwd=2)
points(spa[[15]],col=8, type="l", lwd=2)
points(spa[[16]],col=8, type="l", lwd=2)
points(spa[[17]],col=8, type="l", lwd=2)
points(spa[[18]],col=8, type="l", lwd=2)
points(spa[[19]],col=8, type="l", lwd=2)
points(spa[[120]],col=8, type="l", lwd=2)
grid()
legend("topright", lty=1, lwd=2, col=1:8,legend = cplx)




library(MASS)


nbModels <- lapply(1:length(spa), function(x) glm.nb(sample(rep(spa[[x]]$V1, spa[[x]]$V2), 100000) ~ 1))

lapply(nbModels, summary)
coef(nbModels[[1]])
coef(summary(nbModels[[1]]))
str(summary(nbModels[[1]]))

nbModels[[1]]$theta
rVec <- sapply(nbModels, function(x) x$theta)
muVec <- sapply(nbModels, function(x) exp(coef(x)))

ssqVec <- muVec^2 / rVec + muVec
pVec <- muVec/ssqVec


plot(muVec ~ cplx)
plot(muVec[1:6] ~ cplx[1:6])
plot(ssqVec ~ I(1/cplx))
plot(ssqVec ~ cplx, log="")
plot(ssqVec[1:18] ~ I(1/cplx[1:18]))
lm00 <- lm(ssqVec[1:18] ~ I(1/cplx[1:18]))
summary(lm00)
grid()
abline(lm00, lty=2)

par(mfrow=c(2,2))
plot(lm00)
par(mfrow=c(1,1))
#ssq = 33 + 10 * 1/cplx


# r=mu^2/(s^2-mu)
# (ssq - mu) r = mu^2
# ssq = mu^2/r + mu