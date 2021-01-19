rm(list = ls())
library(tidyverse)
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/R/R-machineLearning/데이터")

#파일 불러오기
list.files()
load(file = "bank_dataset.rda")

#랜덤포레스트 모형 적합
library(randomForest)
set.seed(seed = 1234)
fit1 <- randomForest(formula = PersonalLoan~.,
                     data = trainset,
                     ntree = 1000,
                     mtrey = 3,
                     importance = T, #변수 중요도 표시
                     do.trace = 50, #모형이 생성될 때마다 OOB 콘솔창에 표시
                     keep.forest = T) #개별 나무 모형의 끝마디 객수를 결과 객체에 저장
print(x = fit1)

#OOB 오차 추정
print(x = fit1$err.rate)
print(x = fit1$err.rate[,1])
tail(x = fit1$err.rate[,1], n = 1)

#OOB 결과 시각화
plot(x = fit1)

#변수 중요도 확인
importance(x = fit1, type = 1)
varImpPlot(x = fit1, main = 'Variable', type = 1)

#끝마디 시각화
fit1 %>% 
  treesize(terminal = T) %>% 
  hist(main = 'Terminal Nodes')

#목표변수의 추정값 및 추정확률 생성
#실제값
real <- testset$PersonalLoan
#추정값
pred1 <- predict(object = fit1, newdata = testset, type = 'response')
table(real,pred1)
#추정확률
prob1 <- predict(object = fit1, newdata = testset, type = 'vote')[,2]

#분류모형 성능평가
#혼동행렬
library(caret)
confusionMatrix(data = pred1, reference = real, positive = "1")

#F1점수
library(MLmetrics)
F1_Score(y_true = real,y_pred = pred1,positive = "1")

#roc곡선, auc 확인
library(pROC)
roc(response = real, predictor = prob1) %>% 
  plot(main = 'roc curve', col = 'red', lty = 1)
auc(response = real, predictor = prob1)

#decision tree 모형과 성능 비교
list.files()
fitDT <- readRDS("decisiontree.rds")
pred0 <- predict(object = fitDT, newdata = testset, type = 'class')

confusionMatrix(data = pred1, reference = real, positive = '1')
confusionMatrix(data = pred0, reference = real, positive = '1')

F1_Score(y_true = real, y_pred = pred1, positive = '1')
F1_Score(y_true = real, y_pred = pred0, positive = '1')

prob0 <- predict(object = fitDT, newdata = testset, type = 'prob')[, 2]
roc(response = real, predictor = prob0) %>%
  plot(col = 'blue', lty = 2, add = TRUE)
auc(response = real, predictor = prob0)
#의사결정나무 추정값 및 결과

#반복문을 통한 모형 튜닝
grid <- expand.grid(ntree = seq(300,1000,by = 200),
                    mtry = 3:7,
                    error = NA)
print(grid)

n <- nrow(x = grid)
for(i in 1:n){
  ntree = grid$ntree[i]
  mtry = grid$mtry[i]
  disp <- str_glue('현재 {i}행 실행 중! [ntree : {ntree}, mtry : {mtry}]  {Sys.time()}')
  cat(disp, "\n")
  
  set.seed(seed = 1234)
  fit <- randomForest(formula = PersonalLoan~.,
                      data = trainset,
                      ntree = ntree,
                      mtry = mtry)
  grid$error[i] <- tail(x = fit$err.rate[,1],n = 1)
}

#튜닝 결과 확인
plot(x = grid$error, type = "b", pch = 19, col = "gray30")
abline(h = min(grid$error), col = "red", lty = 2)
abline(v = which.min(grid$error), col = "red", lty = 2)

#최적 파라미터 저장
loc <- which.min(grid$error)
bestpara <- grid[loc,]

#최적 분류모형 적합
set.seed(seed = 1234)
best <- randomForest(formula = PersonalLoan~.,
                     data = trainset,
                     ntree = bestpara$ntree,
                     mtry = bestpara$mtry,
                     importance = T)
print(fit1)
print(best)
importance(x = best, type = 1)
varImpPlot(x = best, type = 1)

#결과분석
boxplot(formula = Income~PersonalLoan, data = trainset)
avg <- trainset %>% group_by(PersonalLoan) %>% summarise(m = mean(x = Income))
points(formula = m~PersonalLoan, data = avg, pch = 19, col = 'red', cex = 1.2)

#범주형이므로 크로스테이블로 분석
library(gmodels)
CrossTable(x = trainset$Education, y = trainset$PersonalLoan)
boxplot(formula = Education ~ PersonalLoan, data = trainset)

#성능 비교
pred2 <- predict(object = best, newdata = testset, type = 'response')

confusionMatrix(data = pred1, reference = real, positive = '1')
confusionMatrix(data = pred2, reference = real, positive = '1')

F1_Score(y_true = real, y_pred = pred1, positive = '1')
F1_Score(y_true = real, y_pred = pred2, positive = '1')

prob2 <-predict(object = best, newdata = testset, type = 'vote')[,2] 

roc(response = real, predictor = prob0) %>%
  plot(col = 'red', lty = 1)
roc(response = real, predictor = prob1) %>%
  plot(col = 'blue', lty = 2, add = TRUE)
roc(response = real, predictor = prob2) %>%
  plot(col = 'purple', lty = 2, add = TRUE)

saveRDS(object = best, file = 'randomforest.rds')