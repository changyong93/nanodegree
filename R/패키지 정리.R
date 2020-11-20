#xlsx 불러오기 위한 라이브러리 설치 및 실행 -> read.xlsx() 사용 가능능
install.packages('openxlsx')
library(openxlsx)

#행결합을 위한 rbind를 하고 싶은데, 열 개수가 다를 경우 plyr 패키지를 사용
#열 개수와 상관없이 강제로 결합시킴
#단, 이럴 경우 NA가 발생하는데, 어디서 발생하는지 모르기에 주의 할 것
#오류 발생 시 stop 방지를 위하며 보통 자동화 업무에 사용
#일부 데이터를 합쳐서 한번에 확인할 경우에도 사용
install.packages("plyr")
library(plyr)
