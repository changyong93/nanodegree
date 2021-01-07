library(tidyverse)
#1강 자료 데이터 표준화
setwd(dir =  'C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/R/R-machineLearning/데이터')

#file명 확인
list.files()

#데이터 불러오기
cust <- readRDS(file = 'Dataset for Cust.RDS')

#데이터 구조 확인
str(object = cust)
summary(object = cust)

#유클라디안 거리 계산
dist(x = cust, method = 'euclidean')

#데이터 표준화
scaled <- scale(x = cust)

#표준화 데이터로 거리 재계산
dist(x = scaled, method = 'euclidean')

#실습1
#데이터 표준화
set.seed(seed = 1234)
heights <- rnorm(n = 10000, mean = 172.4, sd = 5.7)
scaled1 <- scale(x = heights)
mean(x = scaled1)
sd(x = scaled1)
range(scaled1)

#최소-최대 정규화 (= 정규화)
Min <- min(heights)
Max <- max(heights)
scaled2 <- scale(x = heights, center = Min, scale = Max - Min)
mean(x = scaled2)
sd(x = scaled2)
range(scaled2)

#실습2
df <- data.frame(x=c(1,4),y=c(1,5))
print(x = df)
dist(x = df, method = 'manhattan')
dist(x = df, method = 'euclidean')
dist(x = df, method = 'minkowski', p = 1)
dist(x = df, method = 'minkowski', p = 2)

#4강 KNN
url <- 'https://bit.ly/white_wine_quality'
guess_encoding(url)
df <- read.csv(url, sep = ';')
#csv : comma saperated value, => 구분자 ,=> sep = ','가 디폴트
#실제 데이터가 구분자가 다를 경우 구분자 재지정

#데이터 구조 및 기초통계량 확인
str(object = df)
summary(object = df)

#실습 : 목표변수 탐색하기
##목표변수로 사용할 quality 컬럼의 빈도수 확인
tbl <- table(x = df$quality)
print(x = tbl)

##누적상대도수 확인
tbl %>% prop.table() %>% cumsum() %>% round(digits = 4L)*100
#=> 데이터 누적 값을 보고 good과 best 비율을 정함

#quality 컬럼으로 막대 그래프 그리기
bp <- barplot(height = tbl,
        ylim = c(0,2400), #막대별 값을 넣어주기 위해 그래프 늘림
        xlab = 'Quality Score',
        main = 'White Wine')

#빈도수 추가
text(x = bp, #x축의 위치값
     y = tbl,
     labels = tbl,
     pos = 3,
     font = 2)

#quality를 범주형으로 변경 후 grade 컬럼 생성
df$grade <- ifelse(test = df$quality>=7, yes = "best", no = "good")
df$grade <- factor(x = df$grade,levels = c("good","best"))
df$grade %>% table() %>% prop.table()*100

#목표변수를 만든 quality 삭제
df$quality <- NULL

#데이터셋 분할
n <- nrow(df)

set.seed(seed = 1234)
index <- sample(x = n,size = n*0.7,replace = FALSE)
trainSet <- df %>% slice(index)
testSet <- df %>% slice(-index)

trainSet$grade %>% table %>% prop.table() %>% round(digits=4L)*100
testSet$grade %>% table %>% prop.table() %>% round(digits=4L)*100

#k 개수 선정 = 훈련셋의 행 개수의 제곱근
k <- trainSet %>% 
  nrow() %>% 
  sqrt() %>% 
  ceiling()
print(x = k)

#가중치가 없는 knn 모형
# install.packages('kknn')
library(kknn)
fit1 <- kknn(formula = grade ~ .,
             train = trainSet,
             test = testSet,
             k = k,
             kernel = 'rectangular')
str(fit1)

#성능 평가
real <- testSet$grade
pred1 <- fit1$fitted.values
table(pred1,real)

library(caret)
confusionMatrix(data = pred1, reference = real, positive = 'best')

library(MLmetrics)
F1_Score(y_true = real,y_pred = pred1,positive = "best")

library(pROC)
prob1 <- fit1$prob[,2]
roc(response = real, predictor = prob1) %>% 
  plot(main = 'ROC curve', col = 'red', lty = 1)

auc(response = real, predictor = prob1)

#데이터 균형화
# install.packages('DMwR')
library(DMwR)
set.seed(seed = 1234)
trainBal <- SMOTE(form = grade~.,
                  data = trainSet,
                  perc.over = 200,
                  k = 5,
                  perc.under = 150)
trainBal$grade %>% table() %>% prop.table() %>% round(digits = 4L)*100

#trainSet과 trainBal의 목표변수 레벨이 같은 순서인지 확인
levels(x = trainSet$grade)
levels(x = trainBal$grade)

#다시 KNN 시행
fit2 <- kknn(formula = grade~.,
             train = trainBal,
             test = testSet,
             k = k,
             kernel = 'rectangular')

pred2 <- fit2$fitted.values
table(pred2, real)
confusionMatrix(data = pred2, reference = real, positive = 'best')

prob2 <- fit2$prob[,2]

roc(response = real,predictor = prob2) %>% 
  plot(col = 'blue', lty = 1, add = TRUE)

auc(response = real,predictor = prob1)
auc(response = real,predictor = prob2)

#가중치 있는 모형

fit3 <- kknn(formula = grade~.,
             train = trainBal,
             test = testSet,
             k = k,
             kernel = 'triangular')

pred3 <- fit3$fitted.values
confusionMatrix(data = pred3, reference = real, positive = 'best')

prob3 <- fit3$prob[,2]
roc(response = real, predictor = prob3) %>% 
  plot(col = 'purple', lty = 2, lwd = 2, add=TRUE)

auc(response = real, predictor = prob1)
auc(response = real, predictor = prob2)
auc(response = real, predictor = prob3)