##조건문
#if & else if #else - 하나의 data에 대한 조건문
#ifelse - 여러 데이터에 대한 조건문

x <- 1
y <- 2
if (x>y){
  "positive"
} else if (x<0){
  "negative"
} else{
  "zero"
}

x <- c(1,2,3,4)
y <- c(2,1,4,5)
ifelse(x>y, "positive",
       ifelse(x<y, "negetive", "zero"))


rm(list = ls())
# 문제 1
# a의 평균이 15이상이면 "평균이상" 아니면 "평균미만"으로 출력하시오
a <- seq(1,30,4)
if (mean(a)>=15){
  "평균이상"
} else{
  "평균미만"
}
ifelse((mean(a)>=15),"평균이상","평균이하")
# 문제 2
# if , else if , else를 사용해서 tmep 조건을 만드시오
# 0이하면 freezing, 10이하면 cold, 20이하면 cool, 30이하면 warm, 그외는 hot이 출력되게 하시오
temp <- 25
if (temp>=0){
  "freezing"
} else if (temp>=10){
  "cold"
} else if (temp>=20){
  "cool"
} else if (temp>=30){
  "warm"
} else {
  "hot"
}
# 문제 2_1
temp <-c(5,20,-6,37,24,13)
# 문제 2번의 값을 ifelse 로 바꿔서 값을 변경하시오
ifelse(temp<=0, "frezzing",
       ifelse(temp<=10,"cold",
              ifelse(temp<=20,"cool",
                     ifelse(temp<=30,"warm","hot"))))

# 문제 3
# - ifelse 를 사용해서 iris의 Sepal.Length가 6보다 크면 1 작으면 0 변수 생성하시오
# - new라는 변수 추가하고 new가 1인 Sepal.Width의 합을 구하시오
data(iris)
iris$new<- ifelse(iris$Sepal.Length>6,1,0)
sum(iris[iris$new==1,"Sepal.Width"])

#------------------------------------------------------------------------
# 루프
# 특정 조건에 부합할 경우
# 루프문 실행 for문 ,while 문
# 루프문 종료 repeat

#expand.grid : 모든 경우의 수를 펼쳐보는 함수
#코드 작성 전 데이터하기에 유용한 함수

##expand. grid 연습
rm(list = ls())
wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
prob <- c("DD" = 0.03, "7" = 0.03, "BBB" = 0.06, 
          "BB" = 0.1, "B" = 0.25, "C" = 0.01, "0" = 0.52)

#1번 문제

# wheel 과 같이 총 7개의 경우의 수가 있다.
# 각 확률은 prob와 같고 총 3번의 시도를 했을 경우에 0.001보다 높은 경우의 수 개수는?
# (3번 추출하며 각각 독립이다)
# (DD, BBB, 7) 과 (DD , 7 , BBB)는 다른 경우의 수다
test <- expand.grid(wheel,wheel,wheel)
for (i in 1:ncol(test)){
  test[,paste0("prob",i)] <- prob[test[,i]]
}
test$prob <- test$prob1 * test$prob2 * test$prob3
nrow(test[test$prob>0.001,])
#2번 문제
# 동전을 3번 던질 떄 확률은 0.3과 0.7이다
# 첫번째에 앞이나오고 그리고(&) 세번째에 뒤가 나올 확률을 구하시오
rm(list = ls())
coin <- c("앞","뒤")
prob <- c("앞" = 0.3, "뒤" = 0.7)
coins <- expand.grid(coin,coin,coin)
for (i in 1:ncol(coins) ){
  coins[,paste0("prob",i)] <- prob[coins[,i]]
}
coins$prob <- coins$prob1*coins$prob2*coins$prob3
sum(coins[coins$Var1=='앞' & coins$Var3=='뒤', 'prob'])


#####################################
#for문
#1번 문제
sum <- 0
# for문을 사용해서 1부터 100까지의 누적합을 구하시오
for (i in 1:100){
  sum <- sum+i
}
sum

#2번 문제
sum2 <- 0
sample(1:6,1)
# for문을 사용해서 위의 주사위 20번 던진 누적 합을 구하시오
for (i in 1:20){
  sum2 <- sum2 + sample(1:6,1)
}
sum2
#####################################

# for, while , repeat 문

#1번 문제 구구단 만들어보기
# 1단부터 9단까지 출력해보기

#ex)
# 2 4 6 8 10 12 14 16 18
# 3 6 9 12 ....
# .....
# 9 18 27 36 ....


