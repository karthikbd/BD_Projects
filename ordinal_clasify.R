#clearing enviroinment
rm(list = ls(all = T))

#set working directory
getwd()
setwd("E:\\Internship\\Mobile phone classification")

#Loading packages
require(foreign)
require(ggplot2)
require(MASS)
require(Hmisc)
require(reshape2)

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

phone$price_range <- ordered(c("0", "1", "2", "3"))
str(phone)

#test train split
library(caret)
set.seed(124)
trainrows <- createDataPartition(y = phone$price_range, p = 0.7, list = F)
train <- phone[trainrows,]
test <- phone[-trainrows,]

#model building
ordinal_model <- polr(price_range ~., data = train)
summary(ordinal_model)

#Model prediction
pred_model_1 <- predict(ordinal_model, test)

pred_model_2 <- predict(ordinal_model,newdata = test, type="class")
confusionMatrix(test$price_range, pred_model_2)
