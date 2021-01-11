rm(list = ls())
library(tidyverse)
#폴더 지정
setwd('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터/원본데이터/우리마을 상권분석 서비스 데이터')
getwd()

file_name <- list.files() #폴더 내 파일명 가져오기
file_name_list <- str_sub(file_name,1,nchar(file_name)-4) #파일명에서 .csv 제거
info_class_list <- c('점포수'=1,'신생기업 생존율'=2,'연차별 생존율'=3,'평균영업기간'=4,
                     '개폐업수(률)'=5,'인구수'=6,'소득&가구수'=7,'임대시세'=8)
# x <- '2019년_4분기_개폐업수(률)_소매업_운동&경기용품.csv'
# x <- '2019년_4분기_개폐업수(률)_소매업_유아의류.csv'
# y <- 5
# i <- 2

#엑셀파일 중간 년&분기 데이터 전처리 및 추출
modi_data_2019 <- function(x,y){
  test <- read.csv(x)
  ifelse(y>5,col <- 2,col <- 2:3)
  col_num <- grep(pattern = "2019",x = names(test))
  test <- test[,c(col,as.integer(col_num))]
  col_num <- dim(test)[2]
  if(colnames(test)[2]=="생활밀접업종"){
    d1 <- c()
    d2 <- c()
    for(i in 1:dim(test)[1]){
      d1 <- c(d1,strsplit(test$생활밀접업종,"/")[[i]][1])
      if(length(strsplit(test$생활밀접업종,"/")[[i]])==2){
        d2 <- c(d2,strsplit(test$생활밀접업종,"/")[[i]][2])
      } else {
        name = paste0(strsplit(test$생활밀접업종,"/")[[i]][2],"&",strsplit(test$생활밀접업종,"/")[[i]][3])
        d2 <- c(d2,name)
      }
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

modi_data_2020 <- function(x,y){
  test <- read.csv(x)
  ifelse(y>5,col <- 2,col <- 2:3)
  col_num <- grep(pattern = "2020",x = names(test))
  test <- test[,c(col,as.integer(col_num))]
  col_num <- dim(test)[2]
  if(colnames(test)[2]=="생활밀접업종"){
    d1 <- c()
    d2 <- c()
    for(i in 1:dim(test)[1]){
      d1 <- c(d1,strsplit(test$생활밀접업종,"/")[[i]][1])
      if(length(strsplit(test$생활밀접업종,"/")[[i]])==2){
        d2 <- c(d2,strsplit(test$생활밀접업종,"/")[[i]][2])
      } else {
        name = paste0(strsplit(test$생활밀접업종,"/")[[i]][2],"&",strsplit(test$생활밀접업종,"/")[[i]][3])
        d2 <- c(d2,name)
      }
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
  data_2019 = modi_data_2019(x,y)
  if(str_sub(file_name[i],1,4)==2019){
    
    data_2020 = c()
  }else {
    data_2020 = modi_data_2020(x,y)
  }
  if(y==1){
    store_num_data = rbind(store_num_data,data_2019,data_2020)
  } else if(y==2){
    new_Enter_data = rbind(new_Enter_data,data_2019,data_2020)
  } else if(y==3){
    annual_survival_rate_data = rbind(annual_survival_rate_data,data_2019,data_2020)
  } else if(y==4){
    biz_period_data = rbind(biz_period_data,data_2019,data_2020)
  } else if(y==5){
    swt_biz_data = rbind(swt_biz_data,data_2019,data_2020)
  } else if(y==6){
    pop_data = rbind(pop_data,data_2019,data_2020)
  } else if(y==7){
    income_num_data = rbind(income_num_data,data_2019,data_2020)
  } else {
    rent_price_data = rbind(rent_price_data,data_2019,data_2020)
  }
  cat(i,"_",round(x = i*100/length(file_name), digits = 2L),"% 완료 \n")
}

#컬럼명 변경
colnames(rent_price_data)[5:6] <- rent_price_data[1,5:6]
colnames(biz_period_data)[6:7] <- c("평균영업기간(년,최근10년)","평균영업기간(년,최근30년)")

#불필요 행 제거
store_num_data <- store_num_data %>% filter(행정구역!="서울시 전체")
new_Enter_data <- new_Enter_data %>% filter(행정구역!="서울시 전체")
annual_survival_rate_data <- annual_survival_rate_data %>% filter(행정구역!="서울시 전체")
biz_period_data <- biz_period_data %>% filter(행정구역!='행정구역')
swt_biz_data <- swt_biz_data %>% filter(행정구역!="서울시 전체")
income_num_data <- income_num_data %>% filter(행정구역!="서울시 전체")
pop_data <- pop_data %>% filter(행정구역!="서울시 전체")
rent_price_data <- rent_price_data %>% filter(행정구역!='행정구역')

#소득분위 컬럼 값 변경
income_num_data$소득분위 <- str_sub(income_num_data$소득분위,1,1)

#정보분류 1~5번 합치기(대분수 & 중분류 포함 데이터)
smallbz_data <- merge(x=annual_survival_rate_data,y=biz_period_data,by=c('년도','분기','대분류','소분류','행정구역'),all=T)
smallbz_data <- merge(x=smallbz_data,y=new_Enter_data,by=c('년도','분기','대분류','소분류','행정구역'),all=T)
smallbz_data <- merge(x=smallbz_data,y=swt_biz_data,by=c('년도','분기','대분류','소분류','행정구역'),all=T)
smallbz_data <- merge(x=smallbz_data,y=store_num_data,by=c('년도','분기','대분류','소분류','행정구역'),all=T)

#정보분류 6~8번 합치기(대분수 & 중분류 미포함 데이터)
smallbz_data_gu <- merge(x=income_num_data,y=pop_data,by=c('년도','분기','행정구역'),all=T)
smallbz_data_gu <- merge(x=smallbz_data_gu,y=rent_price_data,by=c('년도','분기','행정구역'),all=T)


#데이터형태 변환
smallbz_data[,9] <- gsub(pattern = "년",replacement = "",x = smallbz_data[,9])
smallbz_data[,10] <- gsub(pattern = "년",replacement = "",x = smallbz_data[,10])

vars <- 1:5
smallbz_data[,vars] <- map_df(.x = smallbz_data[,vars],.f = as.factor)
smallbz_data[,-vars] <- map_df(.x = smallbz_data[,-vars],.f = as.numeric)


vars <- 4:12
smallbz_data_gu[,-vars] <- map_df(.x = smallbz_data_gu[,-vars],.f = as.factor)
for(i in vars){
  smallbz_data_gu[,i] <- str_replace_all(smallbz_data_gu[,i],",","")
  smallbz_data_gu[,i] <- as.numeric(smallbz_data_gu[,i])
}

#csv file로 전처리 데이터 저장장
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터")
getwd()

#rdata로 저장
save(smallbz_data,smallbz_data_gu,file = '우리마을상권분석.rda')


