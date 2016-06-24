#' ## 4. Decsion Trees and Random Forest

#' ### 4.1 Decisiono Trees with Package party

#' *iris* again

#+
str(iris)

#' preparation of train data (70%) and test data (30%).

#+
set.seed(54321)
ind <- sample(2, nrow(iris), replace = TRUE, prob = c(0.7, 0.3))
# create the bit series's number with the length nrow(iris) with
# the probability 0.7, 0.3, respectively
str(ind)
table(ind)

#+
trainData <- iris[ind==1, ]    # setup the train data
testData  <- iris[ind==2, ]    # setup the test data
head(trainData)
head(testData)

#' building the decision tree

#+
library(party)
#
# Species is the target variable and all other variables are independent variables.
myFormula <- Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width
#
# ctree() provides some parameters, such as MinSplit, MinBusket, MaxSurrogate, MaxDept
# to control the training of decision trees.
iris_ctree <- ctree(myFormula, data=trainData)

#' check the prediction

#+
str(predict(iris_ctree))
str(trainData$Species)
table(predict(iris_ctree), trainData$Species)

#' the built decision tree

#+
print(iris_ctree)

#+
plot(iris_ctree)

#+
plot(iris_ctree, typ="simple")

#+
testPred <- predict(iris_ctree, newdata=testData)
table(testPred, testData$Species)
