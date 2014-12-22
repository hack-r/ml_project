---
title: "ml_project_writeup.Rmd"
author: "Jason D. Miller"
date: "Sunday, December 21, 2014"
output:
  html_document:
    fig_caption: yes
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

## Libraries and Functions
I called in a number of R packages (libraries), a subset of which was used in the final analysis, and defined 2 custom functions.

```
require(caret)
require(data.table)
require(MASS)
require(mlogit)
require(grid)
require(gtable)
require(rpart)
require(rattle)

ml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}


xyform <- function (y_var, x_vars) {
  # y_var: a length-one character vector
  # x_vars: a character vector of object names
  as.formula(sprintf("%s ~ %s", y_var, paste(x_vars, collapse = " + ")))
}
```

## Getting the Data
### Reading Data
The first step of this project was to import the test and training datasets from the Internet:

```
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

```
test$X       <- NULL
train$X      <- NULL
train.clean  <- train[,colSums(is.na(train)) < .5 * nrow(train)]
test.clean   <- test[,colSums(is.na(test)) < .5 * nrow(test)]
```

I saw no reason to keep columns in my training dataset that are not available in my prediction dataset, asides of course from the outcome variable:

```
train.clean0 <- train.clean[,colnames(train.clean) %in% colnames(test.clean)]

train.clean0$classe <- train.clean$classe
```

This allowed me to greatly reduce noise in the data -- meaning I only have to consider about 1/3 of the number of columns that I began with.

### Divide Labeled Data into Training and Testing
```
# 60-40 Split
inTrain       <- createDataPartition(train$classe, p=0.6, list=FALSE)
labeled.train <- train[inTrain,]
labeled.test  <- train[-inTrain,]
```

## Model Building
I tested a few different classification algorithms and packages during the model building phase.

Namely:

1. Multinomial logistic regression (via `mlogit`)  
2. Decision tree classification  (via `rpart`)  
3. Random Forest (via `randomForest`)  

```
# Using Multinomial Logistic Regression
long = mlogit.data(labeled.train,shape="wide",choice="classe")
logit.fit <- mlogit(classe ~ 0 | new_window + num_window + roll_belt + pitch_belt + 
                      yaw_belt + total_accel_belt + gyros_belt_x + gyros_belt_y + 
                      gyros_belt_z + accel_belt_x + accel_belt_y + accel_belt_z + 
                      magnet_belt_x + magnet_belt_y + magnet_belt_z + roll_arm + 
                      pitch_arm + yaw_arm + total_accel_arm + gyros_arm_x + gyros_arm_y + 
                      gyros_arm_z + accel_arm_x + accel_arm_y + accel_arm_z + magnet_arm_x + 
                      magnet_arm_y + magnet_arm_z + roll_dumbbell + pitch_dumbbell + 
                      yaw_dumbbell + total_accel_dumbbell + gyros_dumbbell_x + 
                      gyros_dumbbell_y + gyros_dumbbell_z + accel_dumbbell_x + 
                      accel_dumbbell_y + accel_dumbbell_z + magnet_dumbbell_x + 
                      magnet_dumbbell_y + magnet_dumbbell_z + roll_forearm + pitch_forearm + 
                      yaw_forearm + total_accel_forearm + gyros_forearm_x + gyros_forearm_y + 
                      gyros_forearm_z + accel_forearm_x + accel_forearm_y + accel_forearm_z + 
                      magnet_forearm_x , data=long) 

# Using rpart for Classification Desicision Trees
rpart.fit <- rpart(classe ~ ., data=labeled.train, method="class") 

# Using Random Forest 
rf.fit <- randomForest(classe ~ ., data=labeled.train)
```

## Cross Validation and Expected out of sample error 
My multinomial logit had a relatively high R-squared, but was less straightforward to compare with other algorithms due to lack of support for a  confusion matrix.

```
test.long  <- mlogit.data(labeled.test,shape="wide",choice="classe")
pred.logit <- predict(logit.fit, test.long)
summary(logit.fit)
summary(pred.logit)
```

My decision tree predictor has accuracy of about 85.8% - 87.3% (95% CI):

```
pred.rpart <- predict(rpart.fit, labeled.test, type = "class")
confusionMatrix(pred.rpart, labeled.test$classe)
```
My final and best performing prediction algorithm was random forest, with 99.75 - 99.93% accuracy (95% CI)

```
pred.rf <- predict(rf.fit, labeled.test)
confusionMatrix(pred.rf, labeled.test$classe)
```

## Visualization
```
fancyRpartPlot(rpart.fit)
fancyRpartPlot(rf.fit)
```

## Prediction with Unlabeled Data
Finally, I predicted the (unlabeled) test data with my best model, which was the random forest:

```
result <- predict(rf.fit, test.clean, type = "class")
summary(result)
```