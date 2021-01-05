library(tidyverse)
getwd()

#절대경로
setwd(dir = 'C:/Users/ChangYong/Documents') #처음부터 경로 지정

#상대경로
setwd(dir = './R') #현재 위치를 . 이하로 인식하고, .이하 이후 경로 지정

#현재 작업 경로의 파일 리스트 확인
list.files() #전체 파일 리스트 확인
list.files(pattern = 'csv') #특정 패턴이 포함된 리스트 확인, 대소문자 구분

#data 불러오기
df <- read.csv(file = 'https://bit.ly/used_cars_price')

#객체 structure 확인
str(df)
#price : 중고차 가격
#Age : 연식(개월수)
#KM : 주행거리
#fuelType : 연료 형태(diesel, petrol(가솔린), CNG(가스)) -> 범주형
#CNG 제외
#HP : 마력 <= 120
#Metcolor : 금속 컬러 -> 범주형
#Automatic : 자동 수동 -> 범주형
#CC : 엔진 크기 
#Doors : 문 개수 >= 3
#Weight : 차량 무게 <= 1200

#데이터 분석 전 EDA를 해야 함
#1. 목표변수인 Price가 정규분포인지 확인
#2. 입력변수와 연속변수 관계 확인=> 피어슨 관계분석, T테스트

#강사님이 교육 전 EDA를 통해 데이터 1차 가공
df <- df %>% 
  filter(HP<=120 & Weight <=1200 & Doors>=3)

#피어슨 상관성 분석 통과 못함
df <- df %>% select(-CC)


#CNG 개수가 작아서 이걸론 모델을 만들지 못하므로 제외
table(df$FuelType)
df <- df %>% 
  filter(FuelType %in% c('Diesel','Petrol')) %>% 
  # filter(!FuelType %in% c('CNG')) %>%  ! FuelType %in% 하면 %in%에 속한 변수값이 아닌 값 출력
  mutate(FuelType = factor(x = FuelType),
         Automatic= factor(x = Automatic),
         MetColor = factor(x = MetColor))

str(object = df) #최종 객체 형태 확인
summary(object=df) #요약 데이터
                   #숫자=>기술통계량, 범주=>빈도수

#정규분포 확인하는 방법
shapiro.test(x = df$Price)
#가설검정 : 연구자, 분석가가 주장하는것
# with 증거(숫자)=>검정통계량 =>
# 우리가 알고있는 분포상에서 얼마나 희박한지 => 유의확률

n <- nrow(x = df)
print(x = n)

set.seed(seed = 1234)
index <- sample(x = n, size = n*0.7, replace = FALSE)
print(x = index)

trainSet <- df %>% slice(index)
testSet <- df %>% slice(-index)

mean(x = trainSet$Price)
mean(x = testSet$Price)

fit <- lm(formula = Price ~ Age, data = trainSet)
summary(object = fit)
windows()
par(mfrow = c(2,2))# plot창의 환경을 설정해주는 함수
plot(x = fit)
par(mfrow = c(1,1))
hist(x = fit$residuals)
shapiro.test(x = fit$residuals)

# install.packages('car')
library(car)
ncvTest(model = fit)
durbinWatsonTest(model = fit)
crPlots(model = fit)
influencePlot(model = fit)

real <- testSet$Price
print(x = real)
pred1 <- predict(object = fit, newdata = testSet)
print(x = pred1)

library(MLmetrics)
MSE(y_pred = pred1,y_true = real)
RMSE(y_pred = pred1,y_true = real)
MAE(y_pred = pred1,y_true = real)
MAPE(y_pred = pred1,y_true = real)

full <- lm(formula = Price~., data = trainSet)
null <- lm(formula = Price~1, data = trainSet)
fit2 <- step(object = null,
             scope = list(lower = null, upper = full),
             direction = 'both')

summary(object = fit2)
vif(mod = fit2)

library(reghelper)
beta.z <- beta(mode = fit2)
round(x = beta.z$coefficients[,1], digits = 4L)

pred2 <- predict(object = fit2, newdata = testSet, type = 'response')
RMSE(y_pred = pred1, y_true = real)
RMSE(y_pred = pred2, y_true = real)

regMeasure(real = real, pred = pred1)