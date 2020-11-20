##1회차 복습
mat <- matrix(1:9, ncol = 3, byrow=T)
mat [1,]
mat [,3]

a <- 1:10
b <- rep("a", 10)
c <- data.frame(a,b)

list1 <- list("A", 1:8)
list1[[3]] <- list(c(T,F))
list1[[2]][9] <- 9
list1[3] <- NULL
list1[[2]] <- list1[[2]][-9]

rm(list=ls())

# 연습해보기!

# 1. a에 1부터 10까지 홀수를 3번씩 출력하고 다음과 같은 matrix 저장하시오
#     [,1] [,2] [,3] [,4] [,5]
#[1,]   1    3    5    7    9
#[2,]   1    3    5    7    9
#[3,]   1    3    5    7    9
a <- matrix(rep(seq(1,10,2),each = 3), ncol = 5)
a <- matrix(rep(seq(1,10,2),times = 3),ncol = 5, byrow = T)
a <- matrix(rep(seq(1,10,2),times = 3),nrow = 3, byrow = T)

# 2. b와 c로 데이터 프레임을 d에 저장하시오
b <- c(1,2,3)
c <- c("a","b","c")
d <- data.frame(b,c)
# 3. a와 d로 리스트를 e에 저장하고 2번째층에 저장된 데이터프레임 2행 2열을 출력하시오
e <- list(a,d)
e[[2]][2,2]

###############################################################

##R 2회차 복습

#패키지 활용
#패키지 설치 <- install.pakages(pkgs = '패키지이름')
#패키지 불러오기 <- libraryr(패키지이름)

#현재 작업 폴더 확인
getwd() #작업폴더 지정 후 다시 확인할 것

#작업 폴더 지정
setwd() #()안에 작업 directory가 있어야 함
#또는 ctrl + shift + H로 작업 폴더 지정할 수 있음

#데이터 불러오기(csv)
read.csv('test.csv',header = T, skip = 0) #단 해당 데이터를 변수에 할당주지 않으면 데이터를 확인만 하는 용도
test <- read.csv('test.csv')
#read.csv('파일명+확장자',header = T)
#header : 첫 행 값을 변수이름으로 지정할 지(dafault : T)
#skip : 불러올 때 무시할 행의 개수
#fileEncoding = '인코딩' #같은 운영체제일 경우 생략 가능
  ## Windows 인코딩 : CP949/euc-kr
  ## mac/Linux 인코딩 : UTF-8  
  ## 상기 인코딩이 안될 경우 기존 엑셀 파일의 데이터를 새로 연 엑셀 파일에 붙여넣을 후 저장하여 다시 열어보기

head(read.csv('pop_seoul_euckr.csv'), header = T, skip = 0, fileEncoding = 'euc-kr')  ##ex)
pop_seoul <- read.csv('pop_seoul_euckr.csv')
View(pop_seoul) # 또는 우측 상황판의 pop_seoul 변수를 클릭하여 확인 가능

#데이터 샘플 확인
head(pop_seoul,10) #상위 10개 row 데이터
tail(pop_seoul,10) #하위 10개 row 데이터
str(pop_seoul) #데이터 구조 살펴보기
ls(pop_seoul) #데이터 변수 살펴보기
summary(pop_seoul) #데이터 요약하여 살펴보기
                   #강사님 자료에서는 행정구역별 & 구분에 class, mode 대신 강서구 : 3 이런 식으로 나왔는데
                   #이는 데이터 문자형이 다르기 때문, 강사님과 같이 데이터 출력을 원할 경우
                   #factor(pop_seoul$행정구역별) and factor(popup_seoul%구분) 후 다시 해볼 것
                   #char형 복구는 as.character(pop_seoul$행정구역별별)

#read.table()로 txt파일 불러오기
###tap으로 구분된 데이터

temp <- read.table('pop_seoul.txt', header = TRUE, fileEncoding = 'UTF-8')

#데이터 내보내기(csv) write.csv(변수명, 저장할 파일명, row.names = T(default), .....)
write.csv(pop_seoul,'aaa.csv',row.names = T)
write.csv(pop_seoul,'aaa1.csv',row.names = F)
write.csv(pop_seoul,'aaa2.csv')
#row.names : 행번호 부여할 것인지 <- T인 경우 sql의 rownum처럼 행 순서대로 번호가 부여됨

