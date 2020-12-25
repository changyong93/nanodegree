library(openxlsx)
library(lubridate)
#원본 데이터 위치 및 저장 위치
setwd('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/data/raw_data/skt음성통화 이용데이터')


file_list <- list.files(read_path)
skt_call_data <- c()

#데이터 형태 변환 후 합치기기
for(i in 1:length(file_list)){
  df=as.data.frame(read.xlsx(paste0(read_path,file_list[i])))
  df[,1]=ymd(df[,1])
  for(j in 2:7){
    df[,j]=as.factor(df[,j])
  }
  skt_call_data=rbind(skt_call_data,df)
}

#파일저장
# write.xlsx(skt_call_data,paste0(write_path,'skt음성통화데이터.xlsx'),row.names=F)
setwd('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/data')
saveRDS(skt_call_data,'skt음성통화데이터.rds')

