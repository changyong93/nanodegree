######## 작업 폴더 설정
getwd() #현재 폴더 확인
setwd(directory) #작업폴더 지정, directory 반드시 필요
#혹은 ctrl + Shift + H로 작업폴더 지정
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
######## 데이터 불러오기 & 내보내기
write.csv(pop_seoul, file = 'aaa.csv', row.names = F)
#저장할 변수, 저장할 파일명(경로설정, 여기선 작업폴더에 저장),
#row.names = T/F-> T면 따로 sql의 rownum처럼 컬럼 생성됨

read.csv('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/R/강의자료/데이터/test.csv')#다른 작업폴더일 겨우 따로 경로 지정해야함
                                #단, 하위폴더 시 구분은 \(역슬래시)가 아닌 /(슬래시)
read.csv('test.csv') #지정한 작업폴더의 csv파일일 경우
read.csv('test.csv', fileEncoding = 'CP949') #window 인코딩
read.csv('test.csv', fileEncoding = 'euc-kr') #window 인코딩
read.csv('test.csv', fileEncoding = 'utf-8') #mac 인코딩
#fileEncoding이나 encoding이나 둘 다 같은 변수로 적용됨
#인코딩은 세 개다 해보고 안될 경우 데이터 excel 파일을 새로 만들어서 기존 데이터 저장후 다시 해보기
#같은 운영체제는 인코딩 생략 가능능

read.xlsx('test.xlsx', sheet = 1, startRow = 3, colNames = T)
  #openxlsx 패키지 및 파이브러리가 실행된 상태에서 함수 사용 가능
  #sheet : 시트 번호 1(default)
  #startRow = 불러올 데이터의 첫 Row 1(default)
  #colNames = T(default/F 불러올 첫 row가 컬럼명이 맞는지
white.xlsx()

read.table('test.txt', header = F, fileEncoding = '')
  #read.table(파일명, header = T/F(첫 줄을 컬럼명으로 할당할지))
write.table()

readRDS("iris.rds") # R파일을 R데이터 형태로 가져오기
saveRDS(new_data, file = "new_iris.rds")# RDS 파일로 저장
      #  변수명,   저장 파일명

load('iris.rdata') #저장해놨던 workspace 데이터 가져오기, 변수할당 불필요
save.image('iris.rdata') # workspace 데이터 저장
save(iris1, iris2, file = 'iris_data.rdata') #workspace의 변수 일부 저장
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
########workspace 관련
ls() # workspace의 변수 목록 출력
ls.str() # workspace의 변수 목록 및 데이터 출력
rm(변수명) #workpace의 변수 선택하여 삭제
rm(list = ls()) #workpsace의 모든 변수 삭제

########데이터 확인
mode() # 물리적 데이터 형태
class() # 함수로 사용 시 구분되는 데이터 형태
typeof() #변수 타입
summary() #자료 전체 요약
head() #데이터 상위 n개
tail() #데이터 하위 n개
str() #데이터 구조 확인
sapply(iris, class) # 변수 구조 확인
names() #변수 별칭
length() #데이터 길이
sum() #데이터 합계
dim() #matrix 데이터 행렬 개수
      #dim(벡터변수명) <- c(nrow,ncol) 시 matrix생성됨
which(names(dataframe) == "컬럼명") # 해당 컬럼의 번호 찾기
unique() #데이터 중복값 없이 종류 확인할 때때
table() #범주형 데이터 범주별 빈도수 계산
which.max() #각 팩터 중 가장 빈도수가 높은 팩터
expand.grid() #데이터 모든 경우의수 보기
nrow() # row 개수 반환
ncol() # col 개수 반환
rowSums(x, na.rm = FALSE) #row sum, na를 제외할지 여부
colSums(x, na.rm = FALSE) #col sum, na를 제외할지 여부부

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#dplyr 함수로 필요한 데이터 조회
dplyr::filter(data, filter방법) #sql where와 같음
dplyr::arrange(data, arrange_method) # 오름차순 / 내림차순(desc(data))
dplyr::select(data, col명) #data의 특정 컬럼 선택
distinct(data, col명) #반복 내용 제거하여 불러오기
                      #중복 내용 없애는 연산이 추가되어 대용량 처리시 오래 걸림
                      #간단한 분류만
