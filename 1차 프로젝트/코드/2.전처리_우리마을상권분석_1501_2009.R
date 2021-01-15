rm(list = ls())
library(tidyverse)
#폴더 지정
setwd('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터/원본데이터/우리마을 상권분석 서비스 데이터/1501_2009')
getwd()

file_name <- list.files() #폴더 내 파일명 가져오기
file_name_list <- str_sub(file_name,1,nchar(file_name)-4) #파일명에서 .csv 제거
info_class_list <- c('점포수'=1,'신생기업 생존율'=2,'연차별 생존율'=3,'평균영업기간'=4,
                     '개폐업수(률)'=5,'인구수'=6,'소득&가구수'=7,'임대시세'=8)
# x <- '2019년_4분기_개폐업수(률)_소매업_운동&경기용품.csv'
# x <- '2019년_4분기_개폐업수(률)_소매업_유아의류.csv'

#엑셀파일 데이터 전처리 및 추출
modi_data <- function(filename,info_class,year){
  test <- read.csv(filename)
  ifelse(info_class>5,col <- 2,col <- 2:3)
  col_num <- grep(pattern = year,x = names(test))
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

i
#데이터 정보분류에 따라 합치기(merge)
for (i in c(1:(length(file_name)-1))){
  x=file_name[i]
  y=info_class_list[strsplit(file_name_list[i],'_')[[1]][3]]
  if(str_sub(file_name[i],1,4)==2017){
    data = rbind(modi_data(x,y,"2015"), modi_data(x,y,"2016"),modi_data(x,y,"2017"))
  }else if(str_sub(file_name[i],1,4)==2019){
    data = rbind(modi_data(x,y,"2018"), modi_data(x,y,"2019"))
  } else {
    data = rbind(modi_data(x,y,"2018"), modi_data(x,y,"2019"),modi_data(x,y,"2020"))
  }
  if(y==1){
    store_num_data = rbind(store_num_data,data)
  } else {
    new_Enter_data = rbind(new_Enter_data,data)
  }
  cat(round(x = i*100/(length(file_name)-1), digits = 2L),"% 완료","_",i,"_",x,"\n")
}

#불필요 행 제거
store_num_data <- store_num_data %>% filter(행정구역!="서울시 전체")
new_Enter_data <- new_Enter_data %>% filter(행정구역!="서울시 전체")

#소득분위 컬럼 값 변경

#정보분류 2-3번 합치기(대분류 & 소분류 포함 데이터)
smallbz_data <- merge(x=new_Enter_data,y=store_num_data,by=c('년도','분기','대분류','소분류','행정구역'),all=T)


vars <- 1:5
smallbz_data[,vars] <- map_df(.x = smallbz_data[,vars],.f = as.factor)
smallbz_data[,-vars] <- map_df(.x = smallbz_data[,-vars],.f = as.numeric)
lapply(X = smallbz_data,FUN = function(x){sum(is.na(x))})

#csv file로 전처리 데이터 저장장
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터")
getwd()

#rdata로 저장
save(smallbz_data,file = '우리마을상권분석_1501_2009.rda')