#1_1 for문
#seq(값 , by = 차이, length.out = 길이)
for(i in 1:9){
  cat(i,"단 : ", seq(i,by = i,length.out = 9),"\n")
}
#1_2 while문
#while문
i <- 1
while(i < 10){
  cat(i,"단 : ", seq(i, by = i, length.out = 9),"\n")
  i <- i+1
}

#1_3 repeat문
i <- 1
repeat{
  cat(i,"단 : ", seq(i, by = i, length.out = 9), "\n")
  i <- i+1
  if(i >=10) break
}
#####################################
#함수생성
make_plus <- function(x,y){
  return(x+y)
}
make_plus(5,6)

#기본 값 지정
make_plus <- function(x,y=6){
  return(x+y)
}
make_plus(5,6)
make_plus(5)
#y input이 없을 경우 기본 값으로 계산
#가변인수
myf <- function(x,...){
  print(x)
  summary(...)
}
myf(10, 1:10)

#1 
# 성적을 입력했을경우 40점 이하는 "C", 70점 이하는 "B" 
# 71점 이상은 "A"를 출력하는 function을 만드시오
score <- function(x){
  if(x<=40){
    "C"
  } else if(x<=70){
    "B"
  } else {
    "A"
  }
}
score(71)
###########################
#apply 류
#데용량 처리에 특화
#for문 대비 월등한 연산 속도
#apply in : mat,array -> out : vector
#lapply in : 벡터, 리스트, 표현식 또는 데이터 프레임 -> out : list
  #do.call or unlist 등으로 리스트 변환하여 데이터 사용
#sapply in : 벡터, 리스트, 표현식 또는 데이터 프레임 -> out : vector, mat / simplify=T면 list
#tapply in : list, vector -> out : vector, array

#apply
apply(x, margin, func)
#x : input / margin : func 진행 방향(행1,열2) / func : 데이터 연산 방법

rm(list = ls())
d <- matrix(1:9, ncol = 3)
apply(d,1,sum) # 행 기준 연산
apply(d,2,sum) # 열 기준 연산
rowSums(d)
colSums(d)

#lapply
lapply(x, func,...)
#x : input / func : 데이터 연산 방법
result <- lapply(1:3, function(x){x^2})
unlist(result, use.names = T)

lapply(iris[,1:4],mean)
unlist(lapply(iris[,1:4],mean))
x <- list(data.frame(name="foo", value=1),data.frame(name="bar", value=2))
unlist(x)
do.call(rbind,x)
do.call(cbind,x)
#do.call & unlist은 list형태의 데이터를 입력해야 함

tapply(iris$Sepal.Length, iris$Species, sum)

############ apply 종류 연습
#문제 1
# iris에서 각 행바다(1~4열)의 분산 열을 추가하시오 (var)
apply(iris[,1:4],1,var)


#문제 2
# function을 활용해서 iris[,1:4]의 모든 값들은 제곱하시오
apply(iris[,1:4],2, function(x){x^2})
class(lapply(iris[,1:4], function(x){x^2}))
class(sapply(iris[,1:4], function(x){x^2}, simplify = F))
class(sapply(iris[,1:4], function(x){x^2}))
class(sapply(iris[,1:4], function(x){x^2}, simplify = T))

#문제 3
# iris에서 for문을 활용해서 숫자형(iris[,1:4]) 값을 Species별 평균을 구하시오
# z변수에 저장
rm(list = ls())
i <- 1
z <- c()
b <- c()
d <- c()
for (i in 1:4){
  z <- rbind(z, tapply(iris[,i], iris$Species, mean))
  a <- tapply(iris[,i],iris$Species,mean)
  d <- rbind(d,a)
  b <- rbind(b,data.frame(t(a)))
}
class(t(tapply(iris[,i], iris$Species, mean)))
class(z)
class(d)
class(b)
z$setosa
d$setosa
b$setosa
##mat이나 data.frame 형태는 비슷하나, mat은 문자열 포함 안되고
#데이터 불러오는 방식이 한정적임
#ex) matrix$column.name 으로 데이터 불러오기 불가
#-----------------day3 완료--------------------------------------
rm(list = ls())
##데이터 요약 함수
#기본 함수 대비 시간 단축 및 파이프라인(sql의 select, group by등과 같음)을 활용한 함수간 연계
install.packages('dplyr')
library(dplyr)

delivery <- read.csv('SKT.csv', fileEncoding = 'UTF-8')
head(delivery)

#dplyr의 함수 쓸 때 dplyr를 붙이는 이유는
#다양한 패키지 내의 함수명이 같은 것이 있으므로
#어떤 패키지의 함수인지 표기하기 위해 패키지명을 붙여서 작성

