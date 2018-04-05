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

sum(is.na(phone))

#test train split
library(caret)
set.seed(124)
trainrows <- createDataPartition(y = phone$price_range, p = 0.7, list = F)
train <- phone[trainrows,]
test <- phone[-trainrows,]

dim(train)
dim(test)
prop.table(table((train$price_range)))
prop.table(table(test$price_range))

test1 <- read.csv("test.csv", header = T, sep = ",")

#MODEL BULDING
library(nnet)
multi_model <- multinom(formula = price_range ~., data = train)
summary(multi_model)
head(fitted(multi_model))

#variable imporance
library(caret)
mostImportantVariables <- varImp(multi_model)
mostImportantVariables$Variables <- row.names(mostImportantVariables)
mostImportantVariables <- mostImportantVariables[order(-mostImportantVariables$Overall),]
print(head(mostImportantVariables))


pred_model1 <- predict(multi_model, newdata = test, type = "probs")
head(pred_model1)

pred_model2 <- predict(multi_model, type="class", newdata=test)
head(pred_model2)
  
confusionMatrix(test$price_range, pred_model2)                     

#Predict test
test_data <- read.csv("test.csv")

test_data$blue <- as.factor(test_data$blue)
test_data$dual_sim <- as.factor(test_data$dual_sim)
test_data$four_g <- as.factor(test_data$four_g)
test_data$three_g <- as.factor(test_data$three_g)
test_data$touch_screen <- as.factor(test_data$touch_screen)
test_data$wifi <- as.factor(test_data$wifi)

pred_model_1 <- predict(multi_model, newdata = test_data, type = "probs")
head(pred_model_1)

pred_model_2 <- predict(multi_model, type="class", newdata=test_data)
head(pred_model_2)

submission1 = data.frame(id = test_data$id, price_range = pred_model_2)
write.csv(submission1, file = "E:\\Internship\\Mobile phone classification\\submission1.csv")
