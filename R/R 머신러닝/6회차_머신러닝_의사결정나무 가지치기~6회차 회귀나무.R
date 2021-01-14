rm(list = ls())
library(tidyverse)
url <- 'https://bit.ly/universal_bank'
guess_encoding(url)
df <- read.csv(url)

str(object = df)
#id 정보력 없으니 불필요, 쓸 경우엔 문자형
#zip.code = 문자형 : 우편번호로 따라서 지역을 분석해볼 순 있지만 어려움, 이런 경우엔 안씀
#한국의 zip.code라면 범정동 단위까지 만들어서 사용
#법정동 단위로 분석한 통계지표를 엮어서 사용 가능
#mortgage : 주택담보대출잔액 = 잔액이 있으면 0 없으면 1로 해서 모기지 대출 이용여부로 활용 가능
summary(object = df)
head(x = df, n = 10L)

####전처리####
#불필요한 컬럼과 이상치를 갖는 행 제거
df <- df %>% select(-ID, -ZIP.Code) %>% filter(Experience>=0)
#현재는 이상치를 제거하나 현업에서는 IT부서에 의뢰하여 수정해서 사용

#일부 컬럼을 범주형 벡터로 변환
cols <- c(6, 8:12)
df[,cols] <- map_df(.x = df[,cols],.f = as.factor)

#데이터셋 재확인
str(object = df)

#목표변수 빈도수 확인
#공부할 땐 SMOTE 함수로 데이터 균형화 후 진행해보기
df$PersonalLoan %>% table() %>% prop.table() %>% round(digits = 4L)*100
summary(object = df)

#testset과 trainset 데이터 분리
n <- nrow(df)
set.seed(seed = 1234)
index <- sample(x = n, size = n*0.7, replace = F)
trainset <- df %>% slice(index)
testset <- df %>% slice(-index)
trainset$PersonalLoan %>% table() %>% prop.table() %>% round(digits = 4L)*100
testset$PersonalLoan %>% table() %>% prop.table() %>% round(digits = 4L)*100

#다른 알고리즘으로 분류모형을 적합할 때 사용하기 위해 데이터 저장
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/R/R-machineLearning/데이터")
save(list = c('df','trainset','testset'),file =  "bank_dataset.RDA")
save(df,trainset,testset,file =  "bank_dataset.rda")

#의사결정나무 분류모형 적합
# install.packages("rpart")
library(rpart)
ctrl <- rpart.control(minsplit = 20,
                      cp = 0.01,
                      maxdepth = 10)

#의사결정나무 모형은 적합할 때 교차검증을 수행하므로
#재현가능한 결과를 생성하기 위해선 seed를 지정해야 함
set.seed(seed = 1234)
fit <- rpart(formula = PersonalLoan~., data = trainset, control = ctrl)

#분류 모형 적합 결과 확인
summary(fit)

# install.packages("rpart.plot")
library(rpart.plot)
rpart.plot(x = fit,
           type = 2,
           extra = 101,
           fallen.leaves = F)

printcp(x = fit)
plotcp(x = fit)

#분류모형 재적합, 정지규칙 변경
ctrl1 <- rpart.control(minsplit = 10,
                      cp = 0.001,
                      maxdepth = 30)

set.seed(seed = 1234)
fit1 <- rpart(formula = PersonalLoan~., data = trainset, control = ctrl1)
summary(fit1)
printcp(x = fit1)
plotcp(x = fit1)

#가지치기
fit2 <- prune.rpart(tree = fit1,
                    cp = 0.0098)
printcp(x = fit2)
plotcp(x = fit2)
rpart.plot(x = fit1,type = 2,extra = 101,fallen.leaves = F)
rpart.plot(x = fit2,type = 2,extra = 101,fallen.leaves = F)
windows()

#성능 확인
real <- testset$PersonalLoan
pred1 <- predict(object = fit1, newdata = testset, type = "class")
pred2 <- predict(object = fit2, newdata = testset, type = "class")

#혼동행렬 미리보기
table(pred1,real)
table(pred2,real)

#혼동행렬에서 민감도, 정밀도, 1-특이도 확인해보기
library(caret)
confusionMatrix(data = pred1, reference = real, positive = "1")
confusionMatrix(data = pred2, reference = real, positive = "1")

#F1 score 계산
library(MLmetrics)
F1_Score(y_true = real,y_pred = pred1, positive = "1")
F1_Score(y_true = real,y_pred = pred2, positive = "1")

#예측 분류 결과
prob1 <- predict(object = fit1, newdata = testset, type = "prob")[,2]
prob2 <- predict(object = fit2, newdata = testset, type = "prob")[,2]

#성능 확인
library(pROC)
roc(response = real, predict = prob1) %>% 
  plot(main = "ROC Curve", col = 'red', lty = 1)
roc(response = real, predict = prob2) %>% 
  plot(col = 'blue', lty = 2, add=T)

#---------------------------------6회차-------------------------
rm(list = ls())
library(tidyverse)

#파일 불러오기
url <- 'https://bit.ly/median_house_value'
guess_encoding(url)
df <- read.csv(url)