dplyr::mutate(data, new_col_name = 데이터셋) #새로운 컬럼 추가
dplyr::count(data, col_name) #특정 그룹별 개수 세기
                             #col_name 부분은 option
dplyr::group_by(data, col_name) # data를 어떤 col_name 기준으로 그룹화 할 것인지 인지시키는 작업
dplyr::summarize(data, 요약방법) # summarise(UK)도 같음 summarize(US) 
dplyr::top_n(data, n , col_name) #data를 col_name 기준으로 상위 5개 보기
data %>%  #파이프 라인, %>% 기준 아래로 갈수록 해당 내용과 같이 내용 조회
  filter() %>% #ctrl + shift + m
  group_by
#--------------------------------------------------------------------------------------------------
########데이터 형태 변경
as.data.frame(data)
as.data.frame(t(data)) # row & col date 치환
as.character(data) #문자형으로 변환
as.matrix(data)
factor(data) # 범주형으로 변환

apply(x,margin,func) #x :배열&행렬, margin: 함수 적용 방향으로 1(열방향)2(행방향)
                     # mat이나 vector로 결과  출력

lapply(x,func,...) # 리스트트 형태로 데이터 출력
                    #x :벡터,리스   트,표현식,DF / func 적용 함수
                    #... : 추가 인자로, 이 인자들은 Func에 전달됨
sapply(x,func, simplify= T/F) # T simplify T(default) : vector나 mat출력 / F : list출력(=lapply)
tapply(X,INDEX,FUNC,...) #결과값은 배열(array)
  #X, 벡터
  #INDEX, 데이터를 그룹으로 묶을 색인. 
  #       팩터를 지정해야 하며 팩터가 아닌 타입이 지정되면 팩터로 형 변환된다.
  #FUNC,    # 각 그룹마다 적용할 함수
  #...,    # 추가 인자. 이 인자들은 FUNC에 전달된다.


unlist(x, recursive=FALSE, use.names=TRUE)
  #x, R 객체. 보통 리스트 또는 벡터
  #recursive=FALSE, x에 포함된 리스트 역시 재귀적으로 변환할지 여부로, 리스트안에 리스트가 있을 경우 안쪽 리스트도 형태를 없애겠느냐에 대한 여부
  #use.names=TRUE 리스트 내 값의 이름을 보존할지 여부

do.call(func, what) #func을 what에 적용하여 리스트 결과를 반환

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
########데이터 추출
subset(dataframe, dataframe_colname) #해당 컬럼 추출
subset(dataframe, dataframe_colname%%2 == 0) #비교 연산자 조건에 일치하는 로우 데이터 추출
dataframe[dataframe$dataframe_rowname,] # 해당 로우 추출
dataframe[1,] # 해당 로우 추출
dataframe[dataframe$dataframe_colname == 0,] #비교 연산자 조건에 일치하는 로우 추출
dataframe[,dataframe$dataframe_colname] #해당 컬럼 추출
dataframe[,1] #해당 컬럼 추출
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#######데이터 편집기
edit(변수명) #행렬 or 데이터프레임과 같은 형태만 가능
data.entry(변수명)
View(변수명) #workspace의 데이터를 더블 클릭하는 것과 같음
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
####### 데이터 합치기 및 추가
rbind(df1, df2) # 행(row)로 결합, 로우 개수 증가
                # 컬럼명 및 개수가 일치해야 함
cbind(df1, df2) # 열(column)로 결합, 컬럼 개수 증가
                # 로우 개수 일치해야 함

