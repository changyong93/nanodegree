library(tidyverse)
#1강 자료 데이터 표준화
setwd(dir =  'C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/R/R-machineLearning/데이터')
file_name <- list.files()

#RDS 파일 불러오기
cust <- readRDS(file_name)

#데이터 구조 확인
str(cust)
summary(cust)

#거리 확인
dist(x = cust, method = 'euclidean')

#데이터 표준화
scaled <- scale(x = cust)
summary(object = scaled)
apply(X = scaled, MARGIN = 2, FUN = sd)

#표준화 데이터 거리 확인
dist(x = scaled)

#실습 데이터 표준화 및 정규화
set.seed(seed = 1234)
heights <- rnorm(n = 10000, mean = 172.4, sd = 5.7)

#데이터 표준화
#그냥 scale 시 mean=0, sd=1인 표준 정규분포로 표준화
scaled1 <- scale(x = heights)
mean(x = scaled1)
sd(x = scaled1)
range(scaled1)
#정규화(= 최소-최대 정규화)
#최소가0, 최대가1인 값으로 표준화
Min <- min(heights)
Max <- max(heights)
scaled2 <- scale(x = heights, center = Min, scale = Max - Min)

mean(x = scaled2)
sd(x = scaled2)
range(scaled2)

#자체실습 : iris 데이터로 데이터 표준화 해보기
data(iris)
#setosa 종 제외하고 진행해볼 것
str(iris$Sepal.Length)
summary(iris$Sepal.Length)
dist(x = iris$Sepal.Length)

scale_sl <- scale(x = iris$Sepal.Length)
mean(x = iris$Sepal.Length)
sd(x = iris$Sepal.Length)
range(scale_sl)

mi <- min(iris$Sepal.Length)
ma <- max(iris$Sepal.Length)
scale_sl_mm <- scale(x = iris$Sepal.Length, center = mi, scale = ma - mi )

mean(x = scale_sl_mm)
sd(x = scale_sl_mm)
range(scale_sl_mm)

#knn 실습
url <- 'https://bit.ly/white_wine_quality'
guess_encoding(file = url)
df <- read.csv(url, sep = ';')
str(object = df)
summary(object = df)
head(x = df, n = 10L)

#목표변수 설정 및 컬럼 빈도수 확인
tbl <- table(x = df$quality)
tbl %>% prop.table() %>% cumsum() %>% round(digits = 4L)
#누적비율로 보아 8,9는 비율이 매우 작으니 7,8,9를 best 나머진 good
#R 기본 함수로 그리기
bp <- barplot(height = tbl,
              ylim = c(0,2400),
              xlab = 'Quality Score',
              main = 'White Wine Quality')
text(x = bp, labels = tbl, y = tbl, pos = 3, font = 2)

#ggplot으로 그리기
data.frame(tbl) %>% 
  ggplot(aes(x = x, y=Freq, fill = x))+
  geom_bar(stat = 'identity')+
  geom_text(mapping = aes(label = Freq, y=Freq),size = 3)

df$grade <- ifelse(test = df$quality>=7,yes = 'best',no = 'good')
df$grade <- factor(df$grade, levels = c("good","best"))
df$grade %>% table() %>% prop.table %>% round(digits = 4L)*100
df$quality <- NULL

boxplot(formula = alcohol~grade, data = df, col = 'white',
        outcol = 'red', pch=19)
df %>% 
  select(grade, alcohol) %>% 
  ggplot(aes(x = grade, y=alcohol, fill = grade))+
  geom_boxplot(outlier.color = 'red',outlier.shape = 19, outlier.size = 2)+
  theme(legend.position = 'none')

#trainset과 testset 만들기
n <- nrow(df)
set.seed(seed = 1234)
index <- sample(x = n, size = n*0.7, replace = F)

trainset <- df %>% slice(index)
testset <- df %>% slice(index)
trainset$grade %>% table() %>% prop.table() %>% round(digits=4L)*100
testset$grade %>% table() %>% prop.table() %>% round(digits=4L)*100

#가중치 선정
k <- trainset %>% 
  nrow() %>% 
  sqrt() %>% 
  ceiling()

#knn 실행
library(kknn)
fit1 <- kknn(formula = grade~.,
             train = trainset,
             test = testset,
             k = k,
             kernel = 'rectangular')
