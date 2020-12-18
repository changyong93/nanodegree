#####Day 1#####
x1 <- 10
v1 <- c(T,F,T)

seq(1,7,2) #1~7까지 2씩 증가(by : default)
seq(1,7,by=2) #1~7까지 2씩 증가
seq(1,7,length=2) #1~7 등분 개수

rep(1:3,2) #1~3까지 2회 반복(times(=time) : Default)
rep(1:3,times=2)
rep(1:3,times=c(1,2,3)) #1,2,3을 1,2,3번 반복 수행
rep(1:3,times=c(1:3)) #1,2,3을 1,2,3번 반복 수행
rep(1:3,length = 3) #1~3의 출력 개수가 3개가 될 때까지 반복 수행
rep(1:3,each = 10) #1~3을 각 10번씩 반복 출력


# rep, seq를 한번에 사용하는 문 예제문제
#1. 1~100까지 짝수를 2번씩 출력(2 2 4 4 6 6 .... 100 100)
rep(seq(2,100,2),each = 2)
# 2. 1~5까지 숫자만큼 반복 출력(1 2 2 3 3 3 4 4 4 4 5 5 5 5 5)
rep(1:5,1:5)


factor(c("MALE","FEMALE","MALE"))
gender
factor(c("MALE","FEMALE","MALE"),levels=c("MALE","FEMALE"),labels = c("남자","여자"))

ordered(c(4,1,2,3,1,1,1),levels=c(1,2,3,4), labels=c("20대이하","30대","40대","50대이상"))
cut(c(16,3,29,40,66,12,34),
    breaks = c(0,20,40,60,80),
    include.lowest = T,
    right = T,
    labels= c("0~20","21~40","41~60","61~80"))

matrix(1:9, nrow = 3)
matrix(1:9, ncol = 3)
matrix(1:9, nrow = 3, byrow=T)

# 연습문제
# 1. 다음 벡터 생성
A <- rep(seq(1,3,0.5), 1:5)
B <- 1:15
M <- matrix(c(B,A), ncol = 5, byrow = T)
mm <- data.frame(matrix(c(B,A), ncol = 5, byrow = T))
colnames(M) <- paste0("col",1:5)
names(mm) <- paste("col",1:5)

#특정 row & col 을 선택하거나, 불필요한 row & col 지우기
M[c(1,4,6),c(1,3,5)]

as.data.frame(data) #data를 data.frame형태로 변경
data.frame(data) #data로 데이터프레임 생성

exm <- list(c("Abe", "Bob", "Carol", "Deb"),c("Weight","Height"))
names(exm) <- c("names","features")
exm$names
exm[[1]]

# 1. a에 1부터 10까지 홀수를 3번씩 출력하고 다음과 같은 matrix 저장하시오
#     [,1] [,2] [,3] [,4] [,5]
#[1,]   1    3    5    7    9
#[2,]   1    3    5    7    9
#[3,]   1    3    5    7    9
a <- matrix(rep(seq(1,10,2),each=3),ncol=5)
matrix(rep(seq(1,10,2),3),ncol=5,byrow=T)

# 2. b와 c로 데이터 프레임을 d에 저장하시오
b <- c(1,2,3)
c <- c("a","b","c")
d <- data.frame(b,c)
# 3. a와 d를 리스트 e에 저장하고 2번째층에 저장된 데이터프레임 2행 2열을 출력하시오
e <- list(a,d)
e[[2]][2,2]
#--------------------------------------------------------------------------------
#####Day 2#####
getwd()
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/R/강의자료/데이터") #or ctrl+shift+H로 위치 지정

test <- read.csv('test.csv')
pop_seoul <- read.csv('pop_seoul_euckr.csv',fileEncoding = 'euc-kr')
View(pop_seoul)
edit(pop_seoul)
data.entry(pop_seoul)
str(pop_seoul)
summary(pop_seoul)

temp <- read.table('pop_seoul.txt',
           header = T,
           fileEncoding = 'utf-8')
write.csv(pop_seoul,file = 'aaa.csv',row.names = F)

library(openxlsx)
read.xlsx('test.xlsx', sheet=1)
read.xlsx('test.xlsx', sheet=2, startRow = 3)
read.xlsx('test.xlsx', sheet=3, colNames = F)

new_data <- readRDS('iris.RDS')
saveRDS(new_data,file = 'new_iris1.rds')