rbind.fill(df1,df2) #plyr 패키지 설치시 가능능
######rbind, 강제 결합을 원할 경우 plyr 패키지 설치

merge(df1, df2, by.x =1 , by.y =2, all = F)
#by.x와 by.y가 일치하면 by = 로 변경 가능
#all.x=T(df1기준 합치기) or all.y=T(df2기준 합치기) or all=F(교집합) or all=T(합집합)
#****** 다:1, 1:1 결합 OK / 다 : 다 결합은 절대 안됨
#merge(df1,df2,by=col1, all.x=T) 등과 같이 결합 시 데이터 개수 증가하면 의심해야 함

my_data$age_grp = cut(my_data$age, 
                      breaks=c(10,20,30,40), 
                      include.lowest=TRUE, #가장 왼쪽값을 포함하는지 ex)10을 포함하는지
                      right=FALSE,
                      labels=c('10_19','20_29','30_39')) #구간이 4개니 범위는 3개

## cut( )을 활용한 연령대 변수 추가, 범위 기반으로 자르는 함수
## breaks : 구간 경계값
## include.lowest : 첫 경계값 포함 여부(ex) 10이 첫 범주에 포함할지
## right : 각 구간의 오른쪽 경계 포함 여부 (ex)20을 10~20 범주에 포함할지
## labels : 각 구간의 이름


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#######데이터 생성
aa <- 1:10 #실수 데이터 값 할당
ba <- c(1:10) #실수 데이터 값 할당
ca <- c("X","Y","Z") #문자형 변수 할당
da <- letters[1:10] #알파벳 소문자 a부터
ea <- LETTERS[1:10] #알파벳 대문자 A부터
fa <- matrix(c(aa,ba), ncol = 5 ,byrow = F) #메트릭스 생성(ncol or nrow, byrow = FALSE(default, 열부터 데이터 할당))
##matrix 행렬이름 지정(1)
rownames(fa) <- c("a1","a2","a3","a4") #row개수만큼
colnames(fa) <- c("A1","A2","A3","A4","A5")#col 개수만큼
##matrix 행렬이름 지정(1)
rownames(fa) <- paste0("a",1:4) #변수명이 특정 문자 기준으로 반복되는 경우
colnames(fa) <- paste0("A",1:5)

ga <- array(1:8, c(2,2,2)) #array(벡터 개수, 데이터 형태) -> c(2,2,2) 3차원 데이터
ha <- data.frame(aa,da,ea)
ia <- seq(1,10,2,3) #sequence(초기값, 최종값, 증가분, 데이터수)
ja <- seq(along.with = 1:10,4,1)#sequence(along.with = 데이터 개수, 시작값(option), 끝값(option)) #실수형으로 계산도 가능
ka <- rep(ca, 3) #replicate(데이터, times = (객체 반복수), length.out = 데이터를 몇 등분 할 지, each = (개별 원소 반복수))
ja <- list(AA = aa, BB = ba, CC = ca) #list, 각 데이터의 변수명 입력은 선택사항
ma <- factor(c("O","AB","A"),levels = c("A","B","AB","O"),labels=c("A형","B형","AB형","O형")) #범주형, 순서X , level과 label 지정 안할 시 입력 데이터로 알아서 라벨링
na <- ordered(AgeG, levels=c(1,2,3,4), labels=c("20대 이하","30대","40대","50대 이상")) #범주형, 순서O, level과 label 입력 안할 시 입력 데이터로 범주 할당
oa <- sample(1:6,10,replace = T)# sample (범위, 추출수, replace = 중복가능)
sample(1:2, 400, prob = (0.4,0.6), replace = T)
#1,2를 40%, 60% 확률로 400개 추출
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#기타
set.seed(1233) 
sample(1:6,10,replace=T) #set.seed(번호)과 sample()을 순서대로 실행 시 set.seed(번호)에 sample 값 저장됨