#데이터 불러오기(xlsx)
#xlsx는 openxlsx 패키지를 활용하여 불러올 수 있음,단 인터넷이 연결되어 있어야 함함
install.packages('openxlsx')

library(openxlsx) #필요시 library로 패키지 불러오기->read.xlsx() 사용 가능

sheet1 <- read.xlsx('test.xlsx', sheet = 1) #sheet가 여러 개일 경우 sheet 번호 설정(Default -> Sheet = 1)
sheet2 <- read.xlsx('test.xlsx', sheet = 2, startRow = 3) #데이터 시작 행 지정
sheet3 <- read.xlsx('test.xlsx', sheet = 3, colNames = F) #첫 행이 변수명이 아니라 데이터일 때

###R 데이터 불러오기 및 저장하기
new_data <- readRDS("iris.RDS")
saveRDS(new_data, "new_iris.RDS")#R 객체를 RDS 파일로 저장하기

##우측 workspace 불러오기 및 저장하기
load("iris.RData") #기존 작업 간 저장했던 우측 workspace의 변수 데이터 가져오기
iris4 <- iris

save.image("iris_image.RData")#image(우측 workspace) 저장
load("iris_image.RData")

##6 (실습) 다양한 데이터 불러오기
# 통계청 인구 데이터 
## 출처 : http://kosis.kr/statisticsList/statisticsListIndex.do?menuId=M_01_01&vwcd=MT_ZTITLE&parmTabId=M_01_01#SelectStatsBoxDiv

## 파일위치 :'data/'
## 파일이름 : '광역시도별_연령성별_인구수.xlsx'
## 데이터 시작 위치 : 2행
a <- read.xlsx('광역시도별_연령성별_인구수.xlsx', startRow = 2)
head(a)
str(a)
summary(a)

######################### 1번 연습문제 #############################
#1......... 통계청 가구별 주택 거주 데이터
## 출처 : http://kosis.kr/statHtml/statHtml.do?orgId=101&tblId=DT_1JU1501&vw_cd=&list_id=&seqNo=&lang_mode=ko&language=kor&obj_var_id=&itm_id=&conn_path=I2
## 파일위치 :'data/'
## 파일이름 : '시도별_가구_주택종류.xlsx'
## 데이터 시작 위치 : 2행
#2......... 통계청 가구별 주택 거주 데이터
## 출처 : http://kosis.kr/statHtml/statHtml.do?orgId=101&tblId=DT_1JU1501&vw_cd=&list_id=&seqNo=&lang_mode=ko&language=kor&obj_var_id=&itm_id=&conn_path=I2
## 파일위치 :'data/'
## 파일이름 : '시도별_가구_주택종류.xlsx'
## 데이터 시작 위치 : 2행
#3......... 국토교통부 아파트 실거래가 데이터(2018, 강남구)
## 출처 : http://rtdown.molit.go.kr/
## 파일위치 :'data/'
## 파일이름 : '아파트매매_2019_강남구.xlsx'
# 데이터 시작 위치 : 17행

install.packages('openxlsx')
library(openxlsx)

read.xlsx('시도별_가구_주택종류.xlsx', startRow = 2)
read.xlsx('시도별_가구_주택종류.xlsx', startRow = 2)
read.xlsx('아파트매매_2019_강남구.xlsx', startRow = 17)
#---------------------------------------------------------------------------##
rm(list=ls())
#산술연산자
a <- c(5,6)
b <- c(2,4)
A<-matrix(c(5,10,2,1), ncol=2)
B<-matrix(c(3,4,5,6), ncol=2)
a+b
a-b
A*B #행렬의 곱은 %*%, (5*3) + (2*4) ; (5*5) + (2*6) ; (10*3) + (1*4) ; (10*5) + (1*6)
a%*%b
a/b
a^b
a%%b  #벡터 변수의 나머지 
a%/%b #벡터 변수의 몫

rm(list = ls())
#비교연산자 비교항이 조건과 일치하면 True, 아님 False
x <- 2
y <- 3
x<y
x>y
x<=y
x>=y
x==y
x!=y

#논리연산자
1==1 & 3>4 # 둘 다 논리적으로 맞으면 True 아니면 False
1==1 & 3>4
1==1 | 3>4 # 둘 중 하나라도 논리적으로 맞으면 True 아니면 False
1==1 | 3>4