#slicing
#1,3,5~10 행 불러오기
slice(delivery,c(1,3,5:10))
delivery[c(1,3,5:10),]
#상기 두 가지는 동일한 데이터를 불러오지만
#slice는 조건에 맞게 불러온 데이터를 첫 행번호부터 다시 쌓음

#filter로 조건에 맞는 행 불러오기
dplyr::filter(delivery, 시군구=='성북구')
dplyr::filter(delivery, delivery$시군구=='성북구')
#dplyr 함수에서는 delivery 기준 데이터를 불러오기에 $을 붙일 필요 없음
#subset과 동일

#arrange로 정렬하기
dplyr::arrange(delivery, desc(시군구), 요일, 업종)
#col.name만 쓰면 오름차순, desc()는 내림차순

#특정 변수 선택 또는 제외
dplyr::select(delivery, 일자:시간대, 업종) #특정 변수만 불러오기
dplyr::select(delivery, -일자) #특정 변수 제외하고 불러오기

#중복 데이터 제거하기
dplyr::distinct(delivery, 업종)
dplyr::distinct(delivery, 일자,업종)


###################### 연습문제 ##########################
data(iris)
head(iris)
## 1.iris 데이터중 1부터 50행중 홀수, 100부터 150행중 짝수 선택
dplyr::slice(iris, c(seq(1,50,2),seq(100,150,2)))
iris[c(seq(1,50,2),seq(100,150,2)),] # index 순번 reset X
## 2.iris 데이터중 Species가 "setosa"이면서 Sepal.Length가 5보다 큰 값을 추출하시오
dplyr::filter(iris, Species == 'setosa' & Sepal.Length > 5)

## 3.iris 데이터중 Sepal.Length는 내림차순 Sepal.Width는 오름차순으로 출력하시오
dplyr::arrange(iris, desc(Sepal.Length), Sepal.Width)

## 4.iris 데이터중 "Sepal.Width" 와 "Species" 열을 선택하시오
dplyr::select(iris, Sepal.Width, Species)

## 5.iris 데이터중 "Species"의 종류를 확인하시오
dplyr::distinct(iris, Species)
###########################################################
rm(list = ls())
#기존 변수를 활용하여 임시 변수 생성 : dplyr::mutate()
delivery <- read.csv('SKT.csv', fileEncoding = 'UTF-8')
head(delivery)
dplyr::mutate(delivery,새요일 = paste0(요일,'요일'))
# = delivery$새요일 <- paste0(delivery$요일,'요일')

# count()로 그룹별 개수 세기
dplyr::count(delivery, 시군구)

#group_by로 그룹 지정해주기
#group_by로 그룹화 할 기준 인지시켜 놓는 작업
delivery_grp <- dplyr::group_by(delivery, 시군구)

#summarize = summarise로 요약
dplyr::summarise(delivery,
                 mean = mean(통화건수),
                 m = min(통화건수),
                 M = max(통화건수))
dplyr::summarize(delivery,
                 mean = mean(통화건수),
                 m = min(통화건수),
                 M = max(통화건수))

dplyr::summarise(delivery_grp,
                 mean = mean(통화건수),
                 m = min(통화건수),
                 M = max(통화건수))
#그룹으로 묶지 않으면 통화건수 전체에 대해서 계산 후 값을 출력
#그룹으로 묶으면 통화건수 그룹별 계산 후 값 출력
## "delivery %>% count(통화건수)"와 동일

#top_n()으로 상위 관측치 확인
dplyr::top_n(delivery, 100, 통화건수)
#전체에서 상위 5개
dplyr::top_n(delivery_grp, 5, 통화건수)
#각 그룹별 상위 5개
#단 중복 값이 있으면 개수 상관없이 가져옴
#ex)10,9,9,8,7,6,5,4,3,2,1
#여기서 top_n으로 상위 5개를 가져오면 10,9,9,8,7,6을 가져옴
# 9가 2개여서 중복값 가져옴
#중복 상관 없이 상위 5개만 보려면 arrange나열 후 head로 가져오면 됌
head(dplyr::arrange(delivery, desc(통화건수)),5)

###################### 연습문제 ##########################
rm(list = ls())
data(iris)
head(iris)
## 6.iris 데이터중 "Sepal.Length" 와 "Sepal.Width" 두변수의 합을 Sepal_sum이라는 변수에 저장하시오
dplyr::mutate(iris, Sepal_sum = Sepal.Length + Sepal.Width)

