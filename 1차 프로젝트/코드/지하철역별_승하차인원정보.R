setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터/원본데이터/서울시 지하철 호선별 역별 시간대별 승하차 인원 정보")
getwd()
file_list <- list.files()
main_data <- read.csv(file_list[22])
test <- read.csv(file_list[1])

for(i in 1:dim(main_data)[1]){
  main_data$승차총승객수[i]=sum(main_data[i,seq(4,50,2)])
  main_data$하차총승객수[i]=sum(main_data[i,seq(5,51,2)])
  cat(round((i*100)/dim(main_data)[1],2),"% 완료\n")
}
year_month <- c(201901:201912,202001:202009)
main_data <- main_data %>% filter(사용월 %in% year_month)

setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터")
getwd()

saveRDS(main_data,"subway_t.rds")