##데이터 열 추가
temp_df <-  data.frame(AA = 1:5, BB = rep(c("A","B"), c(2,3)))
head(temp_df)
tail(temp_df)
str(temp_df)
summary(temp_df)

temp_df$CC <- 1 # CC열 및 데이터 전부 1로 생성
temp_df$DD <- temp_df$AA + temp_df$CC

temp_df[,-1] #df의 특정 열 제거한 상태로 보기, 적용할 거면 변수에 재할당
temp_df[,-"AA"] #컬럼 번호가 아닌 명으로 삭제는 현 상태로는 불가하며
                # 관련 패키지로 하면 됨, 아닐 경우 위치나 변수로 제거 가능
names(temp_df) #모든 컬럼명 보기
which(names(temp_df)=="CC")# 특정 컬럼 번호 찾기


##데이터 추출하기(select)
sample_df <- data.frame(AA = rep(letters[1:5],10), BB=sample((50:70), 50, replace = T))
#sample(변수범위, 변수개수, replace = F(dafault) = 중복 변수 허용할 것인지) 

#cf) set.seed() 함수로 sample의 random 변수 나오는 값을 고정할 수 있음
set.seed(100)
sample(1:10,5,replace = T)
#set.seed() 함수를 실행 후 sample을 실행하면 set.seed(번호)에 해당 샘플값이 저장됨

#sample_df에서 AA 변수가 a인 행만 추출(2안) -> 편한 방법으로 사용
sample_df[sample_df$AA=="a",]
subset(sample_df, AA=="a")

#sample_df에서 AA 가 a or b인 행만 추출(2안) sql의 in과 같음
sample_df[sample_df$AA %in% c("a","b"),]
subset(sample_df, AA %in% c("a","b"))

#필요한 컬럼 선택 (로우는 컴마 전에 좌표를 쓰면 됌)
sample_df[,c("AA","BB")]
sample_df[,c(1,2)]
sample_df[,c(-3,-4)]

######################## 2번 연습문제 ##########################
data(iris)
head(iris)
# 1. Sepal.Length 변수의 짝수행을 출력하시오 . (3가지 방안으로 해보기)
iris$Sepal.Length[seq(2,length(iris$Sepal.Length),2)]
iris$Sepal.Length[1:150 %% 2 ==0]
iris[1:150 %% 2 ==0, 1]
iris[1:150 %% 2 ==0, "Sepal.Length"]
# 2. Subset을 사용해서 변수 Species 에서 setosa 인 데이터를 추출하시오
a1 <- subset(iris, Species == "setosa")
a1 <- iris[iris$Species =="setosa", ]
# 3. 2번에서 뽑은 데이터를 a1에 저장하고 Sepal.Length 가 5 보다 작은 Petal.Width 의 합을 구하시오
head(a1)
sum(a1[a1$Sepal.Length < 5,"Petal.Width"])

# 추가문제. a1 데이터에서 Sepal.Length가 높은 순으로 데이터 정렬하시오
a1[order(a1$Sepal.Length, decreasing = T),] #강사님께서 order는 방법에 따라 정렬 결과가 달라지므로
                                            #강의에서 뺐고, 추후 관련 패키지 교육을 해주신다고 함
#---------------------------------------------------------------------------#
rm(list=ls())

#데이터 합치기 -> cbind, rbind, merge ( merge가 사용 빈도수가 높음)
## rbind 나 cbind일반적으로 잘 활용하지 않음(개개인 성향)
## $를 활용한 변수 추가 혹은 key(id) 변수를 활용한 결합 활용
## 일단 사용 방법 익혀놓기

install.packages('openxlsx')
library(openxlsx)

GN = read.xlsx('아파트매매_2018_강남구.xlsx', sheet=1, startRow=17)
GD = read.xlsx('아파트매매_2018_강동구.xlsx', sheet=1, startRow=17)
SC = read.xlsx('아파트매매_2018_서초구.xlsx', sheet=1, startRow=17)
SP = read.xlsx('아파트매매_2018_송파구.xlsx', sheet=1, startRow=17)
#데이터 합치기 전 자료 구조 파악

names(GN) # columns name
str(SP) #데이터 구조
summary(GN) #데이터 요약

