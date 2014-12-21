---
title: "ml_project_writeup.Rmd"
author: "Jason D. Miller"
date: "Sunday, December 21, 2014"
output: html_document
---

# Practical Machine Learning Project Writeup

## Project Scope
This project uses data from the **Weight Lifting Exercise Dataset** to predict the manner in which exercisers wearing smartphone-powered biofeedback technology completed their exersies.

For details on the data please see `README.md` and `CodeBook.md`.

## R Scripts
The scripts I used in this project are:
1. functions.R -- which loads my libraries and custom functions
2. data.R -- which imports and cleans the data
3. run_analysis.R -- which builds and executes my machine learning algorithm

## Outcome
The outcome variable was `classe`, which categorizes the manner in which exercisers completed their exercises.
 
## Getting the Data
### Reading Data
The first step of this project was to import the test and training datasets from the Internet:

```{r}
# Grab from the Internet --------------------------------------------------
#download.file ("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv",
#               destfile = "train.csv")
#download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv",
#              destfile = "test.csv")

# Read CSV's --------------------------------------------------------------
train <- read.csv("train.csv")
test  <- read.csv("test.csv")
```

### Cleaning the Data
The next step was to manipulate and massage the data into an analyst-friendly, tidy dataset.

This included removing columns of junk data, such as those which contained mostly NA's:

```{r}
# Clean Up the Data -------------------------------------------------------
test$X       <- NULL
train$X      <- NULL
train.clean  <- train[,colSums(is.na(train)) < .5 * nrow(train)]
test.clean   <- test[,colSums(is.na(test)) < .5 * nrow(test)]
```

I saw no reason to keep columns in my training dataset that are not available in my prediction dataset, asides of course from the outcome variable:

```{r}
train.clean0 <- train.clean[,colnames(train.clean) %in% colnames(test.clean)]

train.clean0$classe <- train.clean$classe
```

This allowed me to greatly reduce noise in the data -- meaning I only have to consider about 1/3 of the number of columns that I began with.

### Divide Labeled Data into Training and Testing
```{r}
# Partition Labeled Data into Training and Testing ------------------------
# 60-40 Split
inTrain       <- createDataPartition(train$classe, p=0.6, list=FALSE)
labeled.train <- train[inTrain,]
labeled.test  <- train[-inTrain,]
```

## Libraries and Functions
I called in a number of R packages (libraries), a subset of which was used in the final analysis, and defined one custom function.

```{r}
# Load Libraries ----------------------------------------------------------
require(caret)
require(data.table)
require(MASS)
require(mlogit)
require(grid)
require(gtable)
require(rpart)
require(rattle)
require(sqldf)
require(tm)


# Custom Functions --------------------------------------------------------
ml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}

```

## Model Building
I tested a few different classification algorithms and packages during the model building phase.



## Cross Validation

## Expected out of sample error 

## Comments