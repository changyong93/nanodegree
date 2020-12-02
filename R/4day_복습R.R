# 데이터 분석가 _ james        \
#                                \
# 스크립트 실행(Run a script)    \
##  : Windows : 'Ctrl + Enter'   \
##  : MAC     : 'Command + Enter'\
#---------------------------------

# 복습 !

######################
####### dplyr ########
######################

# dplyr 패키지 설치
##sql의 select where 등과 같은 명령어로, sql 기반으로 만든 패키지
##패키지별로 함수의 이름이 같은 경우에는 패키지 이름도 명시해야 함
#이부분은 추후에 강사님께서 알려주실 예정
install.packages('dplyr')
library(dplyr)
##데이터 요약 함수
#기본 함수 대비 시간 단축 및 파이프라인(sql의 select, group by등과 같음)을 활용한 함수간 연계

# SKT의 delivery 데이터 활용
## 원본 출처 : SKT Big Data Hub(www.bigdatahub.co.kr)
delivery = read.csv('SKT.csv', fileEncoding='UTF-8')
head(delivery)


## 1.1 slice( )로 특정 행만 불러오기
## 행번호를 활용해서 특정 행을 불러오기
## 햄 슬라이스...

dplyr::slice
slice(delivery, c(1,3,5:10))
delivery[c(1,3,5:10),]
## slice(데이터명, 잘라서가져올 행)
## 1, 3, 5~10 행만 불러오기
## slice는 조건에 맞게 행을 불러와서 번호를 처음부터 쌓음


##1.2 filter( )로 조건에 맞는 데이터 행만 불러오기
filter(delivery, 시군구=='성북구')
filter(delivery, delivery$시군구=='성북구') #모든 dplyr에선 모든 원본을 불러올 필요 업음

## { filter(데이터명, 조건) }
## '성북구' 데이터만 불러오기


filter(delivery, 시군구=='성북구', 요일 %in% c('토', '일'), 업종=='피자' | 통화건수>=100)

## 복수의 조건 사용
## filter(데이터명, 조건1, 조건2, 조건3, ...)
## 조건문은 논리연산(==, !=, >, < 등)을 활용
## 'OR'은 | 로 연결, 'AND'는 ,로 연결



##1.3 arrange( )로 정렬하기(오름차순)
arrange(delivery, 시군구, 요일, 업종)
## arrange(데이터명, 정렬기준변수1, 정렬기준변수2, ...)

arrange(delivery, desc(시군구), 요일, 업종)
## 내림차순(Descending)으로 정렬할 때는 'desc' 옵션 활용



##1.4 select( )로 변수를 선택하거나 제외하기
select(delivery, 통화건수)

# ":"를 활용한 순서대로 여러변수 선택하기 
head(select(delivery, 시간대:통화건수))
select(delivery, 시간대:시군구, 업종:통화건수) #가운 행을 빼고 싶으면 :, :로 해야 함
# "-"를 활용한 변수제외
select(delivery, -요일)



##1.5 distinct( )로 반복 내용제거하기
distinct( delivery, 업종)
## 메모리를 많이써서 대용량 처리할 땐 시간이 오래걸림
## 간단한 분류
#unique()랑 속도 거의 비슷함
###################### 연습문제 ##########################
data(iris)
head(iris)
## 1.iris 데이터중 1부터 50행중 홀수, 100부터 150행중 짝수 선택
slice(iris, c(seq(1,50,2), seq(100,150,2)))
slice(iris, c(1:50, 100:150%%2==0)) #100:150%%2==0으로 하면 T F T F로 반환되고
##c( )안에 숫자와 T,F가 같이 있으면 더 큰 범주인 숫자로 변경됨

## 2.iris 데이터중 Species가 "setosa"이면서 Sepal.Length가 5보다 큰 값을 추출하시오
filter(iris, Species =="setosa", Sepal.Length >5)

## 3.iris 데이터중 Sepal.Length는 내림차순 Sepal.Width는 오름차순으로 출력하시오
arrange(iris,desc(Sepal.Length),Sepal.Width)


## 4.iris 데이터중 "Sepal.Width" 와 "Species" 열을 선택하시오
select(iris, Sepal.Width, Species)
dplyr::select(iris, Sepal.Width, Species)
dplyr:: ##패키지를 많이 사용하면 함수명이 같아지는데 dplyr::처럼 패키지별 확인해서 사용
  
  ###iris[,c("Sepal.Width","Species")]
  
  ## 5.iris 데이터중 "Species"의 종류를 확인하시오
  distinct(iris, Species)
###unique(iris[,"Species"])

###########################################################


##1.6 mutate( )로 기존 변수를 활용한 임시 변수 만들기

