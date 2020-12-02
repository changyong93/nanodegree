rm(list =ls())
install.packages("hflights")
library(hflights)
data("hflights")

##### 연습문제!

#문제1
# mutate를 사용해 delay라는 변수를 만들고 오름차순으로 정렬후 상위 20개의 평균을 구하시오
# delay = ArrDelay - DepDelay
hflights %>% 
  dplyr::mutate(delay = ArrDelay - DepDelay) %>% 
  dplyr::arrange(delay) %>% 
  head(20)

#문제2
# 비행편수(TailNum)가 20편 이상, 평균 비행거리가 2000마일 이상 평균 연착시간의 평균을 구하시오
# 비행거리 : Distance
# 연착시간 : ArrDelay

hflights %>% 
  dplyr::group_by(TailNum) %>% 
  dplyr::summarise(sum = n(),
                   dist = mean(Distance, na.rm=T),
                   delay = mean(ArrDelay, na.rm=T)) %>% 
  dplyr::filter(sum >=20 & dist >=2000) %>% 
  dplyr::summarise(mean = mean(delay))

##########################################
################# tidyr ##################
##########################################
library(tidyr)
library(plyr)
delivery <-  read.csv('SKT.csv', encoding = 'UTF-8')

head(delivery)
#시군구, 시간대, 요일, 업종별 통화건수 조회
aggr <- delivery %>% 
  dplyr::group_by(시군구,시간대,요일,업종) %>% 
  dplyr::summarise(통화건수 = sum(통화건수)) %>% 
  as.data.frame()
aggr

#spread

aggr_wide <- aggr %>% 
  tidyr::spread(업종,통화건수)
#결측치 찾기
summary(aggr_wide)# 1번

names(aggr_wide)
apply(aggr_wide[,4:7],2, function(x){sum(is.na(x))}) #2번
sapply(aggr_wide[,4:7], function(x){sum(is.na(x))}) #3번
aggr_wide2 <- aggr_wide %>% 
  tidyr::replace_na(list(족발보쌈=0, 중국음식=0,치킨=0, 피자=0))
  
aggr_wide %>% drop_na()
aggr_wide %>% drop_na(족발보쌈, 중국음식)

#gather( <-> spread)
names(aggr_wide2)
aggr_long <- aggr_wide2 %>% 
  tidyr::gather(category, count, 족발보쌈:피자)

aggr_long

#complete()
aggr_wide2 %>% 
  tidyr::complete(시군구,시간대,요일, fill=list(족발보쌈=0, 중국음식=0,치킨=0, 피자=0))

rm(list = ls())
library(openxlsx)
subway_2017 <- read.xlsx('subway_1701_1709.xlsx')

str(subway_2017)
desc(subway_2017)
head(subway_2017, 10)
names(subway_2017)
names(subway_2017)[6:25] <- paste0("H",substr(names(subway_2017[6:25]),1,2))
head(subway_2017)

######################## 연습문제 #############################

# (실습) gather( ) 함수를 활용하여 H05부터 H24까지 변수를 모아
# '시간대'와 '승객수'으로 구분하는 데이터 subway2 만들기
subway2 = NA
subway2 <- subway_2017 %>% 
  tidyr::gather(시간대, 승객수, H05:H24)

## 위에서 만든 subway2 데이터와 dplyr 패키지를 활용하여
# 역명/시간대별 전체 승객수 합계 계산 (승객수 합계의 내림차순으로 정렬)
subway2 %>% NA
subway2_sum <- subway2 %>% 
  dplyr::group_by(역명, 시간대) %>% 
  dplyr::summarise(sum = sum(승객수)) %>% 
  dplyr::arrange(desc(sum))


# 위의 결과를 spread( ) 함수를 활용해서 표 형태로 변환
subway2 %>% 
  group_by(역명, 시간대) %>% 
  summarise(sum = sum(승객수)) %>% 
  spread(시간대, sum)


# 역명/시간대/구분별 전체 승객수 합계 계산
head(subway2)
subway2 %>%
  group_by(역명,시간대,구분) %>% 
  summarise(sum = sum(승객수)) %>% 
  arrange(desc(sum))