#AA컬럼의 값중에서 a인 값만 추출
#Type1
Sample.df[Sample.df$AA == "a",] 
#Type2
# subset(데이터, 조건)
subset(Sample.df, AA == "a") 

#AA컬럼의 값중에서 a orb 값 추출
#Type1
Sample.df[Sample.df$AA %in% c("a","b"),] #%in% c() 괄호안의 데이터 기준이 or로 적용
#Type2
subset(Sample.df, AA %in% c("a","b"))

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##tidyr 패키지 함수
spread(데이터 , 기준변수, 나열할 값)
# 데이터를 기준 변수로 열 펼치기

#단 데이터가 기준 변수에 따라 없는 값이 생성됨(NA)
#이를 처리하기 위한 함수
drop_na(결측치를 찾을 변수1, 변수2,...)
#변수 입력 안할 경우 NA가 있는 행 모두 버리기
#변수 입력 하면 변수에 NA가 없으면 행 버리기

replace_na(list(변수1=값,변수2값,...))
#변수마다 NA가 있을 경우 변경할 값 입력
#spead와 replace_na는 세트로 적용됨


spread() <-> gather()
gather(데이터명, 새기준변수이름, 새변수이름, 모을 변수들)
gather(category, count, 족발보쌈, 중국이름)
#족발보쌈, 중국이름 등을 카테고리열에 담고, 각 변수마다 count 개수 넣기

complete(컬럼1, 컬럼2, 컬럼3,..., fill=list(변수1 =0, 변수2=0,...))
#데이터를 보면 특정 기준에 아무런 데이터가 없어서 경우의 보다 데이터가 적을 경우가 있음
#이럴 경우 complete함수로 나머지 경우의 수를 생성하고, fill로 이 데이터의 NA를 특정 값으로 변경

#--------------------------------------------------------------------------------------------------
#stringr 패키지 내장함수
#### 패턴찾기 ####

#str_detect(데이터, 패턴)
x <- c("apple", "banana", "pear")
str_detect(x, "e") #특정 문자가 있는지 -> 논리형 T or F, 숫자로 바꾸면 T->1, F->0

#str_count(데이터, 패턴)
str_count(x,"e") #특정 문자 개수 반환

#str_which(데이터, 패턴)
str_which(x,"e") #특정 문자의 위치 반환

#str_locate(데이터, 패턴)
str_locate(x,"a")

#텍스트 내에서 특정 문자 위치 반환
#단 eeeee가 여러개 있더라도, 찾는 문자는 e 하나기에 하나의 위치만 반환
#ee로 하면 start = 4번 / end = 5번


### 부분집합 찾기
#str_sub(데이터, 시작, 끝)
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)
str_sub(x, -3, -1) #뒤에서부터
#각 문자에서 특정 범위의 문자열 가져오기
substr(x,1,3)
#str_sub(stringr 패키지 내장 함수) = substr(R 내장함수)
#편한거 사용하면됨, 강사님은 str_sub 사용하심


#str_subset(데이터, 패턴)
str_subset(x,"r") ##특정 데이터가 포함된 텍스트를 조회하기


### 문자열 변형하기
# str_replace(데이터,찾는변수,바꿀변수)
# str_replace_all(데이터,찾는변수,바꿀변수)
str_replace("apple","p","l") #처음 찾은 p 문자를 l로 변환
str_replace_all("apple","p","l") #텍스트 내의 모든 p를 l로 변환
#불용어 처리할 때 많이 사용


# Mutate STrings
str_to_lower("STRING") #소문자로
str_to_upper("string") #대문자로
str_to_title("string") #첫 글자만
str_to_title("ko-string") #첫 글자만, 구분자 구분함
#-----------------------------------------------------------------------------------------
#lubridate 패키지 내장 함수
library(lubridate)
# 기본적으로 일반 텍스트 데이터를 날짜 데이터로 바꿉
as.Date('2020-01-01') #텍스트 전재, 날짜를 알아볼 수 있는 텍스트라면 OK