load('iris.rdata')
iris4 <- iris
save.image('iris_image')
save(iris,iris2,file = 'iris_images.rdata')

# 통계청 가구별 주택 거주 데이터
## 출처 : http://kosis.kr/statHtml/statHtml.do?orgId=101&tblId=DT_1JU1501&vw_cd=&list_id=&seqNo=&lang_mode=ko&language=kor&obj_var_id=&itm_id=&conn_path=I2

## 파일위치 :'data/'
## 파일이름 : '시도별_가구_주택종류.xlsx'
## 데이터 시작 위치 : 2행
read.xlsx('시도별_가구_주택종류.xlsx', startRow = 2)
View(read.xlsx('시도별_가구_주택종류.xlsx', startRow = 2))

# 국토교통부 아파트 실거래가 데이터(2018, 강남구)
## 출처 : http://rtdown.molit.go.kr/

## 파일위치 :'data/'
## 파일이름 : '아파트매매_2019_강남구.xlsx'
# 데이터 시작 위치 : 17행
read.xlsx('아파트매매_2019_강남구.xlsx',startRow=17)
View(read.xlsx('아파트매매_2019_강남구.xlsx',startRow=17))

a<-c(1,2)
b<-c(3,4)
a+b ; a-b ; a*b ; a/b
a%/%b ; a%%b #몫, 나머지
A<-matrix(c(5,10,2,1), ncol=2)
B<-matrix(c(3,4,5,6), ncol=2)
A%*%B


tmp_df <- data.frame(AA = c(1:5), BB = c("A","A","B","B","B"))
head(tmp_df)
tmp_df$CC <- 1
tmp_df$DD <- tmp_df$AA + tmp_df$CC
which(names(tmp_df)=='CC')
rm(list = ls())
smp_df <- data.frame(aa=rep(letters[1:5],10),
                     bb=sample(60:70,50,replace=T))
smp_df[smp_df$aa=='a',]
subset(smp_df,aa=='a')

smp_df[smp_df$aa %in% c('a','b'),1]
subset(smp_df, aa %in% c('a','b'),1)

rm(list = ls())
data(iris)
# 1. Sepal.Length 변수의 짝수행을 출력하시오 .
iris[seq(2,length(iris$Sepal.Length),2),"Sepal.Length"]
iris$Sepal.Length[seq(2,dim(iris)[1],2)]
iris[seq(1,150)%%2==0,"Sepal.Length"]
# 2. Subset을 사용해서 변수 Species 에서 setosa 인 데이터를 추출하시오
a1 <- subset(iris,Species=='setosa',)
# 3. 2번에서 뽑은 데이터를 a1에 저장하고 Sepal.Length 가 5 보다 작은 Petal.Width 의 합을 구하시오
sum(iris[iris$Sepal.Length<5,"Petal.Width"])
sum(a1[a1$Sepal.Length<5,4])
sum(subset(a1,Sepal.Length<5,Petal.Width))

library(openxlsx)
gn <- read.xlsx('아파트매매_2018_강남구.xlsx',sheet=1,startRow=17,colNames=T)
gd <- read.xlsx('아파트매매_2018_강동구.xlsx',sheet=1,startRow=17,colNames=T)
sc <- read.xlsx('아파트매매_2018_서초구.xlsx',sheet=1,startRow=17,colNames=T)
sp <- read.xlsx('아파트매매_2018_송파구.xlsx',sheet=1,startRow=17,colNames=T)
gn4 <- rbind(gn,gd,sc,sp)

my_data = data.frame(id = 1:5,
                     gender = c('M','F','F','F','M'),
                     age = seq(15, 35, 5))
another_data = data.frame(region = c('Seoul','Seoul','Seoul','Busan','Busan'),
                          amount = c(1,1,1,1,1))
cbind(my_data,another_data)


my_data$amount <- 100
my_data$age_grp <-cut(my_data$age,
                       breaks = c(10,20,30,40),
                       include.lowest = T,
                       right = F,
                       labels = c('10_19','20_29','30_39'))

sales <- read.csv('ex_sales.csv')
prod <- read.csv('ex_prod.csv')
head(sales); head(prod)
merge(sales,prod,by='PROD',all=T)



