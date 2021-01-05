rm(list = ls())
library(hflights) #데이터셋 패키지
library(dplyr) #데이터 전처리 패키지
library(tidyr) #데이터 결측치 정리 패키지
library(openxlsx) #xlsx 확장자 패키지
library(ggplot2) #시각화 패키지
library(stringr) #문자열 정리 패키지

##### 연습문제!

#문제1
# mutate를 사용해 delay라는 변수를 만들고 오름차순으로 정렬후 상위 20개의 평균을 구하시오
# delay = ArrDelay - DepDelay

hflights %>% 
  dplyr::mutate(delay = ArrDelay - DepDelay) %>% 
  dplyr::arrange(delay) %>%
  head(20)
# top_n(-20,delay) %>% 
# arrange(delay)

#문제2
# 비행편수(TailNum)가 20편 이상, 평균 비행거리가 2000마일 이상 평균 연착시간의 평균을 구하시오
# 비행거리 : Distance
# 연착시간 : ArrDelay

hflights %>% 
  group_by(TailNum) %>% 
  summarise(num = n(),
            dist = mean(Distance, na.rm=T),
            delay = mean(ArrDelay,na.rm =T)) %>% 
  filter(num >= 20, dist >=2000) %>% 
  summarise(mean = mean(delay))

##########################################
################# tidyr ##################
##########################################

delivery <- read.csv('SKT.csv', encoding = 'UTF-8')
head(delivery)
tail(delivery)
str(delivery)
summary(delivery)
length(delivery)
count(delivery)
dim(delivery)
names(delivery)

#시군구, 시간대, 요일, 업종별 통화건수 조회
aggr <- delivery %>% 
  dplyr::group_by(시군구,시간대,요일,업종) %>% 
  dplyr::summarise(통화건수 = sum(통화건수)) %>% 
  as.data.frame()
dim(aggr)

#spread
aggr_wide <- aggr %>% 
  spread(업종,통화건수)
dim(aggr_wide)
apply(aggr_wide[,4:7],2,function(x){sum(is.na(x))})
sapply(aggr_wide[,4:7],function(x){sum(is.na(x))})
aggr_wide2 <- aggr_wide %>%
  replace_na(list(족발보쌈=0, 중국음식=0, 치킨=0, 피자=0))
dim(aggr_wide2)
#spread 후 replace_na로 결측치 조정
#결측치 보유 행을 제거하려면 drop_na(tidyr 패키지 내장함수) or na.omit(R 내장함수)

aggr_wide %>% drop_na()
aggr_wide %>% drop_na(족발보쌈 : 피자)
aggr_wide %>% drop_na(족발보쌈, 중국음식)
drop_na(aggr_wide, 족발보쌈, 중국음식)

#gather(<->spread)
names(aggr_wide2)
aggr_long <- aggr_wide2 %>% 
  gather(category,count,족발보쌈:피자)
dim(aggr_long)
#족발보쌈~피자를 category에 컬럼명을 담아 구분하고, count에 value를 입력

#complete

#25(시군구)*24(시간대)*7(요일) = 4200 !=3947
#특정 시간대,날짜에는 주문 건수 자체가 없어서 데이터 트레킹이 안되어 개수가 다름
#complete로 이에 빈 데이터 추가
names(aggr_wide2)
aggr_wide2 %>% 
  complete(시군구,시간대,요일,
              fill = list(족발보쌈=0,중국음식=0,치킨=0,피자=0))
#여기서 fill은 replace_na와 같은 기능
#complete하여 데이터 행을 생성하고 NA를 replace_na로 정리해도 됌

subway_2017 <- read.xlsx('subway_1701_1709.xlsx')


names(subway_2017)[6:25] <- paste0("H",substr(names(subway_2017)[6:25],1,2))

######################## 연습문제 #############################

# (실습) gather( ) 함수를 활용하여 H05부터 H24까지 변수를 모아
# '시간대'와 '승객수'으로 구분하는 데이터 subway2 만들기
names(subway_2017)[6:25] <- paste0("H",substr(names(subway_2017)[6:25],1,2))
head(subway_2017)
subway2 <- subway_2017 %>%
  gather(시간대,승객수,H05:H24)

