
# Load data ---------------------------------------------------------------


setwd("~/git_repos/excess-variance/02readOverlap/")
#dir()
is.range <- c(200, 250, 300, 350, 400, 450, 500)

is.stats <- lapply(is.range, function(x){
  lRaw <- readLines(paste0("ref1M.fa.IS", x, "rs.bam.stats"))
  goodLines <- lRaw[startsWith(lRaw, "IS")]
  read.table(textConnection(goodLines), header=T, sep="\t")[,2:5]
})
length(is.stats)
is.stats[[1]]


# Plot distributions ------------------------------------------------------

{
plot(is.stats[[1]][,1:2],
     xlim=c(0, 700),
     ylim=c(1, 1e5),
     log="y",
     xlab="Insert size (bp)",
     ylab="Count of pairs")
for(i in 2:7){
  points(is.stats[[i]][,1:2],
         col=i)
}
grid()
abline(v=300, lty=2)
legend("bottomright",
       col=1:7,
       pch=1,
       legend=seq(200, 500, 50))
}
# proportion of pairs with IS < 300
propOverlap <- sapply(is.stats, function(x) sum(x[x[,1] < 300,2])/sum(x[,2]))*100
names(propOverlap) <- seq(200, 500, 50)
propOverlap


lm01 <- lm(sample(makeLong(is.stats[[7]]), 10000) ~ 1)
summary(lm01)
par(mfrow=c(2,2))
plot(lm01)
par(mfrow=c(1,1))