mutate(delivery, 새요일=paste0(요일, '요일'))

# 변수 추가 
#delivery$새요일 = paste0(delivery$요일, '요일')

##1.7 count( )로 그룹별 개수 세기
count(delivery, 시군구)
# count = group_by & summarise
##1.8 group_by( )로 그룹 지정해주기
delivery_grp = group_by(delivery, 시군구)
#어떤 기준으로 그룹화 할 건지 인지시켜 놓는 작업



##1.9 summarize( )로 요약 하기
##그룹으로 묶지 않으면 그냥 mean(delivery$통화건수) 한 것과 같음
#그룹으로 묶고 작업할 것

summarise(delivery,
          mean = mean(통화건수),
          m = min(통화건수),
          M = max(통화건수))
summarise(delivery_grp,
          mean(통화건수),
          m = min(통화건수),
          M = max(통화건수))
## 원본 데이터는 전체 요약, 그룹이 지정된 데이터는 그룹별 요약

summarise(delivery_grp, length(통화건수))
## "delivery %>% count(통화건수)"와 동일




##1.10 top_n( )으로 상위 관측치 확인하기  

top_n(delivery, 5, 통화건수)

top_n(delivery_grp, 5, 통화건수)
#중복 상관없이 상위 5개만 보려면 arrange로 나열 후 head로 가져오면 됌
#head() default 6개
###################### 연습문제 ##########################
data(iris)

## 6.iris 데이터중 "Sepal.Length" 와 "Sepal.Width" 두변수의 합을 Sepal_sum이라는 변수에 저장하시오
mutate(iris, Sepal_sum=(Sepal.Length + Sepal.Width))

## 7.iris 데이터중 "Species"의 종별 개수를 확인하시오
count(iris, Species)

## 8.iris 데이터중 Sepal.Length의 합과 Sepal.Width의 평균을 구하시오
summarise(iris, Sepal.Length_sum = sum(Sepal.Length), Sepal.Width_mean = mean(Sepal.Width))
summarise(group_Species, Sepal.Length_sum = sum(Sepal.Length), Sepal.Width_mean = mean(Sepal.Width))
group_Species = group_by(iris, Species)
group_length = group_by(iris, ) ## Sepal.Length의 값을 1-5 5~나머지 묶으려면
## for문과 같은 반복문으로 1-5일땐 3, 나머진 4
## 처럼 새로운 컬럼을 생성해야 함

## 9.iris 데이터중 "Petal.Width"의 상위 5개의 값을 출력
top_n(iris, 5, Petal.Width)


head(iris)
###########################################################


##1.11 파이프라인( %>% )을 활용한 연속작업
delivery %>%  
  filter(업종=='중국음식') %>% # filter 여러 개도 가능
  group_by(시군구) %>% 
  summarise(mean_call = mean(통화건수)) %>% 
  arrange(desc(mean_call))
##파이프라인 장점 : 디버깅이 가능하여 한 줄 한 줄 보며 어디서 오류가 난 지 알 수 있음

# 데이터 저장
new_data = delivery %>% 
  filter(업종=='중국음식') %>% 
  group_by(시군구) %>% 
  summarise(mean_call = mean(통화건수)) %>% 
  arrange(desc(mean_call))


# 결과를 csv파일로 저장
write.csv(new_data, 'result.csv', row.names=FALSE) 
## 작업폴더(Working Directory)에 'result.csv'이름으로 저장



##1.12 ungroup( )의 활용

a = delivery %>% 
  filter(업종=='중국음식') %>% 
  group_by(시간대, 시군구) %>% 
  summarise(mean_call = mean(통화건수))
write.csv(a,'a.csv', row.names = F)
#여기서 top_n을 해도 각 시군구별 상위 3개가 나옴
#시간대 시군구의 top 3

# 시군구별 상위 3대 시간대 확인
c=delivery %>% 
  filter(업종=='중국음식') %>% 
  group_by(시간대, 시군구) %>% 
  summarise(mean_call = mean(통화건수)) %>% 
  ungroup() %>%  ##ungroup을 안해도 그룹을 다시 재정의하면 바뀌나, 이해 차원에서 앞으로도 쓰자자
  group_by(시군구) %>% 
  top_n(3, mean_call) %>% 
  arrange(시군구, desc(mean_call))
write.csv(b,'b.csv', row.names = F)
write.csv(c,'c.csv', row.names = F)
## summarise( )로 요약할 떄의 그룹과
## top_n( )등의 선택에서의 그룹이 다를 때는
## 중간에 ungroup( )을 넣어서 그룹 지정 해제


########################### 연습문제 #############################

##2 (실습) 보험료 데이터 요약하기

