rm(list = ls())
library(tidyverse)
#파일 불러오기
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터")
load("dataset_set.rda")

#입력변수 설정
#최종 입력변수
#확정 : 매출_월화수목,매출_금토일,매출_0614,매출_1421,매출_2106,대분류
#비교 : 중분류,년도, 분기,행정구역,년분기
colnames(trainset)
vars_full <- c(6,7,8,9,10,11,4,5,1,2,3,24)
vars_selected <- c(6,7,8,9,10,11,4)
trainset_full <- trainset[,vars_full]
trainset_selected <- trainset[,vars_selected]

#다중선형회귀분석 모델
#Multiple Linear Regression Model

#모델 적합
fit_full <- lm(formula = 매출총액~.,data = trainset_full) #목표변수와 상관관계 있는 입력변수와 보류인 입력변수
trainset_full_new <- trainset_full %>% select(-c(년분기,중분류))

fit_full_new <- lm(formula = 매출총액~.,data = trainset_full_new)
fit_selected <- lm(formula = 매출총액~.,data = trainset_selected) #목표변수와 상관관계가 있는 입력변수
null <- lm(formula = 매출총액~1.,data = trainset_full)
full <- lm(formula = 매출총액~.,data = trainset_full)
fit_stepwise <- step(object = null,
             scope = list(lower = null, upper = full),
             direction = "both") #stepwise를 통한 단계적 변수 선택

summary(fit_full)
#년분기는 NA 생성, 중분류 중 종합소매 및 주점업 NA 생성
#매출_1421, 행정구 25구 중 8구, 분기2,3은 p-value = 0.05이상
#모델에서 제외
summary(fit_full_new)
summary(fit_selected)
#대분류 외식업이 p-value 0.05 이상으로 유의성이 없다고 판단되지만 일단 진행해봄
summary(fit_stepwise)
#행정구역 일부,년분기 대부분이 p-value 0.05 이상으로 유의성이 없다고 판단
#단 일단 진행

#다중공산성 문제 확인
library(car)
vif(mod = fit_full_new) # GVIF^(1/(2*Df)) > 2 => 매출_월화수목/금토일/0614/1421
vif(mod = fit_selected) # GVIF^(1/(2*Df)) > 2 => 매출_월화수목/금토일/0614/1421
vif(mod = fit_stepwise)# GVIF^(1/(2*Df)) > 2 => 매출_월화수목/금토일/0614/1421

#다중공산성를 발생시키는 인자 중 가장 영향이 큰 매출_월화수목 제외
trainset_full_new <- trainset_full_new %>% select(-c(매출_1421,매출_월화수목))
trainset_selected <-  trainset_selected %>% select(-c(매출_1421,매출_월화수목))
trainset_full <- trainset_full %>% select(-c(매출_1421,매출_금토일,매출_0614))
fit_full_new_af <- lm(formula = 매출총액~., data = trainset_full_new)
fit_selected_af <- lm(formula = 매출총액~., data = trainset_selected)
null <- lm(formula = 매출총액~1, data = trainset_full)
full <- lm(formula = 매출총액~., data = trainset_full)
fit_stepwise_af <- step(object = null,scope = list(lower = null, upper = full),direction = "both")

#결과재확인
summary(object = fit_full_new_af)
summary(object = fit_selected_af)
summary(object = fit_stepwise_af)

#다중공산성 문제 확인
vif(mod = fit_full_new_af)
vif(mod = fit_selected_af)
vif(mod = fit_stepwise_af)

#변수 소거 전후 모델 비교평가
anova(fit_full_new, fit_full_new_af) # p-value 0.05 이하로 변수소거 전후 성능 차이 있음을 확인
anova(fit_selected, fit_selected_af) # p-value 0.05 이하로 변수소거 전후 성능 차이 있음을 확인
anova(fit_stepwise, fit_stepwise_af) # p-value 0.05 이하로 변수소거 전후 성능 차이 있음을 확인

#잔차가정 검정 bonferroni p 0.05이하 제거
fit_full_new_af <- outliers(trainset_full_new,0)
fit_selected_af <- outliers(trainset_selected,0)
fit_stepwise_af <- outliers(trainset_full,1)

#잔차 패턴 확인
windows()
par(mfrow = c(2,2))
plot(x = fit_stepwise_af)
par(mfrow = c(1,1))

#잔차가정 검정
library(car)
ncvTest(model = fit_stepwise_af) 
durbinWatsonTest(model = fit_stepwise_af) 
crPlots(model = fit_selected_af)
influencePlot(model = fit_stepwise_af)
# fit_full_new_af - 애매하거나 확실한 입력변수 기준
# fit_selected_af - 확실한 입력변수 기준
# fit_stepwise_af - 전체 데이터(확정변수+비교용변수)에서 변수소거법 적용

