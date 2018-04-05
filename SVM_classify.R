#clear env
rm(list = ls(all = T))

#Set working dir
getwd()
setwd("E:\\Internship\\Mobile phone classification")

#load data
phone <- read.csv("train.csv", header = T, sep = ",")
str(phone)
summary(phone)


#Data cleansing and pre processing
phone$price_range <- as.factor(phone$price_range)
phone$blue <- as.factor(phone$blue)
phone$dual_sim <- as.factor(phone$dual_sim)
phone$four_g <- as.factor(phone$four_g)
phone$three_g <- as.factor(phone$three_g)
phone$touch_screen <- as.factor(phone$touch_screen)
phone$wifi <- as.factor(phone$wifi)

str(phone)

#Test train split
library(caret)
set.seed(123)

train_split <- createDataPartition(y = phone$price_range, p = 0.7, list = F)
train <- phone[train_split,]
dim(train)
test <- phone[-train_split,]
dim(test)

#Standard scalling
process <- preProcess(x= train[,-21], method = c("center", "scale"))
train[,-21] <- predict(object = process, newdata = train[,-21])
test[,-21] <- predict(object = process, newdata = test[,-21])

#model building
library(e1071)

modl_svm <- svm(price_range ~ ., data = train, kernel = "linear")
summary(modl_svm)

##optimal c tuning
library(caret)
sampling_startegy <- trainControl(method = "repeatedcv", number = 4, repeats = 10)
svm_rough_model_c <- train(price_range ~ ., train, method = "svmLinear", tuneGrid = data.frame(.C = c(10^-4, 10^-3, 10^-2, 10^-1, 10^1, 10^2, 10^3, 10^5, 10^6)), trControl = sampling_startegy)
svm_rough_model_c                  

##predict
pred1 = predict(modl_svm, test)
pred2 = predict(svm_rough_model_c, test)

##confusion matrix
confusionMatrix(pred1,test$price_range)
confusionMatrix(pred2, test$price_range)

test_data <- read.csv("test.csv")

test_data$blue <- as.factor(test_data$blue)
test_data$dual_sim <- as.factor(test_data$dual_sim)
test_data$four_g <- as.factor(test_data$four_g)
test_data$three_g <- as.factor(test_data$three_g)
test_data$touch_screen <- as.factor(test_data$touch_screen)
test_data$wifi <- as.factor(test_data$wifi)

pred_model_1 <- predict(svm_rough_model_c, newdata = test_data)
head(pred_model_1)

pred_model_2 <- predict(multi_model, type="class", newdata=test_data)
head(pred_model_2)

submission1 = data.frame(id = test_data$id, price_range = pred_model_1)
write.csv(submission1, file = "E:\\Internship\\Mobile phone classification\\submission2.csv")
