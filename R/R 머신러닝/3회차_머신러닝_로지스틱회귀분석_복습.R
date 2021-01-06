#for loop를 대신 사용할 수 있어서 간격하고 빠르므로 사용하기 좋음
#데이터 핸들링 능력 강화
#apply, lapply, sapply, map, map_df

library(tidyverse)
url <- 'https://bit.ly/university_admit'
guess_encoding(file = url) # 해당 파일은 어떤 인코딩 방식으로 작성되어 있는지 확인
df <- read.csv(file = url)

#데이터 구조 확인
#str() : 컬럼벅 벡터 자료형을 학윈하기 위함
#summary() : 컬럼별 기술통계량을 빠르게 확인하기 위함
str(object = df)
head(x= df, n = 10L)
summary(object = df)

#목표변수 비율 확인
df$admit %>% table() %>% prop.table()*100

#데이터 전처리, admit과 rank를 범주형으로 변환
vars <- c('admit', 'rank')
df[,vars] <- map_df(.x = df[,vars],.f = as.factor)
str(object = df)
summary(object = df)
#각 입력변수별 목표변수와 상관성이 있는지 확인
boxplot(formula = gre~admit,
        data = df,
        col = 'white',
        pch = 19,
        outcol = 'blue')

avg <- df %>%
  group_by(admit) %>%
  summarise(m = mean(x = gre))

points(x = avg$admit,
       y = avg$m,
       pch = 19,
       col = 'red',
       cex = 1.2)

#두 집단(합격/불합격) 간 'gre'의 평균이 같은지 확인
#연속형 숫자는 정규분포를 가져야 하므로 정규성 검정 시행
by(data = df$gre, INDICES = df$admit, FUN = shapiro.test)
tapply(X = df$gre,INDEX = df$admit,FUN = shapiro.test)
#0.05 이하이므로 두 그룹은 정규성 X

#정규성을 만족하지 않으므로 t.test(모수적 방법) 불가
#비 모수적 방법인 wilcox.test 시행

#gpa도 동일 방식으로 진행해보기
boxplot(formula = gpa~admit,
        data = df,
        col = 'white',
        pch = 19,
        outcol = 'blue')
avg <- df %>% group_by(admit) %>% dplyr::summarise(m = mean(x = gpa))
points(formula = m~admit,
       data = avg,
       pch = 19,
       col = 'red',
       cex = 1.5)

by(data = df$gpa,INDICES = df$admit, FUN = shapiro.test)
tapply(X = df$gpa, INDEX = df$admit, FUN = shapiro.test)
wilcox.test(formula = gpa~admit, data = df)
wilcox.test(formula = gre~admit, data=df)

#rank는 범주형이므로 목표변수와 카이제곱 검정 진행
library(gmodels)
CrossTable(x= df$rank, y=df$admit, chisq = T)
chisq.test(x= df$rank, y=df$admit)
#rank=2의 카이제곱 값을 보면 0에 가까우므로
#전체 평균과 유사
#그 다음 행별 합/불 확률을 보면 rank가 낮아질수록 낮아짐
#즉 rank와 합불 여부는 관련이 있다
#chisq.test 혹은 crosstable(chisq=t)로 보면
#p-value는 0.05 미만이므로 두 변수간 독립이 아니다.
#즉 귀무 기각으로 두 변수는 관련이 있다.

#분석 데이터셋 분할
n <-  nrow(df)
set.seed(seed = 1234)
index <- sample(x = n, size = n*0.7, replace = FALSE)
trainSet <- df %>% slice(index)
testSet <- df %>% slice(-index)

trainSet$admit %>% table() %>% prop.table()*100
testSet$admit %>% table() %>% prop.table()*100

#로지스틱 회귀 분석 함수 모델 생성
fit1 <- glm(formula = admit ~ .,
            data = trainSet,
            family = binomial(link = 'logit'))
summary(fit1)
#모형 유의성 검정
devGap <- fit1$null.deviance-fit1$deviance
print(x = devGap)
dfGap <- fit1$df.null - fit1$df.residual
print(x = dfGap)
pchisq(q = devGap, df = dfGap, lower.tail = FALSE)

#입력변수의 오즈비 계산
fit1$coefficients %>% exp() %>% round(digits = 4L)
#단 값의 스케일이 다르므로, 표준화회귀계수를 구하기 전까진
#어떤 계수가 더 중요한지는 모름

library(reghelper)
beta.z <- beta(model = fit1)
beta.z$coefficients[,1] %>% round(digits=4L)

#목표변수의 추정확률 생성
#-시험셋의 실제값 real에 할당
real <- testSet$admit
prob1 <- predict(object = fit1, newdata = testSet, type = 'response')
pred1 <- ifelse(test = prob1 >=0.5, yes = 1, no = 0) %>% as.factor()
print(x = pred1)

#분류모형 성능 평가=>민감도,정밀도,1-특이도
library(caret)
confusionMatrix(data = pred1, reference = real, positive = "1")

#분류모형 성능 평가=>F1-점수
library(MLmetrics)
F1_Score(y_true = real,
         y_pred = pred1,
         positive = '1')

library(pROC)
roc(response = real, predictor = prob1) %>% 
  plot(main = 'ROC curve', col = 'red', lty = 1)
# roc(response = real, predictor = as.numeric(x = pred1)) %>% 
#   plot(main = 'ROC curve', col = 'blue', lty = 2,lwd = 2,add=TRUE)
#추정라벨은 0과1로 되어있어서 한 점 사이를 찍고끝이므로, roc곡선은 반드시 추정 확률을 기입

auc(response = real, predictor = prob1)
i <- 0.2
for(i in seq(0.2,0.8,0.01)){
  pred1 <- ifelse(test = prob1 >=i, yes = 1, no = 0) %>% as.factor()
  conf <- confusionMatrix(data = pred1, reference = real, positive = "1")
  print(x = conf$byClass[c(1,2,3)])
  cat(i,"_",F1_Score(y_true = real, y_pred = pred1, positive = '1'),"\n")
}
