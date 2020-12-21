#xlsx 불러오기 위한 라이브러리 설치 및 실행 -> read.xlsx() 사용 가능
install.packages('openxlsx')
library(openxlsx)

#행결합을 위한 rbind를 하고 싶은데, 열 개수가 다를 경우 plyr 패키지를 사용
#열 개수와 상관없이 강제로 결합시킴
#단, 이럴 경우 NA가 발생하는데, 어디서 발생하는지 모르기에 주의 할 것
#오류 발생 시 stop 방지를 위하며 보통 자동화 업무에 사용
#일부 데이터를 합쳐서 한번에 확인할 경우에도 사용
install.packages("plyr")
library(plyr)
plyr::

# dplyr 패키지 설치
##sql의 select where 등과 같은 명령어로 sql을 토대로 만든 패키지
##패키지별로 함수의 이름이 같은 경우에는 패키지 이름도 명시해야 함

install.packages('dplyr')
library(dplyr)

#tidyr 패키지 설치
## 데이터를 원하는 형태로 변경하는 패키지
##형태 변환, 결측치 정리 등등
install.packages('tidyr')
library(tidyr)

###########################
###### 문자열 다루기 ######
###########################
#텍스트 마이닝쪽에서 많이 활용함
#대표적으로, 불용어처리, 한글만 가져오기 등
#원하는 텍스트 찾기
#ex) 유통 데이터에서 남자,남성을 포함하는 데이터를 가져와서 분석하고 싶을 때 특정 행 추출
## 기본 패키지 설치하기
install.packages("stringr")
library(stringr)

install.packages('lubridate') #시간 데이터를 깔끔하게 정리해주는 패키지
library(lubridate)

install.packages("zoo") #na.locf0 함수 내장 패키지
library(zoo)

# ggplot2 패키지 설치, 불러오기 
install.packages('ggplot2')
library(ggplot2)
#R내장 시각화 함수가 있으나 성능이 떨어지는데
#ggplot과 같은 시각화 패키지들로 인해 파이썬보다 시각화 성능 우수


# RColorBrewer 패키지의 활용
install.packages('RColorBrewer')
library(RColorBrewer)
#팔레트, 보기좋은 특정 색상의 조합을 쓸 수 있음
## http://colorbrewer2.org/

install.packages("sampling")
library(sampling) #샘플링 패키지로 층화추출 시 많이 사용

install.packages("psych")
library(psych) #pairs.panels() 데이터별 상관관계 그래프 출력

install.packages("PerformanceAnalytics");
library(PerformanceAnalytics) 
#chart.Correlation() 내장 패키지로, pairs.panels와 같으나 조금 더 가시성이 있음

install.packages("corrplot")
library(corrplot) #상관관계 그래프로, psych나 performanceanalytics랑 같음, 단, 상관관계에 따라 다양하게 표현가능

install.packages("laercio")
library(laercio)#F검정 사후분석 LDuncan, tukeyHSD

install.packages("gmodels")
library(gmodels)#CrossTable() 카이제곱 분석표가 출력력

install.packages("moments")
library(moments) #왜도 첨도 skewness(왜도) / kurtosis(첨도)