## 7.iris 데이터중 "Species"의 종별 개수를 확인하시오
dplyr::count(iris, Species)
## 8.iris 데이터중 Sepal.Length의 합과 Sepal.Width의 평균을 구하시오
iris_grp <- dplyr::group_by(iris, Species)
dplyr::summarize(iris, Length_sum = sum(Sepal.Length),
                       Width_mean = mean(Sepal.Width))
dplyr::summarize(iris_grp, Length_sum = sum(Sepal.Length),
                 Width_mean = mean(Sepal.Width))
## 9.iris 데이터중 "Petal.Width"의 상위 5개의 값을 출력
dplyr::top_n(iris, 5, Petal.Width)

###########################################################
#파이프 라인을 활용하여 원하는 데이터 선별 및 조회
#파이프 라인 장점 : 한 줄씩 확인하며 디버깅 가능
delivery <- read.csv('SKT.csv', encoding = 'UTF-8')

delivery %>% 
  dplyr::filter(업종=='중국음식') %>% 
  dplyr::group_by(시군구) %>% 
  dplyr::summarize(mean_call = mean(통화건수)) %>% 
  arrange(desc(mean_call))

# 데이터 저장
new_data <- delivery %>%
  filter(업종=='중국음식') %>% 
  group_by(시군구) %>% 
  summarise(mean_call = mean(통화건수)) %>% 
  arrange(desc(mean_call))

write.csv(new_data,'result.csv', row.names = F)

##ungroup 활용
delivery %>% 
  filter(업종=='중국음식') %>% 
  group_by(시간대, 시군구) %>% 
  summarise(mean_call = mean(통화건수)) %>% 
  top_n(3, mean_call) %>% 
  arrange(시군구, 시간대) 
#시군구별 상위 3개만 보고 싶었으나 이미 group으로 묶여 있고,
#group_by로 시간대 시군구로 묶었으므로
#이미 하나하나가 top 1이 됨
#그러므로 ungroup 또는 group 재지정을 통해 기준을 바꿔야 함 


a <- delivery %>% 
  filter(업종=='중국음식') %>% 
  group_by(시간대, 시군구) %>% 
  summarise(mean_call = mean(통화건수)) %>% 
  #ungroup() %>%  ##ungroup을 안해도 그룹을 다시 재정의하면 바뀌나, 이해 차원에서 앞으로도 쓰자자
  group_by(시군구) %>% 
  top_n(3, mean_call) %>% 
  arrange(시군구, desc(mean_call))

########################### 연습문제 #############################

##2 (실습) 보험료 데이터 요약하기

# 예제 데이터 불러오기 
rm(list = ls())
ins = read.csv('insurance.csv')


#1 데이터 ins에서 sex가 female인 관측치로 region별 관측치 수==행의 수 계산
ins %>% 
  dplyr::filter(sex == 'female') %>% 
  dplyr::group_by(region) %>% 
  dplyr::summarize(nim = n())

#2 charges가 10000이상인 관측치 중에서 smoker별 평균 age 계산
ins %>% 
  dplyr::filter(charges >=10000) %>% 
  dplyr::group_by(smoker) %>% 
  dplyr::summarize(age_mean = mean(age))


#3 age가 40 미만인 관측치 중에서 sex, smoker별 charges의 평균과 최댓값 계산   
savedata <- ins %>% 
  dplyr::filter(age<40) %>% 
  dplyr::group_by(sex, smoker) %>% 
  dplyr::summarize(mean = mean(charges), max = max(charges))
  


# 데이터를 csv파일로 저장하기
# 위에서 작업한 내용 중 3번을 csv파일로 저장해보기

write.csv(savedata, 'savedata.csv', row.names = F)


# -------------------------------------------------------------------------
rm(list = ls())
##3 (실습) 국민건강보험공단 데이터 요약

# 국민건강보험공단 진료내역정보 
## http://data.go.kr/dataset/15007115/fileData.do
## 원본 데이터에서 외래 진료 건과 주요 변수만 선택


load('NHIS.RData')

View(NHIS)
str(NHIS)
head(NHIS)
# IDV_ID  가입자일련번호
# SEX  성별
# AGE_GROUP  연령대코드
# FORM_CD  서식코드
# DSBJT_CD  진료과목코드 
# MAIN_SICK  주상병코드 
# VSCN  요양일수
# RECN  입내원일수
# EDEC_TRAMT  심결요양급여비용총액
# EDEC_SBRDN_AMT  심결본인부담금


# 성 / 연령대별 진료건수 계산  (진료건수 기준 내림차순 정렬)

