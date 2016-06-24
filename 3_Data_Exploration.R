#' ## 3 Data Exploration

#' This chapter show examples on data exploraton with R.
#' * inspecting w.r.t. an R object
#'     - the dimensionality
#'     - structure
#'     - data
#' * basic satistics
#' * various charts
#'     - pie charets
#'     - histograms
#' * Exploration of multiple variables
#'     - grouped distribution
#'     - grouped boxplots
#'     - scattered plot
#'     - pairs plot
#'     - level plot
#'     - controur plot
#'     - 3D plot
#'     - how to save charts into files of various formats

#' ### 3.1 Have a Look at Data

#' dimension, names, structure, and attributes

#+
dim(iris)
names(iris)
str(iris)
attributes(iris)

#' on Iris

#' [iris](https://www.google.co.jp/search?q=iris&espv=2&biw=1264&bih=913&tbm=isch&tbo=u&source=univ&sa=X&ved=0ahUKEwiQ8qPQ68HMAhXlJ6YKHRZcAeQQsAQIRw)

#' the first or last rows

#+
iris[1:5,]
head(iris)
tail(iris)

#' retrieval of the values of a single column

#+
iris[1:10, "Sepal.Length"]
iris$Sepal.Length[1:10]

#' ### 3.2 Explore Individual Variables

#' #### basic statistics

#' distribution of every numeric variable
#' it shows the frequency of every level for factors

#+
summary(iris)

#+
quantile(iris$Sepal.Length)
quantile(iris$Sepal.Length, c(.1, .3, .65))

#+
var(iris$Sepal.Length)

#' #### various charts

#+
hist(iris$Sepal.Length)

#+
y.d <- density(iris$Sepal.Length)
str(y.d)
plot(y.d)

#' The frequency of **factors** can be calculated with function **table()**.

#+
y.t <- table(iris$Species)
str(y.t)

#+
pie(table(iris$Species))

#+
barplot(table(iris$Species))

#' ### 3.3 Explore Multiple Variables
 
#' **covariance**
#' 
#' \[cov(X,Y) = E((X-E(X))(Y-E(Y))\]   
#' 
#' \[\sigma_{xy} = \dfrac{1}{N}\sum_{i=1}^{N}(x_i-\bar{x})(y_i-\bar{y})\]
#' 
#' \[cor(X,Y) = \dfrac{cov(X,Y)}{\sqrt{var(X)}\sqrt{var(Y)}}\]
#' 
#' \[\rho_{xy} = \dfrac{\sum_{i=1}^{N}(x_i-\bar{x})(y_i-\bar{y})}{
#'               \sqrt{\sum_{i=1}^{N}(x_i-\bar{x})^2}
#'               \sqrt{\sum_{i=1}^{N}(y_i-\bar{y})^2} }\]
#'               

#+
cov(iris$Sepal.Length, iris$Petal.Length)
cov(iris[,1:4])

#+
cor(iris$Sepal.Length, iris$Petal.Length)
cor(iris[,1:4])

#+
aggregate(Sepal.Length~Species, summary, data=iris)

#+
boxplot(Sepal.Length~Species, data=iris)

#' scatter plot

#+
with(iris, plot(Sepal.Length, Sepal.Width, col=Species, pch=as.numeric(Species)))
plot(iris$Sepal.Length, iris$Sepal.Width, col=iris$Species, pch=as.numeric(iris$Species))
as.numeric(iris$Species)

#+
plot(iris$Sepal.Length, iris$Sepal.Width)
plot(jitter(iris$Sepal.Length), jitter(iris$Sepal.Width))

#+
pairs(iris)

#' ### More Explorations
#' 
#+
library(scatterplot3d)
scatterplot3d(iris$Petal.Width, iris$Sepal.Length, iris$Sepal.Width)

#+
library(rgl)
plot3d(iris$Petal.Width, iris$Sepal.Length, iris$Sepal.Width)

#+
distMatrix <- as.matrix(dist(iris[,1:4]))
heatmap(distMatrix)

#+
library(lattice)
levelplot(Petal.Width~Sepal.Length*Sepal.Width, iris, cuts=9, 
          col.regions=grey.colors(10)[10:1])

#+
levelplot(Petal.Width~Sepal.Length*Sepal.Width, iris, cuts=9, 
          col.regions=rainbow(10)[10:1])

#' color pallets

#+
demo.pal <- function(
  n, border = if (n<32) "light gray" else NA,
  main = paste("color palettes;  n=",n),
  ch.col = c("rainbow(n, start=.7, end=.1)", "heat.colors(n)",
             "terrain.colors(n)", "topo.colors(n)", "cm.colors(n)"))
{
  nt <- length(ch.col)
  i <- 1:n; j <- n / nt; d <- j/6; dy <- 2*d
  plot(i,i+d, type="n",yaxt="n",ylab="",main=main)
  for (k in 1:nt) {
    rect(i-.5, (k-1)*j+ dy, i+.4, k*j,
         col = eval(parse(text=ch.col[k])), border = border)
    text(2*j,k * j +dy/4, ch.col[k])
  }
}
n <- if(.Device == "postscript") 64 else 16
demo.pal(n)

#' Contour plots

#+
library(graphics)
#  data(volcano)
filled.contour(volcano, color=terrain.colors, asp=1, 
               plot.axes=contour(volcano, add=T))

#+
persp(volcano, theta=25, phi=30, expand=0.5, col="lightblue")

#+
library(MASS)
parcoord(iris[1:4], col=iris$Species)

#+
library(lattice)
parallelplot(~iris[1:4]|Species, data=iris)

#+
library(ggplot2)
qplot(Sepal.Length, Sepal.Width, data=iris, facets=Species ~.)