# lubridate에 들어 있는 ymd() 함수는 어떤 모양이든 이를 날짜로 인식!
ymd('20200110')
mdy('January 10th 2020')
dmy('10-jan-2020')
ymd('820327')
ymd(820327)
#y : year, m : month, d : day

# 날짜 데이터 뽑아내기
date_test <- ymd(191020)

year(date_test)
month(date_test)
day(date_test)
week(date_test) #연도 기준 몇주차인지
wday(date_test) #0 일요일 ~ 6 토요일
wday(date_test,label = T) #요일 반환

# 날짜로 각종 계산하기
date_test + days(100) #100일 후
date_test + months(100) #100개월 후
date_test + years(100) #100일 후

date()
today()
today()-date_test


# 날자 + 시간 데이터
ymd_hm(20-10-20 14:30) #시간이 포함된 경우 :(콜론)이 들어가기에 따움표로 묶어줘야 함
ymd_hm("20-10-20 14:30")
date_test2 <- ymd_hm("20-10-20 14:30")
hour(date_test2)
minute(date_test2)
second(date_test2)

#-----------------------------------------------------------------------------------------
#결측치 처리

#결측치 확인
is.na(df)
table(is.na(df)) # 전체에서 
table(is.na(df$sex)) #행기준
summary(df) #결측치 개수 반환, 단 문자형은 반환 X

#결측치 제거
df$filter(!is.na(score)) #특정 열에서 na가 있는 행을 제외하고 반환
na.omit() #결측치 행 제거, 단 행 번호 유지
# = tidyr::drop_na() #결측치 행 제거, 행 번호 재지정

#결측치 대체
ifelse(is.na(df$score),4,df$score) #결측치가 있으면 특정 값으로 변환
df[is.na(df$score),"hwy"] <- mean(df$score, na.rm=T)
#특정 열의 na를 na 제외한 평균 값으로 대체

##zoo 패키지 내장 함수 na.locf0를 이용한 결측치 정리
na.locf0(c(NA, NA, "A", NA, "B"), fromLast = FALSE) # 1
## [1] NA  NA  "A" "A" "B"
## NA가 있을 경우 왼쪽 데이터를 그대로 사용

na.locf0(c(NA, NA, "A", NA, "B"), fromLast = TRUE) # 2
## [1] "A" "A" "A" "B" "B"
## NA가 있을 경우 오른쪽 데이터를 그대로 사용

#----------------------------------------------------------------------------------
#시각화

options("scipen" = 100) #지수옵션 풀기 "scipen=4이상이면 다 지수풀기기
options(scipen = 100) #괄호 안해도 됌
options("scipen" = 0) #지수옵션

## RColorBrewer 패키지의 함수 - 팔레트 색상 조합 사용
# 패키지 내 모든 색상조합 확인  
display.brewer.all()  ## 색상조합 이름 확인
brewer.pal(9, 'Set1') #brewer.pal(개수, 조합명) 조합에서 몇개의 색상을 랜덤으로 가져올지

## ggplot2 패키지, 부를땐 ggplot
aes(x = ) #x 지정
aes(y = ) #y축 지정
aes(color = ) #color 지정 - 산점도 등
aes(fill = ) #color 지정 - boxplot, bar
#color, fill 헷갈리면 둘 다 기입
aes(shape = ) #데이터 형상
aes(size = ) #사이즈
aes(alpha = ) #투명도

facet_grid(~변수명) #특정 변수로 구분하여 플랏 생성
                    #변수명이 year명 년도별 플랏 생성됨

geom_point() #산점도
geom_boxplot()#박스플랏
geom_bar()#바플랏
geom_histogram()#히스토그램
geom_tile # 히트맵

