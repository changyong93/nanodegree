rm(list = ls())
# install.packages("XML")
library(XML)
#고정
api_url="http://openapi.seoul.go.kr:8088"
key="/(자신의 인증키 입력)"
type="/json" #xml or json
service="/VwsmTrdarSelngQq/"

#변경
year=c(2017)

table <- data.frame()
for(i in year){
  request_url=paste0(api_url,key,type,service,1,"/",1,"/",i) #요청할 url 코드 작성
  doc=xmlToDataFrame(request_url) #호출하여 xml 형태의 데이터를 데이터프레임 형으로 변환
  totaldata_num=as.numeric(doc[1,1]) #doc[1,1]에 있는 총 데이터 개수(row) 확인
  start_index=1 #호출 index 첫번호 #1000개씩 호출 가능
  end_index=1000 #호출 index 끝번호
  while(start_index<=totaldata_num){ #호출할 index 첫번호가 총 개수보다 적을 경우 하위 코드 실행
    cat(round(end_index/totaldata_num*100,2),"%","진행 중...\n")
    request_url=paste0(api_url,key,type,service,start_index,"/",end_index,"/",i)
    doc=xmlToDataFrame(request_url)
    table <- rbind(table,doc[3:nrow(doc),4:ncol(doc)])
    start_index=start_index+1000
    end_index=end_index+1000
  }
  cat(i,"년도 데이터 수집 완료")
}
