rm(list = ls())
library(openxlsx)
library(tidyverse)

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
setwd('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터/원본데이터/')
guess_encoding(file = '행정동코드_매핑정보_20200325.xlsx')
sangkwon_gu <- read.xlsx(xlsxFile = '행정동코드_매핑정보_20200325.xlsx',sheet = 1)
sangkwon_gu <- sangkwon_gu %>% slice(-1)
sangkwon_gu <- sangkwon_gu[,c(2,4,5)]#행정동 추가

#EDA를 위한 초기 전처리 진행
#상권-추정매출 데이터 합치기
setwd('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터/원본데이터/')
getwd()
#상권 추정매출 데이터 전처리
data1 <- read.csv("서울시 우리마을가게 상권분석서비스(상권-추정매출)_2015.csv", fileEncoding = 'euc-kr')
data2 <- read.csv("서울시 우리마을가게 상권분석서비스(상권-추정매출)_2016.csv", fileEncoding = 'euc-kr')
data3 <- read.csv("서울시 우리마을가게 상권분석서비스(상권-추정매출)_2017.csv", fileEncoding = 'euc-kr')
data4 <- read.csv("서울시 우리마을가게 상권분석서비스(상권-추정매출)_2018.csv", fileEncoding = 'euc-kr')
data5 <- read.csv("서울시 우리마을가게 상권분석서비스(상권-추정매출)_2019.csv", fileEncoding = 'euc-kr')
data6 <- read.csv("서울시 우리마을가게 상권분석서비스(상권-추정매출)_2020.csv", fileEncoding = 'euc-kr')

#상권코드명 인덱스 일치시키기
data6[data6$상권_코드_명=="종로?청계 관광특구",]$상권_코드_명 <- "종로·청계 관광특구"

#2015~2020년도 데이터셋 결합
smallbz_sales <- rbind(data1,data2,data3,data4,data5,data6)

#매출액이 마이너스인 인덱스의 상권&업태 조합을 모두 제거
outlier_minus <- data.frame()
for(i in 36:48){
  outlier_minus <- rbind(outlier_minus, smallbz_sales[smallbz_sales[,i]<0,c(1,2,5,7)])
  
}
outlier_minus <- outlier_minus %>% distinct(상권_코드,서비스_업종_코드)
outlier_minus$사용여부 <- 1

smallbz_sales <- merge(x = smallbz_sales,y = outlier_minus, by = c("상권_코드","서비스_업종_코드"), all.x = T)
smallbz_sales <- smallbz_sales %>% filter(is.na(사용여부) == T)
smallbz_sales <- smallbz_sales[,-81]

#매출액 컬럼 생성 - 월화수목/금토일 & 0614/1421/2106
smallbz_sales <- smallbz_sales %>% 
  mutate(매출_월화수목 = 월요일_매출_금액+화요일_매출_금액+수요일_매출_금액+목요일_매출_금액,
                매출_금토일 = 금요일_매출_금액+토요일_매출_금액+일요일_매출_금액,
                매출_0614 = 시간대_06.11_매출_금액+시간대_11.14_매출_금액,
                매출_1421 = 시간대_14.17_매출_금액+시간대_17.21_매출_금액,
                매출_2106 = 시간대_21.24_매출_금액+시간대_00.06_매출_금액)
vars <- c("상권_코드","서비스_업종_코드","기준_년_코드","기준_분기_코드","서비스_업종_코드_명","당월_매출_금액","점포수","매출_월화수목","매출_금토일","매출_0614","매출_1421","매출_2106")
smallbz_sales <- smallbz_sales[,vars]
colnames(smallbz_sales)[c(3,4,5,6,7)] <- c("년도","분기","소분류","매출총액","점포수_추정매출")


#매출데이터 행정구 추가
smallbz_total_1501_2009 <- merge(x = smallbz_sales, y = sangkwon_loc,by.x = '상권_코드', by.y = 'TRDAR_CD', all.x=T)
smallbz_total_1501_2009 <- merge(x = smallbz_total_1501_2009, y = sangkwon_gu,by.x = 'ADSTRD_CD', by.y = '행자부행정동코드', all.x=T)
smallbz_total_1501_2009 <- rename(smallbz_total_1501_2009,c('행정구역' = '시군구명'))

