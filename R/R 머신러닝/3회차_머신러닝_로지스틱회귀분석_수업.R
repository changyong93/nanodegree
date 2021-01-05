#map, map_df, apply, lapply, sapply 사용 예 공부하기
#for loop를 대신 사용하는데 단결하고 사용하기 좋음

library(tidyverse)
url <- 'https://bit.ly/university_admit'
guess_encoding(file = url)
#ASCII 사용 확률 100%, confidence가 가장 높은 것으로 인코딩 되어 있음
#guess_encoding(file = 'https://www.naver.com')
#guess_encoding(file = 'https://finance.naver.com')

df <- read.csv(file = url)

#str() 함수를 실행하는 이유
# 컬럼별 벡터 자료형을 확인하기 위함!
str(object = df)
#admit과 rank는 명복형 factor로 변경해야 함

head(x = df, n = 10L) #L자는 정수변수로 만들어 주는 것, 생략해도 됨

#summary() 함수를 실행하는 이유
# 컬럼별 기술 통계량 빠르게 확인하기 위함
summary(object = df)

#연속형 데이터를 범주형 데이터로 변경
vars <- c('admit','rank') # orr vars <- c(1,4)
df[,vars] <- map_df(.x=df[vars], .f=as.factor)
map_df(.x=df[vars], .f=as.factor)
summary(object = df)

prop.table(x = table(df$admit))*100
df$admit %>% table() %>% prop.table()*100
#기본 전처리 완료----------------------

#eda
#gre
#boxplot formula = y~x
boxplot(formula = gre~admit,
        data=df,
        col = 'white',
        pch=19,
        outcol='red')

avg <- df %>% group_by(admit) %>% summarise(m = mean(x = gre))
#평균을 포인트로 생성
points(formula = m ~  admit,
       data = avg,
       pch = 19,
       col = 'blue',
       cex = 1.2)

#t-test 시 연속형 숫자는 정규분포여야 함
by(data = df$gre, INDICES = df$admit, FUN = shapiro.test)
#정규성 만족하지 않으므로 wilcox.test
wilcox.test(formula = gre~admit, data = df)
#귀무x => 대립 채택, 평균값의 차이가 있다.

#gpa
boxplot(formula = gpa~admit,
        data=df,
        col = 'white',
        pch=19,
        outcol='red')

avg <- df %>% group_by(admit) %>% summarise(m = mean(x = gpa))
#평균을 포인트로 생성
points(formula = m ~  admit,
       data = avg,
       pch = 19,
       col = 'blue',
       cex = 1.2)

by(data = df$gpa, INDICES = df$admit, FUN = shapiro.test)
wilcox.test(formula = gpa~admit, data = df)
#귀무 기각 => 두 집단의 중심에 대한 이동이 0이라고 하는 가설이 기각이므로 집단간 차이가 있다

#rank, admit = 범주형 => 카이제곡ㅂ검정 => 교차테이블 출력
library(gmodels)
CrossTable(x = df$rank, y = df$admit)
chisq.test(x = df$rank, y = df$admit)
#두 변수간 관계가 없다는 귀무가설이 기각이므로, 변수간 관계가 있다.

n <- nrow(x=df)
set.seed(seed = 1234)
index <- sample(x = n, size = n*0.7, replace = FALSE)
trainSet <- df %>% slice(index)
testSet <- df %>% slice(-index)

trainSet$admit %>% table() %>% prop.table()*100
testSet$admit %>% table() %>% prop.table()*100

fit1 <- glm(formula = admit ~.,
            data = trainSet,
            family = binomial(link = 'logit'))
summary(fit1)
#Null Deviance 입력변수가 하나도 사용되지 않는 이탈도
#Residual Deviance 입력변수가 사용됐을 경우의 이탈도, 이탈도=멍청한 정도
#회귀모형의 계수에 대해서 유의성 검증 결과 별이 있으면 0이 아니기에 통과
#0이 없을 경우 deviance로 유의성을 검증
#gre = 베타가 0이라고 하는 귀무가설 채택 => 현재는 기각을 못하지만 데이터셋을 늘릴 경우 대립 채택될 수 있음
#rank2,3,4는 더미변수

fit1$coefficient %>% exp() %>% round(digits = 4L)

#install.packages('reghelper')
library(reghelper)
beta.z <- beta(model = fit1)
beta.z$coefficients[,1] %>% round(digits = 4L)

real <- testSet$admit
print(x= real)

prob1 <- predict(object = fit1, newdata = testSet, type = 'response')
print(x = prob1)

pred1 <- ifelse(test = prob1>=0.5, yes = 1, no = 0) %>%  as.factor()
print(x = pred1)

#install.packages('caret')
#install.packages('e1071')
library(caret)
confusionMatrix(data = pred1, reference = real, positive = '1')

# install.packages('MLmetrics')
library(MLmetrics)
F1_Score(y_true = real, y_pred = pred1, positive = '1')

#install.packages('pROC')
library(pROC)
roc(response = real, predictor = prob1) %>% 
  plot(main = 'ROC Curve', col = 'red', lty = 1)

roc(response = real, predictor = as.numeric(x = pred1)) %>% 
  plot(col = 'blue', lty = 3, lwd = 3, add = TRUE)

auc(response = real, predictor = prob1)