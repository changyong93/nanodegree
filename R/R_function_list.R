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
save(iris1, iris2, file = 'iris_data.rda') #workspace의 변수 일부 저장
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