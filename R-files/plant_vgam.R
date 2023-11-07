library(VGAM)
attach(hunua)
library(Matrix)
fit <- vglm(cbind(cyadea, beitaw, kniexc) ~ altitude, loglinb3)
fit@coefficients
sqrt(diag(vcov(fit)))

# fitted probabilities for each outcome
fitted = fitted(fit)
# fitted marginal probabilities
mu.c = apply(fitted[,c(5,6,7,8)], 1, sum)
mu.b = apply(fitted[,c(3,4,7,8)], 1, sum)
mu.k = apply(fitted[,c(2,4,6,8)], 1, sum)
mu.cb = apply(fitted[,c(7,8)], 1, sum)
mu.ck = apply(fitted[,c(6,8)], 1, sum)
mu.bk = apply(fitted[,c(4,8)], 1, sum)
# fitted variances and covariances
var.cc = mu.c*(1-mu.c); var.bb = mu.b*(1-mu.b); var.kk = mu.k*(1-mu.k) ;
cov.cb = mu.cb-mu.c*mu.b; cov.ck = mu.ck-mu.c*mu.k; cov.bk = mu.bk-mu.b*mu.k;
# compute sandwich estimator of variance
meat = 0 ;
bread = 0
for (i in 1:392){
  Wi = rbind(c(var.cc[i], cov.cb[i], cov.ck[i]),
             c(cov.cb[i], var.bb[i], cov.bk[i]),
             c(cov.ck[i], cov.bk[i], var.kk[i]))
  Di = bdiag(mu.c[i]*(1-mu.c[i])*cbind(1, altitude[i]),
             mu.b[i]*(1-mu.b[i])*cbind(1, altitude[i]),
             mu.k[i]*(1-mu.k[i])*cbind(1, altitude[i]))
  Si = rbind(cyadea[i] - mu.c[i], beitaw[i] - mu.b[i], kniexc[i] - mu.k[i])
  meat = meat + t(Di)%*%solve(Wi)%*%Si%*%t(Si)%*%solve(Wi)%*%Di
  bread = bread + t(Di)%*%solve(Wi)%*%Di
}
sandwich.vcov = solve(bread)%*%(meat)%*%solve(bread)