#15.1~20.3분기 데이터가 모두 있는 상권만 선택
selected <- smallbz_total_1501_2009 %>%count(ADSTRD_CD,상권_코드,소분류) %>% filter(n == 23)
smallbz_total_1501_2009 <- merge(x = smallbz_total_1501_2009, y = selected, by = c('ADSTRD_CD','상권_코드','소분류'),all.x=T)
smallbz_total_1501_2009 <- smallbz_total_1501_2009 %>% filter(n==23) %>% select(-n)

#이상치 데이터가 있는 송파구 가락1동 반찬가게,슈퍼마켓,육류 데이터 모두 삭제
smallbz_total_1501_2009 %>% filter(행정구역 == '송파구' & 소분류 %in% c("슈퍼마켓","육류판매","반찬가게") & 행정동명 == "가락1동") %>% 
  mutate(년분기 = paste0(년도,"_",분기)) %>% ggplot(aes(x = 년분기, y=매출총액/점포수_추정매출,color = 소분류))+geom_point()
smallbz_total_1501_2009 <- smallbz_total_1501_2009 %>% filter(행정동명 != "가락1동" | !소분류 %in% c("슈퍼마켓","육류판매","반찬가게"))

#이상치 데이터가 있는 강남구 청담동 문구 데이터 중 상권코드 1000939 제거
smallbz_total_1501_2009 %>% filter(행정구역 =="강남구" & 소분류 =="문구" & 행정동명 == '청담동') %>% 
  mutate(년분기 = paste0(년도,"_",분기)) %>% ggplot(aes(x = 년분기, y = 매출총액/점포수_추정매출,color = as.factor(상권_코드)))+geom_point(position = position_jitter())
smallbz_total_1501_2009 <- smallbz_total_1501_2009 %>% filter(행정동명 != "청담동" | 소분류 !="문구" | 상권_코드!=1000939)

#코로나 확진자 수 가져오기
setwd('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터')
covid19 <- readRDS("코로나19확진자현황.rds")

smallbz_total_1501_2009 <- merge(x = smallbz_total_1501_2009, y = covid19, by = c('년도','분기','행정구역'), all.x=T)

#19년도 코로나 확진자 수 NA값을 0으로 대체
smallbz_total_1501_2009[,"확진자수"] <- ifelse(is.na(smallbz_total_1501_2009$확진자수)==T,yes = 0,no = smallbz_total_1501_2009$확진자수)

#유동인구 데이터 가져오기
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터/원본데이터")
guess_encoding("서울시 우리마을가게 상권분석서비스(상권-추정유동인구).csv")
smallbz_pop <- read.csv("서울시 우리마을가게 상권분석서비스(상권-추정유동인구).csv")


#유동인구 데이터에 행정구 기준 추가
smallbz_pop <- merge(x = smallbz_pop, y = sangkwon_loc,by.x = '상권_코드', by.y = 'TRDAR_CD', all.x=T)
smallbz_pop <- merge(x = smallbz_pop, y = sangkwon_gu,by.x = 'ADSTRD_CD', by.y = '행자부행정동코드', all.x=T)

#조작할 컬럼만 선택
vars <- c(3,4,534,8,17:29)
smallbz_pop <- smallbz_pop[,vars]

#컬럼명 및 컬럼 구성 변경
colnames(smallbz_pop)[1:4] <- c("년도","분기","행정구역","총_유동인구수")

smallbz_pop <- smallbz_pop %>% 
  mutate(유동인구수_월화수목 = 월요일_유동인구_수+화요일_유동인구_수+수요일_유동인구_수+목요일_유동인구_수,
                   유동인구수_금토일 = 금요일_유동인구_수+토요일_유동인구_수+일요일_유동인구_수,
                   유동인구수_0614 = 시간대_2_유동인구_수+시간대_3_유동인구_수,
                   유동인구수_1421 = 시간대_4_유동인구_수+시간대_5_유동인구_수,
                   유동인구수_2106 = 시간대_6_유동인구_수+시간대_1_유동인구_수,) %>% 
  select(년도,분기,행정구역,총_유동인구수,유동인구수_월화수목,유동인구수_금토일, 유동인구수_0614,유동인구수_1421,유동인구수_2106) %>% 
  group_by(년도,분기,행정구역) %>% 
  summarise(총_유동인구수 = sum(총_유동인구수), 유동인구수_월화수목 = sum(유동인구수_월화수목),
                   유동인구수_금토일 = sum(유동인구수_금토일), 유동인구수_0614 = sum(유동인구수_0614),
                   유동인구수_1421 = sum(유동인구수_1421),유동인구수_2106 = sum(유동인구수_2106)) %>% as.data.frame()
