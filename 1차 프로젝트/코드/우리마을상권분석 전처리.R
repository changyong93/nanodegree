rm(list = ls())
library(stringr)
#폴더 내 파일명 가져오기
file_name <- list.files()

#파일명 분류
switching_list <- c()#개폐업수(률)
income_num_list <- c()#소득\가구수
New_Enterprise_list <- c()#신생기업 생존률
Annual_survival_rate_list <- c() #연차별생존률
population_list <- c() #인구수
rent_price_list <- c() #임대시세
store_num_list <- c() #점포수
biz_period_list <- c()#편균영업기간
file_name_list <- str_sub(file_name,1,nchar(file_name)-4)
file_list <- c('개폐업수(률)','소득&가구수','신생기업 생존율',
            '연차별 생존율','인구수','임대시세',
            '점포수','평균영업기간')

for(i in 1:length(file_name_list)){
  biz <- strsplit(file_name_list[i],'_')[[1]][3]
  if(biz==file_list[1]){
    switching_list <- c(switching_list,file_name_list[i])
  } else if(biz==file_list[2]){
    income_num_list <- c(income_num_list,file_name_list[i])
  } else if(biz==file_list[3]){
    New_Enterprise_list <- c(New_Enterprise_list,file_name_list[i])
  } else if(biz==file_list[4]){
    Annual_survival_rate_list <- c(Annual_survival_rate_list,file_name_list[i])
  } else if(biz==file_list[5]){
    population_list <- c(population_list,file_name_list[i])
  } else if(biz==file_list[6]){
    rent_price_list <- c(rent_price_list,file_name_list[i])
  } else if(biz==file_list[7]){
    store_num_list <- c(store_num_list,file_name_list[i])
  } else{
    biz_period_list <- c(biz_period_list,file_name_list[i])
  }
}

#정보분류 2~6
swt_biz_rate <- c()
# View(swt_biz_rate)
for(i in 1:400){
  switching_name <- paste0(switching_list[i],".csv")
  swt_biz_rate <- rbind(swt_biz_rate,swt_biz_rate_modi(switching_name))
}


#정보분류 7~9
pop_data <- c()
rent_price_data <- c()
# View(pop_data)
# View(rent_price_data)
for(i in 1:4){
  population_name <- paste0(population_list[i],".csv")
  pop_data <- rbind(pop_data,population_modi(population_name))
  rent_price_name <- paste0(rent_price_list[i],".csv")
  rent_price_data <- rbind(rent_price_data,rent_price_modi(rent_price_name))
}

#함수--------------------------------------------------------------------------------------------
#개폐업률
swt_biz_rate_modi <- function(x){
  test <- read.csv(x) 
  test <- test[,c(2:3,12:15)]
  col_num <- dim(test)[2]
  year_quarter <- names(test)[3]
  test$년도 <- str_sub(year_quarter,2,5)
  test$분기 <- str_sub(year_quarter,8,8)
  colnames(test)[1:col_num] <- test[1,1:col_num]
  test <- test[-1,]
}

#인구수

population_modi <- function(x){
  test <- read.csv(x) 
  test <- test[,c(2,11:14)]
  col_num <- dim(test)[2]
  year_quarter <- names(test)[3]
  test$년도 <- str_sub(year_quarter,2,5)
  test$분기 <- str_sub(year_quarter,8,8)
  colnames(test)[1:col_num] <- test[1,1:col_num]
  test <- test[-1,]
}
#임대시세
x <- paste0(rent_price_list[3],".csv")
# rent_price_modi <- function(x){
  test <- read.csv(x) 
  test <- test[,c(2,9:11)]
  col_num <- dim(test)[2]
  year_quarter <- names(test)[3]
  test$년도 <- str_sub(year_quarter,2,5)
  test$분기 <- str_sub(year_quarter,8,8)
  colnames(test)[1:col_num] <- test[1,1:col_num]
  test <- test[-1,]
# }
