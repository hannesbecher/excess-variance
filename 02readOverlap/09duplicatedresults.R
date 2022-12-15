# the effect on a sample's variance of (some) duplicated outcomes

lbd <- 0.4 # probability of duplication



runiq <- rpois(1000, 200)
rdup <- numeric()

while(length(rdup) <= 1000){
  r <- rpois(1,200)
  rdup <- append(rdup, rep(r, rpois(1, lbd)+1))
}
rdup <- rdup[1:1000]

var(runiq)
var(rep(runiq[1:500],2))
var(rep(runiq[501:1000],2))
var(rep(runiq,2))

var(rdup)
plot(rdup, runiq)



a <- floor(runif(1000000)*1000)
b <- table(a)
plot(table(b))
as.vector(b)
hist(b)
var(b)

adup <- numeric()
while(length(adup) < 1000000){
  aTemp <- floor(runif(1000)*1000)
  repTemp <- rpois(1000, lbd)+1
  adup <- append(adup, rep(aTemp, repTemp))
}
length(adup)
adup <- adup[1:1000000]
bdup <- table(adup)

plot(table(bdup))
var(bdup)
hist(b, freq=F)
hist(bdup, col="#FF000040", add=T, freq=F)

nbUniq <- MASS::glm.nb(as.vector(b) ~ 1)
summary(nbUniq)
getSdFromNb <- function(mod){
  mu <- exp(coef(summary(mod))[1])
  th <- mod$theta
  c(mu=mu, var=(mu + mu^2/th))
}
getSdFromNb(nbUniq)
getSdFromNb(nbDup)
exp(6.9)
nbDup <- MASS::glm.nb(as.vector(bdup) ~ 1)
summary(nbDup)
