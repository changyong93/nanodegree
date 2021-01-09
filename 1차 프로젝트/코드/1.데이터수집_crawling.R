library(rvest)
library(RSelenium)
library(httr)
library(seleniumPipes)
library(stringr)
rm(list=ls())
##selenium(셀레니움)을 켭니다
##cmd를 켠 상태에서
##1) cd C:\r-selenium
##2) java -Dwebdriver.gecko.driver="geckodriver.exe" -jar selenium-server-standalone-4.0.0-alpha-1.jar -port 4445
##입력후 엔터로 실행합니다

##그리고 R에서 아래 명령어를 실행
remDr <- remoteDriver(remoteServerAddr="localhost",
                      port=4445L,
                      browserName="chrome")
#cmd에서 상기 1),2)과정 후 cmd를 켜놔야 함
remDr$open()

#사이트 섭속
url_path <- 'https://golmok.seoul.go.kr/regionAreaAnalysis.do'
remDr$navigate(url_path)

#비회원 접속
element <- remDr$findElement(using="xpath",value='//*[@id="loginPop"]/div/button[1]')
element$clickElement()

#기준년/분기 선택
year <- remDr$findElement(using="xpath", value ="//*[@id='selectYear']/option[@value='2020']")
year$clickElement()
quarter <- remDr$findElement(using="xpath",value="//*[@id='selectQu']/option[@value='1']")
quarter$clickElement()

#정보분류 선택
info_class <- remDr$findElement(using="xpath",value="//*[@id='infoCategory']/option[2]")
info_class$clickElement()

#생활밀접업좀
#인구수, 소득/가구수, 임대시세가 아닐 시
#중분류
sector <- remDr$findElement(using="xpath",value="//*[@id='induL']/option[3]")
sector$clickElement()
#소분류
option <- remDr$findElement(using="xpath",value="//*[@id='induM']/option[37]")
option$clickElement()

#검색
button <- remDr$findElement(using="xpath",value="//*[@id='presentSearch']")
button$clickElement()

#table 읽기
table <- remDr$findElement(using="id",value="table1")
page_parse = remDr$getPageSource()[[1]]
page_html = page_parse %>% read_html()
Sys.setlocale('LC_ALL', 'English')
table = page_html %>% html_table(fill = TRUE)
Sys.setlocale('LC_ALL', 'Korean')
data <- as.data.frame(table[4])
# data <- data[str_sub(data$행정구역,-1)=='구',]
data <- rbind(data[1:2,],data[str_sub(data$행정구역,-1)=='구',])
# View(data)
file_name <- paste0(year$getElementText(),"_",quarter$getElementText(),"_",
                    info_class$getElementText(),"_",sector$getElementText(),"_",option$getElementText(),".csv")
setwd('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/data/raw_data/우리마을 상권분석 서비스 데이터')
write.csv(data,file_name)

#--------------------------------------------------------------------------------------------------------------
library(rvest)
library(RSelenium)
library(httr)
library(seleniumPipes)

##selenium(셀레니움)을 켭니다
##cmd를 켠 상태에서
##1) cd C:\r-selenium
##2) java -Dwebdriver.gecko.driver="geckodriver.exe" -jar selenium-server-standalone-4.0.0-alpha-1.jar -port 4445
##입력후 엔터로 실행합니다

##그리고 R에서 아래 명령어를 실행
remDr <- remoteDriver(remoteServerAddr="localhost",
                      port=4445L,  
                      browserName="chrome")

#cmd에서 상기 1),2)과정 후 cmd를 켜놔야 함
remDr$open()

#사이트 섭속
url_path <- 'https://golmok.seoul.go.kr/regionAreaAnalysis.do'
remDr$navigate(url_path)

#비회원 접속
element <- remDr$findElement(using="xpath",value='//*[@id="loginPop"]/div/button[1]')
element$clickElement()

#자동화
#crawling csv파일로 저장 함수
crawling <- function(x,y){
  table <- remDr$findElement(using=x,value=y)
  page_parse = remDr$getPageSource()[[1]]
  page_html = page_parse %>% read_html()
  Sys.setlocale('LC_ALL', 'English')
  table = page_html %>% html_table(fill = TRUE)
  Sys.setlocale('LC_ALL', 'Korean')
  data <- as.data.frame(table[4])
  data_final <- rbind(data[1:2,],data[str_sub(data$행정구역,-1)=='구',])
  if(b>6){
    file_name <- paste0(ele_year$getElementText(),"_",ele_quarter$getElementText(),"_",ele_info_class$getElementText(),".csv")
  } else{
    file_name <- paste0(ele_year$getElementText(),"_",ele_quarter$getElementText(),"_",
                        ele_info_class$getElementText(),"_",ele_sector$getElementText(),"_",ele_option$getElementText(),".csv")
  }
  if(str_detect(file_name, "/")==T){
    file_name <- str_replace_all(file_name,"/","&")
  }
  write.csv(data_final,file_name)
}

setwd('C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/data/raw_data/우리마을 상권분석 서비스 데이터')
getwd()
#input 변수
# year_quarter <- list(Set1=c(2019,4),Set2=c(2020,1),Set3=c(2020,2),Set1=c(2020,3))
# info_class <- c(2:9) #점포분류 
# sector <- c(2:4) #생활밀접업종

year_quarter <- list(Set1=c(2019,4))
#2020 - 1,2,3 // 2019 - 4분기
info_class <- c(4) #점포분류 
sector <- c(3) #생활밀접업종

for(a in 1:length(year_quarter)){
  ele_year=remDr$findElement(using="xpath",value=paste0("//*[@id='selectYear']/option[@value='",year_quarter[[a]][1],"']"))
  ele_year$clickElement()
  Sys.sleep(time = 0.5)
  ele_quarter=remDr$findElement(using="xpath",value=paste0("//*[@id='selectQu']/option[@value='",year_quarter[[a]][2],"']"))
  ele_quarter$clickElement()
  Sys.sleep(time = 0.5)
  for(b in c(info_class)){
    ele_info_class=remDr$findElement(using="xpath",value=paste0("//*[@id='infoCategory']/option[",b,"]"))
    ele_info_class$clickElement()
    Sys.sleep(time = 0.5)
    if(b>6){
      remDr$findElement(using="xpath",value="//*[@id='presentSearch']")$clickElement()
      Sys.sleep(time = 2)
      crawling("id","table1")
      Sys.sleep(time = 0.5)
    } else{
      for(cc in c(sector)){
        ele_sector=remDr$findElement(using="xpath",value=paste0("//*[@id='induL']/option[",cc,"]"))
        ele_sector$clickElement()
        Sys.sleep(time = 0.5)
        webElem <- remDr$findElement('id',"induM")
        appHTML <- webElem$getElementAttribute("outerHTML")[[1]]
        induM_data <- strsplit(appHTML,"</option>")[[1]]
        for(d in seq(2,length(induM_data)-1,1)){
          ele_option=remDr$findElement(using="xpath",value=paste0("//*[@id='induM']/option[",d,"]"))
          ele_option$clickElement()
          Sys.sleep(time = 0.5)
          remDr$findElement(using="xpath",value="//*[@id='presentSearch']")$clickElement()
          Sys.sleep(time = 2.5)
          crawling("id","table1")
          Sys.sleep(time = 0.5)
        } 
      }
    }
  }
}

