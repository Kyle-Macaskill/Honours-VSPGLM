library(gldrm)

burns = data.table::fread("burns.txt", sep=",")
colnames(burns) = c("age", "gender", "burn_severity", "death")
burns[,4] = abs(burns[,4] - 2)
burns[,3] = log(burns[,3]+1)

model = gldrm(burn_severity ~ age, data=burns, link="identity")
model
#gldrmPIT(model)
n=981
library(Matrix)
# fit independent models for each component
fit1 = glm(burn_severity~age, data=burns)
fit2 = glm(death~age, family = quasibinomial,data=burns)
y1 = burns$burn_severity
y2 = burns$death
# fitted values
mu1 = fit1$fitted
mu2 = fit2$fitted
# working variances
W1 = rep(summary(fit1)$disp, n)
W2 = summary(fit2)$disp*mu2*(1-mu2)
# model-based variance-covariance matrix
naive.vcov = bdiag(summary(fit1)$cov.scaled, summary(fit2)$cov.scaled)
# compute sandwich estimator of variance
meat = 0
for (i in 1:n){
  Di = bdiag(model.matrix(fit1)[i,],(mu2[i]-mu2[i]^2)*model.matrix(fit2)[i,])
  Wi.inv = diag(c(1/W1[i], 1/W2[i]))
  Si = rbind(y1[i] - mu1[i], y2[i]-mu2[i])
  meat = meat + Di%*%Wi.inv%*%Si%*%t(Si)%*%Wi.inv%*%t(Di)
}
sandwich.vcov = naive.vcov%*%meat%*%naive.vcov
sqrt(sandwich.vcov)