a1 <-  data.frame(name=c("aa","bb","cc"),value=seq(10,20,length.out = 3))
a2 <-  data.frame(name=c("cc","dd","ee"),value=seq(30,50,length.out = 3))
a3 <-  data.frame(name=c("aa","dd","ee","ff"),value=seq(20,80,length.out = 4),any=seq(0,3,1))
#  1. a1 와 a2 를 행결합 하시오
a1;a2
rbind(a1,a2)
# 2. a3 와 a1 를 행결합하시오
a3;a1
library(plyr)
rbind.fill(a3,a1)
# 3. a3 와 a2 를 name 기준으로 결합 하시오 (a3 데이터는 모두출력)
a3;a2
z <- merge(a3,a2,by='name',all.x=T)
#--------------------------------------------------------------------------------
#####Day 3#####
rm(list = ls())
# 문제 1
# a의 평균이 15이상이면 "평균이상" 아니면 "평균미만"으로 출력하시오
a <- seq(1,30,4)
mean(a)
if(mean(a) >=15){'평균이상'
} else{
  '평균미만'
}

# 문제 2
# if , else if , else를 사용해서 tmep 조건을 만드시오
# 0이하면 freezing, 10이하면 cold, 20이하면 cool, 30이하면 warm, 그외는 hot이 출력되게 하시오
temp <- 25
if(temp<=0){
  'freezing'
} else if(temp<=10){
  'cold'
} else if(temp<=20){
  'cool'
} else if(temp<=30){
  'warm'
} else {
  'hot'
}

# 문제 2_1
temp <-c(5,20,-6,37,24,13)
# 문제 2번의 값을 ifelse 로 바꿔서 값을 변경하시오
ifelse(temp<=0,'cold',
       ifelse(temp<=10,'cold',
              ifelse(temp<=20,'cool',
                     ifelse(temp<=30,'warm','hot'))))

# 문제 3
# - ifelse 를 사용해서 iris의 Sepal.Length가 6보다 크면 1 작으면 0 변수 생성하시오
# - new라는 변수 추가하고 new가 1인 Sepal.Width의 합을 구하시오
data(iris)
iris$new <- ifelse(iris$Sepal.Length>6,1,0)
sum(subset(iris,new==1,Sepal.Width))

#1번 문제
# wheel 과 같이 총 7개의 경우의 수가 있다.
# 각 확률은 prob와 같고 총 3번의 시도를 했을 경우에 0.001보다 높은 경우의 수 개수는?
# (3번 추출하며 각각 독립이다)
# (DD, BBB, 7) 과 (DD , 7 , BBB)는 다른 경우의 수다
wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
prob <- c("DD" = 0.03, "7" = 0.03, "BBB" = 0.06, 
          "BB" = 0.1, "B" = 0.25, "C" = 0.01, "0" = 0.52)
test <- expand.grid(wheel,wheel,wheel)
test$prob1 <- prob[test$Var1]
test$prob2 <- prob[test$Var2]
test$prob3 <- prob[test$Var3]
for(i in 1:3){
  test[,paste0('prob',i)] <- prob[test[,i]]
}
test$prob <- test$prob1*test$prob2*test$prob3
nrow(test[test$prob>0.001,])
#2번 문제
# 동전을 3번 던질 떄 확률은 0.3과 0.7이다
# 첫번째에 앞이나오고 그리고(&) 세번째에 뒤가 나올 확률을 구하시오

coin <- c("앞","뒤")
prob <- c("앞" = 0.3, "뒤" = 0.7)
test <- expand.grid(coin, coin, coin)
for(i in 1:3){
  test[,paste0('prob',i)] <- prob[test[,i]]
}
test$prob <- test$prob1*test$prob2*test$prob3
sum(test[test$Var1=='앞' & test$Var3=='뒤','prob'])

rm(list = ls())
#1번 문제
# for문을 사용해서 1부터 100까지의 누적합을 구하시오
sum <- 0
for(i in 1:100){
  sum <- sum+i
}

#2번 문제
# for문을 사용해서 위의 주사위 20번 던진 누적 합을 구하시오
sum1 <- 0
for(i in 1:20){
  sum1 <- sum1+sample(1:6,1)
}
sum2 <- 0
i=1
while(i<=20){
  sum2 <- sum2+sample(1:6,1)
  i=i+1
}
sum3 <- 0
i <- 1
repeat{
  sum3 <- sample(1:6,1)+sum3
  i <- i+1
  if(i>20) break
}

#1번 문제 구구단 만들어보기


