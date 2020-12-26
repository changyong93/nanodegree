rm(list = ls())
library(openxlsx)
library(lubridate)
#원본 데이터 위치 및 저장 위치
setwd('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/data/raw_data/skt음성통화 이용데이터')

#폴더 내 파일 리스트 확인
file_list <- list.files()

#빈 데이터 생성
skt_call <- c()

#데이터 형태 변환 후 합치기기
for(i in 1:length(file_list)){
  df=as.data.frame(read.xlsx(file_list[i]))
  df[,1]=ymd(df[,1])
  for(j in 2:7){
    df[,j]=as.factor(df[,j])
  }
  skt_call=rbind(skt_call,df)
}

#파일저장
# write.xlsx(skt_call_data,paste0(write_path,'skt음성통화데이터.xlsx'),row.names=F)
setwd('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/data')
getwd()
save(skt_call,file='skt음성통화데이터.RData')