## 위에서 만든 subway2 데이터와 dplyr 패키지를 활용하여
# 역명/시간대별 전체 승객수 합계 계산 (승객수 합계의 내림차순으로 정렬)
head(subway2)
subway2 %>% 
  group_by(역명,시간대) %>% 
  summarise(sum=sum(승객수)) %>% 
  arrange(desc(sum))

# 위의 결과를 spread( ) 함수를 활용해서 표 형태로 변환
head(subway2)
subway2 %>% 
  group_by(역명,시간대) %>% 
  summarise(sum = sum(승객수)) %>% 
  spread(시간대,sum) %>% 
  arrange(역명)

# 역명/시간대/구분별 전체 승객수 합계 계산
subway2 %>% 
  group_by(역명,시간대,구분) %>% 
  summarise(sum=sum(승객수)) %>% 
  arrange(desc(sum))

# 2월 한달간 역명/시간대/구분별 전체 승객수 합계 계산
head(subway2)
subway2 %>% 
  filter(월 == 2) %>% 
  group_by(역명,시간대,구분) %>% 
  summarise(sum=sum(승객수)) %>% 
  arrange(desc(sum))

########################################################
#문자열다루기
#stringr 패키지
library(stringr)
str_detect(c("afjeilwjfa","aadddd","fafafa"),"fa")
str_count(c("afjeilwjfa","aadddd","fafafa"),"fa") #개수
str_which(c("afjeilwjfa","aadddd","fafafa"),"fa") #찾을 문자가 속한 변수 위치
str_locate(c("afjeilwjfa","aadddd","fafafa"),"fa") #변수별로 찾을 문자 위치
str_sub(c("afjeilwjfa","aadddd","fafafa"),1,3) #stringr 패키지 내장함수 = substr 
substr(c("afjeilwjfa","aadddd","fafafa"),1,3) #R 내장함수 str_sub
str_subset(c("afjeilwjfa","aadddd","fafafa"),"fa") #찾을 문자가 들어있는 문자열 전체 반환
str_replace("aasscccc","s","b") #하나만 변환
str_replace_all("aasscccc","s","b") #전부다 변환
str_to_lower("aaBBcc") #소문자로 변환
str_to_upper("aaBBcc") #대문자로 변환
str_to_title("aaBBcc") #첫 문자 대문자롭 변환 =sql initcap

### 연습해보기

# 문제 1
# words를 모두 대문자로 바꾼 상태에서 'AB'를 포함한 단어의 개수는 총 몇개이며 어떤단어들이 있는가?
words #내장함수
data(words)
words
sum(str_detect(str_to_upper(words),"AB"))
str_subset(str_to_upper(words),"AB")
str_to_upper(words)[str_which(str_to_upper(words),'AB')]

# 문제 2
# words에서 "b"를 "a"로 모두 바꾸고 "aa"를 포함하는 단어 개수는?
sum(str_detect(str_replace_all(words,"b","a"),"aa"))
str_subset(str_replace_all(words,"b","a"),"aa")
words[str_which(str_replace_all(words,"b","a"),"aa")]
# 문제 3
# words에서 "e"의 수는 전체 합과 평균은 몇인가? 
sum(str_count(words,'e'))
mean(str_count(words,'e'))

##################################################################
# 날짜 다루기
#lubridate 패키지
library(lubridate)
as.Date('2020-10-20') #R 내장함수는 이 형태로 정형화된 날짜만 인식

date_test <- ymd(191020)
ymd('201210')
myd('122010')
mdy('121020')

ymd(201210)
myd(122010)
mdy(121020)

class(date_test)

year(date_test)
month(date_test)
date(date_test)
week(date_test)
wday(date_test)
wday(date_test,label=T)

date() #요일, 월, 일, 시분초, 년도
today() #년월일
today()-date_test #두 날짜 사이 일자 계산

ymd_hm("201010 16:30")
ymd_hm("201010 1630")
ymd_hm(201010 1630) #시간이 들어가면 반드시 따움표로 묶어줘야함

