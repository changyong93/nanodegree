rm(list = ls())
library(openxlsx)
library(stringr)
library(lubridate)
setwd('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/data/raw_data')
getwd()
file_name <- list.files()

#소상공인 실적 전망
setwd('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/data/raw_data')
getwd()
data_modi <- function(x){
  data <- read.xlsx(x)
  data <- as.data.frame(t(rbind(data,colnames(data))))
  col_num <- dim(data)[2]
  data$년도 <- year(ym(data[,col_num]))
  data$월 <- month(ym(data[,col_num]))
  colnames(data)[1:col_num] <- c('구분',data[1,c(2:col_num)])
  data <- data[-1,-col_num]
}
Sector_pp <- data_modi(file_name[2])
industry_pp <- data_modi(file_name[3])
region_pp <- data_modi(file_name[4])

setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/data")
getwd()
save(Sector_pp,industry_pp,region_pp,file = "소상공인실적전망.rdata")


#통신사 이용현황 
setwd('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/data/raw_data')
getwd()
carrier_stat <- as.data.frame(t(read.xlsx(file_name[6])))
col_num <- dim(carrier_stat)[2]
carrier_stat$년도 <- year(ym(rownames(carrier_stat)))
carrier_stat$월 <- month(ym(rownames(carrier_stat)))
colnames(carrier_stat)[1:col_num] <- carrier_stat[1,1:col_num]
carrier_stat <- carrier_stat[-1,]

setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/data")
getwd()
save(carrier_stat,file = "통신사이용현황.rdata")
