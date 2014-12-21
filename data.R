# Title:  data.R
# Author: Miller, J.D.
# Date:   2014-Dec-21


# Grab from the Internet --------------------------------------------------
download.file ("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv",
               destfile = "train.csv")
download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv",
              destfile = "test.csv")

# Read CSV's --------------------------------------------------------------
train <- read.csv("train.csv")
test  <- read.csv("test.csv")

# Clean Up the Data -------------------------------------------------------
test$X       <- NULL
train$X      <- NULL
train.clean  <- train[,colSums(is.na(train)) < .5 * nrow(train)]
test.clean   <- test[,colSums(is.na(test)) < .5 * nrow(test)]
train.clean0 <- train.clean[,colnames(train.clean) %in% colnames(test.clean)]

train.clean0$classe <- train.clean$classe

# Partition Labeled Data into Training and Testing ------------------------
# 60-40 Split
inTrain       <- createDataPartition(train.clean0$classe, p=0.6, list=FALSE)
labeled.train <- train.clean0[inTrain,]
labeled.test  <- train.clean0[-inTrain,]

# Save Image --------------------------------------------------------------
save.image("ml_project_data.Rdata")
