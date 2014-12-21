# Title:  run_analysis.R
# Author: Miller, J.D.
# Date:   2014-Dec-21

# Source Functions --------------------------------------------------------
source("functions.R")

# Import Data -------------------------------------------------------------
source("data.R")

# Train Predictor ---------------------------------------------------------
# Using rpart for Classification Desicision Trees
fit <- rpart(classe ~ ., data=labeled.train, method="class") #f "anova", "poisson", "class" or "exp"


# Visualization -----------------------------------------------------------


# Run Against Test Data ---------------------------------------------------