#데이터 구조 확인
head(df,10)
str(object = df)
summary(df)

range(df$MedianHouseValue)
breaks <- seq(from = 0, to = 510000, by = 10000)
#목표변수 히스토그램 그리기
hist(x = df$MedianHouseValue,col = 'white', breaks = breaks)
#목표변수가 500000만 이상인 값은 모두 500001로 추정되어 500000만 이상은 삭제
df <- df %>% filter(MedianHouseValue < 500000)

#분석 데이터셋 분할
n <- nrow(df)
set.seed(seed = 1234)
index <- sample(x = n,size = n*0.3,replace = F)
trainset <- df %>% slice(index)
testset <- df %>% slice(-index)

mean(x =trainset$MedianHouseValue)
mean(x =testset$MedianHouseValue)

#rda 파일로 저장
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/R/R-machineLearning/데이터")
getwd()
save(df,trainset,testset,file = "house_dataset.rda")

#회귀모형 적합
library(rpart)
ctrl <- rpart.control(minsplit = 20,
                      cp = 0.01,
                      maxdepth = 10)
set.seed(seed = 1234)
fit1 <- rpart(formula = MedianHouseValue~.,
             data = trainset,
             control = ctrl)

printcp(x = fit1)
plotcp(x = fit1)

#정지규칙 변경하여 다시 모형 재적합
ctrl <- rpart.control(minsplit = 10,
                      cp = 0.001,
                      maxdepth = 30)
set.seed(seed = 1234)
fit1 <- rpart(formula = MedianHouseValue~.,
              data = trainset,
              control = ctrl)

printcp(x = fit1)
plotcp(x = fit1)

#xerror만 벡터로 선택
str(object = fit1)

#xerror 최소값 위치 확인
xerror_min_loc <- which.min(x = fit1$cptable[,4])

#cp만 벡터로 선택
cp <- fit1$cptable[xerror_min_loc,1]
print(x = cp)

#가지치기
fit2 <- prune.rpart(tree = fit1,cp = cp)
printcp(x = fit2)
plotcp(x = fit2)

#나무모형 시각화
library(rpart.plot)
windows()
rpart.plot(x = fit2,type = 2,extra = 101,fallen.leaves = F)

#성능 평가
real <- testset$MedianHouseValue

pred1 <- predict(object = fit1, newdata = testset, type = 'vector')
pred2 <- predict(object = fit2, newdata = testset, type = 'vector')

#성능평가 지표 함수 만들기
#회귀모형의 성능 평가하는 사용자 정의 함수 생성
regMeasure <- function(real, pred){
  library(MLmetrics)
  result <- data.frame(
    MSE = MSE(y_pred = pred, y_true = real),
    RMSE = RMSE(y_pred = pred, y_true = real),
    MAE = MAE(y_pred = pred, y_true = real),
    MAPE = MAPE(y_pred = pred, y_true = real)
  )
  return(result)
}
regMeasure(real,pred1)
regMeasure(real,pred2)

getwd()
setwd('../코드')
list.files()
source(file = "myfuncs.R")

regMeasure(real = real,pred = pred1)
regMeasure(real = real,pred = pred2)

#선형 회귀모형 프로세스
#목표 변수가 정규분포를 따르는지 확인
#히스토그램 그려서 보는 것도 방법
#목표변수와 입력변수 간 상관 분석 : 피어슨 상관분석
#정규분포해야 퍼이슨 상관분석
#비모수적 기법으로 상관관계를 보려면 스피어만 상관분석

test <- cor.test(x = df$MedianIncome, y=df$MedianHouseValue)
str(test)
test$p.value > 0.05

corrResult <- map_lgl(.x = df, .f = function(x){
  test <- cor.test(x = x, y=df$MedianHouseValue)
  result <- test$p.value > 0.05
  return(result)
  })

#'x' 인자의 True 인덱스 반환
which(x = 1:5 >=3)
which(x = corrResult)

#다중선형회귀모형 적합
full = lm(formula = MedianHouseValue~., data = trainset)
fit2 <- step(object = full, direction = 'both')
summary(object = fit2)

#다중공산성 확인
library(car)
vif(mod = fit2)

#10이상 중 가장 큰거 하나 제외
trainset1 <- trainset %>% select(-TotalBedrooms)
full = lm(formula = MedianHouseValue~., data = trainset1)
fit2 <- step(object = full, direction = 'both')
summary(object = fit2)
vif(mod = fit2)

trainset1 <- trainset1 %>% select(-Households)
full = lm(formula = MedianHouseValue~., data = trainset1)
fit2 <- step(object = full, direction = 'both')
summary(object = fit2)
vif(mod = fit2)

library(reghelper)
beta.z <- beta(model = fit2)
beta.z$coefficients[,1]
beta.z$coefficients[,1] %>% abs() %>% round(digits = 4L) %>% sort()

pred2 <- predict(object = fit2, newdata = testset, type = 'response')
regMeasure(real,pred1)
regMeasure(real,pred2)
windows()
plot(x = real, type = "l", col = 'red')
plot(x = pred2, type = 'l', col = 'blue')


