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

#나무모형 시각화
# install.packages("rpart.plot")
library(rpart.plot)
rpart.plot(x = fit,
           type = 2,
           extra = 101,
           fallen.leaves = F)