#ex)
# 1 2 3 4 5 6 7 8 9
# 2 4 6 8 10 12 14 16 18
# 3 6 9 12 ....
# .....
# 9 18 27 36 ....

#1_1 for문
#seq(값 , by = 차이, length.out = 길이)
for(i in 1:9){
  cat(i,"단 : ",seq(i,by=i,length.out=9),"\n")
}

#1_2 while문
#while문
i <- 1
while(i<=9){
  cat(i,"단 : ", seq(from=i,by=i,length=9),"\n")
  i <- i+1
}

#1 
# 성적을 입력했을경우 40점 이하는 "C", 70점 이하는 "B" 
# 71점 이상은 "A"를 출력하는 function을 만드시오

my_grade <- function(x){
  ifelse(x<=40,print("C"),
         ifelse(x<=70,print("B"),print("A")))
}
my_grade(20)


head(iris)
apply(iris[,1:4],1,sum) ; rowSums(iris[,1:4])
apply(iris[,1:4],2,sum) ; colSums(iris[,1:4])
rowsum(iris[,1:4],group = iris$Species)
lapply(iris[,1:4],sum) ; lapply(iris[,1:4],function(x){sum(x)})
class(do.call(cbind,lapply(iris[,1:4],mean,use.names = T)))
data.frame(lapply(iris[,1:4],mean,use.names = T))

tapply(iris$Sepal.Length,iris$Species,mean)

rm(list = ls())
#문제 1
# iris에서 각 열별(1~4열) 분산 열을 추가하시오 (var)
apply(iris[,1:4],2,var)
sapply(iris[,1:4],var,simplify = T)
lapply(iris[,1:4],var)
lapply(iris[,1:4],function(x){var(x)})
sapply(iris[,1:4],var,simplify = F)
#문제 2
# function을 활용해서 iris[,1:4]의 모든 값들은 제곱하시오
apply(iris[,1:4],1,function(x){x^2})
apply(iris[,1:4],2,function(x){x^2})
sapply(iris[,1:4],function(x){x^2},simplify=T)
sapply(iris[,1:4],function(x){x^2},simplify=F)

#문제 3
# iris에서 for문을 활용해서 숫자형(iris[,1:4]) 값을 Species별 평균을 구하시오
# z변수에 저장
i <- 1
z <- c()
for(i in 1:3){
  tmp <- tapply(iris[,i],iris$Species,mean)
  z <- rbind(z,tmp)
}
z
rm(list = ls())
#--------------------------------------------------------------------------------
#####Day 4#####
library(openxlsx)
library(dplyr)
delivery <- read.csv('SKT.csv',fileEncoding = 'utf-8')
slice(delivery,c(1,3,5:10))
filter(delivery[c(1,3,5:10),])

data(iris)
head(iris)
## 1.iris 데이터중 1부터 50행중 홀수, 100부터 150행중 짝수 선택
slice(iris,c(seq(1,50,2),seq(100,150,2)))
## 2.iris 데이터중 Species가 "setosa"이면서 Sepal.Length가 5보다 큰 값을 추출하시오
iris %>% 
  filter(Species=='setosa', Sepal.Length>5)
## 3.iris 데이터중 Sepal.Length는 내림차순 Sepal.Width는 오름차순으로 출력하시오
iris %>% 
  arrange(desc(Sepal.Length),Sepal.Width)

## 4.iris 데이터중 "Sepal.Width" 와 "Species" 열을 선택하시오
iris %>% 
  select(Sepal.Width,Species)

## 5.iris 데이터중 "Species"의 종류를 확인하시오
iris %>% 
  distinct(Species)
unique(iris$Species)
unique(iris[,"Species"])

## 6.iris 데이터중 "Sepal.Length" 와 "Sepal.Width" 두변수의 합을 Sepal_sum이라는 변수에 저장하시오
iris %>% 
  mutate(Sepal_sum = Sepal.Length + Sepal.Width)
## 7.iris 데이터중 "Species"의 종별 개수를 확인하시오
iris %>% 
  group_by(Species) %>% 
  summarise(nu=n())
count(iris,Species)
## 8.iris 데이터중 Sepal.Length의 합과 Sepal.Width의 평균을 구하시오
iris %>% 
  summarise(sum=sum(Sepal.Length), mean=mean(Sepal.Width))
