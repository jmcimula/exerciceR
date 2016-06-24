#' ## chapter 8. Time Series Analysis and Mining

#' the contents of this chapter  
#' * time series data in R
#' * an example on decomposing time series into trend, seasonal, andn random components.
#' * how to build an autoregressive integrated moving average (ARIMA) model in R   
#'   use it to predict future valuses
#' * Dynamic Time Warping (DTW) and hierarchical clustering of time series data
#' * three examples on time series classification   
#'  

#' ### 8.1 Time Series Data in R 

#' ts {stats}	: Time-Series Objects    
#' The function ts is used to create time-series objects.

#' as.ts and is.ts coerce an object to a time-series and 
#' test whether an object is a time series.
#' #### Usage

#' ts(data = NA, start = 1, end = numeric(), frequency = 1,
#'    deltat = 1, ts.eps = getOption("ts.eps"), class = , names = )
#' as.ts(x, ...)
#' is.ts(x)

#' #### Arguments

#' * data: a vector or matrix of the observed time-series values. 
#'   A data frame will be coerced to a numeric matrix via data.matrix. (See also ÅeDetailsÅf.)
#' * start: the time of the first observation. 
#'   Either a single number or a vector of two integers, which specify a natural time unit 
#'   and a (1-based) number of samples into the time unit. 	
#' * end: the time of the last observation, specified in the same way as start.
#' * frequency: the number of observations per unit of time.

#+ 
a <- ts(1:30, frequency=12, start=c(2011,3))
str(a)
print(a)
attributes(a)


#' ### 8.2 Time Series Decomposition

#' The time Series Decomposition is to decompose a time series into 
#' * trend
#' * seasonal
#' * cyclical
#' * irregular components
#' 
#' #### Data   
#' *AirPassengers*: monthly totals of Box&Jenkins international airline passengers
#'                 from 1949 to 1960.

#+ fig.width=8, fig.height=8
str(AirPassengers)
print(AirPassengers)
plot(AirPassengers)

#' decompose time series
#+ 
apts <- ts(AirPassengers, frequency=12)
apts
f <- decompose(apts)
str(f)

#' seasonal figures
#+ 
f$figure
f$seasonal

#' plot the seasonal figure in the graph
#+ fig.width=8, fig.height=8
plot(f$figure, type="b", xaxt="n", xlab="")
  # type="b": point and line
  # xaxt="n": do not describe x axis 
monthNames <- months(ISOdate(2011,1:12,1))
  # get names of 12 months in English words
  # label x-axis with month names 
  # las is set to 2 for vertical label orientation
axis(1, at=1:12, labels=monthNames, las=2) 
  # las=2: vertical label orientation

#' plot decomposition of additive time series
#+ fig.width=8, fig.height=8 
plot(f)
(y <- f$seasonal + f$trend + f$random)
#f$x - y

#' some other funtions for time series decomposition
#' * stl() in package *stats* (R Development Core Team, 2012)
#' * decomp() in package *timsac* (The Institute of Statistical Mathematics, 2012)
#' * tsr() in package *ast* 

#' ### 8.3 Time Series Forecasting

#+ fig.width=8, fig.height=8
fit <- arima(AirPassengers, order=c(1,0,0), list(order=c(2,1,0), period=12))
fore <- predict(fit, n.ahead=24)
# error bounds at 95% confidence level
U <- fore$pred + 2*fore$se
L <- fore$pred - 2*fore$se
ts.plot(AirPassengers, fore$pred, U, L, col=c(1,2,4,4), lty = c(1,1,2,2))
legend("topleft", c("Actual", "Forecast", "Error Bounds (95% Confidence)"),
       col=c(1,2,4), lty=c(1,1,2))


#' ### 8.4 Time Series Clustering   

#' Time series clustering is to partition time series data into groups 
#' base on similarity or distance, so that time series in the same cluster
#' are similar to each other.

#' various measures or distance
#' 
#' * Euclidean distance
#' * Manhattan distance
#' * Maximum norm
#' * Hamming distance
#' * angle between two vectors (inner product)
#' * Dynamic Time Warping (DTW)
#'    

