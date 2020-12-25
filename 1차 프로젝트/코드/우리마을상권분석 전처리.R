rm(list = ls())
library(stringr)
#폴더 지정
setwd('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/data/raw_data/우리마을 상권분석 서비스 데이터')
getwd()

file_name <- list.files() #폴더 내 파일명 가져오기
file_name_list <- str_sub(file_name,1,nchar(file_name)-4) #파일명에서 .csv 제거

file_name <- list.files()
file_name_list <- str_sub(file_name,1,nchar(file_name)-4)
info_class_list <- c('점포수'=1,'신생기업 생존율'=2,'연차별 생존율'=3,'평균영업기간'=4,
                     '개폐업수(률)'=5,'인구수'=6,'소득&가구수'=7,'임대시세'=8)

modi_data <- function(x,y){
  test <- read.csv(x)
  ifelse(y>5,col <- 2,col <- 2:3)
  col_num <- as.data.frame(str_locate(names(test),str_sub(x,1,4)))
  col_num <- rownames(col_num[!is.na(col_num$start),])
  test <- test[,c(col,as.integer(col_num))]
  col_num <- dim(test)[2]
  year_quarter <- names(test)[3]
  test$년도 <- str_sub(year_quarter,2,5)
  test$분기 <- str_sub(year_quarter,8,8)
  colnames(test)[1:col_num] <- test[1,1:col_num]
  test <- test[,c((dim(test)[2]-1),dim(test)[2],1:(dim(test)[2]-2))]
  test <- test[-1,c((dim(test)[2]-1),dim(test)[2],1:(dim(test)[2]-2))]
}

store_num_data <- c() #점포수
new_Enter_data <- c()#신생기업 생존률
annual_survival_rate_data <- c() #연차별생존률
biz_period_data <- c()#평균영업기간
swt_biz_data <- c()#개폐업수(률)
pop_data <- c() #인구수
income_num_data <- c()#소득&가구수
rent_price_data <- c() #임대시세

for (i in c(1:length(file_name))){
  x=file_name[i]
  y=info_class_list[strsplit(file_name_list[i],'_')[[1]][3]]
  data=modi_data(x,y)
  if(y==1){
    store_num_data = rbind(store_num_data,data)
  } else if(y==2){
    new_Enter_data = rbind(new_Enter_data,data)
  } else if(y==3){
    annual_survival_rate_data = rbind(annual_survival_rate_data,data)
  } else if(y==4){
    biz_period_data = rbind(biz_period_data,data)
  } else if(y==5){
    swt_biz_data = rbind(swt_biz_data,data)
  } else if(y==6){
    pop_data = rbind(pop_data,data)
  } else if(y==7){
    income_num_data = rbind(income_num_data,data)
  } else {
    rent_price_data = rbind(rent_price_data,data)
  }
}

#csv file로 전처리 데이터 저장장
path <- "C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/data"
k <- 1
while(k < 2){
  write.csv(store_num_data,paste0(path,'/store_num_data.csv'),row.names = F) #점포수
  write.csv(new_Enter_data,paste0(path,'/new_Enter_data.csv'),row.names = F)#신생기업 생존률
  write.csv(annual_survival_rate_data,paste0(path,'/annual_survival_rate_data.csv'),row.names = F) #연차별생존률
  write.csv(biz_period_data,paste0(path,'/biz_period_data.csv'),row.names = F)#평균영업기간
  write.csv(swt_biz_data,paste0(path,'/swt_biz_data.csv'),row.names = F)#개폐업수(률)
  write.csv(pop_data,paste0(path,'/pop_data.csv'),row.names = F) #인구수
  write.csv(income_num_data,paste0(path,'/income_num_data.csv'),row.names = F)#소득&가구수
  write.csv(rent_price_data,paste0(path,'/rent_price_data.csv'),row.names = F) #임대시세
  k=k+1
}



#-------------------------------------------------------------------------------------------
#폴더내 파일명을 정보분류에 따라 리스트 나누기
#파일명 분류
store_num_list <- c() #점포수
New_Enterprise_list <- c()#신생기업 생존률
Annual_survival_rate_list <- c() #연차별생존률
biz_period_list <- c()#평균영업기간
switching_list <- c()#개폐업수(률)
population_list <- c() #인구수
income_num_list <- c()#소득&가구수
rent_price_list <- c() #임대시세

file_list <- c('점포수','신생기업 생존율','연차별 생존율','평균영업기간',
               '개폐업수(률)','인구수','소득&가구수','임대시세')

for(i in 1:length(file_name_list)){
  biz <- strsplit(file_name_list[i],'_')[[1]][3]
  if(biz==file_list[1]){
    store_num_list <- c(store_num_list,file_name_list[i])
  } else if(biz==file_list[2]){
    New_Enterprise_list <- c(New_Enterprise_list,file_name_list[i])
  } else if(biz==file_list[3]){
    Annual_survival_rate_list <- c(Annual_survival_rate_list,file_name_list[i])
  } else if(biz==file_list[4]){
    biz_period_list <- c(biz_period_list,file_name_list[i])
  } else if(biz==file_list[5]){
    switching_list <- c(switching_list,file_name_list[i])
  } else if(biz==file_list[6]){
    population_list <- c(population_list,file_name_list[i])
  } else if(biz==file_list[7]){
    income_num_list <- c(income_num_list,file_name_list[i])
  } else{
    rent_price_list <- c(rent_price_list,file_name_list[i])
  }
}