## 9.iris 데이터중 "Petal.Width"의 상위 5개의 값을 출력
iris %>%
  select(Petal.Width) %>% 
  arrange(desc(Petal.Width)) %>% 
  top_n(5,Petal.Width)
  # head(5)


##2 (실습) 보험료 데이터 요약하기
# 예제 데이터 불러오기 
ins = read.csv('insurance.csv')

head(ins)
#1 데이터 ins에서 sex가 female인 관측치로 region별 관측치 수==행의 수 계산
ins %>% 
  filter(sex=='female') %>% 
  group_by(region) %>% 
  summarise(num = n())
ins %>% 
  filter(sex=='female') %>% 
  count(region)
  

#2 charges가 10000이상인 관측치 중에서 smoker별 평균 age 계산
savedata <- ins %>% 
  filter(charges>=10000) %>% 
  group_by(smoker) %>% 
  summarise(m=mean(age))
# 데이터를 csv파일로 저장하기
# 위에서 작업한 내용 중 3번을 csv파일로 저장해보기
write.csv(savedata,'savedata.csv',row.names = F)

rm(list = ls())
#3 (실습) 국민건강보험공단 데이터 요약
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
  group_by(SEX,AGE_GROUP) %>% 
  summarise(num = n()) %>% 
  arrange(desc(num))

NHIS %>% 
  count(SEX, AGE_GROUP) %>% 
  arrange(desc(n))

# 성별/연령대별 환자 분포 확인
## distinct() : 중복값 제거 
NHIS %>% 
  select(SEX,AGE_GROUP,IDV_ID) %>% 
  distinct() %>%
  count(SEX,AGE_GROUP)

############################ 연습 문제 ################################


# 문제1
# 성 / 연령대 / 진료과목별 환자수  계산  (환자수 기준 내림차순 정렬)
NHIS %>% 
  select(SEX,AGE_GROUP,DSBJT_CD,IDV_ID) %>% 
  distinct() %>% 
  group_by(SEX,AGE_GROUP,DSBJT_CD) %>% 
  summarise(n=n()) %>% 
  arrange(desc(n))
NHIS %>% 
  distinct(SEX,AGE_GROUP,DSBJT_CD,IDV_ID) %>% 
  count(SEX,AGE_GROUP,DSBJT_CD) %>% 
  arrange(desc(n))


# 문제2
# 성별/연령대별 평균(요양일수/입내원일수/급여비용/본인부담금액) 계산 후 급여비용 내림차순으로 정렬
NHIS %>% 
  group_by(SEX,AGE_GROUP) %>% 
  summarise(m1=mean(VSCN),m2=mean(RECN),m3=mean(EDEC_TRAMT),m4=mean(EDEC_SBRDN_AMT)) %>% 
  arrange(desc(m3))

# VSCN  요양일수
# RECN  입내원일수
# EDEC_TRAMT  심결요양급여비용총액
# EDEC_SBRDN_AMT  심결본인부담금

# 문제3
# 성별/연령대별 3개 최고빈도 주상병코드
## top_n(n=k, wt=기준변수) : 기준변수를 기준으로 상위 k개 관측치 선택
## 주상병코드 조회 (MAIN_SICK)
NHIS %>% 
  group_by(SEX,AGE_GROUP) %>% 
  count(MAIN_SICK) %>% 
  top_n(3,wt=n)

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
a <- iris %>% 
  group_by(Species) %>% 
  mutate(sum=sum(Sepal.Length)) %>% 
  mutate(prop = Sepal.Length/sum) %>% 
  select(Sepal.Length,Species,prop)

######################



###### mutate의 확장2
## group별로 번호를 매기고 싶다면??


#ex) prop 열 추가하려면? 
# m group   prop
# 2   a     1
# 3   a     2
# 5   a     3
# 1   b     1
# 1   b     2
# 3   b     3


# 도전해보자
# iris 데이터에서 Species별 Sepal.Width가 3번쨰로 큰 값들의 합은?

######################
# 코드 작성
iris %>% 
  group_by(Species) %>% 
  arrange(Species,Sepal.Width) %>% 
  mutate(prop = row_number()) %>% 
  ungroup() %>% 
  filter(prop ==3) %>% 
  summarise(sum=sum(Sepal.Width))

######################
rm(list = ls())
library(hflights)

