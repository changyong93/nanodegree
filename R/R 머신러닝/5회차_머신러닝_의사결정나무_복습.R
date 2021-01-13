library(tidyverse)
url <- 'https://bit.ly/universal_bank'

guess_encoding(url)
df <- read.csv(url)
str(df)
summary(df)

#불필요 컬럼 및 이상치 행 삭제
df <- df %>% select(-ID, -ZIP.Code) %>% filter(Experience>=0)
str(df)
summary(df)

#일부 컬럼을 범주형 벡터로변환
cols <- c(6, 8:12)
df[,cols] <- map_df(.x = df[,cols],.f = as.factor)
str(object = df)
summary(object = df)

#목표변수 빈도수 파악
df$PersonalLoan %>% table() %>% prop.table() %>% round(digits = 4L)*100

#분석 데이터셋 분할
n <- nrow(df)
set.seed(seed = 1234)
index <- sample(x = n,size = n*0.7,replace = F)
testset <- df %>% slice(-index)
trainset<- df %>% slice(index)
trainset$PersonalLoan %>% table() %>% prop.table() %>% round(digits = 4L)*100
testset$PersonalLoan %>% table() %>% prop.table() %>% round(digits = 4L)*100

#rda 파일로 저장
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/R/R-machineLearning/데이터")
save(trainset,testset, file = "bank_dataset.rda")

#분류모형 적합
library(rpart)
ctrl <- rpart.control(minsplit = 20L,
                      cp = 0.01,
                      maxdepth = 10L)
set.seed(seed = 1234)
fit1 <- rpart(formula = PersonalLoan~.,
              data = trainset,
              control = ctrl)
summary(fit1)

#나무모형 시각화
library(rpart.plot)
windows()
rpart.plot(x = fit1,
           type = 2,extra = 106,
           fallen.leaves = F)

#성능평가
real <- testset$PersonalLoan
pred1 <- predict(object = fit1, newdata = testset, type = 'class')
table(pred1, real)

#데이터 균형화
library(DMwR)
set.seed(seed = 1234)
trainbal <- SMOTE(form = PersonalLoan~.,
      data = trainset,perc.over = 200,
      k = 5,
      perc.under = 150)

#균형화 데이터로 결정나무 모델 적합
set.seed(seed = 1234)
fit2 <- rpart(formula = PersonalLoan~.,
              data = trainbal,
              control = ctrl)
summary(fit2)
# windows()
rpart.plot(x = fit2,
           type = 2,
           extra = 106,
           fallen.leaves = F)

pred2 <- predict(object = fit2, newdata = testset, type = 'class')
table(pred2,real)

library(caret)
library(MLmetrics)

#C5.0 함수 사용해보기
# install.packages("C50")
library(C50)
C5.0Control()
set.seed(seed = 1234)
fit3 <- C5.0(formula = PersonalLoan~.,
      data = trainset,
      control = C5.0Control(winnow = T))
summary(fit3)
pred3 <- predict(object = fit3, newdata = testset, type = "class")
confusionMatrix(data = pred1, reference = real, positive = '1')
confusionMatrix(data = pred2, reference = real, positive = '1')
confusionMatrix(data = pred3, reference = real, positive = "1")

F1_Score(y_true = real, y_pred = pred1, positive = '1')
F1_Score(y_true = real, y_pred = pred2, positive = '1')
F1_Score(y_true = real, y_pred = pred3, positive = '1')

#참고 : https://byungjun0689.github.io/4.-DecisionTree2(withR)/