# 2월 한달간 역명/시간대/구분별 전체 승객수 합계 계산
subway2 %>% NA
head(subway2)
subway2 %>% 
  filter(월==2) %>% 
  group_by(역명,시간대,구분) %>% 
  summarise(sum = sum(승객수)) %>% 
  arrange(desc(sum))

rm(list = ls())
###########################
###### 문자열 다루기 ######
###########################
install.packages("stringr")
library(stringr)

"This is a string"
"If I want to include a 'quote' inside a string, I use single quotes"
'If I want to include a "quote" inside a string, I use single quotes'
#큰 따움표 안의 작은 따움표는 따움표로 인식
#작은 따움표 안의 큰 따움표는 특수문자로 인식 ( \n 처럼)

##패턴찾기
x <- c("apple", "banana", "pear")
str_detect(x,"e") #T or F
str_detect("aabbeeededd","e")

str_count(x,"e")
str_count("aabbeeededd","e") #e 개수

str_which(x,"e")
str_which("aabbeeededd","e")
str_which(c('e', 'f', 'ee', 'ef','a'),'e') #e 위치 반환

str_locate("aabbeeededd","e") #찾을 문자의 시작과 끝 위치 반환
str_locate("aabbeeededd","ee")
str_locate("aabbeeededd","eee")

##부분찾기
x <- c("Apple", "Banana", "Pear")
str_sub(x,1,3)
# = substr(x,1,3)

str_subset(x, "e") #e가 들어있는 데이터 반환

str_replace("App", "p","T") #문자열에서 처음 찾은 특정 문자를 변환
str_replace_all("App", "p","T")#문자열의 모든 특정 문자를 변환

str_to_lower("Apple")
str_to_upper("Apple")
str_to_title("Apple") #sql의 initcap과 같음

### 연습해보기

# 문제 1
# words를 모두 대문자로 바꾼 상태에서 'AB'를 포함한 단어의 개수는 총 몇개이며 어떤단어들이 있는가?
words #내장함수
class(words)
sum(str_detect(str_to_upper(words), "AB"))
str_to_upper(words)[str_which(str_to_upper(words),'AB')]
# 문제 2
# words에서 "b"를 "a"로 모두 바꾸고 "aa"를 포함하는 단어 개수는?
sum(str_detect(str_replace(words, "b", "a"),'aa'))
str_replace(words, "b", "a")[str_which(str_replace(words, "b", "a"),'aa')]
str_subset(str_replace(words, "b", "a"), 'aa')
# 문제 3
# words에서 "e"의 수는 전체 합과 평균은 몇인가? 
sum(str_count(words, 'e'))
mean(str_count(words, 'e'))

###########################
###### 날짜 데이터 ######
###########################
install.packages("lubridate")
library(lubridate)

as.Date('2020-10-10') #정확히 YYYY-MM-DD로 텍스트를 입력 안하면 오류
#대체 => lubridate::ymd 등등

ymd('201010')
ymd(201010)
myd(102010)

date_test <- ymd(191020)

year(date_test) #년도
month(date_test) #월
day(date_test) #일
week(date_test) #연도 기준 몇주차인지
wday(date_test) #0 일요일 ~ 6 토요일
wday(date_test,label = T) #요일

date_test + days(100) #100일 후
date_test + months(100) #100개월 후
date_test + years(100) #100일 후

lubridate::date()
lubridate::today()-date_test

ymd_hm("201020 1430") #시간 데이터가 포함되면 무조건 따움표로 묶어줘야 함
ymd_hm("201020 14:30")

date_test2 <- ymd_hm("20-10-20 14:30")
hour(date_test2)
minute(date_test2)
second(date_test2)

##############################
### 연습해보기 날짜 연습해보기
head(subway_2017)
summary(subway_2017$날짜)
min(subway_2017$날짜)

# 문제1
# (실습) gather( ) 함수를 활용하여 H05부터 H24까지 변수를 모아
# '시간대'와 '승객수'으로 구분하는 데이터 subway2 만들기
# subway2 데이터의 날짜에 시간을 추가하기 ex) "2017-01-02 06:00:00"
names(subway_2017)[6:25] <- paste0("H",substr(names(subway_2017)[6:25],1,2))
subway2 <- subway_2017 %>% 
  tidyr::gather(시간대,승객수,H05:H24) %>% 
  dplyr::mutate(날짜 = ymd_h(paste0(날짜," ",str_sub(시간대,2,3))))