#문제1
# mutate를 사용해 delay라는 변수를 만들고 오름차순으로 정렬후 상위 20개의 평균을 구하시오
# delay = ArrDelay - DepDelay
apply(hflights,2,function(x){sum(is.na(x))})
hflights %>% 
  mutate(delay = ArrDelay - DepDelay) %>% 
  arrange(delay) %>%
  head(20) %>%
  summarise(mean=mean(delay))

#문제2
# 비행편수(TailNum)가 20편 이상, 평균 비행거리가 2000마일 이상인 평균 연착시간의 평균을 구하시오
# 비행거리 : Distance
# 연착시간 : ArrDelay
hflights %>% 
  group_by(TailNum) %>% 
  summarise(dist=mean(Distance, na.rm=T), arr=mean(ArrDelay,na.rm=T),n=n()) %>% 
  filter(n>=20, dist>=2000) %>% 
  summarise(mean=mean(arr))


#--------------------------------------------------------------------------------
#####Day 5#####
rm(list = ls())
library(tidyr)
library(dplyr)
delivery = read.csv('SKT.csv', fileEncoding='UTF-8')

aggr <- delivery %>% 
  group_by(시군구,시간대,요일,업종) %>% 
  summarise(통화건수=sum(통화건수))

aggr_wide <- aggr %>% 
  spread(업종,통화건수)

aggr_wide2 <- aggr %>% 
  spread(업종,통화건수) %>% 
  replace_na(list(족발보쌈=0,중국음식=0,치킨=0,피자=0))


aggr_long <- aggr_wide2 %>% 
  gather(category,count,족발보쌈:피자)


head(aggr_wide2)
dim(aggr_wide2)
as.data.frame(aggr_wide2) %>%
  complete(시군구,시간대,요일,fill=list(족발보쌈=0,중국음식=0,치킨=0,피자=0))


######################## 연습문제 #############################
library(openxlsx)
subway_2017 = read.xlsx('subway_1701_1709.xlsx')
names(subway_2017)[6:25] <- paste0("H",substr(names(subway_2017)[6:25],1,2))
# (실습) gather( ) 함수를 활용하여 H05부터 H24까지 변수를 모아
# '시간대'와 '승객수'으로 구분하는 데이터 subway2 만들기
subway2 <- subway_2017 %>% 
  gather(시간대,승객수,H05:H24)

## 위에서 만든 subway2 데이터와 dplyr 패키지를 활용하여
# 역명/시간대별 전체 승객수 합계 계산 (승객수 합계의 내림차순으로 정렬)
head(subway2)
subway2 %>% 
  group_by(역명,시간대) %>% 
  summarise(sum=sum(승객수,na.rm=T)) %>% 
  arrange(desc(sum))

# 위의 결과를 spread( ) 함수를 활용해서 표 형태로 변환
subway2 %>% 
  group_by(역명,시간대) %>% 
  summarise(sum=sum(승객수,na.rm=T)) %>% 
  arrange(desc(sum)) %>% 
  spread(시간대,sum)
# 역명/시간대/구분별 전체 승객수 합계 계산
subway2 %>% 
  group_by(역명,시간대,구분) %>% 
  summarise(승객수=sum(승객수))
# 2월 한달간 역명/시간대/구분별 전체 승객수 합계 계산
head(subway2)
subway2 %>% 
  filter(월==2) %>% 
  group_by(역명,시간대,구분) %>% 
  summarise(승객수=sum(승객수))

library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)
rm(list=ls())
x <- c("apple", "banana", "pear")
str_detect(x,'e')
str_count(x,'a')
str_which(x,'e')
str_locate(x,'a')
str_sub(x,1,3)
substr(x,1,3)
str_subset(x,'e')
str_replace(x,'a','zzzz')
str_replace_all(x,'a','zzzz')
str_to_lower(x)
str_to_upper(x)
str_to_title(x)

# 문제 1
# words를 모두 대문자로 바꾼 상태에서 'AB'를 포함한 단어의 개수는 총 몇개이며 어떤단어들이 있는가?
words #내장함수
sum(str_detect(str_to_upper(words),'AB'))
# 문제 2
# words에서 "b"를 "a"로 모두 바꾸고 "aa"를 포함하는 단어 개수는?
sum(str_detect(str_replace_all(words,'b','a'),'aa'))

