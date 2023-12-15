
# mapping reads


l <- 1e5 # genome length
rl <-100 # read length
n <- 1e4 # n reads to map

pos <- sample(1:l, n, replace = T) # "mapping reads"
hist(pos)

# computing per-position mapping depths
deps <- rep(0, l+rl-1)
for(i in pos){
  deps[i:(i+rl-1)] <- deps[i:(i+rl-1)] + 1
}
plot(deps)
hist(deps, breaks=(0:(max(deps)+1)-0.5), freq=F)


# Poisson fit
dPois <- glm(deps ~ 1, family="poisson")
muPois <- exp(coef(dPois))
points(0:max(deps), dpois(0:max(deps), lambda = muPois), pch="p")

# Neg binom fit
dNb <- glm.nb(deps ~ 1)
muNb <- exp(coef(dNb))
thNb <- dNb$theta
points(0:max(deps), dnbinom(0:max(deps), size = thNb, mu=muNb), pch="n")
AIC(dPois, dNb)

# plots don't look vastly different, but NB fits better