# 문제2 **매우 중요, 많이 사용
# subway_2017 데이터에서 월과 일을 month, day 변수명으로 추가하시오
head(subway_2017)
subway_2017 %>% 
  mutate(month=month(날짜), day=day(날짜))
# 문제3
# 위에서 추가한 변수들 기반으로 3월중 가장 많이 탑승한 시간은 몇시인가?
head(subway_2017)
subway_2017 %>% 
  gather(시간대, 승객수, H05:H24) %>% 
  mutate(month=month(날짜), day=day(날짜)) %>% 
  filter(month == 3) %>% 
  group_by(시간대) %>% 
  summarise(sum = sum(승객수)) %>% 
  arrange(desc(sum))

subway_2017 %>% 
  mutate(month=month(날짜), day=day(날짜)) %>% 
  filter(month == 3) %>%
  select(H06:H24) %>% 
  sapply(sum) %>% 
  data.frame()

rm(list = ls())
########## 결측치 처리 #############
# 결측치(Missing Value)
# 누락된 값, 비어있는 값
# 함수 적용 불가, 분석 결과 왜곡
# 제거 후 분석 실시

# 결측치 확인하기
df <- data.frame(sex = c("M", "F", NA, "M", "F"),
                 score = c(5, 4, 3, 4, NA))

is.na(df) #Na가 있을 경우 True, 아니면 False
table(is.na(df)) #df의 dateframe에서 NA = True 개수 및 아닐 경우 개수 카운트
table(is.na(df$sex)) #특정 행의 NA와 아닐 경우 개수 카운트

apply(df, 2, function(x){sum(is.na(x))}) #na 개수 반환
sapply(df, function(x){sum(is.na(x))}) #na 개수 반환
sapply(iris, function(x){sum(is.na(x))})
df %>% 
  apply(2,function(x){sum(is.na(x))})
df %>% 
  sapply(function(x){sum(is.na(x))})


library(dplyr)
df %>%
  filter(!is.na(sex) & !is.na(score))

df$score <- ifelse(is.na(df$score), 4 , df$score)

mpg <- as.data.frame(ggplot2::mpg)
mpg[c(65, 124, 131, 153, 212), "hwy"] <- NA

sapply(mpg, function(x){sum(is.na(x))})
#결측치 평균값으로 넣기
mpg[is.na(mpg$hwy), "hwy"]<- mean(mpg$hwy, na.rm = T)

##zoo 패키지 내장 함수 na.locf0를 이용한 결측치 정리
na.locf0(c(NA, NA, "A", NA, "B"), fromLast = FALSE) # 1
## [1] NA  NA  "A" "A" "B"
## NA가 있을 경우 왼쪽 데이터를 그대로 사용

na.locf0(c(NA, NA, "A", NA, "B"), fromLast = TRUE) # 2
## [1] "A" "A" "A" "B" "B"
## NA가 있을 경우 오른쪽 데이터를 그대로 사용

rm(lsit = ls())
##############################
####### 결측치 처리해보기!!
data(airquality)
head(airquality)


# 1. airquality 데이터의 결측치 개수를 구하시오 (열별로)
apply(airquality,2, function(x){sum(is.na(x))})
sapply(airquality, function(x){sum(is.na(x))})
library(dplyr)
airquality %>% apply(2,function(x){sum(is.na(x))})
airquality %>% sapply(function(x){sum(is.na(x))})


# 2. 결측치가 있는 행들을 제거한 후 각 열의 평균을 구하시오
head(airquality)
airquality %>% 
  na.omit() %>%
  sapply(function(x){mean(x)})

airquality %>% 
  sapply(function(x){mean(x, na.rm = T)})
#상기 코드는 결측치가 있는 행을 모두 제거한 상태로 평균을 계산하고
#하기 코드는 행별 결측치를 제외한 평균을 계산하므로 결과값이 다름


# 3. 결측치는 변수의 중앙값으로 대체후 각 열의 평균을 출력하시오

for(i in 1:6){
  airquality[is.na(airquality[,i]),i] <- median(airquality[,i], na.rm = T)
}
apply(airquality,2,mean)  