smallbz_pop[,1:3] <- map_df(.x = smallbz_pop[,1:3],.f = as.factor)

#매출데이터와 유동인구 데이터 합치기
smallbz_total_1501_2009 <- merge(x = smallbz_total_1501_2009, y = smallbz_pop,by = c("년도","분기","행정구역"), all.x=T)

#소분류 중 / 문자를 & 바꿔 통일하기
smallbz_total_1501_2009$소분류 <- str_replace_all(string = smallbz_total_1501_2009$소분류,pattern = "/",replacement = "&")

#우리마을 상권분석 데이터에서 신생기업 생존율 및 업종 구분 컬럼 가져오기
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터")
load('우리마을상권분석_1501_2009.rda')
smallbz_data <- smallbz_data[,1:8]
colnames(smallbz_data)[6:8] <- c("생존률_1년차","생존률_3년차","생존률_5년차")
smallbz_data$소분류 <- str_replace_all(string = smallbz_data$소분류, pattern = '자전거및기타운송장비', replacement = '자전거 및 기타운송장비')
smallbz_total_1501_2009 <- merge(x = smallbz_total_1501_2009, y = smallbz_data, by = c('년도','분기','소분류','행정구역'), all.x=T)

#상권-숙박시설 데이터 합치기
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터/원본데이터")
guess_encoding("서울시 우리마을가게 상권분석서비스(상권-집객시설).csv")
smallbz_faci <- read.csv("서울시 우리마을가게 상권분석서비스(상권-집객시설).csv")

##NA를 0으로 변환
for(i in 7:26){
  smallbz_faci[,i] <- ifelse(is.na(smallbz_faci[,i])==T,0,smallbz_faci[,i])
}
##행정구 추가
smallbz_faci <- merge(x = smallbz_faci, y = sangkwon_loc,by.x = '상권_코드', by.y = 'TRDAR_CD', all.x=T)
smallbz_faci <- merge(x = smallbz_faci, y = sangkwon_gu,by.x = 'ADSTRD_CD', by.y = '행자부행정동코드', all.x=T)

##필요 컬럼 선택
vars <- c(3,4,28,22)
smallbz_faci <- smallbz_faci[,vars]
colnames(smallbz_faci) <- c("년도","분기","행정구역","숙박시설_수")

smallbz_faci <- smallbz_faci %>% 
  group_by(년도,분기,행정구역) %>% summarise(숙박시설_수 = sum(숙박시설_수))

smallbz_total_1501_2009 <- merge(x = smallbz_total_1501_2009, y= smallbz_faci, by = c("년도","분기","행정구역"),all.x =T)

#지하철 개수 추가
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터")
transportation <- readRDS("지하철역별_행정구 구분.rds")
smallbz_total_1501_2009 <- merge(x = smallbz_total_1501_2009, y= transportation, by = c("행정구역"),all.x =T)

#점포 개수 추가하기
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터/원본데이터")
data1 <- read.csv("서울시_우리마을가게_상권분석서비스(상권-점포)_2015년.csv")
data2 <- read.csv("서울시_우리마을가게_상권분석서비스(상권-점포)_2016년.csv")
data3 <- read.csv("서울시_우리마을가게_상권분석서비스(상권-점포)_2017년.csv")
data4 <- read.csv("서울시_우리마을가게_상권분석서비스(상권-점포)_2018년.csv")
data5 <- read.csv("서울시_우리마을가게_상권분석서비스(상권-점포)_2019년.csv")
data6 <- read.csv("서울시_우리마을가게_상권분석서비스(상권-점포)_2020년.csv")
jeompo <- rbind(data1,data2,data3,data4,data5,data6)

jeompo <- merge(x = jeompo, y = sangkwon_loc,by.x = '상권_코드', by.y = 'TRDAR_CD', all.x=T)
jeompo <- merge(x = jeompo, y = sangkwon_gu,by.x = 'ADSTRD_CD', by.y = '행자부행정동코드', all.x=T)

vars <- c(2,3,4,17,9,10,11,13,15)
jeompo <- jeompo[,vars]
colnames(jeompo)[2:9] <- c("년도","분기","행정구역","소분류","점포수","점포수_유사업종","점포수_개업","점포수_폐업")
jeompo$소분류 <- str_replace_all(jeompo$소분류,"/","&")
smallbz_total_1501_2009 <- merge(x = smallbz_total_1501_2009, y= jeompo, by=c("상권_코드","년도","분기","행정구역","소분류"),all.x=T)