##############################
### 연습해보기 날짜 연습해보기
head(subway_2017)
summary(subway_2017$날짜)
min(subway_2017$날짜)

# 문제1
# (실습) gather( ) 함수를 활용하여 H05부터 H24까지 변수를 모아
# '시간대'와 '승객수'으로 구분하는 데이터 subway2 만들기
# subway2 데이터의 날짜에 시간을 추가하기 ex) "2017-01-02 06:00:00"
subway_2017 <- read.xlsx('subway_1701_1709.xlsx')
names(subway_2017)[6:25] <- paste0("H",str_sub(names(subway_2017)[6:25],1,2))
subway2 <- subway_2017 %>% 
  gather(시간대,승객수, H05:H24)
head(subway2)
subway2[,1] <- paste0(subway2[,1]," ",str_sub(subway2[,"시간대"],2,3),":00:00")
# 문제2 **매우 중요, 많이 사용
# subway_2017 데이터에서 월과 일을 month, day 변수명으로 추가하시오
head(subway_2017)
subway_2017 <- subway_2017 %>% 
  mutate(month = month(subway_2017[,1]),
         day = day(subway_2017[,1]))

# 문제3
# 위에서 추가한 변수들 기반으로 3월중 가장 많이 탑승한 시간은 몇시인가?
subway_2017 %>% 
  filter(month ==3) %>% 
  gather(시간대,승객수,H05:H24) %>% 
  group_by(시간대) %>% 
  summarise(sum = sum(승객수)) %>% 
  arrange(desc(sum)) %>% 
  head(3)

subway_2017 %>% 
  filter(month ==3) %>% 
  select(H05:H24) %>% 
  sapply(sum) %>% 
  as.data.frame() %>% 
  top_n(3)

###################################################################################
#결측치(missing Value) 처리
#누락된 값이나 비어있는 값으로, 함수 적용 불가하여 결과 왜곡시킴
#결측치 처리 후 분석
df <- data.frame(sex = c("M", "F", NA, "M", "F"),
                 score = c(5, 4, 3, 4, NA))
is.na(df)
table(is.na(df)) #df의 전체 NA/ non-na 개수 개수
table(is.na(df$sex)) #df의 sex열 NA/ non-na 개수

apply(df, 2,function(x){sum(is.na(x))})
sapply(df,function(x){sum(is.na(x))})
df %>% 
  filter(!is.na(sex) & !is.na(score))

ifelse(is.na(df$score),0,df$score)#ifelse구문으로 열별로 NA를 대체하는 방법

mpg <- as.data.frame(ggplot2::mpg)
mpg[c(65, 124, 131, 153, 212), "hwy"] <- NA
##결측치에 평균 값으로 넣기
mpg[is.na(mpg$hwy),"hwy"] <- mean(mpg$hwy, na.rm=T)
mpg$hwy

#zoo 패키지 내장 함수로 결측치 정리
#na.locf0()로 결측치를 좌/우 값으로 덮기
library(zoo)
na.locf0(mpg$hwy, fromLast=FALSE) #앞의 값을 가져옴
na.locf0(mpg$hwy, fromLast=TRUE) #뒤의 값을 가져옴

##############################
####### 결측치 처리해보기!!
data(airquality)
head(airquality)

str(airquality)

# 1. airquality 데이터의 결측치 개수를 구하시오 (열별로)
summary(airquality)
apply(airquality,2,function(x){sum(is.na(x))})
sapply(airquality,function(x){sum(is.na(x))})


# 2. 결측치가 있는 행들을 제거한 후 각 열의 평균을 구하시오
airquality %>% 
  na.omit() %>% 
  sapply(function(x){mean(x)})



# 3. 결측치는 변수의 중앙값으로 대체후 각 열의 평균을 출력하시오
head(airquality)
airquality %>% 
  na.omit() %>% 
  sapply(function(x){mean(x)})
