rm(list = ls())

x <- 5
y <- 10
z <- 1:5

seq(1 , 10 , by = 2, length = 3)
seq(along.with = 1:10,4,1)

rep(c(1,2,3), 3)
rep(c(1,2,3), times = 3)
rep(c(1,2,3), times = 3, length.out = 5)
rep(c(1,2,3), each = 3)
rep(c(1,2,3), each = 3, length.out = 5)

# rep, seq를 한번에 사용하는 문
# 예제문제
#1. 1~100까지 짝수를 2번씩 출력(2 2 4 4 6 6 .... 100 100)
rep(seq(2,100,2),each = 2)
# 2. 1~5까지 숫자만큼 반복 출력(1 2 2 3 3 3 4 4 4 4 5 5 5 5 5)
rep(1:5,1:5)
rep(seq(1,5), times = 1:5)
rep(seq(1,5), times = c(1,2,3,4,5))

factor(c("A","A","B","A"), level = c("A","B","AB","O"), labels = c("A형","B형","AB형","O형"))
ordered(c("A","A","B","A"), level = c("A","B","AB","O"), labels = c("A형","B형","AB형","O형"))

vec <- 1:5
vec[1]
vec[c(2,3,5)]
vec[6] <- 6
vec
vec[c(-2,-3)]
length(vec)

matrix
AA = 1:10
dim(AA) <-c(2,5) 
rownames(AA) <- paste0("a",1:2)
colnames(AA) <- paste0("b",1:5)

# matrix 문제
# 1. vector 생성
# A = (1.0 1.5 1.5 2.0 2.0 2.0 2.5 2.5 2.5 2.5 3.0 3.0 3.0 3.0 3.0)
# B = (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)
A <- rep(seq(1,3,0.5), 1:5)
B <- 1:15

# 2. A & B 벡터를 이용해 matrix 생성
# 단, 열 개수 5개, 행 기준 B의 데이터 입력 완료 후 A 입력
M <- matrix(c(B,A), ncol = 5, byrow = T)

# 3. 행렬 M에 대해 열 이름 지정 Col1 ~ Col5
colnames(M) <- c("Col1","Col2","Col3","Col4","Col5")
colnames(M) <- paste0("Col",1:5)


mat <- matrix(1:9, ncol = 3, byrow= T)
test <- as.data.frame(mat)
test

son <- list(son.name = c("Minsu","Minchul"), son.cnt = 2, son.age = c(2,6))
length(son)
mode(son)
names(son)
names(son) <- c("son_name", "son_cnt", "son_age")
names(son)
names(son) <- paste0("son_", c("name","cnt","age"))

str(son)
summary(son)
son[[1]]
son[[1]][1]
son$son_name[1]

###리스트 연습문제
#강의 교본 문제 참고
#1. 
x.list <- list(c(41,25,35), matrix(10:17, ncol = 2, byrow = F), c("Kim","Lee","Cho"))
x.list

#2. x.list에서 2번째층 메트릭스 3행 2열 출력
x.list[[2]][3,2]

#--------------------------1주차-1회차 복습내용--------------------
##1회차 복습
# 1. a에 1부터 10까지 홀수를 3번씩 출력하고 다음과 같은 matrix 저장하시오
#     [,1] [,2] [,3] [,4] [,5]
#[1,]   1    3    5    7    9
#[2,]   1    3    5    7    9
#[3,]   1    3    5    7    9
a <- matrix(rep(seq(1,10,2), each = 3), ncol = 5, byrow=F)
# 2. b와 c로 데이터 프레임을 d에 저장하시오
b <- c(1,2,3)
c <- c("a","b","c")
d <- data.frame(b,c)
# 3. a와 d로 리스트를 e에 저장하고 2번째층에 저장된 데이터프레임 2행 2열을 출력하시오
e <- list(a,d)
e[[2]][2,2]


getwd()
read.csv('test.csv')
test <- read.csv('test.csv')
pop_seoul <- read.csv('pop_seoul_euckr.csv')
View(pop_seoul)
data.entry(pop_seoul)

head(pop_seoul)
head(pop_seoul, n = 10)
tail(pop_seoul, n = 10)
str(pop_seoul)
summary(pop_seoul)

temp <- read.table('pop_seoul.txt', header = T, fileEncoding = 'utf-8')

write.csv(pop_seoul, file='aaa.csv', row.names = F)

install.packages('openxlsx')
library(openxlsx)

sheet1 <- read.xlsx('test.xlsx', sheet = 1, startRow = 1, colNames = T)
sheet2 <- read.xlsx('test.xlsx', sheet = 2, startRow = 3, colNames = T)
sheet3 <- read.xlsx('test.xlsx', sheet = 3, startRow = 1, colNames = F)

rm(list = ls())
new_data <- readRDS('iris.rds')
saveRDS(new_data, "new_iris.RDS")

rm(list = ls())
load('iris_image1.rdata')
iris4 <- iris
save.image('iris_image1.rdata')
##saveRDS & readRDS, load & save.image 시
##불러오는 or 저장할 파일명의 확장자는 대소문자 구분 없음

######################### 1번 연습문제 #############################