#그래프 테마(바탕)
theme_bw()
theme_classic()
theme_dark()
theme_light()
theme_linedraw()
theme_minimal()
theme_test()
theme_void()

#범례제목 수정
labs(fill = "범례명")

#그래프에 숫자 넣기
#막대형 기준
#그래프가 누적값일 경우, y=변수1에서 변수1의 누적값 위치 저장
mutate(pos = cumsum(변수1)- 0.5*변수1)
#단 group_by & arrange로 그래프 누적 순으로 행을 맞춰준 후 누적합 구하기
geom_text(aes(label=변수1, y=변수1) size=10) #size : 글자사이즈

#facet_grid로 누적값별로 다 그래프로 나눈 경우
#누적위치 pos 생성 불필요
geom_text(aes(label=변수1),vjust=+-숫자)
#개별일 경우 label만 입력해도 적당한 위치에 값이 생성되는데
#바가 수직형일 경우 vjust = 값(+-으로 위치 조정해도 되고
#aes(label = 변수1, y=변수1+ 값(+-)으로 위치 조정 가능
#단 aes안에 있을 경우 값 기준은 y축 unit 기준, aes밖이면 그래프 좌표기준

# 범례 테두리 설정
theme(legend.position = "top")
theme(legend.position = "bottom")
theme(legend.position = c(0.9,0.7))
theme(legend.position = 'none')
##이건 그래프마다 정해야 하서 수작업해야 하는 단점이 있음

#축 변경
# 이산형 - deiscreate()
# 연속형 - continuous()
scale_x_discrete(labels = c("하","중","상")) +
scale_y_continuous(breaks = seq(0,8000,by = 1000))

#색변경
#범주형
scale_fill_brewer(palette='Set1') #box, bar
scale_fill_brewer(palette='Set1',direction = -1) #box, bar 색상 반전
scale_fill_manual(values = c('red','royalblue','tan')) #bar, boxplot,...
scale_fill_manual(values = rev(c('red','royalblue','tan'))) #bar, boxplot,... 색상 반전
#manual은 범주 개수만큼 설정해야 함
#연속형
scale_fill_distiller(palette='Set1')#heatmap #팔레트 이용
scale_fill_distiller(palette='Set1',trans="reverse") #heatmap #색반전
scale_fill_gradient(low='white', high='#FF6600') #heatmap #처음과 끝 색 지정

#x,y축 바꾸기
coord_flip()

#그래프 제목 추가
ggtitle()

#축 & 범례 텍스트 크기 및 배치 조정
theme(legend.position = 'none',
      axis.text.x = element_text(size = 15,angle = 90),
      axis.text.y = element_text(size = 15),
      legend.text = element_text(size = 15))

# 그래프에 평행선, 수직선, 대각선을 그릴 수 있는 명령어

ggplot(NULL) +
  geom_vline(xintercept = 10, 
             col = 'royalblue', size = 2) +
  geom_hline(yintercept = 10, linetype = 'dashed', 
             col = 'royalblue', size = 2) +
  geom_abline(intercept = 0, slope = 1, col = 'red',
              size = 2) +
  theme_bw()


#--------------------------------------------------------------------------------
#R통계
#sampling 패키지 내장 함수
strata(date, size, method, stratanaems)
strata(c("Species"), size=c(3, 1, 1), method="srswr", data=iris)
#Species별(층화) size에 따라 각 3개 1개 1개 추출

#이항분포 -> n30이상 시 정규분포화 가능
rbinom(n=100,size=5,prob=0.5)
dbinom(x=3,size=5,prob=0.5) #확률밀도함수 5C3*(1/2)^3*(1/2)^2
pbinom(q=2,size=5,prob=0.5) #누적 확률

#연속 확률 분포
# 정규분포
rnorm(n, mean = , sd = ) # 평균과 분산에 해당하는 랜덤 샘플, 난수함수

dnorm(x, mean = , sd = ) # 확률 밀도함수