i <- 1
length(airquality)
nrow(airquality)
ncol(airquality)
for (i in 1:length(airquality)){
  airquality[is.na(airquality[,i]),i] <- median(airquality[,i],na.rm=T)
}
summary(airquality)
#------------------5회차 끝--------------------------------
#------------------6회차 시작------------------------------
rm(list =ls())
library(ggplot2) #시각화 패키지
library(dplyr) #전처리 패키지
library(tidyr) #결측치
library(lubridate) #날짜
library(openxlsx) #xlsx 엑셀 파일 관련 패키지
library(plyr) #강제 rbind 결합
library(stringr) #문자열 패키지
library(RColorBrewer)#팔레트 패키지
windows()

#plot으로 점찍기
plot(0,0, pch=16,cex=10, col='black')
#아래 위치를 참고하여 색상 선택 가능
#http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf

rgb(100/255,100/255,100/255) #RGB 색상으로 조합하여 쓸 수 있음
plot(0,0, pch=16,cex=10, col='#646464')

library(RColorBrewer)
# http://colorbrewer2.org/
# 인터넷 사이트에서 에서 색상 조합 찾거나
RColorBrewer::display.brewer.all()
#RColorBrewer 패키지의 내장 함수로 색상 조합 찾을 수 있음

brewer.pal(9, 'Set1') #색상조합, 최대 9개 랜덤 조합 가져올 수 있음

#ggplot2 시각화 패키지를 이용한 시각화
#시각화는 +로 명령어 연결
install.packages("gapminder") #데이터셋
library(gapminder)
data(gapminder)
head(gapminder)
data1 <- gapminder[gapminder$year==2007,]
data2 <- gapminder[gapminder$year==c(2002,2007),]

#산점도 그리기
#color(산점도 점 색상), shape(점 모양), alpha(투명도), size(점 크기)
windows()
head(data1)
ggplot(data1)+
  aes(x=gdpPercap,
      y=lifeExp,
      color=continent,
      shape=continent,
      size=pop,
      alpha=lifeExp)+
  geom_point()
  # labs(color = '대륙', alpha = '수명')+
  # theme(legend.position = c(0.9,0.3))+
  # scale_x_continuous(breaks=seq(0,50000,5000))+
  # scale_y_continuous(breaks=seq(0,100,5))+
  # ylim(0,100)+
  # ggtitle('대륙별 gdp에 따른 수명 비교')


###########################################
############### 연습해보기  ###############
###########################################
insurance <- read.csv('insurance.csv')
head(insurance)
#1. bmi에 따라서 charges가 어떻게 변하는지 점그래프를 그리시오
## region을 색으로 지정
## sex를 모양으로 지정
## 투명도는 0.7
insurance %>% 
  ggplot(aes(x=bmi,y=charges, color=region, shape=sex))+
  geom_point(alpha = 0.7)+
  ggtitle("남녀 및 지역별 bmi에 따른 charges")+
  scale_x_continuous(breaks=seq(0,100,5))+
  scale_y_continuous(breaks=seq(0,100000,5000))+
  xlim(15,60)+ylim(0,65000)
  

#2. age에 따라서 charges가 어떻게 변하는지 점그래프를 그리시오
## bmi 색으로 지정
## smoker를 모양으로 지정
windows()
insurance %>% 
  ggplot(aes(x=age,y=charges, color=bmi, shape=smoker))+
  geom_point()

###########################################
#막대그래프
#막대그래프 기본은 x변수에 대한 count
head(data1)
data1 %>% 
  ggplot(aes(x=continent,fill=continent))+
  geom_bar()+
  scale_fill_brewer(palette = 'Set1')

#단, x,y변수 두개가 적용될 경우 개별로 적용해야 하므로
#stat="identity"적용
head(data2)
data2 %>% 
  ggplot(aes(x=continent, y=lifeExp, fill=continent))+
  geom_bar(stat="identity",alpha=0.5)+
  theme_bw()+
  scale_fill_brewer(palette = 'Set1')+
  facet_grid(~year)
head(data2)
data2 %>% 
  group_by(continent, year)%>% 
  dplyr::summarise(sum = sum(lifeExp)) %>% 
  arrange(year,continent, sum)


###########################################
############### 연습해보기  ###############
###########################################
head(insurance)

