library(ggplot2)
library(dplyr)
library(lubridate)
library(stringr)
library(tidyr)
rm(list = ls())
list.files()
public_transport_subway <- readRDS("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터/subway_t.rds")
public_transport_bus <- readRDS("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터/버스노선별_승하차인원정보.rds")
smallbz_commercial_sales_2019<- readRDS("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터/서울시 우리마을가게 상권분석서비스(상권-추정매출)_2019.rds")
smallbz_commercial_sales_2020<- readRDS("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터/서울시 우리마을가게 상권분석서비스(상권-추정매출)_2020.rds")
smallbz_commercial_floating_pop<- readRDS("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터/서울시 우리마을가게 상권분석서비스(상권-추정유동인구)14.1~20.3.rds")
smallbz_commercial_background_income_consumtion<- readRDS("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터/서울시 우리마을가게 상권분석서비스(상권배후지-소득소비)14.1~20.3.rds")
smallbz_commercial_background_working_pop<- readRDS("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터/서울시 우리마을가게 상권분석서비스(상권배후지-직장인구)14.1~20.3.rds")
COVID19_confirmed_list<- readRDS("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터/코로나19확진자현황.rds")
load("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터/우리마을상권분석.RData")

#소상공인_상권 추정매출 자료 전처리
#1) 상권코드명 중 종로청계 관광특구 상권명 통일
smallbz_commercial_sales_2020[smallbz_commercial_sales_2020$상권_코드_명=="종로?청계 관광특구",]$상권_코드_명 <- "종로·청계 관광특구"

#19,20년도 자료 합치기
smallbz_commercial_sales <- data.frame()
smallbz_commercial_sales <- rbind(smallbz_commercial_sales_2019,smallbz_commercial_sales_2020)

#불필요한 행 삭제
test <- smallbz_commercial_sales


public_transport_bus %>% 
  filter(사용년월=='201901') %>% 
  unique(역명)
public_transport_bus[]

201901




















rm(list = ls())
setwd('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/data')
getwd()

list.files()
load('우리마을상권분석.rdata')
smallbiz_DA$년분기 <- factor(paste0(smallbiz_DA$년도,'_',smallbiz_DA$분기))

#1,2,3분기 행정구역별 개폐업수
smallbiz_DA %>%
  filter(년분기!='2019_4') %>% 
  group_by(년도,분기,행정구역) %>% 
  dplyr::summarise(개폐업수=sum(개폐업수,na.rm=T)) %>%
  ggplot(aes(x=as.numeric(분기),y=개폐업수,group=행정구역,color=행정구역))+geom_line()+
  facet_grid(~년도)+theme(axis.text.x = element_text(angle=45))

#행정구역&분기&년도별 개폐업수
windows()
smallbiz_DA %>% 
  filter(분기!=4) %>% 
  group_by(년도,분기,행정구역) %>% 
  dplyr::summarise(개폐업수=sum(개폐업수,na.rm=T)) %>%
  ggplot(aes(x=분기,y=개폐업수,fill=년도))+
  geom_bar(stat='identity',position='dodge')+
  facet_grid(~행정구역)+theme(axis.text.x = element_text(angle=90,size=12))

#행정구역&분기&년도별 개폐업수#히트맵
smallbiz_DA %>% 
  filter(분기!=4) %>% 
  group_by(년분기,행정구역) %>% 
  dplyr::summarise(개폐업수=sum(개폐업수,na.rm=T)) %>%
  ggplot(aes(x=년분기,y=행정구역,fill=개폐업수))+geom_tile()+
  ggsave(width = 15,height = 8,units = 'cm','행정구역&분기&년도별 개폐업수_히트맵.jpg')
library(RColorBrewer)
RColorBrewer::display.brewer.all()
RColorBrewer::brewer.pal.info
#업종&분기&년도별 개폐업수#히트맵
windows()
smallbiz_DA %>% 
  filter(대분류=='서비스업') %>% 
  group_by(년분기,소분류) %>% 
  dplyr::summarise(개폐업수=sum(개폐업수,na.rm=T)) %>%
  ggplot(aes(x=년분기,y=소분류,fill=개폐업수))+geom_tile()+
  scale_fill_gradient(low='maroon4', high='white')+
  legend(cex=1.5)

#업종&분기&년도별 개업수,폐업수,개폐업수
windows()
smallbiz_DA %>% 
  filter(대분류=='서비스업') %>% 
  group_by(년분기,소분류) %>% 
  dplyr::summarise(개업수=sum(개업수),폐업수=sum(폐업수),개폐업수=sum(개폐업수,na.rm=T)) %>%
  ggplot(aes(x=년분기,y=개폐업수,group=소분류,color=소분류))+geom_line()+
  theme(axis.text.x=element_text(angle=45))
  # ggsave(width = 12,height=8,units = 'cm','외식 업종&분기&년도별 개업,폐업,개폐업수.jpg')

#우리마을상권분석상관관계분석
test <- smallbiz_DA
test <- test %>% mutate(개폐업수=개업수-폐업수)
test$년도 <- as.numeric(test$년도)
test$분기 <- as.numeric(test$분기)
corrplot(cor(test[,c(1:2,6:21)],use="na.or.complete"),method='number')

#서비스업,소매업,외식업 업종&년&분기별 개폐업수
smallbiz_DA %>% 
  filter(행정구역=='중구' & 대분류=='서비스업') %>% 
  ggplot(aes(x=년분기,y=개폐업수,fill=소분류))+geom_bar(stat='identity')+
  theme(legend.position = 'none',axis.text.x=element_text(angle=90,size=2))+

smallbiz_DA %>% 
  filter(행정구역=='강남구' & 소분류=='컴퓨터학원') %>% 
  ggplot(aes(x=년분기,y=개폐업수,fill=소분류))+geom_bar(stat='identity')+
  theme(legend.position = 'none',axis.text.x=element_text(angle=90,size=2))+
  facet_wrap(~소분류,nrow=2,strip.position = "left")

corrplot(cor(test_gn[,c(1:2,6:21)],use="na.or.complete"),method='number')
head(test)
names(test)
summary(lm(개폐업수~.,data=test))
summary(lm(개폐업수~개업수,test ))

test %>% 
  ggplot(aes(x=개업수,y=개폐업수))+
  geom_point()

list.files()
load('skt음성통화데이터.RData')
head(skt_call)
skt_call$`발신지(시도)`
skt_call %>% 
  filter(`발신지(시군구)`=='강남구') %>% 
  dplyr::summarise(통화비율=sum(`통화비율(시군구내)`))
View(aa)
skt_call %>% 
  filter(`발신지(시군구)`=='강남구') 

try.except
file <- list.files()[7]
test <- read.csv(file)
saveRDS(test,"서울시 우리마을가게 상권분석서비스(상권배후지-직장인구)14.1~20.3.rds")
unique(test$기준_년_코드)



