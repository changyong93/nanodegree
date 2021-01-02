setwd('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/data/raw_data/skt음성통화 이용데이터')
getwd()
Sys.getlocale()

file_list <- list.files()
read.csv(file_list[1],fileEncoding = 'UTF-8')

api_key <- '56aa22b7513d3cecf77299c8fd0b5e16b7e3343d5818b64be21c0ff69a3f5d08'
url <- 'https://api.bigdatahub.co.kr/v1/datahub/datasets/search.json?pid='
loc <- c("1002262","1002263","1002264","1002276","1002283",
         "1002284","1002289","1002293","1002297","1002305",
         "1002306","1002311","1002328","1002333","1002334",
         "1002339")

urllist <- list()
cnt <- 1
for(i in 1: length(loc)){
  urllist[cnt]=paste0(url,loc[i],"&TDCAccessKey=",api_key)
  cnt=cnt+1
}
raw_data <- xmlTreeParse(urllist[1],useInternalNodes = TRUE,encoding = "utf-8")
rootNode <- xmlRoot(raw_data)

# install.packages('RCurl')
# install.packages('digest')
# install.packages('openssl')
# install.packages('jsonlite')
# install.packages('httr')
library(RCurl)
library(digest)
library(openssl)
library(jsonlite)
library(httr)
library(XML)
RCurl::