#1. insurance 데이터에서 region별 charges의 중앙값을 구한후 막대그래프를 그리시고
##  region을 색으로 지정
## 투명도는 0.7
windows()
insurance %>% 
  dplyr::group_by(region) %>% 
  dplyr::summarise(mda = median(charges)) %>% 
  ggplot(aes(x=region, y=mda, fill=region))+
  geom_bar(stat="identity", alpha = 0.7)



#2. insurance 데이터에서 sex, smoker별 charges의중앙값을 구한후 막대그래프를 그리시고
## x축은 smoker이며 sex를 색으로 구분
##  region을 색으로 지정
## 투명도는 0.7
#누적막대를 옆으로 펼칠려면 postion = "dodge"추가
## 내가만든 추가 문제 - 지역별로도 보기
insurance %>% 
  dplyr::group_by(sex,smoker,region) %>% 
  dplyr::summarise(mda = median(charges)) %>% 
  dplyr::group_by(smoker) %>%
  dplyr::arrange(smoker,desc(mda)) %>%
  dplyr::mutate(pos=cumsum(mda)-0.6*mda) %>% 
  ggplot(aes(x=smoker,y=mda,fill=sex))+
  geom_bar(stat="identity",color='black')+
  facet_grid(c(~region,~sex))+
  geom_text(aes(label=mda),vjust=-0.5)+
  ylim(0,45000)

###박스 그래프
windows()
gapminder %>% 
  ggplot(aes(x=continent, y=lifeExp))+
  geom_boxplot(alpha = 0.5)
#filter로 원하는 변수를 축약해서 그려주는 형태이며
#데이터 요약X

#히스토그램
gapminder %>% 
  ggplot(aes(x=lifeExp))+
  geom_histogram()

#선 그래프 한개, 여러개
gapminder %>% 
  group_by(year,continent) %>% 
  dplyr::summarise(mean=mean(lifeExp)) %>% 
  ggplot(aes(x=year, y=mean, color=continent))+geom_line()
  # ggplot(aes(x=year, y=mean, group=continent))+geom_line()

###########################################
############### 연습해보기  ###############
###########################################

#1 insurance데이터에서 children이 0보다 크면 1, 0이면 0인 변수 ch_data를 만드시오
insurance1<- insurance %>% 
  dplyr::mutate(ch_data = as.factor(ifelse(children>0,1,0)))



#2 insurance데이터를 활용해서 막대그래프를 그리시오
## x축은 region y축은 charges이며 ch_data를 색으로 구분
insurance1 %>% 
  ggplot(aes(x=region,y=charges, fill=ch_data))+
  geom_bar(stat="identity")


#3 insurance데이터를 활용해서 막대그래프를 그리시오
## x축은 charges ch_data를 색으로 구분
## region마다 4개의 그래프를 그리시오
insurance1 %>% 
  ggplot(aes(x=charges, fill=ch_data))+
  geom_histogram()+
  facet_grid(c(~ch_data,~region))

#4 insurance데이터를 활용해서 막대그래프를 그리시오
## x축은 region y축은 charges이며 ch_data를 색으로 구분
## (누적 막대그래프와 ch_data별 비교 막대그래프)
insurance1 %>% 
  ggplot(aes(x=region,y=charges,fill=ch_data))+
  geom_bar(stat="identity")+
  facet_grid(~ch_data)

#sum을 안하고 dodge를 하게 될 경우 누적된 데이터가 다 옆으로 펼쳐짐
#그래서 가장 높은 값이 나오게 됌
# geom_bar(stat = "identity")
insurance1 %>% 
  group_by(ch_data, region) %>%
  dplyr::summarise(sum=sum(charges)) %>%
  ggplot(aes(x=region,y=sum,fill=ch_data))+  geom_bar(stat="identity",position = "dodge")
  # ggplot(aes(x=region,y=charges,fill=ch_data))+  geom_bar(stat="identity")

head(hr)
hr$left <- as.factor(hr$left)
hr$salary <- factor(hr$salary,levels=c("low","medium","high"))

