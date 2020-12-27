rm(list = ls())
library(stringr)
library(dplyr)
library(lubridate)
#폴더 지정
setwd('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/data/raw_data/우리마을 상권분석 서비스 데이터')
getwd()

file_name <- list.files() #폴더 내 파일명 가져오기
# View(file_name)
file_name_list <- str_sub(file_name,1,nchar(file_name)-4) #파일명에서 .csv 제거
info_class_list <- c('점포수'=1,'신생기업 생존율'=2,'연차별 생존율'=3,'평균영업기간'=4,
                     '개폐업수(률)'=5,'인구수'=6,'소득&가구수'=7,'임대시세'=8)
#엑셀파일 중간 년&분기 데이터 전처리 및 추출
modi_data_R <- function(x,y){
  test <- read.csv(x)
  ifelse(y>5,col <- 2,col <- 2:3)
  col_num <- as.data.frame(str_locate(names(test),str_sub(x,1,4)))
  col_num <- rownames(col_num[!is.na(col_num$start),])
  test <- test[,c(col,as.integer(col_num))]
  col_num <- dim(test)[2]
  if(colnames(test)[2]=="생활밀접업종"){
    d1 <- c()
    d2 <- c()
    for(i in 1:dim(test)[1]){
      d1 <- c(d1,strsplit(test$생활밀접업종,"/")[[i]][1])
      d2 <- c(d2,strsplit(test$생활밀접업종,"/")[[i]][2])
    }
    test$대분류 <- d1
    test$소분류 <- d2
  }
  year_quarter <- names(test)[3]
  test$년도 <- str_sub(year_quarter,2,5)
  test$분기 <- str_sub(year_quarter,8,8)
  colnames(test)[1:col_num] <- test[1,1:col_num]
  if(colnames(test)[2]=="생활밀접업종"){
    test <- test[-1,c((dim(test)[2]-1),dim(test)[2],(dim(test)[2]-3),(dim(test)[2]-2),1,3:(dim(test)[2]-4))]
  } else{
    test <- test[-1,c((dim(test)[2]-1),dim(test)[2],1:(dim(test)[2]-2))]
  }
}
#엑셀파일  우측 년&분기 데이터 전처리 및 추출
modi_data_C <- function(x,y){
  test <- read.csv(x)
  ifelse(y>5,col <- 2,col <- 2:3)
  col_num <- as.data.frame(str_locate(names(test),as.character(as.integer(str_sub(x,1,4))-1)))
  col_num <- rownames(col_num[!is.na(col_num$start),])
  test <- test[,c(col,as.integer(col_num))]
  col_num <- dim(test)[2]
  if(colnames(test)[2]=="생활밀접업종"){
    d1 <- c()
    d2 <- c()
    for(i in 1:dim(test)[1]){
      d1 <- c(d1,strsplit(test$생활밀접업종,"/")[[i]][1])
      d2 <- c(d2,strsplit(test$생활밀접업종,"/")[[i]][2])
    }
    test$대분류 <- d1
    test$소분류 <- d2
  }
  year_quarter <- names(test)[3]
  test$년도 <- str_sub(year_quarter,2,5)
  test$분기 <- str_sub(year_quarter,8,8)
  colnames(test)[1:col_num] <- test[1,1:col_num]
  if(colnames(test)[2]=="생활밀접업종"){
    test <- test[-1,c((dim(test)[2]-1),dim(test)[2],(dim(test)[2]-3),(dim(test)[2]-2),1,3:(dim(test)[2]-4))]
  } else{
    test <- test[-1,c((dim(test)[2]-1),dim(test)[2],1:(dim(test)[2]-2))]
  }
}
#데이터를 정보분류 8개로 합치기 위한 변수 지정
store_num_data <- c() #점포수
new_Enter_data <- c()#신생기업 생존률
annual_survival_rate_data <- c() #연차별생존률
biz_period_data <- c()#평균영업기간
swt_biz_data <- c()#개폐업수(률)
pop_data <- c() #인구수
income_num_data <- c()#소득&가구수
rent_price_data <- c() #임대시세

#데이터 정보분류에 따라 합치기(merge)
for (i in c(1:length(file_name))){
  x=file_name[i]
  y=info_class_list[strsplit(file_name_list[i],'_')[[1]][3]]
  data_R=modi_data_R(x,y)
  if(str_sub(file_name[i],1,4)==2020){
    data_C=modi_data_C(x,y)
  } else{
    data_C=c()
  }
  if(y==1){
    store_num_data = rbind(store_num_data,data_R,data_C)
  } else if(y==2){
    new_Enter_data = rbind(new_Enter_data,data_R,data_C)
  } else if(y==3){
    annual_survival_rate_data = rbind(annual_survival_rate_data,data_R,data_C)
  } else if(y==4){
    biz_period_data = rbind(biz_period_data,data_R,data_C)
  } else if(y==5){
    swt_biz_data = rbind(swt_biz_data,data_R,data_C)
  } else if(y==6){
    pop_data = rbind(pop_data,data_R,data_C)
  } else if(y==7){
    income_num_data = rbind(income_num_data,data_R,data_C)
  } else {
    rent_price_data = rbind(rent_price_data,data_R,data_C)
  }
}
#마지막 전처리
store_num_data <- store_num_data %>% filter(행정구역!="서울시 전체")
new_Enter_data <- new_Enter_data %>% filter(행정구역!="서울시 전체")
annual_survival_rate_data <- annual_survival_rate_data %>% filter(행정구역!="서울시 전체")
colnames(biz_period_data)[6:7] <- c("평균영업기간(년,최근10년)","평균영업기간(년,최근30년)")
biz_period_data <- biz_period_data %>% filter(행정구역!='행정구역')
swt_biz_data <- swt_biz_data %>% filter(행정구역!="서울시 전체")
income_num_data <- income_num_data %>% filter(행정구역!="서울시 전체")
income_num_data$소득분위 <- str_sub(income_num_data$소득분위,1,1)
pop_data <- pop_data %>% filter(행정구역!="서울시 전체")
colnames(rent_price_data)[5:6] <- rent_price_data[1,5:6]
rent_price_data <- rent_price_data %>% filter(행정구역!='행정구역')

