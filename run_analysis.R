# Title:  run_analysis.R
# Author: Miller, J.D.
# Date:   2014-Dec-21

# Source Functions --------------------------------------------------------
source("functions.R")

# Import Data -------------------------------------------------------------
source("data.R")

# Train Predictor ---------------------------------------------------------
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
rpart.fit <- rpart(classe ~ ., data = labeled.train, method = "class") 

# Using Random Forest 
rf.fit <- randomForest(classe ~ ., data = labeled.train)

# Classifier Performance --------------------------------------------------
# Quantitative
## Multinomial Logit
test.long  <- mlogit.data(labeled.test,shape="wide",choice="classe")
pred.logit <- predict(logit.fit, test.long)
summary(logit.fit)
summary(pred.logit)
#confusionMatrix(pred.logit, test.long$alt)

## Rpart Decision Tree 
pred.rpart <- predict(rpart.fit, labeled.test, type = "class")
confusionMatrix(pred.rpart, labeled.test$classe)

## Random Forest
pred.rf <- predict(rf.fit, labeled.test)
confusionMatrix(pred.rf, labeled.test$classe)

# Visualization
fancyRpartPlot(rpart.fit)
plot(rf.fit)

# Run Against Test Data ---------------------------------------------------
result <- predict(rf.fit, test.clean, type = "class")
summary(result)