# 문제 3
# words에서 "e"의 수는 전체 합과 평균은 몇인가?
sum(str_count(words,'e'))
mean(str_count(words,'e'))
library(ggplot2)
library(dplyr)
library(plyr)
library(tidyr)
library(stringr)
library(lubridate)
library(openxlsx)
library(zoo)
ymd(20201020)
test <- today()
year(test)
month(test)
day(test)
week(test)
wday(test)
wday(test,label = T)

ymd_hms('20201020 152430')
rm(list = ls())
subway_2017 = read.xlsx('subway_1701_1709.xlsx')
names(subway_2017)[6:25] <- paste0("H",substr(names(subway_2017)[6:25],1,2))
# 문제1
# (실습) gather( ) 함수를 활용하여 H05부터 H24까지 변수를 모아
# '시간대'와 '승객수'으로 구분하는 데이터 subway2 만들기
# subway2 데이터의 날짜에 시간을 추가하기 ex) "2017-01-02 06:00:00"
head(subway_2017)
subway2 <- subway_2017 %>% 
  gather(시간대,승객수,H05:H24) %>% 
  mutate(날짜=ymd_h(paste0(날짜," ",substr(시간대,2,3))))

# 문제2 **매우 중요, 많이 사용
# subway_2017 데이터에서 월과 일을 month, day 변수명으로 추가하시오
subway2 <- subway2 %>% 
  mutate(month=month(날짜), day=day(날짜))

# 문제3
# 위에서 추가한 변수들 기반으로 3월중 가장 많이 탑승한 시간은 몇시인가?
head(subway2)

subway_2017 %>% 
  gather(시간대,승객수,H05:H24) %>% 
  mutate(month=month(날짜),day=day(날짜)) %>% 
  filter(month==3) %>% 
  dplyr::group_by(시간대) %>% 
  dplyr::summarise(승객수=sum(승객수)) %>% 
  dplyr::arrange(desc(승객수))

# 결측치 확인하기
df <- data.frame(sex = c("M", "F", NA, "M", "F"),
                 score = c(5, 4, 3, 4, NA))
table(is.na(df))
apply(df,2,function(x){sum(is.na(x))})

filter(df, !is.na(sex) & !is.na(score))

mpg <- as.data.frame(ggplot2::mpg)
mpg[c(65, 124, 131, 153, 212), "hwy"] <- NA
sapply(mpg,function(x){sum(is.na(x))})
mpg[is.na(mpg$hwy),"hwy"] <- mean(mpg$hwy,na.rm=T)

na.locf(object = c(NA, NA, "A", NA, "B"), fromLast = F)
na.locf0(object = c(NA, NA, "A", NA, "B"), fromLast = F)

# 1. airquality 데이터의 결측치 개수를 구하시오 (열별로)
apply(airquality,2,function(x){sum(is.na(x))})
# 2. 결측치가 있는 행들을 제거한 후 각 열의 평균을 구하시오
na.omit(airquality)
airquality %>% 
  drop_na() %>% 
  apply(2,mean)
# 3. 결측치는 변수의 중앙값으로 대체후 각 열의 평균을 출력하시오
ncol(airquality)
for(i in 1:6){
  airquality[is.na(airquality[,i]),i] <- median(airquality[,i],na.rm=T)
}
sapply(airquality,mean,simplify=T)
#--------------------------------------------------------------------------------
#####Day 6#####
library(RColorBrewer)
display.brewer.all()
display.brewer.pal(9,'Set3')
brewer.pal(9,'Set1')
library(ggplot2)
library(gapminder)
data("gapminder")
head(gapminder)
data1 <- gapminder[gapminder$year=="2007",]
ggplot(data1)+
  aes(x=gdpPercap,y=lifeExp,color=continent)+geom_point(alpha=0.3)

insurance <- read.csv('insurance.csv')
head(insurance)
#1. bmi에 따라서 charges가 어떻게 변하는지 점그래프를 그리시오
## region을 색으로 지정
## sex를 모양으로 지정
## 투명도는 0.7
insurance %>% 
  ggplot(aes(x=bmi,y=charges,color=region,shape=sex))+geom_point(alpha=0.7)

#2. age에 따라서 charges가 어떻게 변하는지 점그래프를 그리시오
## bmi 색으로 지정
## smoker를 모양으로 지정
insurance %>% 
  ggplot(aes(x=age,y=charges,color=bmi,shape=smoker))+geom_point()

