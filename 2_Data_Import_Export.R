#' ## 2 Data Import and Export

#' This chapter show how to import foreign data in to R
#' and export R objects to other formats.


#' ### 2.1 Save and Load R Data

#+
a <- 1:10
save(a, file="./data/dumData.Rdata")
rm(a)
a
load("./data/dumData.Rdata")
print(a)


#' ### 2.2 Import from and Export to .csv Files

#+
var1 <- 1:5
var2 <- var1/10
var3 <- c("R", "and", "Data Mining", "Examples", "Case Studies")
df1 <- data.frame(var1, var2, var3)
df1
names(df1) <- c("VariableInt", "VariableReal", "Variablechar")
print(df1)
write.csv(df1, "./data/dummyData.csv", row.names=FALSE)
df2 <- read.csv("./data/dummyData.csv")
print(df2)


#' ### Import/Export via ODBC

#' later