#상기 4개의 데이터는 모두 12개의 컬럼을 가지고 있으므로, 컬럼 기준으로 데이터 합치기(rbind)
GN4 <- rbind(GN, GD, SC, SP)
head(GN4)
str(GN4)
rm(list = ls())



my_data = data.frame(id = 1:5,
                     gender = c('M','F','F','F','M'),
                     age = seq(15, 35, 5))
another_data = data.frame(region = c('Seoul','Seoul','Seoul','Busan','Busan'),
                          amount = c(1,1,1,1,1))
str(my_data)
str(another_data)
#데이터를 살펴보면 행의 개수가 같고 열의 개수가 다르므로, rbind 불가(패키지를 사용하면 강제로 합칠 수 있음, 다음시간)
#cbind를 사용하여데이터 합치기
cbind(my_data, another_data)


#동일한 값 변수 추가
my_data$amout <- 100
my_data

##cf cut()을 활용하여 데이터를 범주로 구분하여 나눌 수 있음
my_data$age_urp <- cut(my_data$age, #범주를 나눌 기준 데이터
                       breaks = c(10,20,30,40), #범주 경계
                       include.lowest = T, #경계의 맨 좌측값(여기선 10)을 범주에 포함할 지
                       right = F, #우측 값을 범주에 포함할지 ex) 20을 10~20 사이 범주에 포함시킬지
                       labels = c("10_19","20_29","30_39")) #범주명, 경계가 4개이므로, 범주는 3개개
my_data
rm(list = ls())
#######조건에 맞는 데이터 합치기, merge() 매우 중요하고, 많이 쓰임
sales = read.csv('ex_sales.csv')
sales
prod  = read.csv('ex_prod.csv')
prod

#merge(x_data, y_data, by.x , by.y, all.x(or all.y))
#merge(x_data, y_data, by, all)
#x_data & y_data : 합칠 데이터 입력
#by.x : x의 어떤 데이터 기준으로 합칠지 / by.y y의 어떤 데이터 기준으로 합칠지
#by : x,y의 합칠 데이터 기준이 같을 경우 씀
#all : FALSE가 기본 값으로, False -> 교집합, TURE 합집합, all.x = TRUE X 전체, all.y Y 전체
merge(sales, prod, by = "PROD", all = FALSE) #prod 기준 정렬 및 합치고 교집합
merge(sales, prod, by = "PROD", all.x = TRUE)#prod 기준 정렬 및 합치고 x 전체 포함
merge(sales, prod, by = "PROD", all.y = TRUE)#prod 기준 정렬 및 합치고 y 전체 포함
merge(sales, prod, by = "PROD", all = TRUE) #prod 기준 정렬 및 합치고 합집합

######### 1:1, 다:1은 문제 없지만, 다:다 결합은 조심할 것!!!!!!!!!!!!!!!!!!!!!!
prod2 = read.csv('ex_prod2.csv')
prod2
##데이터를 살펴보면 category가 2가지이다 .이럴 경우 합치면
merge(sales, prod2, 'PROD')
##sales에서 Product B 상품이 각각 카테고리가 2가지로 나타날 경우가 있음
##데이터를 어떻게 활용할 지에 따라 조심할 것
##강사님 데이터 참고하여 해당 내용 다시 보기
rm(list = ls())
################################ merge 연습문제 ###################################

a1 <-  data.frame(name=c("aa","bb","cc"),value=seq(10,20,length.out = 3))
a2 <-  data.frame(name=c("cc","dd","ee"),value=seq(30,50,length.out = 3))
a3 <-  data.frame(name=c("aa","dd","ee","ff"),value=seq(20,80,length.out = 4),any=seq(0,3,1))

#  1. a1 와 a2 를 행결합 하시오
rbind(a1,a2)
#if 열결합일 경우
cbind(a1,a2) #단 컬럼이 일치하기에 열결합은 불필요 자료

# 2. a3 와 a1 를 행결합하시오
rbind(a3,a1) #컬럼 개수가 달라서 오류가 발생
             #이럴 경우 아래 신규 패키지 사용

install.packages("plyr")
library(plyr)
rbind.fill(a3,a1) #자료가 달라도 억지로 합침


# 3. a3 와 a2 를 name 기준으로 결합 하시오 (a3 데이터는 모두출력)
merge(a3,a2, "name", all.x = TRUE)