head(insurance)
#1. insurance 데이터에서 region별 charges 중앙값을 구한후 막대그래프를 그리시고
##  region을 색으로 지정
## 투명도는 0.7
insurance %>% 
  group_by(region) %>% 
  dplyr::summarise(charges=median(charges)) %>% 
  ggplot(aes(x=region,y=charges,fill=region))+geom_bar(stat='identity',alpha=0.7)
  
#2. insurance 데이터에서 sex, smoker별 중앙값을 구한후 막대그래프를 그리시고
## x축은 smoker이며 sex를 색으로 구분
##  region을 색으로 지정
## 투명도는 0.7
insurance %>% 
  group_by(sex,smoker) %>% 
  dplyr::summarise(charges=median(charges)) %>% 
  ggplot(aes(x=smoker,y=charges,fill=sex))+
  geom_bar(stat='identity',alpha=0.7,position='dodge')


#1 insurance데이터에서 children이 0보다 크면 1, 0이면 0인 변수 ch_data를 만드시오
head(insurance)
insurance %>% 
  mutate(ch_data=ifelse(children>0,1,0))
#2 insurance데이터를 활용해서 막대그래프를 그리시오
## x축은 region y축은 charges이며 ch_data를 색으로 구분
insurance %>% 
  mutate(ch_data=as.factor(ifelse(children>0,1,0))) %>% 
  ggplot(aes(x=region,y=charges,fill=ch_data))+geom_boxplot()

#3 insurance데이터를 활용해서 막대그래프를 그리시오
## x축은 charges ch_data를 색으로 구분
## region마다 4개의 그래프를 그리시오
insurance %>% 
  mutate(ch_data=as.factor(ifelse(children>0,1,0))) %>% 
  ggplot(aes(x=charges,fill=ch_data))+geom_histogram()+facet_grid(~region)
#4 insurance데이터를 활용해서 막대그래프를 그리시오
## x축은 region y축은 charges이며 ch_data를 색으로 구분
## (누적 막대그래프와 ch_data별 비교 막대그래프)
insurance %>% 
  mutate(ch_data=as.factor(ifelse(children>0,1,0))) %>% 
  ggplot(aes(x=region,y=charges,fill=ch_data))+geom_bar(stat='identity')+
  facet_grid(~ch_data)

HR <- read.csv("HR_comma_sep.csv")
HR$left = as.factor(HR$left)
HR$salary = factor(HR$salary,levels = c("low","medium","high"))

# (실습) NHIS에서 AGE_GROUP, DSBJT_CD별 EDEC_TRAMT 평균 계산 후 저장
#        저장된 데이터로 열지도 시각화
#어떤 범주형과 어떤 범주형에 대해 전처리 후 히트맵을 그려야 함




###########################################
# tidyr + dplyr + ggplot을 한번에

# 데이터 불러오기
## 역변호가 150인 서울역 데이터 
library(openxlsx)
subway_2017 = read.xlsx('subway_1701_1709.xlsx')
names(subway_2017)[6:25] <- paste0('H', substr(names(subway_2017)[6:25], 1, 2))
head(subway_2017)
# gather( ) 함수를 활용하여 H05부터 H24까지 변수를 모아
# '시간대'와 '승객수'으로 구분하는 데이터 subway2 만들기
subway2 <- subway_2017 %>% 
  gather(시간대,승객수,H05:H24)
## 위에서 만든 subway2 데이터와 dplyr 패키지를 활용하여
# 역명/시간대별 전체 승객수 합계 계산 (승객수 합계의 내림차순으로 정렬)
subway2 %>% 
  group_by(역명,시간대) %>% 
  dplyr::summarise(승객수=sum(승객수)) %>% 
  arrange(desc(승객수))
### 이러한 tidyr을 통해서 데이터를 시각화하기
### 시간대별로 승객 합계 막대차트로 그려보기!
subway2 %>% 
  group_by(시간대) %>% 
  dplyr::summarise(승객수=sum(승객수)) %>% 
  arrange(desc(승객수)) %>% 
  ggplot(aes(x=시간대,y=승객수,fill=시간대))+geom_bar(stat='identity')+
  theme(axis.text.x=element_text(angle=60))+
  scale_y_continuous(breaks = seq(0,270000000,30000000))+
  geom_text(aes(label=승객수,y=승객수),color='black')
  ggtitle('시간대별 승객수')+
options(scipen=0)

