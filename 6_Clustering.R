#' ## Chapter 6 Clustering   


#' ### 6.1 The k-Means Clustering   

#+ include=FALSE
set.seed(8953)

#+
iris2 <- iris
head(iris2)
iris2$Species <- NULL     # same as iris2[,-5]
head(iris2)
(kmeans.result <- kmeans(iris2, 3))    # the number of cluster = 3
str(kmeans.result)
kmeans.result$centers

#+
table(iris$Species, kmeans.result$cluster)

#+
plot(iris2[c("Sepal.Length", "Sepal.Width")], col = kmeans.result$cluster)
# plot cluster centers
points(kmeans.result$centers[,c("Sepal.Length", "Sepal.Width")], col = 1:3, 
       pch = 8, cex=2)

#' ### 6.2 The k-Medoids Clustering

#' #### Summary of the k-Medoids Clustering  
#' A medoid is the point in the cluster defined by
#' \[arg\, min_{x \in X} \sum_{y\in(X-\{x\})} d(x,y)\]
#' 
#' * while a cluster is represented with its center (i.e., the means of the cluster)
#'  in the k-means algorithm, it is represented with the object 
#'  where the sum of distance is minimal.
#' * k-medoids cluster is not affected by outliers rather than k-means.     

#' * PAM (Partitioning Around Medoids) is a classic algorithm for k-medois clustering.
#' * PAM algorithm is inefficient for clustering large data.
#' * CLARA algorithm is an enhanced tecnique of PAM by drawing multiple samples of data,
#'   applying PAM on each sample and return the best clustering.
#' * pam(): implementation of PAM in the package *cluster*
#' * clara(): implementation of PAM in the package *cluster*
#' * pamk(): an enhanced version of pam(), not need to choose k (in package *fpc*)   

#+ include=FALSE
library(fpc)

#+ 
(pamk.result <- pamk(iris2))
# number of clusters
pamk.result$nc
# check clustering against actual species
table(pamk.result$pamobject$clustering, iris$Species)

#+ fig.width =12, fig.height=6
layout(matrix(c(1,2),1,2)) # 2 graphs per page 
plot(pamk.result$pamobject)
layout(matrix(1)) # change back to one graph per page 

#+
library(cluster)
pam.result <- pam(iris2, 3)
table(pam.result$clustering, iris$Species)

#+ fig.width =12, fig.height=6
layout(matrix(c(1,2),1,2)) # 2 graphs per page 
plot(pam.result)
layout(matrix(1)) # change back to one graph per page 

#' ### 6.3 Hierarchical Clustering

#+ include=FALSE
set.seed(2835)

#+
idx <- sample(1:dim(iris)[1], 40)
dim(iris)
dim(iris)[1]
idx
irisSample <- iris[idx,]
irisSample$Species <- NULL
hc <- hclust(dist(irisSample), method="ave")

#+ fig.width = 12, fig.height=8
plot(hc, hang = -1, labels=iris$Species[idx])
# hang: The fraction of the plot height
# by which labels should hang below the rest of the plot. 
# A negative value will cause the labels to hang down from 0.

# cut tree into 3 clusters
rect.hclust(hc, k=3)
groups <- cutree(hc, k=3)

#' ### 6.4 Density-Based Clustering

#+
library(fpc)
iris2 <- iris[-5] # remove class tags
ds <- dbscan(iris2, eps=0.42, MinPts=5)
# compare clusters with original class labels
table(ds$cluster, iris$Species)


#+
plot(ds, iris2)

#+
plot(ds, iris2[c(1,4)])

#+
plotcluster(iris2, ds$cluster)

#+
# create a new dataset for labeling
set.seed(435) 
idx <- sample(1:nrow(iris), 10)
newData <- iris[idx,-5]
newData <- newData + matrix(runif(10*4, min=0, max=0.2), nrow=10, ncol=4)
# label new data
myPred <- predict(ds, iris2, newData)
# plot result
plot(iris2[c(1,4)], col=1+ds$cluster)
points(newData[c(1,4)], pch="*", col=1+myPred, cex=3)
# check cluster labels
table(myPred, iris$Species[idx])