ggplot(hr,aes(x=salary))+
  geom_bar(aes(fill=salary))
  #theme_bw() #테마 변경

  #ggtitle("제목")#그래프명 설정
  #labs(fill='범례제목') #범례명 설정
  #theme(legend.position = 'top') #범례 위치지정, top
  #theme(legend.position = 'bottom')#범례 위치지정 bottom
  #theme(legend.position = 'none')#범례 없애기
  #theme(legend.position = 'left')#범례 위치지정 left
  #theme(legend.position = 'right')#범례 위치지정 right
  #theme(legend.position = c(0.3,0.8))#범례 좌료로 위치 지정
  # theme(legend.position = 'top',
  #       axis.text.x = element_text(size=15, angle=90), #x축 텍스트 크기 및 각도 조정
  #       axis.text.y = element_text(size=15), #y축 텍스트 크기 조정
  #       legend.text = element_text(size=15)) #범례 텍스트 크기 조정
  # scale_x_discrete(labels=c("하","중","상")) #x축 범주형 값 변경
  # scale_y_continuous(breaks=seq(0,8000,500)) #y축 연속형 값 변경
  # ylim(0,10000) #y축 그래프 사이즈 조정, x축 연속형이면 가능
  # scale_fill_brewer(palette = 'Set1') palette로 색상 변경
  # scale_fill_manual(values=c("red","black","blue")) #특정 색상 지정
  # coord_flip() #x,y축 반전전

#축 수직수평대각선 생성
ggplot(NULL)+
  geom_vline(xintercept = 10,
             col='royalblue', size=3)+
  geom_hline(yintercept = 10,
             col='red', size=3)+
  geom_abline(intercept = 0,
              slope = 1, col = 'blue', size =5)

head(insurance)
agg2 <- insurance %>% 
  mutate(bmi_grp = cut(bmi,
                       breaks = c(0,30,35,40,100),
                       labels = c('g1','g2','g3','g4'))) %>% 
  group_by(region,bmi_grp) %>% 
  dplyr::summarise(q90=quantile(charges,0.9))

agg2 %>% 
  ggplot(aes(x=region, y=bmi_grp,fill=q90))+
  geom_tile()+
  # scale_fill_gradient(low='black',high='royalblue')
  scale_fill_distiller(palette='Set1')

###########################################
############### 연습해보기  ###############
###########################################

# (실습) NHIS에서 AGE_GROUP, DSBJT_CD별 EDEC_TRAMT 평균 계산 후 저장
#        저장된 데이터로 열지도 시각화
#어떤 범주형과 어떤 범주형에 대해 전처리 후 히트맵을 그려야 함




###########################################
# tidyr + dplyr + ggplot을 한번에

# 데이터 불러오기
## 역변호가 150인 서울역 데이터 
library(openxlsx)
subway_2017 = read.xlsx('subway_1701_1709.xlsx')
names(subway_2017)[6:25] <- paste0("H",str_sub(names(subway_2017)[6:25],1,2))

# gather( ) 함수를 활용하여 H05부터 H24까지 변수를 모아
# '시간대'와 '승객수'으로 구분하는 데이터 subway2 만들기
head(subway_2017)
subway2 <- subway_2017 %>% 
  gather(시간대,승객수,H05:H24)

## 위에서 만든 subway2 데이터와 dplyr 패키지를 활용하여

# 역명/시간대별 전체 승객수 합계 계산 (승객수 합계의 내림차순으로 정렬)
subway2 %>% 
  group_by(역명,시간대) %>% 
  dplyr::summarise(sum=sum(승객수)) %>% 
  arrange(desc(sum))

### 이러한 tidyr을 통해서 데이터를 시각화하기
### 시간대별로 승객 합계 막대차트로 그려보기!
windows()
subway2 %>% 
  group_by(역명,시간대) %>% 
  dplyr::summarise(sum=sum(승객수)) %>% 
  arrange(desc(sum)) %>% 
  ggplot(aes(x=시간대,y=sum,fill=시간대))+
  geom_bar(stat="identity")

options("scipen"=3)  
options(scipen = 100)