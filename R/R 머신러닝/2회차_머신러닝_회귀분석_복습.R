# install.packages('tidyverse')
library(tidyverse)
#유용한 패키지를 모아놓은 종합 패키지
#ggplot2, tibble, purrr, dplyr, tidyr, readr, stringr, forcats 

getwd() #현재 경로 확인

#경로지정=> 절대경로, 상대경로

setwd('./R') #현재 경로에서부터 경로 재지정(상대경로)
set('C:/Users/ChangYong/Documents/R') #모든 경로 재작성(절대경로)

#현재 경로의 파일 리스트 확인
list.files() #모든 파일 확인
list.files(pattern = '.csv') #파일명에 '.csv'라는 문자가 포함된 파일 확인

#강의 data 불러오기
df <- read.csv(file = 'https://bit.ly/used_cars_price')

#데이터 구조 확인
str(object = df)
summary(object = df)

#EDA
#1. 목표변수인 Price가 정규분포인지 확인
#2. 입력변수와 연속변수 관계 확인=> 피어슨 관계분석, T테스트

#강사님이 교육 전 EDA를 하여 데이터 1차 가공 방법 판단하심
df <- df %>% filter(HP<=120 & Weight <=1200 & Doors>=3)

#피어슨 상관성 분석 통과 못함
df <- df %>% select(-CC)
#FuelType에서 CNG 개수가 작아 모델을 생성하지 못하므로 제외
#연속형 데이터 중 범주형 데이터인 것을 변환
df <- df %>% 
  filter(!FuelType %in% c('CNG')) %>% 
  mutate(FuelType = factor(x = FuelType),
         Automatic= factor(x = Automatic),
         MetColor = factor(x = MetColor))

#전체 데이터에서 70%는 trainset으로 나머지 30%는 testset으로 분리
n <- nrow(x = df)
set.seed(seed = 1234)
index <- sample(x = n, size = n*0.7, replace = FALSE)
trainSet <- df %>% slice(index)
testSet <- df %>% slice(-index)
#평균 비교를 통해 자료가 유사한 지 확인
mean(x = trainSet$Price)
mean(x = testSet$Price)

#선형 회귀 => lm(formula = y(목표변수)~x(입력변수), data = dataset)
lm(formula = Price ~ 1, data = trainSet) #입력변수 없음
lm(formula = Price ~ Age, data = trainSet) #입력변수 : Age
lm(formula = Price ~ Age+KM, data = trainSet) #입력변수 2개
lm(formula = Price ~ ., data = trainSet) #입력변수 : 목표변수를 제외한 모든 컬럼

#단순 선형 회귀모형 적합 및 결과 확인
fit1 <- lm(formula = Price~Age, data = trainSet)
summary(fit1)
#모델 유의성 검정 시 모델은 p-value<0.05로 귀무가설 기각,
#즉, 회귀계수 beta중 최소 1개 이상은 0이 아님
#입력변수가 1개이므로, 회귀계수는 1개고, Age에 대한 회귀계수도 p-value<0.05이므로 0이 아님
#결정계수 R은 0.7761로 이 모델은 적합도가 좋은 모형임임

#선형회귀 결과 그래프로 잔차가정 확인
windows()
par(mfrow = c(2,2))
plot(x = fit1)
par(mfrow = c(1,1))

#잔차의 정규성 검정
hist(x = fit1$residuals, freq = FALSE) #분포의 좌&우측 끝이 올라온 걸로 보임, 정규성X / freq = 빈도인지 여부
shapiro.test(x = fit1$residuals) #p-value < 0.05 이므로 정규성x

#잔차 등분산성 검정
#install.packages('car)
library(car)
car::ncvTest(model = fit1) #p-value < 0.05 이므로, 귀무 기각 => 등분산 X

#잔차 독립성 검정
car::durbinWatsonTest(model = fit1) # p-value >=0.05 이므로, 귀무 기각X => 독립

#잔차 패턴 확인
car::crPlots(model = fit1) #입력변수에 따라 실선이 점선 위/아래에 있는데, 그래프를 따로 그려야 할 정도로 결과가 나쁨
                           #이럴 경우, 2차항을 추가하는 등의 방법을 고안해야 함

#이상치 확인
car::influencePlot(model = fit1) #cook's distance가 1 이상인 이상치가 없음

#잔차 이상 패턴으로 2차항 추가
fit2 <- lm(formula = Price ~ Age+I(x = Age^2), data = trainSet)

summary(fit1)
summary(fit2)

crPlots(model = fit1)
crPlots(model = fit2)

#두 입력변수가 상관관계가 있을 경우, 다중공산성 문제 발생하여 회귀계수가 이상한 값이 구해짐
#이를 판단하기 위해 분산팽창지수를 보는데, 이 부분은 3장에서 강의 예정
vif(mod = fit2)

#목표변수의 추정값 생성
real <- testSet$Price
print(x=real)
#시험셋으로 목표변수의 추정값 생성
pred1 <- predict(object = fit1, newdata = testSet, type='response')#type='response'는 선형회귀에선 생략 가능, 로지스틱에선 불가
print(x=pred1)

#성능확인, 성능평가지표 4가지 MSE, RMSE, MAE, MAPE
# install.packages('MLmetrics')
library(MLmetrics)
MSE(y_pred = pred1, y_true = real)
RMSE(y_pred = pred1, y_true = real)
MAE(y_pred = pred1, y_true = real)
MAPE(y_pred = pred1, y_true = real)

#성능변환 함수를 만들어서 사용하면 유용함
#해당 함수가 기입된 script 파일을 저장하면 000.R 파일이 생성되는데,
#source('000.R')하면 함수가 불러와지고, regMeasure(변수1,변수2) 넣으면 사용 가능
regMeasure <- function(pred,real){
  library(MLmetrics)
  return(data.frame(MSE = MSE(y_pred = pred, y_true = real),
                    RMSE = RMSE(y_pred = pred, y_true = real),
                    MAE = MAE(y_pred = pred, y_true = real),
                    MAPE = MAPE(y_pred = pred, y_true = real)))
}
regMeasure(pred1, real)
null <- lm(formula = Price ~ 1, data = trainSet)
full <- lm(formula = Price ~ ., data = trainSet)
fit2 <- step(object = null,
             scope = list(lower = null, upper = full),
             direction = 'both')

summary(object = fit2)
vif(mod = fit2)

pred2 <- predict(object = fit2, newdata = testSet, type = 'response')

regMeasure(real, pred1)
regMeasure(real, pred2)
