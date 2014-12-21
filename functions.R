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