#' #### 8.4.1 Dynamic Time Warping
#' 
#' Dynamic Time Warping (DTW) finds optimal alignment between two time series.
#+ fig.width=8, fig.height=8
library(dtw)
idx <- seq(0, 2*pi, len=100)
a <- sin(idx) + runif(100)/10
b <- cos(idx)
align <- dtw(a, b, step=asymmetricP1, keep=T)
# dtw(x, y, ..) computes dynamic time warp and
# finds optimal alignment between x, y
dtwPlotTwoWay(align)

#' dtwDist(mx, my) or dist(mx, my, method="DTW", ..) 
#' calculates the distances between time series mx and my.

#' crazy alignment
#+ fig.width=8, fig.height=8 
a <- sin(idx)
b <- cos(idx)
align <- dtw(a, b, step=asymmetricP1, keep=T)
dtwPlotTwoWay(align)


#' #### 8.4.2 Synthetic Control Chart Time Series Data

#' loading a data
#+
sc <- read.table("./data/synthetic_control.data", header=F, sep="")

#' first example 
#+ fig.width=8, fig.height=8
# show one sample from each class
idx <- c(1,101,201,301,401,501)
sample1 <- t(sc[idx,])
plot.ts(sample1, main="")

#' 2nd example from each class
#+ fig.width=8, fig.height=8
idx <- c(56,123,282,339,421,591)
sample1 <- t(sc[idx,])
plot.ts(sample1, main="")

#' one example from same class
#+ fig.width=8, fig.height=8
idx <- c(401,421,441,461,481,499)
sample1 <- t(sc[idx,])
plot.ts(sample1, main="")


#' #### 8.4.3 Hierarchical Clustering with Euclidean Distance

#+
set.seed(6218)

#+ fig.width=8, fig.height=5
s <- sample(1:100, n)
idx <- c(s, 100+s, 200+s, 300+s, 400+s, 500+s)
sample2 <- sc[idx,]
observedLabels <- rep(1:6, each=n)
# hierarchical clustering with Euclidean distance
hc <- hclust(dist(sample2), method="average")
plot(hc, labels=observedLabels, main="")
# cut tree to get 6 clusters
rect.hclust(hc, k=6)
memb <- cutree(hc, k=6)
table(observedLabels, memb)


#' #### 8.4.4 Hierarchical Clustering with DTW Distance

#+ fig.width=8, fig.height=5
library(dtw)
distMatrix <- dist(sample2, method="DTW")
hc <- hclust(distMatrix, method="average")
plot(hc, labels=observedLabels, main="")
# cut tree to get 6 clusters
rect.hclust(hc, k=6)
memb <- cutree(hc, k=6)
table(observedLabels, memb)


#' ### 8.5 Time Series Classification

#' ### 8.5.1 Classification with Original Data
#' 
#+ 
classId <- rep(as.character(1:6), each=100)
newSc <- data.frame(cbind(classId, sc))
library(party)
ct <- ctree(classId ~ ., data=newSc, 
            controls = ctree_control(minsplit=30, minbucket=10, maxdepth=5))
pClassId <- predict(ct)
table(classId, pClassId)
# accuracy
(sum(classId==pClassId)) / nrow(sc)
plot(ct, ip_args=list(pval=FALSE), ep_args=list(digits=0))

#' ### 8.5.2 Classification with Extracted Feaures
#' 
#+
library(wavelets)
wtData <- NULL
for (i in 1:nrow(sc)) {
  a <- t(sc[i,])
  wt <- dwt(a, filter="haar", boundary="periodic")
  wtData <- rbind(wtData, unlist(c(wt@W, wt@V[[wt@level]])))
}
wtData <- as.data.frame(wtData)
wtSc <- data.frame(cbind(classId, wtData))

#+
# build a decision tree with DWT coefficients
ct <- ctree(classId ~ ., data=wtSc, 
            controls = ctree_control(minsplit=30, minbucket=10, maxdepth=5))
pClassId <- predict(ct)
table(classId, pClassId)
(sum(classId==pClassId)) / nrow(wtSc)
plot(ct, ip_args=list(pval=FALSE), ep_args=list(digits=0))

#' #### 8.5.3 k-NN Classification
#' 
#+
# fix seed to get a fixed result in the chunk below
#+
set.seed(100)

#+
k <- 20
# create a new time series by adding noise to time series 501
newTS <- sc[501,] + runif(100)*15
distances <- dist(newTS, sc, method="DTW")
s <- sort(as.vector(distances), index.return=TRUE)

# class IDs of k nearest neighbors
#+
table(classId[s$ix[1:k]])