# 다중공산성 문제를 일으키는 인자 제거
# 이상치 제거 => bonfferoni p 0.05 이하인 index 제거

# 최종 확인결과, 세 경우 모두 잔차의 목표변수가 정규성을 위배하여 이후 순서 진행불가

#######
library(olsrr)
olsrr::ols_plot_cooksd_bar(model = fit_t) #cook 거리 바플랏
                                          #해당 관측값이 전체 최소제곱추정량에 미치는 영향력을 보여주는 지표
ols_plot_dfbetas(model = fit_t) #해당 관측치의 개별 베타 값에 대한 영향력 지표
ols_plot_dffits(model = fit_t) #베타값의 분상 공분상 행렬의 Cov(b^) 추정값에 대한 해당 관측치에 대한 영향력

#5000개 이상 데이터 정규성 확인 => 앤더슨 달링 테스트
library(nortest)
ad.test(fit_t2$residuals)


#-------------------------------------------------------------------------------------------------------
#회귀나무로 모델 만들기
rm(list = ls())
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터")
load("dataset_set.rda")
function_path = "C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/코드/"
source(file = paste0(function_path,"function.r"))
library(tidyverse)
library(rpart)
library(rpart.plot)
library(MLmetrics)

#최종 입력변수
#확정 : 매출_월화수목,매출_금토일,매출_0614,매출_1421,매출_2106,대분류
#비교 : 중분류,년도, 분기,행정구역,년분기
vars_full <- c(6,7,8,9,10,11,4,5,1,2,3,24)
vars_selected <- c(6,7,8,9,10,11,4)
trainset_full <- trainset[,vars_full]
trainset_selected <- trainset[,vars_selected]

#회귀나무 정지요인 설정
ctrl <- rpart.control(minsplit = 10L,
                      cp = 0.01,
                      maxdepth = 20L)

#회귀나무모델 적합
fit1 <- rpart(formula = 매출총액~.,
              data = trainset[,vars_selected],
              control = ctrl)

#결과 확인 및 가지치기 여부 확인
summary(object = fit1)
plotcp(x = fit1)
#가치치기 불필요 확인

#성능 분석
real <- testset$매출총액
pred1 <- predict(object = fit1, newdata = testset, type = "vector")

regMeasure(real = real, pred = pred1)

compare_result <- testset %>% select(년도,분기,행정구역,대분류,중분류,매출총액)
compare_result$매출총액_pred <- pred1
compare_result <- compare_result %>% group_by(년도,분기,행정구역,대분류) %>% 
  arrange(행정구역,대분류,desc(매출총액)) %>% 
  mutate(rank = as.factor(row_number(desc(매출총액))),
         rank_pred = as.factor(row_number(desc(매출총액_pred)))) %>% 
  filter(rank %in% c("1","2","3") | rank_pred %in% c("1","2","3"))

compare_result %>%
  ggplot(aes(x = rank_pred, y=rank, color = 행정구역), size = 3)+
  geom_point(position=position_jitter())
table(compare_result$rank==compare_result$rank_pred)
#-------------------------------------------------------------------------------------------------------
library(tidyverse)
library(tidymodels)
#library 불러오기
# library(randomForest)

trainset_dummy_split <- trainset_dummy %>% initial_split(prop=0.7)
  
trainset_dummy_recipe <- trainset_dummy_split%>% as.data.frame() %>% 
recipe(매출총액~점포수+매출_월화수목+매출_금토일+
               매출_0614+매출_1421+매출_2106+총_유동인구수+
               유동인구수_월화수목+유동인구수_금토일+유동인구수_0614+
               유동인구수_1421+유동인구수_2106+확진자수+생존률_1년차+
               생존률_3년차+생존률_5년차+숙박시설_수+지하철역_수) %>% 
  step_corr(all_predictors()) %>% 
  step_center(all_predictors(), -all_outcomes()) %>% 
  step_scale(all_predictors(),-all_outcomes()) %>% 
  prep()

trainset_dummy_testing <- trainset_dummy_recipe %>% bake(trainset_dummy_split %>% testing())
trainset_dummy_training <- trainset_dummy_recipe %>% juice()
trainset_rf <- rand_forest(trees = 100,mode = 'regression') %>% 
  set_engine('randomForest') %>% 
  fit(매출총액~점포수+매출_월화수목+매출_금토일+매출_0614+매출_1421+매출_2106+
            유동인구수_2106+확진자수+생존률_1년차+생존률_3년차+생존률_5년차+숙박시설_수+지하철역_수, data = trainset_dummy_training)

trainset_rf %>% predict(trainset_dummy_testing)
##https://kuduz.tistory.com/1202