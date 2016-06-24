## 2 Data Import and Export
This chapter show how to import foreign data in to R
and export R objects to other formats.
### 2.1 Save and Load R Data


```r
a <- 1:10
save(a, file="./data/dumData.Rdata")
```

```
## Warning in gzfile(file, "wb"): cannot open compressed file './data/
## dumData.Rdata', probable reason 'No such file or directory'
```

```
## Error in gzfile(file, "wb"): cannot open the connection
```

```r
rm(a)
a
```

```
## Error in eval(expr, envir, enclos): object 'a' not found
```

```r
load("./data/dumData.Rdata")
```

```
## Warning in readChar(con, 5L, useBytes = TRUE): cannot open compressed file
## './data/dumData.Rdata', probable reason 'No such file or directory'
```

```
## Error in readChar(con, 5L, useBytes = TRUE): cannot open the connection
```

```r
print(a)
```

```
## Error in print(a): object 'a' not found
```

### 2.2 Import from and Export to .csv Files


```r
var1 <- 1:5
var2 <- var1/10
var3 <- c("R", "and", "Data Mining", "Examples", "Case Studies")
df1 <- data.frame(var1, var2, var3)
df1
```

```
##   var1 var2         var3
## 1    1  0.1            R
## 2    2  0.2          and
## 3    3  0.3  Data Mining
## 4    4  0.4     Examples
## 5    5  0.5 Case Studies
```

```r
names(df1) <- c("VariableInt", "VariableReal", "Variablechar")
print(df1)
```

```
##   VariableInt VariableReal Variablechar
## 1           1          0.1            R
## 2           2          0.2          and
## 3           3          0.3  Data Mining
## 4           4          0.4     Examples
## 5           5          0.5 Case Studies
```

```r
write.csv(df1, "./data/dummyData.csv", row.names=FALSE)
```

```
## Warning in file(file, ifelse(append, "a", "w")): cannot open file './data/
## dummyData.csv': No such file or directory
```

```
## Error in file(file, ifelse(append, "a", "w")): cannot open the connection
```

```r
df2 <- read.csv("./data/dummyData.csv")
```

```
## Warning in file(file, "rt"): cannot open file './data/dummyData.csv': No
## such file or directory
```

```
## Error in file(file, "rt"): cannot open the connection
```

```r
print(df2)
```

```
## Error in print(df2): object 'df2' not found
```

### Import/Export via ODBC
later
