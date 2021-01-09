rm(list = ls())
library(tidyverse)
library(openxlsx)
#EDA를 위한 초기 전처리 진행
#상권-추정매출 데이터 합치기
setwd('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터/원본데이터/')
getwd()
list.files()
#상권 추정매출 데이터 전처리
guess_encoding("서울시 우리마을가게 상권분석서비스(상권-추정매출)_2019.csv")
guess_encoding("서울시 우리마을가게 상권분석서비스(상권-추정매출)_2020.csv")
data1 <- read.csv("서울시 우리마을가게 상권분석서비스(상권-추정매출)_2019.csv", fileEncoding = 'euc-kr')
data2 <- read.csv("서울시 우리마을가게 상권분석서비스(상권-추정매출)_2020.csv", fileEncoding = 'euc-kr')

#상권코드명 인덱스 일치시키기
data2[data2$상권_코드_명=="종로?청계 관광특구",]$상권_코드_명 <- "종로·청계 관광특구"

#2019,2020년도 데이터셋 결합
smallbz_sales <- rbind(data1,data2)
# smallbz_sales_raw <- smallbz_sales

#상권코드 -행정동 코드 파일 읽기
library(XML)
loc1 <- xmlToDataFrame(doc = 'http://openapi.seoul.go.kr:8088/6a596b4c4462616235334e454e5a52/xml/TbgisTrdarRelm/1/1000/')
loc2 <- xmlToDataFrame(doc = 'http://openapi.seoul.go.kr:8088/6a596b4c4462616235334e454e5a52/xml/TbgisTrdarRelm/1001/1496/') 
var <- 1:2
loc1 <- loc1 %>% slice(-var)
loc2 <- loc2 %>% slice(-var)
sangkwon_loc <- rbind(loc1,loc2)
sangkwon_loc <- sangkwon_loc[,c(6,11)]

#행정동 코드-행정구 파일 읽기
guess_encoding(file = '행정동코드_매핑정보_20200325.xlsx')
sangkwon_gu <- read.xlsx(xlsxFile = '행정동코드_매핑정보_20200325.xlsx',sheet = 1)
sangkwon_gu <- sangkwon_gu %>% slice(-1)
sangkwon_gu <- sangkwon_gu[,c(2,4)]

#매출데이터 행정구 추가
smallbz_sales <- merge(x = smallbz_sales, y = sangkwon_loc,
      by.x='상권_코드',by.y = 'TRDAR_CD', all.x=T)
smallbz_sales <- merge(x = smallbz_sales, y = sangkwon_gu,
              by.x = 'ADSTRD_CD', by.y = '행자부행정동코드', all.x=T)

#결합 데이터 프레임 정리
smallbz_sales <- smallbz_sales %>% 
  group_by(기준_년_코드,기준_분기_코드,시군구명,서비스_업종_코드_명) %>% 
  summarise(매출총액 = sum(당월_매출_금액),매출건수 = sum(당월_매출_건수),점포수 = sum(점포수),
               매출액_월 = sum(월요일_매출_금액),매출액_화 = sum(화요일_매출_금액),
               매출액_수 = sum(수요일_매출_금액),매출액_목 = sum(목요일_매출_금액),
               매출액_금 = sum(금요일_매출_금액),매출액_토 = sum(토요일_매출_금액),
               매출액_일 = sum(일요일_매출_금액),매출액_0006 = sum(시간대_00.06_매출_금액),
               매출액_0611 = sum(시간대_06.11_매출_금액),매출액_1114 = sum(시간대_11.14_매출_금액),
               매출액_1417 = sum(시간대_14.17_매출_금액),매출액_1721 = sum(시간대_17.21_매출_금액),
               매출액_2124 = sum(시간대_21.24_매출_금액),매출액_남 = sum(남성_매출_금액),
               매출액_여 = sum(여성_매출_금액),매출액_연령10 = sum(연령대_10_매출_금액),
               매출액_연령20 = sum(연령대_20_매출_금액),매출액_연령30 = sum(연령대_30_매출_금액),
               매출액_연령40 = sum(연령대_10_매출_금액),매출액_연령50 = sum(연령대_50_매출_금액),
               매출액_연령60이상 = sum(연령대_60_이상_매출_건수))
colnames(smallbz_sales)[c(1,2,3,4)] <- c("년도","분기","행정구역","소분류")

#data.frame으로 형 변환
smallbz_sales <- as.data.frame(smallbz_sales)

#eda
str(smallbz_sales)
summary(smallbz_sales)
vars <- c(1,2,3,4)
smallbz_sales[,vars] <- map_df(.x = smallbz_sales[,vars], .f = as.factor)

library(corrplot)
corrplot(cor(x = smallbz_sales[,-vars]),method = 'number')
test <- smallbz_sales
test[,-vars] <- map_df(.x = test[,-vars],.f = log)
test[,-vars] <- map_df(.x = test[,-vars],.f = gsub(pattern = -Inf,replacement = 0))
corrplot(cor(x = test[,-vars]),method = 'number')

