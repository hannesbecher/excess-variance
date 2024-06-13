
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
                 dd2=dd^2,
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

plot(x=dd, y=ssqVec/dd, col=factor(cplx),
     ylim=c(0.5,10),
     log="")
grid()

plot(x=dd^2, y=ssqVec, col=factor(cplx),
     log="")
grid()


# linear in dd with separate slopes for each complexity level
lm02 <- lm(ssq ~  0 + dd2 * factor(cplx),
           data=df)
# excellent fit
summary(lm02)

# figure out relationships between complexi
coef(lm02)
slps <- c("0)0.05"=0, coef(lm02)[13:22]) + coef(lm02)[1]
cpls <- as.numeric(sapply(names(slps), function(x) strsplit(x, ")")[[1]][[2]]))
plot(x=cpls,
     y=slps)
grid()


plot(x=1/cpls,
     y=slps)
grid()
lmSlps <- lm(slps ~ I(1/cpls ))
abline(lmSlps)
summary(lmSlps)
# if complexity if v high, slope is 0.477, for each step of 1/cplx, slope goes up by 0.0082

ints <- coef(lm02)[2:12]
intClpls <- as.numeric(sapply(names(ints), function(x) strsplit(x, ")")[[1]][[2]]))

plot(x=ints,
     y=intClpls)

plot(y=ints,
     x=1/intClpls)
plot(x=ints,
     y=intClpls)
abline(ints[1], slps[1])


plot(x=dd^2, y=ssqVec, col=factor(cplx),
     log="")
grid()
mapply(function(x, y) abline(x, y), ints, slps)

summary(lm(ints~I(1/intClpls)))
abline(lm(ints~I(1/intClpls)))
grid()

plot(x=ints,
     y=slps)
plot(lm02)



lm00 <- lm(muVec ~ dd)
summary(lm00)
#abline(lm00)
#grid()


library(nlme)
aa <- df$ssq/df$mu - 1
nls01 <- nls(ssq ~ c0 + c1/cplx*dd2,
    data=df,
    start=list(c0=0, c1=1)
    )

nls02 <- nls(ssq ~ c1 + c2/cplx + c3/cplx*dd2,
             data=df,
             start=list(c1=1, c2=1, c3=1)
)
# slope = c2 + c3/cplx
# intercept = c0 + c1/cplx
nls03 <- nls(log(ssq) ~ log(c1 + c2/cplx + c3/cplx*dd2),
             data=df,
             start=list(c1=20, c2=-1, c3=0.01),
             algorithm = "port"
             
)


summary(nls01)
summary(nls02)
summary(nls03)
cc <- coef(nls01)
cc2 <- coef(nls02)
cc3 <- coef(nls03)
resid(nls02)
#nls1
plot(x=df$dd^2/df$cplx * cc[2] + cc[1],
     y=df$ssq,
     col=factor(round(dd)))
grid()
plot(x=df$dd^2/df$cplx * cc[2] + cc[1],
     y=df$ssq,
     col=factor(round(dd)),
     log="xy")
grid()

plot(x=df$dd^2/df$cplx * cc2[3] + cc2[2]/cplx + cc2[1],
     y=df$ssq,
     col=factor(round(dd)))
plot(x=df$dd^2/df$cplx * cc2[3] + cc2[2]/cplx + cc2[1],
     y=df$ssq,
     col=factor(round(dd)),
     log="xy")


#nls2
plot(x=df$dd^2/df$cplx * cc2[3] + cc2[2]/cplx + cc2[1],
     y=df$ssq,
     col=factor(cplx),
     log="")
grid()
abline(0, 1)


plot(x=df$dd^2/df$cplx * cc2[3] + cc2[2]/cplx + cc2[1],
     y=df$ssq,
     col=factor(cplx),
     log="xy")
grid()
# not a great fit for depth = 10X

plot(x=dd^2, y=ssqVec, col=factor(cplx),
     log="")
grid()
# adding in predictions
points(x=dd^2+100, y=df$dd^2/df$cplx * cc2[3] + cc2[2]/cplx + cc2[1], col=factor(cplx),pch=2)

# plotting prediction separately
plot(x=dd^2+100, y=df$dd^2/df$cplx * cc2[3] + cc2[2]/cplx + cc2[1], col=factor(cplx))
grid()



# nls3
plot(x=df$dd^2/df$cplx * cc3[3] + cc3[2]/cplx + cc3[1],
     y=df$ssq,
     col=factor(cplx),
     log="xy")
grid()

plot(x=df$dd^2/df$cplx * cc3[3] + cc3[2]/cplx + cc3[1],
     y=df$ssq,
     col=factor(cplx),
     log="")
grid()
abline(0, 1)


fx <- function(x) x
curve(fx, 1, 1000, add=T)
?curve
abline(0, 1)
grid()
plot(x=df$dd/df$cplx * cc[2] + cc[1]/df$cplx,
     y=aa,
     col=factor(round(dd)),
     log="xy")
plot(resid(nls02), aa, col=factor(round(dd)))

plot(x=df$dd/df$cplx * cc3[3] + cc3[2]/df$cplx + cc3[1],
     y=aa,
     col=factor(round(dd)),
     log="")
abline(0, 1)

lm01 <- lm(ssqVec ~ dd + cplx)
summary(lm01)
plot(lm01)
plot(ssqVec ~ dd)




# r=mu^2/(s^2-mu)
# (ssq - mu) r = mu^2
# ssq = mu^2/r + mu