##6 (실습) 다양한 데이터 불러오기
# 통계청 인구 데이터 
## 출처 : http://kosis.kr/statisticsList/statisticsListIndex.do?menuId=M_01_01&vwcd=MT_ZTITLE&parmTabId=M_01_01#SelectStatsBoxDiv
## 파일위치 :'data/'
## 파일이름 : '광역시도별_연령성별_인구수.xlsx'
## 데이터 시작 위치 : 2행
#-----------
# 통계청 가구별 주택 거주 데이터
## 출처 : http://kosis.kr/statHtml/statHtml.do?orgId=101&tblId=DT_1JU1501&vw_cd=&list_id=&seqNo=&lang_mode=ko&language=kor&obj_var_id=&itm_id=&conn_path=I2
## 파일위치 :'data/'
## 파일이름 : '시도별_가구_주택종류.xlsx'
## 데이터 시작 위치 : 2행
#-----------
# 국토교통부 아파트 실거래가 데이터(2018, 강남구)
## 출처 : http://rtdown.molit.go.kr/
## 파일위치 :'data/'
## 파일이름 : '아파트매매_2019_강남구.xlsx'
# 데이터 시작 위치 : 17행

install.packages('openxlsx')
library(openxlsx)
a <- read.xlsx('광역시도별_연령성별_인구수.xlsx', startRow = 2)
b <- read.xlsx('시도별_가구_주택종류.xlsx', startRow = 2)
c <- read.xlsx('아파트매매_2019_강남구.xlsx', startRow = 17)
rm(list = ls())

a <- c(8,9)
b <- c(3,4)
a+b
a-b
a*b
a-b
a%/%b
a%%b

a <- matrix(c(5,10,2,1), ncol = 2)
b <- matrix(c(3,4,5,6), ncol = 2)
a%*%b

x <- 2
y <- 3
x==y
x!=y
x<y
x<=y
x>y
x>=y
1==1 & x==y
1==1 | x==y
rm(list = ls())

tmp_df <- data.frame(AA = c(1:5), BB = c("A","A","B","B","B"))
head(tmp_df)
tmp_df$CC <- 1
tmp_df$DD <- tmp_df$AA + tmp_df$CC
tmp_df

which(names(tmp_df)=="CC")
tmp_df[,-3]
tmp_df[,c("AA","BB","DD")]

sample.df <- data.frame(AA = rep(letters[1:5],10), BB = sample(60:70, 50, replace = T))
sample.df

sample.df[sample.df$AA =='a',]
subset(sample.df, AA =='a')

sample.df[sample.df$AA %in% c('a','b'),]
subset(sample.df, AA %in% c('a','b'))
rm(list = ls())
######################## 2번 연습문제 ##########################
data(iris)
head(iris)

# 1-1. Sepal.Length 변수의 짝수행을 출력하시오.
iris[1:length(iris$Sepal.Length)%%2==0,1]
iris[seq(1,length(iris$Sepal.Length))%%2==0, "Sepal.Length"]
subset(iris, 1:length(iris$Sepal.Length)%%2==0)
# 1-2. Sepal.Length 변수의 짝수값만 출력하시오.
iris[(iris$Sepal.Length*10)%%2==0,1]
iris[iris$Sepal.Length%%0.2==0,1]
# 2. Subset을 사용해서 변수 Species 에서 setosa 인 데이터를 추출하시오
subset(iris, Species == "setosa")



library(openxlsx)
GN = read.xlsx('아파트매매_2018_강남구.xlsx', sheet=1, startRow=17)
head(GN)
tail(GN)

GD = read.xlsx('아파트매매_2018_강동구.xlsx', sheet=1, startRow=17)
head(GD)

SC = read.xlsx('아파트매매_2018_서초구.xlsx', sheet=1, startRow=17)
SP = read.xlsx('아파트매매_2018_송파구.xlsx', sheet=1, startRow=17)
names(GN)
str(GN)

GN4 = rbind(GN, GD, SC, SP)
str(GN4)
summary(GN4)

my_data = data.frame(id = 1:5,
                     gender = c('M','F','F','F','M'),
                     age = seq(15, 35, 5))
another_data = data.frame(region = c('Seoul','Seoul','Seoul','Busan','Busan'),
                          amount = c(1,1,1,1,1))
cbind(my_data, another_data)
my_data$amount <- 100
my_data$age_grp <- cut(my_data$age,
                       breaks = c(10,20,30,40),
                       include.lowerest = TRUE,
                       right = FALSE,
                       labels = c('1019','2029','3039'))
my_data


sales = read.csv('ex_sales.csv')
prod  = read.csv('ex_prod.csv')

merge(sales, prod, by = 'PROD', all = F)
merge(sales, prod, by = 'PROD', all.x = T)
merge(sales, prod, by = 'PROD', all.y = T)
merge(sales, prod, by = 'PROD', all = T)

################################ merge 연습문제 ###################################

a1 <-  data.frame(name=c("aa","bb","cc"),value=seq(10,20,length.out = 3))
a2 <-  data.frame(name=c("cc","dd","ee"),value=seq(30,50,length.out = 3))
a3 <-  data.frame(name=c("aa","dd","ee","ff"),value=seq(20,80,length.out = 4),any=seq(0,3,1))

#  1. a1 와 a2 를 행결합 하시오

rbind(a1,a2)


# 2. a3 와 a1 를 행결합하시오
rbind(a3,a1)
install.packages("plyr")
library(plyr)
rbind.fill(a3,a1)


# 3. a3 와 a2 를 name 기준으로 결합 하시오 (a3 데이터는 모두출력)
merge(a3,a2, by = 'name', all.x=T)