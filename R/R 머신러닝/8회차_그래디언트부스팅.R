library(tidyverse)
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/R/R-machineLearning/데이터")
list.files()
load("bank_dataset.rda")

parallel::detectCores()

# install.packages("gbm")
library(gbm)
set.seed(seed = 1234)
fit1 <- gbm(formula = PersonalLoan~.,
            data = trainset,
            distribution = "multinomial",
            n.trees = 5000,
            interaction.depth = 3,
            shrinkage =  0.01,
            n.minobsinnode = 10,
            bag.fraction = 0.5,
            cv.folds = 5,
            n.cores = 11,
            verbose = T)
print(x = fit1)
par(mar = c(5,8,4,2)) #par : 플랏창 설정 함수
                      #mar = margin, c(5,4,4,2)(하,좌,상,우, dafault)
summary(object = fit1, las = 2)
title(main = "Variable Importance")
par(mar = c(5,4,4,2))
dev.off() #Plot창 모드 지움

gbm.perf(object = fit1, method = 'cv') #gbm.perf = gbm.performance
title(main = "Number of Trees")

#성능 평가
real <- testset$PersonalLoan
prob1 <- predict(object = fit1,newdata = testset, type = "response")
#1543번째 나무모형에 해당하는 모델의 추정확률
head(x = prob1)
prob1 <- prob1[,2,1]
boxplot(formula = prob1~real)

pred1 <- ifelse(prob1>=0.5,"1","0") %>% as.factor()
head(x = pred1)

#혼동행렬 그리기
library(caret)
confusionMatrix(data = pred1, reference = real, positive = "1")

#랜덤포레스트 모형 불러오기
bestRF <- readRDS("randomforest.rds")

class(x = bestRF)
#랜덤포레스트 모형이므로 랜덤포레스트 패키지를 불러와야함
library(randomForest)
pred0 <- predict(object = bestRF, newdata = testset, type = "response")
prob0 <- predict(object = bestRF, newdata = testset, type = "vote")[,2]

#성능 비교
confusionMatrix(data = pred0, reference = real, positive = "1")
confusionMatrix(data = pred1, reference = real, positive = "1")

library(MLmetrics)
F1_Score(y_true = real, y_pred = pred0, positive = "1")
F1_Score(y_true = real, y_pred = pred1, positive = "1")

library(pROC)
roc(response = real, predictor = prob0) %>% 
  plot(main = "roc curve", col = "red", lty = 1)
roc(response = real, predictor = prob1) %>% 
  plot(col = "blue", lty = 2, add=T)

auc(response = real, predictor = prob0)
auc(response = real, predictor = prob1)

#모형 튜닝
grid <- expand.grid(depth = c(1,3,5),
                    learn = c(0.01, 0.05, 0.10),
                    min = c(5,7,10),
                    bag = c(0.5,0.8,1.0),
                    verr = NA,
                    tree = NA)
i <- 1
for(i in 1:nrow(x = grid)){
  cat(str_glue('현재 {i}행 실행 중  {Sys.time()}'),"\n")
  set.seed(seed = 1234)
  fit <- gbm(formula = PersonalLoan~.,
             data = trainset,
             distribution = "multinomial",
             n.trees = 5000,
             interaction.depth = grid$depth[i],
             shrinkage =  grid$learn[i],
             n.minobsinnode = grid$min[i],
             bag.fraction = grid$bag[i],
             train.fraction = 0.75,
             n.cores = NULL)
  grid$verr[i] <- min(fit$valid.error)
  grid$tree[i] <- which.min(x = fit$valid.error)
}

loc <- which.min(x = grid$verr)
print(x = loc)

bestPara <- grid[loc,]
print(x = bestPara)

set.seed(seed = 1234)
best <- gbm(formula = PersonalLoan~.,
           data = trainset,
           distribution = "multinomial",
           n.trees = bestPara$tree,
           interaction.depth = bestPara$depth,
           shrinkage =  bestPara$learn,
           n.minobsinnode = bestPara$min,
           bag.fraction = bestPara$bag,
           train.fraction = 0.75,
           n.cores = NULL)
prob2 <- predict(object = best, newdata = testset, type = 'response', n.trees = bestPara$tree)
head(x= prob2)
prob2 <- prob2[,2,1]
head(x = prob2)
boxplot(formula = prob2~real)
pred2 <- ifelse(prob2>=0.5,"1","0") %>% as.factor()

#성능 비교
confusionMatrix(data = pred0, reference = real, positive = "1")
confusionMatrix(data = pred1, reference = real, positive = "1")
confusionMatrix(data = pred2, reference = real, positive = "1")

library(MLmetrics)
F1_Score(y_true = real, y_pred = pred0, positive = "1")
F1_Score(y_true = real, y_pred = pred1, positive = "1")
F1_Score(y_true = real, y_pred = pred2, positive = "1")

library(pROC)
roc(response = real, predictor = prob0) %>% 
  plot(main = "roc curve", col = "red", lty = 1)
roc(response = real, predictor = prob1) %>% 
  plot(col = "blue", lty = 2, add=T)
roc(response = real, predictor = prob2) %>% 
  plot(col = "purple", lwd = 2, add=T)

auc(response = real, predictor = prob0)
auc(response = real, predictor = prob1)
auc(response = real, predictor = prob2)
saveRDS(best,"GradientBoostingModel.rds")