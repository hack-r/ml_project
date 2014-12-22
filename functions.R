# Title:  functions.R
# Author: Miller, J.D.
# Date:   2014-Dec-21


# Load Libraries ----------------------------------------------------------
require(caret)
require(data.table)
require(MASS)
require(mlogit)
require(grid)
require(gtable)
require(rattle)
require(randomForest)
require(rpart)
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

xyform <- function (y_var, x_vars) {
  # y_var: a length-one character vector
  # x_vars: a character vector of object names
  as.formula(sprintf("%s ~ %s", y_var, paste(x_vars, collapse = " + ")))
}