#점포수 처리, NA=>0
na_0 <- function(x){
  x <- ifelse(is.na(x)==T,0,x)
  return(x)
}
vars <- c(13,28,29,30,31)
for(i in vars){
  smallbz_total_1501_2009[,i] <- na_0(smallbz_total_1501_2009[,i])
}

#점포수는 점포수 추정 매출이 유사업종 수보다 큰 경우 점포수_추정매출을, 반대면 점포수_유사업종
#점포가 분기 중간에 폐업한 경우 점포수에서 제외됨
#매출액은 있는데 두 점포수 모두 없는 경우 1개 적용
smallbz_total_1501_2009 <- smallbz_total_1501_2009 %>%
  mutate(점포수 = ifelse(test = 점포수_추정매출 > 점포수_유사업종,yes = 점포수_추정매출,
                      no = ifelse(점포수_유사업종 >= 1,yes = 점포수_유사업종, no = 1))) 

#대분류(업종) 및 소분류(업태) 사이 중분류 추가
#참고 : 중소기업벤처부의 한국표준산업분류
MD_category <- list(오락관련서비스 = c("PC방","노래방","볼링장","전자게임장"),
                    개인및소비용품수리 = c("가전제품수리", "미용실","자동차수리","통신기기수리"),
                    숙박 = c("고시원","여관"),
                    스포츠 = c('골프연습장','당구장','스포츠클럽'),
                    개인 = c('네일숍','세탁소','자동차미용','피부관리실'),
                    교육 = c('스포츠 강습','예술학원','외국어학원','일반교습학원'),
                    보건 = c('일반의원','치과의원','한의원'),
                    부동산 = c("부동산중개업"),
                    기타상품전문 = c('시계및귀금속','안경','애완동물','의료기기','의약품','화장품','화초','예술품'),
                    기타생활용품 = c('가구','인테리어','조명용품','철물점','악기'),
                    무점포 = c('전자상거래업'),
                    오락및여가용품 = c('문구','서적','완구','운동&경기용품','자전거 및 기타운송장비'),
                    음식료품및담배 = c('미곡판매','반찬가게','수산물판매','슈퍼마켓','육류판매','청과상'),
                    의류 = c('가방','섬유제품','신발','일반의류','한복점','유아의류'),
                    전자제품 = c('가전제품','컴퓨터및주변장치판매','핸드폰'),
                    종합소매 = c('편의점'),
                    기타음식점 = c('분식전문점','제과점','치킨전문점','패스트푸드점'),
                    비알콜음료점 = c("커피-음료"),
                    일반음식점 = c('양식음식점','일식음식점','중식음식점','한식음식점'),
                    주점업 = c('호프-간이주점'))
                    # 자동차및부품판매 = c("중고차판매","자동차부품"),
                    # 연료 = c("주유소"),
                    # 전문서비스 = c('법무사사무소','변호사사무소','세무사사무소','회계사사무소'),
                    # 기타전문 = c("사진관"),
                    # 사업시설관리및지원 = c('건축물청소','여행사'),
                    # 임대 = c("비디오&서적임대"),
                    # 여가관련서비스 = c("독서실")


smallbz_total_1501_2009$중분류 <- 0
for(i in 1:length(MD_category)){
  smallbz_total_1501_2009[smallbz_total_1501_2009$소분류 %in% MD_category[[i]],]$중분류 <- names(MD_category[i])
  cat(round(i/length(MD_category),digits=4L)*100,"% 완료\n")
}

#최종 데이터셋 컬럼 정리
vars <- c("년도","분기","행정구역","행정동명","대분류","중분류","소분류","확진자수","점포수","매출총액",
          "매출_월화수목","매출_금토일","매출_0614","매출_1421","매출_2106","총_유동인구수","유동인구수_월화수목",
          "유동인구수_금토일","유동인구수_0614","유동인구수_1421","유동인구수_2106","생존률_1년차","생존률_3년차",
          "생존률_5년차","숙박시설_수","지하철역_수")

smallbz_total_1501_2009 <- smallbz_total_1501_2009[,vars]

#범주형 및 연속형 데이터 정리
vars <- 1:7
smallbz_total_1501_2009[,vars] <- map_df(.x = smallbz_total_1501_2009[,vars],.f = as.factor)
smallbz_total_1501_2009[,-vars] <- map_df(.x = smallbz_total_1501_2009[,-vars],.f = as.numeric)

#파일 저장
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터")
save(smallbz_total_1501_2009,file = "dataset_1501_2009.rda")