for(i in 5:28){
  test[,i] <- ifelse(is.infinite(test[,i])==T,0,test[,i])
}
windows()
smallbz_sales %>% 
  # filter(행정구역 =='송파구') %>% 
  group_by(행정구역) %>% 
  select(매출액_월:매출액_일) %>% 
  gather(key=요일,value=매출,매출액_월:매출액_일) %>% 
  mutate(요일 = factor(x = 요일,levels = c('매출액_월','매출액_화','매출액_수','매출액_목','매출액_금','매출액_토','매출액_일'))) %>% 
  ggplot(aes(x = 요일, y = 매출, fill = 행정구역),col = 'black')+
  geom_bar(stat = "identity")+
  # facet_grid(~행정구역)
  facet_wrap(~행정구역,nrow=2,strip.position = "left")+
  theme(legend.position = "none")+
  scale_x_discrete(labels=c('월','화','수','목','금','토','일'))
  geom_text(mapping = aes(label = 매출, y = 매출))

smallbz_sales %>% 
  group_by(행정구역) %>% 
  select(매출액_0006:매출액_2124) %>% 
  gather(key=시간대,value=매출,매출액_0006:매출액_2124) %>% 
  mutate(시간대 = factor(x = 시간대,levels = c('매출액_0006','매출액_0611','매출액_1114','매출액_1417','매출액_1721','매출액_2124'))) %>% 
  ggplot(aes(x = 시간대, y = 매출, fill = 행정구역),col = 'black')+
  geom_bar(stat = "identity")+
  # facet_grid(~행정구역)
  facet_wrap(~행정구역,nrow=2,strip.position = "left")+
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 90))+
  scale_x_discrete(labels=c('0006','0611','1114','1417','1721','2124'))
  
  
  
#☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
#아래 자료는 아직 쓸 지 말지 고려중(월요일날 신용보증공단 담당자와 통화후 결정)
#(데이터 불균형으로 고려중) 소상공인 매출 데이터와 소상공인 상권분석 데이터와 결합
# file_path <- 'C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터/'
# load(paste0(file_path,'우리마을상권분석.rda'))

smallbz_total <- merge(x = smallbz_sales, y = smallbz_data,
                       by = c("년도","분기","행정구역","소분류"),all.x=T)
View(smallbz_total %>% 
  select(년도,분기,행정구역,소분류,점포수,전체점포수,프랜차이즈점포수,일반점포수) %>% 
  filter(행정구역=='종로구' & 소분류 =='PC방'))



smallbz_sales_raw <- merge(x = smallbz_sales_raw, y = sangkwon_loc,
                       by.x='상권_코드',by.y = 'TRDAR_CD', all.x=T)
smallbz_sales_raw <- merge(x = smallbz_sales_raw, y = sangkwon_gu,
                       by.x = 'ADSTRD_CD', by.y = '행자부행정동코드', all.x=T)
test <- smallbz_sales_raw

View(test %>% 
  select(기준_년_코드,기준_분기_코드,상권_구분_코드_명,서비스_업종_코드_명,시군구명,점포수) %>% 
  filter(기준_년_코드==2019 & 기준_분기_코드 ==1 & 시군구명 =='종로구' & 서비스_업종_코드_명=='PC방') %>% 
  arrange(상권_구분_코드_명))


jeompo <- read.csv("서울시_우리마을가게_상권분석서비스(상권-점포)_2019년.csv")
jeompo <- merge(x = jeompo, y = sangkwon_loc,
                       by.x='상권_코드',by.y = 'TRDAR_CD', all.x=T)
jeompo <- merge(x = jeompo, y = sangkwon_gu,
                       by.x = 'ADSTRD_CD', by.y = '행자부행정동코드', all.x=T)
colnames(jeompo)
View(jeompo %>% 
  group_by(기준_년_코드,기준_분기_코드,시군구명,서비스_업종_코드_명) %>% 
  summarise(점포수 = sum(점포_수), 점포수_프랜차이즈 = sum(프랜차이즈_점포_수),
               점포수_유사업종 = sum(유사_업종_점포_수), 점포수_개업 = sum(개업_점포_수), 점포수_업업 = sum(폐업_점포_수)) %>% 
  filter(기준_년_코드==2019 & 기준_분기_코드==1 & 시군구명=='종로구'))

jeompo %>% 
  select(기준_년_코드,기준_분기_코드,상권_구분_코드_명,서비스_업종_코드_명,시군구명,점포_수) %>% 
  filter(기준_년_코드==2019 & 기준_분기_코드 ==1 & 시군구명 =='종로구' & 서비스_업종_코드_명=='PC방' & 점포_수!=0) %>% 
    arrange(상권_구분_코드_명)
#------------------------------------------------------------------------------------------------------------------


#행정구역&분기&년도별 개폐업수#히트맵
smallbiz_DA %>% 
  filter(분기!=4) %>% 
  group_by(년분기,행정구역) %>% 
  dplyr::summarise(개폐업수=sum(개폐업수,na.rm=T)) %>%
  ggplot(aes(x=년분기,y=행정구역,fill=개폐업수))+geom_tile()+
  ggsave(width = 15,height = 8,units = 'cm','행정구역&분기&년도별 개폐업수_히트맵.jpg')

#업종&분기&년도별 개폐업수#히트맵
windows()
smallbiz_DA %>% 
  filter(대분류=='서비스업') %>% 
  group_by(년분기,소분류) %>% 
  dplyr::summarise(개폐업수=sum(개폐업수,na.rm=T)) %>%
  ggplot(aes(x=년분기,y=소분류,fill=개폐업수))+geom_tile()+
  scale_fill_gradient(low='maroon4', high='white')+
  legend(cex=1.5)



