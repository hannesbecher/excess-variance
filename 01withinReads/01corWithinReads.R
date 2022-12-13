# Re-visit, does not make sense.

# Poisson random numbers --------------------------------------------------

rp01 <- rpois(1000, 20)
rp02 <- rep(rpois(100, 20), 10)
hist(rp01, breaks=seq(0, 50, by=5))
hist(rp02, breaks=seq(0, 50, by=5), add=T, col="#FF000040")

var(rp01)
var(rp02)

# function to compute the variance in mutliplicity
# using independent samples from a Poisson and samples where each sample is included 10 times
comparePois <- function(n){
  c(varSep=var(rpois(120*n, 20) ), varRead=var(rep(rpois(120, 20), n)))
}
popVar <- function(x){
  sum((x-mean(x))^2)/length(x)
}
comparePoisPopVar <- function(n){
  c(varSep=popVar(rpois(120*n, 20)), varRead=popVar(rep(rpois(120, 20), n)))
}

?var
#vars <- as.data.frame(t(sapply(1:10000, function(x) comparePois(10))))
vars <- as.data.frame(t(sapply(1:10000, function(x) comparePoisPopVar(10))))
#vars <- as.data.frame(t(sapply(1:100000, function(x) comparePois(10))))
head(vars)
summary(lm(varSep ~ 1 + offset(varRead),
   data=vars))
colMeans(vars)

# correlation within reads (duplicating counts) leads to (a little) less variance