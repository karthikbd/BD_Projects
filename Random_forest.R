#rm enviroinment
rm(list = ls(all = T))

#setting working directory
getwd()
setwd("E:\\Internship\\Mobile phone classification")

#loading data set
phone = read.csv("train.csv", header = T, sep = ",")
str(phone)
summary(phone)
sum(is.na(phone))

#variable changes
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

test1 <- read.csv("test.csv", header = T, sep = ",")

#model Building
library(randomForest)

model_forest_pf <- tuneRF(train[-21],train$price_range,ntreeTry=1000,
                          stepFactor = 1.5,improve = 0.01,trace = TRUE,
                          plot = TRUE,doBest = FALSE)
adult.rf = randomForest(price_range ~ ., data = train, ntree = 1000, mtry = 9, importance = TRUE, keep.forest = T)
print(adult.rf)
plot(adult.rf)

pred = predict(adult.rf, test)
confusionMatrix(pred, test$price_range)