# 예제 데이터 불러오기 
ins = read.csv('insurance.csv')


#1 데이터 ins에서 sex가 female인 관측치로 region별 관측치 수==행의 수 계산
ins%>%
  dplyr::filter(sex=='female')%>%
  dplyr::count(region)

ins%>%
  dplyr::filter(sex=='female') %>%
  dplyr::group_by(region) %>% #count는 개수해도 끝이지만 group by + length하면 더 타고 들어갈 수 있음
  summarise(num = n()) #n() 변수 기준 없이 특정 행 개수 세달라는 함수 / length()도 가능하지만 특정 변수 기준


#2 charges가 10000이상인 관측치 중에서 smoker별 평균 age 계산
ins%>%
  dplyr::filter(charges >= 10000)%>%
  dplyr::group_by(smoker)%>%
  dplyr::summarise(mean_age = mean(age))
dplyr::
  #3 age가 40 미만인 관측치 중에서 sex, smoker별 charges의 평균과 최댓값 계산   
  savedata = ins%>%
  dplyr::filter(age < 40)%>%
  dplyr::group_by(sex, smoker)%>%
  dplyr::summarise(mean_charges = mean(charges), max_charges = max(charges))

# 데이터를 csv파일로 저장하기
# 위에서 작업한 내용 중 3번을 csv파일로 저장해보기

write.csv(savedata, 'savedata.csv', row.names = FALSE)

########################################################################


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


b <- NHIS %>%
  dplyr::select(IDV_ID, SEX, AGE_GROUP) %>%
  # unique() %>%
  dplyr::distinct() %>%
  dplyr::count(SEX, AGE_GROUP)


############################ 연습 문제 ################################


# 문제1
# 성 / 연령대 / 진료과목별 환자수  계산  (환자수 기준 내림차순 정렬)
NHIS %>% 
  dplyr::distinct(IDV_ID,SEX, AGE_GROUP, DSBJT_CD) %>% 
  dplyr::count(SEX, AGE_GROUP, DSBJT_CD) %>% 
  dplyr::arrange(desc(n))

NHIS %>% 
  dplyr::select(IDV_ID,SEX, AGE_GROUP, DSBJT_CD) %>% 
  unique() %>%
  dplyr::group_by(SEX, AGE_GROUP, DSBJT_CD) %>% 
  dplyr::summarise(num = n()) %>% 
  dplyr::arrange(desc(num))

NHIS %>%
  dplyr::select(SEX, AGE_GROUP,DSBJT_CD, IDV_ID) %>%
  unique() %>%
  count(SEX, AGE_GROUP,DSBJT_CD) %>%
  arrange(desc(n))


# 문제2
# 성별/연령대별 평균(요양일수/입내원일수/급여비용/본인부담금액) 계산 후 급여비용 내림차순으로 정렬
NHIS %>% 
  dplyr::group_by(SEX, AGE_GROUP) %>% 
  dplyr::summarise(m1 = mean(VSCN), m2=mean(RECN), m3=mean(EDEC_TRAMT), m4=mean(EDEC_SBRDN_AMT)) %>%
  dplyr::arrange(desc(m3))

# VSCN  요양일수
# RECN  입내원일수
# EDEC_TRAMT  심결요양급여비용총액
# EDEC_SBRDN_AMT  심결본인부담금

# 문제3
# 성별/연령대별 3개 최고빈도 주상병코드
## top_n(n=k, wt=기준변수) : 기준변수를 기준으로 상위 k개 관측치 선택
## 주상병코드 조회 (MAIN_SICK)
NHIS %>% 
  dplyr::count(SEX,AGE_GROUP,MAIN_SICK) %>% 
  dplyr::group_by(SEX, AGE_GROUP) %>% 
  dplyr::top_n(n=3, wt=n) %>% 
  dplyr::arrange(SEX,AGE_GROUP,desc(n))

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
  dplyr::select(Species, Sepal.Length, prop)


######################



###### mutate의 확장2
## group별로 번호를 매기고 싶다면??
iris %>% 
  dplyr::arrange(Species, Sepal.Length) %>% 
  dplyr::group_by(Species) %>% 
  dplyr::mutate(num = row_number())

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
  dplyr::mutate(num = row_number()) %>% 
  dplyr::filter(num == 3)

######################
#소비자 구매 확률(강사님)
#ex) 7번째 구매한 고객이 6번째에서 7번쨰 어떤 행동을 해서 7번쨰 물품을 구매했는지에 대한 데이터 분석
#    데이터 트레킹 데이터를 토대로 8번쨰 패턴 예측하여 확률을 높여가는 작업을 하시는 중
#    데이터 추천