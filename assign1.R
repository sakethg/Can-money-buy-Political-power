#Data Preperation

getwd()
setwd("C:/Users/ASUS/Desktop/ABA Assignment 1")

#Import Data

data <- read.csv("election_campaign_data.csv", sep=",", header=T, strip.white = T, na.strings = c("NA","NaN","","?"))

#Explore Data

nrow(data)
summary(data)

#Drop unnecessary  variables

data<- data[,c(5,7,10:33)]

#Note: Since categorical variables enter into statistical models differently than continuous variables, 
#storing data as factors insures that the modeling functions will treat such data correctly.

data$twitter <- as.factor(data$twitter)
data$facebook <- as.factor(data$facebook)
data$youtube <- as.factor(data$youtube)
data$cand_ici <- as.factor(data$cand_ici)
data$gen_election <- as.factor(data$gen_election)
summary(data)

#Remove all observations with missing values

data <- data[complete.cases(data), ]
summary(data)

#Randomly assign 70% of the observations to train_data and the remaining observations to test_data 

set.seed(32) 
n = nrow(data) # n will be ther number of obs. in data
trainIndex = sample(1:n, 
                    size = round(0.7*n), 
                    replace=FALSE) # We create an index for 70% of obs. by random
train_data = data[trainIndex,] # We use the index to create training data
test_data = data[-trainIndex,] # We take the remaining 30% as the testing data
summary(train_data)

# Install packages required for Random Forest:

install.packages("randomForest")

#Load Packages required for Random Forest

library(randomForest)

#Build Classifier for Random Forest

rf <-randomForest(gen_election~., data=train_data, ntree=10, na.action=na.exclude, importance=T,
                  proximity=T) 
print(rf)

rf <-randomForest(gen_election~., data=train_data, ntree=20, na.action=na.exclude, importance=T,
                  proximity=T) 
print(rf)

rf <-randomForest(gen_election~., data=train_data, ntree=30, na.action=na.exclude, importance=T,
                  proximity=T) 
print(rf)

#Increase the number of trees in 10 increments 

for(i in seq(from=40, to = 300, by =10)){
rf <-randomForest(gen_election~., data=train_data, ntree=i, na.action=na.exclude, importance=T,
                  proximity=T) 
print(rf)}

#tune RF to find out best mtry

mtry <- tuneRF(train_data[-26], train_data$gen_election, ntreeTry=200,  stepFactor=1.5, 
               improve=0.01, trace=TRUE, plot=TRUE, , na.action=na.exclude)

best.m <- mtry[mtry[, 2] == min(mtry[, 2]), 1]

print(best.m)

#Implementing best ntree and mtry values for best RF classifier


rf <-randomForest(gen_election~., data=train_data, mtry=4, importance=TRUE, ntree=200)
print(rf)

#install package caret

install.packages("caret")

#use caret package

library(caret)

#Create Confusion Matrix

predicted_values <- predict(rf, test_data,type= "prob") # Use the classifier to make the predictions. 
#With the package that we used, type "raw" will give us the probabilities 
head(predicted_values) # Let's look at the predictions (probabilities)

threshold <- 0.5 
pred <- factor( ifelse(predicted_values[,1] > threshold, "W", "L") ) # We ask R to use the threshold and convert the probabilities to class labels (zero and one)
head(pred) # Let's look at the predicted class labels

levels(test_data$gen_election)

#install.packages("e1071")

confusionMatrix(pred, test_data$gen_election, 
                positive = levels(test_data$gen_election)[2])

#Create ROC Curve and calculate AUC

install.packages("ROCR")

library(ROCR)
library(ggplot2)
predicted_values <- predict(rf, test_data,type= "prob")[,2] 
pred <- prediction(predicted_values, test_data$gen_election)
perf <- performance(pred, measure = "tpr", x.measure = "fpr")
auc <- performance(pred, measure = "auc")
auc <- auc@y.values[[1]]

roc.data <- data.frame(fpr=unlist(perf@x.values),
                       tpr=unlist(perf@y.values),
                       model="RF")
ggplot(roc.data, aes(x=fpr, ymin=0, ymax=tpr)) +
  geom_ribbon(alpha=0.2) +
  geom_line(aes(y=tpr)) +
  ggtitle(paste0("ROC Curve w/ AUC=", auc))

#Evaluate Variable Importance

importance(rf)

varImpPlot(rf)

# Install packages required for ANN:

install.packages("nnet")

# Load packages required for ANN:

library(nnet)

#Build ANN Classifier with 5 hidden nodes

ann <- nnet(gen_election ~ ., data=train_data, size=5, maxit=1000) 

summary(ann)

#Create Confusion Matrix

library(caret)

# Use the classifier to make the predictions. With the package that we used, type "raw" will give us the probabilities

predicted_values <- predict(ann, test_data,type= "raw")  
head(predicted_values)

# We ask R to use the threshold and convert the probabilities to class labels (W and L)

threshold <- 0.5 
pred <- factor( ifelse(predicted_values[,1] > threshold, "W", "L") ) 
head(pred)

confusionMatrix(pred, test_data$gen_election, 
                positive = levels(test_data$gen_election)[2])

#Create ROC Curve and calculate AUC

install.packages("ROCR")

library(ROCR)
library(ggplot2)
predicted_values <- predict(ann, test_data,type= "prob")[,2] 
pred <- prediction(predicted_values, test_data$gen_election)
perf <- performance(pred, measure = "tpr", x.measure = "fpr")
auc <- performance(pred, measure = "auc")
auc <- auc@y.values[[1]]

roc.data <- data.frame(fpr=unlist(perf@x.values),
                       tpr=unlist(perf@y.values),
                       model="RF")
ggplot(roc.data, aes(x=fpr, ymin=0, ymax=tpr)) +
  geom_ribbon(alpha=0.2) +
  geom_line(aes(y=tpr)) +
  ggtitle(paste0("ROC Curve w/ AUC=", auc))

#Build ANN Classifier with 24 hidden nodes

ann <- nnet(gen_election ~ ., data=train_data, size=24, maxit=1000) 

summary(ann)

#Create Confusion Matrix

library(caret)

# Use the classifier to make the predictions. With the package that we used, type "raw" will give us the probabilities 

predicted_values <- predict(ann, test_data,type= "raw")
head(predicted_values)

# We ask R to use the threshold and convert the probabilities to class labels (W and L)

threshold <- 0.5 
pred <- factor( ifelse(predicted_values[,1] > threshold, "W", "L") ) 
head(pred)

confusionMatrix(pred, test_data$gen_election, 
                positive = levels(test_data$gen_election)[2])

#Create ROC Curve and calculate AUC

install.packages("ROCR")

library(ROCR)
library(ggplot2)
predicted_values <- predict(ann, test_data,type= "prob")[,2] 
pred <- prediction(predicted_values, test_data$gen_election)
perf <- performance(pred, measure = "tpr", x.measure = "fpr")
auc <- performance(pred, measure = "auc")
auc <- auc@y.values[[1]]

roc.data <- data.frame(fpr=unlist(perf@x.values),
                       tpr=unlist(perf@y.values),
                       model="RF")
ggplot(roc.data, aes(x=fpr, ymin=0, ymax=tpr)) +
  geom_ribbon(alpha=0.2) +
  geom_line(aes(y=tpr)) +
  ggtitle(paste0("ROC Curve w/ AUC=", auc))

#Tables

ftable(xtabs(~twitter+gen_election, data=data))

ftable(xtabs(~facebook+gen_election, data=data))

ftable(xtabs(~youtube+gen_election, data=data))

ftable(xtabs(~opp_fund+gen_election, data=data))
