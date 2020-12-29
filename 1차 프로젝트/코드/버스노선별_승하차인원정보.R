#파일위치 지정
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터/원본데이터/2020년_버스노선별_정류장별_시간대별_승하차_인원_정보")

#폴더 내 파일 다 불러오기
file_name <- list.files()

test<- data.frame()
for(i in 1:17){
  data=read.csv(file_name[i])
  if(sum(names(data) %in% c('버스정류장ARS번호'))>=1){
    data=rename(data,c('버스정류장ID'='버스정류장ARS번호'))
  }
  if(i %in% c(2,3,4,5,6,7,8,9)){
    data=data[,-2]
  }
  test=rbind(test,data)
  cat(round((i/17*100),1),"% 완료/n")
}

#저장위치 지정
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터")
saveRDS(test,"버스노선별_승하차인원정보.rds")