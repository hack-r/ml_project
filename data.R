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
test$X      <- NULL
train$X     <- NULL
train.clean <- train[,colSums(is.na(train)) > .5 * nrow(train)]

# Save Image --------------------------------------------------------------
save.image("ml_project_data.Rdata")