NHIS %>% 
  group_by(SEX, AGE_GROUP) %>% 
  summarise(n=length(SEX)) %>% 
  arrange(desc(n))

NHIS %>% 
  dplyr::count(SEX, AGE_GROUP) %>% 
  arrange(desc(n))


# 성별/연령대별 환자 분포 확인
## distinct() : 중복값 제거 


NHIS %>%
  dplyr::select(IDV_ID, SEX, AGE_GROUP) %>%
  unique() %>%
  dplyr::count(SEX, AGE_GROUP)


############################ 연습 문제 ################################


# 문제1
# 성 / 연령대 / 진료과목별 환자수  계산  (환자수 기준 내림차순 정렬)
a <- NHIS %>% 
  dplyr::select(SEX, AGE_GROUP, DSBJT_CD, IDV_ID) %>% 
  distinct() %>%
  dplyr::count(SEX, AGE_GROUP, DSBJT_CD) %>%
  dplyr::arrange(desc(n))

head(c,5)
b <- NHIS %>%
  dplyr::select(SEX, AGE_GROUP,DSBJT_CD, IDV_ID) %>%
  unique() %>%
  count(SEX, AGE_GROUP,DSBJT_CD) %>%
  arrange(desc(n))
head(d,5)
# 문제2
# 성별/연령대별 평균(요양일수/입내원일수/급여비용/본인부담금액) 계산 후 급여비용 내림차순으로 정렬
NHIS %>% 
  dplyr::group_by(SEX, AGE_GROUP) %>% 
  dplyr::summarise(VSCN_mean = mean(VSCN), RECN_mean = mean(RECN),
                   EDEC_TREAMT_mean = mean(EDEC_TRAMT),
                   EDEC_SBRDN_AMT_mean = mean(EDEC_SBRDN_AMT)) %>% 
  dplyr::arrange(desc(EDEC_TREAMT_mean))



# 문제3
# 성별/연령대별 3개 최고빈도 주상병코드
## top_n(n=k, wt=기준변수) : 기준변수를 기준으로 상위 k개 관측치 선택
## 주상병코드 조회 (MAIN_SICK)
NHIS %>% 
  dplyr::count(SEX, AGE_GROUP, MAIN_SICK) %>% 
  dplyr::group_by(SEX, AGE_GROUP) %>% 
  dplyr::top_n(3, wt=n) %>% 
  dplyr::arrange(SEX,AGE_GROUP, desc(n))
NHIS %>% 
  dplyr::group_by(SEX, AGE_GROUP, MAIN_SICK) %>% 
  dplyr::summarise(num = n()) %>% 
  dplyr::top_n(3, wt = num) %>%
  dplyr::arrange(SEX,AGE_GROUP, desc(num))

rm(list = ls())
###### mutate의 확장
## 변수의 group별 비율을 아고싶다면??
data(iris)
head(iris)

## 도전해보자
## Species 별로 Sepal.Length의 비중을 아고싶다면??

#ex) prop 열 추가하려면? 
# m group   prop
# 2   a     0.2
# 3   a     0.3
# 5   a     0.5
# 1   b     0.2
# 1   b     0.2
# 3   b     0.6


######################
# 코드 작성
iris %>% 
  dplyr::group_by(Species) %>% 
  dplyr::mutate(sum = sum(Sepal.Length)) %>% 
  dplyr::mutate(prop = Sepal.Length/sum) %>% 
  dplyr::select(Species,Sepal.Length,prop) %>% 
  dplyr::arrange(Species, desc(prop))


######################
###### mutate의 확장2
## group별로 번호를 매기고 싶다면??
iris %>% 
  dplyr::arrange(Species,Sepal.Length) %>% 
  dplyr::group_by(Species) %>% 
  dplyr::mutate(seq_num = row_number()) %>% 
  data.frame()


#ex) prop 열 추가하려면? 
# m group   prop
# 2   a     1
# 3   a     2
# 5   a     3
# 1   b     1
# 1   b     2
# 3   b     3


iris  %>% 
  arrange(Species,Sepal.Length) %>%
  dplyr::group_by(Species) %>%
  dplyr::mutate(seq_num = row_number()) %>% data.frame()

# 도전해보자
# iris 데이터에서 Species별 Sepal.Width가 3번쨰로 큰 값들의 합은?

######################
# 코드 작성
iris %>% 
  dplyr::arrange(Species, Sepal.Width) %>% 
  dplyr::group_by(Species) %>% 
  dplyr::mutate(seq_num = row_number()) %>% 
  dplyr::filter(seq_num == 3)
  


######################