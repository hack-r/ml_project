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
 
## Getting the Data
### Reading Data
The first step of this project was to import the test and training datasets from the Internet:

```{r}
#download.file ("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv",
#               destfile = "train.csv")
#download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv",
#              destfile = "test.csv")

train <- read.csv("train.csv")
test  <- read.csv("test.csv")
```

### Cleaning the Data
The next step was to manipulate and massage the data into an analyst-friendly, tidy dataset.

This included removing columns of junk data, such as those which contained mostly NA's:

```{r}
test$X      <- NULL
train$X     <- NULL
train.clean <- train[,colSums(is.na(train)) > .5 * nrow(train)]
```

## Model Building

## Cross Validation

## Expected out of sample error 

## Comments