pnorm(p, mean = , sd = ) # 누적 분포함수
                         # lower.tail=FALSE 입력 시 p기준 우측 분포 구함
qnorm(n, mean = , sd = ) # 분쉬수 함수
                         # lower.tail=FALSE 입력 시 -Z값으로 인식
#--------------------------------------------------------------------------------
####
#정규성 검증 시 샤피로 이외에도 왜도 첨도도 확인해야 함
library(moments)
skewness(data1) #왜도
kurtosis(data1) #첨도
#상관관계분석, T,F,카이제곱검정

#상관관계
library(psych)
pairs.panels() #상관관계그래프화,유수기능이 내장되어 있어서 결측치 처리 불필요

library(PerformanceAnalytics) 
chart.Correlation(acs2, histogram=TRUE, pch=19) #상관관계그래프화,유수기능이 내장되어 있어서 결측치 처리 불필요
                                                #pairs.panels보다 시각화우수
library(corrplot)
corrplot(cor(acs2,use="na.or.complete"),method="pie") #결측치 처리해야 함
#method로 그래프 형태 지정, square, ellipse,number,shade,color,pie,....

#상관관계
cor(data1,data2) #숫자형 데이터 상관관계 분석
#method : pearson(default), spearman, kendall

#독립표본
tapply(score,group,shapiro.test)
shapiro.test() #0.05초과이면 귀무채택 -> 정규성

qqnorm()
wilcox.test() #shapiro 0.05이하시 진행
var.test(data1,data2) #정규성 띄울 시 진행=>0.05초과 귀무채택 ->등분산
#t-test1
t.test(data1,data2,var.equal = T) #0.05이하면 그룹간 차이 있음(대립채택)
#var.test 시 이분산이면 var.equal=F
#t-test2
t.test(value~group,data,var.equal=T)

#대응표본
shapiro.test()
tapply(score,group,shapiro.test)
t.test(data1,data2,paired = T) #shapiro 0.05초과
wilcox.test(data1,data2, paired=T) #shapiro 0.05이하

#자료 확인, tapply와 같음
aggregate(score~as.factor(group),data=anova_data,mean)
tapply(anova_data$score,anova_data$group,mean)

#분산분석(F검정)
kruskal.test()#shapiro 0.05미만
bartlett.test(score~group,data)#shapiro0.05초과이며, p값이 0.05초과 시 등분산(귀무채택)
oneway.test(score~group,data,var.equal = T) #가설검정 특화
summary(aov(score~group,data=anova_data)) #분산분석표 확인 가능
#summary(aov())와 같은 코드
anova(lm(score~as.factor(group),data=anova_data))


library(laercio) #사후분석, lduncan,ltukey 내장
LDuncan(aov_result, "group") #aov 결과와 범주 입력
TukeyHSD(aov(score~as.character(group),data=anova_data))
#범주는 반드시 문자형으로 입력해야 함
plot(TukeyHSD()) #하면 그래프로 표현

#카이제곱검정
chisq.test()$expected #기대빈도 구하기기
chisq.test(data_범주형1,data_범주형2,correct=T)
#비연속적 이항분포에서 확률이나 비율을 알기 위해 연속적 분포로 만들기 위한 교정
#적합성 분석(특정 확률) or 독립성 분석(연관있는지, 이걸 많이 함)

library(gmodels) #CrossTable
CrossTable(data_범주형1,data_범주형2,chisq=T,prop.t=F)
#format='SPSS'추가 시 100% 비율로 나옴
CrossTable(table(data_범주형1,data_범주형2))
#첫번째 코드결과+전체에서 각각비율 나옴
#https://wikidocs.net/34030 참고하여 카이제곱 검정 할 것
fisher.test() #기대빈도수 5이하면 chisq대신 이걸로 진행
prop.trend.test(xtab[1,],colSums(xtab)) #순위가 있을 경우


