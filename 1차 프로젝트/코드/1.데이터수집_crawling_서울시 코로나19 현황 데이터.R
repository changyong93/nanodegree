rm(list = ls())
library(jsonlite) #Fromjson 내장 패키지
library(reshape) #rename 내장 패키지

#URL : https://news.seoul.go.kr/api/27/getCorona19Status/get_status_ajax.php?draw=7&start=100&length=100

url <- "https://news.seoul.go.kr/api/27/getCorona19Status/get_status_ajax_pre.php?draw=1"
url <- paste0(url,'&start=0&length=100') #url 지정
#하기 코드로 url 데이터를 보려면 library(httr) 설치
# get_url <- GET(url)
# content(get_url)

data_json <- fromJSON(url) #데이터를  json형태로 호출
data_json$recordsTotal #총 row수(데이터개수) 반환
as.data.frame(data_json$data) #json형태를 data.frame형태로 변환


#데이터를 저장할 dataframe 생성
covid19_patient <- data.frame()

##1~10000번
i <- 0
repeat{
  url <- paste0("https://news.seoul.go.kr/api/27/getCorona19Status/get_status_ajax_pre.php?draw=",(i+1))
  url <- paste0(url,'&start=',i*100,'&length=',100)
  data_json <- fromJSON(url)
  data_totalnum <- data_json$recordsTotal
  cat("1~10000번 확진자 크롤링",floor(((i)*10000)/data_totalnum),"% 진행중...\n")
  covid19_patient <- rbind(covid19_patient,as.data.frame(data_json$data))
  if((i*100)>=data_totalnum) break
  i <- i+1
}
#10000번 이후
i <- 0
repeat{
  url <- paste0("https://news.seoul.go.kr/api/27/getCorona19Status/get_status_ajax.php?draw=",(i+1))
  url <- paste0(url,'&start=',i*100,'&length=',100)
  data_json <- fromJSON(url)
  data_totalnum <- data_json$recordsTotal
  cat("10000번 이후 확진자 크롤링",floor(((i)*10000)/data_totalnum),"% 진행중...\n")
  covid19_patient <- rbind(covid19_patient,as.data.frame(data_json$data))
  if((i*100)>=data_totalnum) break
  i <- i+1
}

#컬럼명 재지정
covid19_patient<- rename(covid19_patient,c('V1'='연번','V2'='환자','V3'='확진일','V4'='거주지',
                                           'V5'='여행력','V6'='접촉력','V7'='퇴원현황'))
#파일 저장 위치 지정
setwd('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터')
getwd()

saveRDS(covid19_patient,"코로나19확진자현황.rds")