#정보분류 1~5번 합치기(대분수 & 중분류 포함 데이터)
smallbiz_DA <- merge(x=annual_survival_rate_data,y=biz_period_data,by=c('년도','분기','대분류','소분류','행정구역'),all=T)
smallbiz_DA <- merge(x=smallbiz_DA,y=new_Enter_data,by=c('년도','분기','대분류','소분류','행정구역'),all=T)
smallbiz_DA <- merge(x=smallbiz_DA,y=swt_biz_data,by=c('년도','분기','대분류','소분류','행정구역'),all=T)
smallbiz_DA <- merge(x=smallbiz_DA,y=store_num_data,by=c('년도','분기','대분류','소분류','행정구역'),all=T)

#정보분류 6~8번 합치기(대분수 & 중분류 미포함 데이터)
smallbiz_DA_WO <- merge(x=income_num_data,y=pop_data,by=c('년도','분기','행정구역'),all=T)
smallbiz_DA_WO <- merge(x=smallbiz_DA_WO,y=rent_price_data,by=c('년도','분기','행정구역'),all=T)

#데이터형태 변환
str_num <- str_locate(smallbiz_DA[,9],"년")[,1]
smallbiz_DA[,9] <-str_sub(smallbiz_DA[,9],1,str_num-1)
str_num <- str_locate(smallbiz_DA[,10],"년")[,1]
smallbiz_DA[,10] <-str_sub(smallbiz_DA[,10],1,str_num-1)
for(i in 1:20){
  if(i<=5){smallbiz_DA[,i] <- as.factor(smallbiz_DA[,i])}
  else {smallbiz_DA[,i] <- as.numeric(smallbiz_DA[,i])}
}

for(i in 1:12){
  if(i<=3){smallbiz_DA_WO[,i] <- as.factor(smallbiz_DA_WO[,i])}
  else {smallbiz_DA_WO[,i] <- str_replace_all(smallbiz_DA_WO[,i],",","")
    smallbiz_DA_WO[,i] <- as.integer(smallbiz_DA_WO[,i])}
}

#feature 추가
smallbiz_DA$개폐업수 <- (smallbiz_DA$개업수-smallbiz_DA$폐업수)

#csv file로 전처리 데이터 저장장
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/data")
getwd()

#rdata로 저장
save(store_num_data,new_Enter_data,annual_survival_rate_data,
     biz_period_data,swt_biz_data,pop_data,income_num_data,rent_price_data,
     smallbiz_DA,smallbiz_DA_WO,file = '우리마을상권분석.RData')
rm(list = ls())
load('우리마을상권분석.RData')


#excel csv파일로 저장
# k <- 1
# while(k < 2){
#   write.csv(store_num_data,'store_num_data.csv',row.names = F) #점포수
#   write.csv(new_Enter_data,'new_Enter_data.csv',row.names = F)#신생기업 생존률
#   write.csv(annual_survival_rate_data,'annual_survival_rate_data.csv',row.names = F) #연차별생존률
#   write.csv(biz_period_data,'biz_period_data.csv',row.names = F)#평균영업기간
#   write.csv(swt_biz_data,'swt_biz_data.csv',row.names = F)#개폐업수(률)
#   write.csv(pop_data,'pop_data.csv',row.names = F) #인구수
#   write.csv(income_num_data,'income_num_data.csv',row.names = F)#소득&가구수
#   write.csv(rent_price_data,'rent_price_data.csv',row.names = F) #임대시세
#   k=k+1
# }

# #-------------------------------------------------------------------------------------------
# #폴더내 파일명을 정보분류에 따라 리스트 나누기
# #파일명 분류
# store_num_list <- c() #점포수
# New_Enterprise_list <- c()#신생기업 생존률
# Annual_survival_rate_list <- c() #연차별생존률
# biz_period_list <- c()#평균영업기간
# switching_list <- c()#개폐업수(률)
# population_list <- c() #인구수
# income_num_list <- c()#소득&가구수
# rent_price_list <- c() #임대시세
# 
# file_list <- c('점포수','신생기업 생존율','연차별 생존율','평균영업기간',
#                '개폐업수(률)','인구수','소득&가구수','임대시세')
# 
# for(i in 1:length(file_name_list)){
#   biz <- strsplit(file_name_list[i],'_')[[1]][3]
#   if(biz==file_list[1]){
#     store_num_list <- c(store_num_list,file_name_list[i])
#   } else if(biz==file_list[2]){
#     New_Enterprise_list <- c(New_Enterprise_list,file_name_list[i])
#   } else if(biz==file_list[3]){
#     Annual_survival_rate_list <- c(Annual_survival_rate_list,file_name_list[i])
#   } else if(biz==file_list[4]){
#     biz_period_list <- c(biz_period_list,file_name_list[i])
#   } else if(biz==file_list[5]){
#     switching_list <- c(switching_list,file_name_list[i])
#   } else if(biz==file_list[6]){
#     population_list <- c(population_list,file_name_list[i])
#   } else if(biz==file_list[7]){
#     income_num_list <- c(income_num_list,file_name_list[i])
#   } else{
#     rent_price_list <- c(rent_price_list,file_name_list[i])
#   }
# }