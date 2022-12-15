# Empirical IS distributions
setwd("~/git_repos/excess-variance/02readOverlap/empiricalMarchantia/")
dir()
samples <- c(2, 3, 5, 6, 7, 8, 9, 11, 23, 25, 31, 33, 41, 45, 46)
is.empirical <- lapply(samples, function(x){
  a <- read.table(paste0("HB", x, "sd.bam.IS"))[,2:6]
  names(a) <- c("IS", "total", "in", "out", "other")
  a
})
names(is.empirical) <- paste0("s", samples)
is.empirical$s2
head(is.empirical$s2)
{
  plot(is.empirical$s2[,1:2],
       xlim=c(0,1000),
       log="y",
       main="HB2")
  grid()
  points(is.empirical$s2[,c(1, 3)], col=2)
  points(is.empirical$s2[,c(1, 4)], col=3)
  points(is.empirical$s2[,c(1, 5)], col=4)
  abline(v=c(150, 300), lty=2, col=c(2, 1))
  legend("topright",
         title = "Pair types",
         col=1:4,
         pch=1,
         legend=c("Total", "Inward", "Outward", "Other"))
}
var(makeLong(is.empirical$s2[is.empirical$s2[,1] < 1000,]))
sd(makeLong(is.empirical$s2[is.empirical$s2[,1] < 1000,]))

# length(makeLong(is.empirical$s2[is.empirical$s2[,1] < 1000,]))/1000000 # 5.9M

lm.emps2 <- lm(sample(makeLong(is.empirical$s2[is.empirical$s2[,1] < 1000,]), 10000)~1)
summary(lm.emps2)
par(mfrow=c(2,2))
plot(lm.emps2)
par(mfrow=c(1,1))

# general plot function
pltEmp <- function(x, log="y", xlim=c(0,1000), ...){
  plot(x[,1:2],
       xlim=xlim,
       log=log,
       main=substitute(x),
       ...
       )
  grid()
  points(x[,c(1, 3)], col=2)
  points(x[,c(1, 4)], col=3)
  points(x[,c(1, 5)], col=4)
  abline(v=c(150, 300), lty=2, col=c(2, 1))
  legend("topright",
         title = "Pair types",
         col=1:4,
         pch=1,
         legend=c("Total", "Inward", "Outward", "Other"))
}
pltEmp(is.empirical$s2, log="", ylim=c(0, 45000))
abline(v=280)
pltEmp(is.empirical$s3)
pltEmp(is.empirical$s3, log="", ylim=c(0, 45000))
pltEmp(is.empirical$s5)
pltEmp(is.empirical$s6)
pltEmp(is.empirical$s7)
pltEmp(is.empirical$s8)
pltEmp(is.empirical$s9)
pltEmp(is.empirical$s11)
pltEmp(is.empirical$s23)
pltEmp(is.empirical$s25)
pltEmp(is.empirical$s25, log="", ylim=c(0, 45000))
pltEmp(is.empirical$s31)
pltEmp(is.empirical$s33)
pltEmp(is.empirical$s41)
pltEmp(is.empirical$s45)
pltEmp(is.empirical$s46)
summary(lm(makeLong(is.empirical$s46[is.empirical$s46[,1] < 1000,])~1))
ll <- length(makeLong(is.empirical$s46[is.empirical$s46[,1] < 1000,]))
curve(dnorm(x, 351, 82)*ll, 0, 1000, add=T)



# Expected duplication level ----------------------------------------------
colSums(is.empirical$s2)

# function to compute length of overlap between reads
ol <- function(rl=150, is=350){
  if(2*rl < is){
    0
  } else if(is > rl) {
    2*rl-is
  } else { # is <= rl
    is
  }
}

# number of duplicated k-mers
ndk <- function(rl=150, is=350, k=21){
  ovl <- ol(rl, is)
  ifelse(ovl < k, 0, ovl-k+1)
}

# proportion of duplicated k-mers (assuming the full read length contributes to total k-mers)
pdk <- function(rl=150, is=350, k=21){
  ovl <- ol(rl, is)
  ifelse(ovl < k, 0, (ovl-k+1)/(rl-k+2)/2)
}


plot(sapply(1:350, function(x) ndk(150, x, 21)))
plot(sapply(1:350, function(x) pdk(150, x, 21)))

insDens <- function(x, cutoff=1000){
  a <- x[x[,1] <= 1000,3]
  a/sum(a)
}

sum(insDens(is.empirical$s2))
sum(sapply(0:1000, function(x) pdk(150, x, 21)))

dupKmerProp <- sapply(is.empirical, function(x){
  sum(sapply(0:1000, function(y) pdk(150, y, 21)) * insDens(x))
})
# Despite the considerable amount of overlapping reads,
#  there are relatively few duplicated k-mers to expect
barplot(dupKmerProp,
        las=3,
        ylab="Proportion of duplicated k-mers",
        main="Duplicated k-mers expected given insert size distribution")
grid(ny=NULL, nx = NA, col=1, lty=1)
barplot(dupKmerProp, add=T, las=3)