str(object = fit1)
real <- testset$grade
pred1 <- fit1$fitted.values
prob1 <- fit1$prob[,2]
table(pred1,real)

#혼동행렬 구해보기
library(caret)
confusionMatrix(data = pred1, reference = real, positive = 'best')
library(MLmetrics)
F1_Score(y_true = real,y_pred = pred1, positive = 'best')

library(pROC)
roc(response = real, predictor = prob1) %>% 
  plot(main = "roc curve", col = 'red', lty = 1)
auc(response = real, predictor = prob1)

#불균형 데이터 균형화
library(DMwR)
set.seed(seed = 1234)
trainbal <- SMOTE(form = grade~.,
                  data = trainset,
                  perc.over = 200,
                  k = 5,
                  perc.under = 150)

#데이터의 목표변수가 같은지 확인
trainbal$grade %>% table() %>% prop.table() %>% round(digits = 4L)*100
levels(x = trainset$grade)
levels(x = trainbal$grade)

#균형화 데이터로 모델 재적합
fit2 <- kknn(formula = grade~.,
             train = trainbal,
             test = testset,
             k = k,
             kernel = 'rectangular')
real <- testset$grade
prob2 <- fit2$prob[,2]
pred2 <- fit2$fitted.values

table(pred1, real)
table(pred2, real)

confusionMatrix(data = pred1, reference = real, positive = 'best')
confusionMatrix(data = pred2, reference = real, positive = 'best')

F1_Score(y_true = real,y_pred = pred1,positive = 'best')
F1_Score(y_true = real,y_pred = pred2,positive = 'best')

roc(response = real ,predictor = prob2) %>% 
  plot(main = 'roc curve', col = 'blue', lty = 2, add=T)

#균형데이터, 가중치 적용
fit3 <- kknn(formula = grade~.,
             train=trainbal,
             test = testset,
             k = k,
             kernel = 'triangular')
str(fit3)
prob3 <- fit3$prob[,2]
pred3 <- fit3$fitted.values

table(pred1,real)
table(pred2,real)
table(pred3,real)

confusionMatrix(data = pred3, reference = real, positive = 'best')
F1_Score(y_true = real,y_pred = pred3,positive = 'best')

roc(response = real, predictor = prob3) %>% 
  plot(main = 'roc curve', col = 'black', lty = 3, add= T)
auc(response = real, predictor = prob3)


#mcc 값이 높은 k 값 찾기
n <- nrow(trainbal)
i <- 3
loop_num <- ifelse(test = n%%2==0, yes =  n-1,no = n)
k_value <- c() ; mcc_value <- c() ; f1_score_value <- c()
TPR_value <- c() ; FPR_value <- c(); prec_value <- c()
for(i in seq(from = 3, to = loop_num, by = 2)){
  fit <- kknn(formula = grade~.,
              train = trainbal,
              test = testset,
              k = i,
              kernel = 'triangular')
  real <- testset$grade
  prob <- fit$prob[,2]
  pred <- fit$fitted.values
  f1 <- F1_Score(y_true = real,y_pred = pred,positive = 'best')
  conf <- confusionMatrix(data = pred, reference = real, positive = 'best')
  MCC <- mcc(conf)
  k_value <- c(k_value,i)
  TPR_value <- c(TPR_value,conf$byClass[1])
  FPR_value <- c(FPR_value,(1-conf$byClass[2]))
  prec_value <- c(prec_value,conf$byClass[5])
  mcc_value <- c(mcc_value,MCC)
  f1_score_value <- c(f1_score_value,f1)
  cat(round(i*100/loop_num,digits = 2L),"% 완료 \n")
}

final <- data.frame(k=k_value, TPR = TPR_value, FPR = FPR_value, prec = prec_value, mcc = mcc_value, f1 = f1_score_value)
round(x = final, digits = 4L)


mcc <- function(confusionmatrix){
  TP <- as.numeric(confusionmatrix$table[4])
  FP <- as.numeric(confusionmatrix$table[2])
  FN <- as.numeric(confusionmatrix$table[3])
  TN <- as.numeric(confusionmatrix$table[1])
  mcc <- ((TP*TN)-(FP*FN)) / sqrt((TP+FP)*(FP+TN)*(TN+FN)*(FN+TP))
  return(mcc)
}