#rm enviroinment
rm(list = ls(all = T))

#setting working directory
getwd()
setwd("E:\\Internship\\Mobile phone classification")

#Loading the data set
phone = read.csv("train.csv", header = T, sep = ",")
str(phone)
summary(phone)
sum(is.na(phone))

#Data cleansing
phone$price_range <- as.factor(phone$price_range)
phone$blue <- as.factor(phone$blue)
phone$dual_sim <- as.factor(phone$dual_sim)
phone$four_g <- as.factor(phone$four_g)
phone$three_g <- as.factor(phone$three_g)
phone$touch_screen <- as.factor(phone$touch_screen)
phone$wifi <- as.factor(phone$wifi)

str(phone)

#test train split
library(caret)
set.seed(124)
trainrows <- createDataPartition(y = phone$price_range, p = 0.7, list = F)
train <- phone[trainrows,]
test <- phone[-trainrows,]

#Model biilding
library(C50)
c50_tree <- C5.0(price_range ~., data = train)
c50_tree_Rule <- C5.0(price_range ~., data = train, rules = T)

#Variable importance
C5imp(c50_tree, metric = "usage")
C5imp(c50_tree_Rule, metric = "usage")

#Model understanding
summary(c50_tree)
summary(c50_tree_Rule)

#Plotting the tree
plot(c50_tree)

#Evaluation of models and error metrics
preds1 <- predict(c50_tree, test)
preds2 <- predict(c50_tree_Rule, test)

confusionMatrix(preds1, test$price_range)
confusionMatrix(preds2, test$price_range)
