#' ## 5. Regression

#' ### 5.1 Linear Regression

#+
year <- rep(2008:2010, each = 4)    # repeat a year in 2008:2010 4 times
quarter <- rep(1:4, 3)              # replicate 1:4 3 times
cpi <- c(162.2, 164.6, 166.5, 166.0,
         166.2, 167.0, 168.6, 169.5,
         171.0, 172.1, 173.3, 174.0)
plot(cpi, xaxt="n", ylab="CPI", xlab="")   # xaxt = "n" xŽ²iaxisj‚ð•`‚©‚È‚¢
axis(side=1, labels=paste(year, quarter, sep="Q"), at=1:12, las=3)
# las=3: all labels are written vertically
# side: 1 down; 2 left; 3 up; 4 right
# axis: add an axis to a plot

#' check the correlation coefficients

#+ include=FALSE
library(ggplot2)

#+
year
cpi
quarter
qplot(year,cpi)
cor(year, cpi)
qplot(quarter,cpi)
cor(quarter, cpi)

#' a linear regression model   
#' response: cpi
#' predictors: year, quarter

#+
fit <- lm(cpi ~ year + quarter)
fit

#' The CIPs in 2011 can be calculated as follows:

(cpi2011 <- fit$coefficients[[1]] + fit$coefficients[[2]]*2011
          + fit$coefficients[[3]]*(1:4))

#' The attributes and str of the object fit

#+
attributes(fit)
str(fit)

#' The coefficients of fit (the linear model)

#+
fit$coefficients

#' The differences between observed valuses and fitted valuses

#+
residuals(fit)

#' its summary of fit

#+
summary(fit)
plot(fit)

#+ include=FALSE
library(scatterplot3d)

#+
s3d <- scatterplot3d(year, quarter, cpi, highlight.3d=TRUE, type="h", lab=c(2,3))
data2011 <- data.frame(year=2011, quarter=1:4)
cpi2011 <- predict(fit, newdata=data2011)
style <- c(rep(1,12), rep(2,4))
plot(c(cpi, cpi2011), xaxt="n", ylab="CPI", xlab="", 
     pch=style, col=style)
axis(1, at=1:16, las=3, 
     labels=c(paste(year, quarter, set="Q"), "2011Q1", "2011Q2", "2011Q3", "2011Q4")) 

#' ## 5.2 Lgistic Regression
#' 

#' \[logit(y) = \ln\left(\dfrac{y}{1-y}\right)
#'            = c_0 + c_1x_1 + c_2X_2 + \cdots + c_kx_k\]
#' \[\dfrac{y}{1-y} = e^{c_0 + c_1x_1 + c_2X_2 + \cdots + c_kx_k}\]
#' \[y = \dfrac{1}{1+e^{-(c_0 + c_1x_1 + c_2X_2 + \cdots + c_kx_k)}}]

#' ## 5.3 Generalized Linear Regression
#' 

#+
data("bodyfat", package="TH.data")
myFormula <- DEXfat ~ age + waistcirc + hipcirc + elbowbreadth + kneebreadth
bodyfat.glm <- glm(myFormula, family=gaussian("log"), data=bodyfat)
summary(bodyfat.glm)

#+
pred <- predict(bodyfat.glm, type="response")

#+
plot(bodyfat$DEXfat, pred, xlab="Observed Valuse", ylab="Predicted Values")
abline(a=0, b=1)





