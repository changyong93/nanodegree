rm(list = ls())
library(tidyverse)
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터")
list.files()
load("dataset_1501_2009.rda")
windows()
#년분기 및 행정구역에 따른 점포별 log(매출총액) 박스 플랏
smallbz_total_1501_2009 %>% 
  mutate(년분기 = as.factor(paste0(년도,"_",분기))) %>% 
  filter(년분기 != "2020_3") %>% 
  mutate(매출총액 = 매출총액/점포수) %>% 
  ggplot(aes(x = 행정구역, y = log(매출총액), fill = 년분기))+
  geom_boxplot(position = 'dodge')+
  ggtitle("년분기 및 행정구역별 매출총액")+
  scale_y_continuous(breaks = seq(from = -5, to = 30, by = 5),
                     limits = c(0,25))

#년도 분기 및 업태별 행정구역에 따른 log(매출) 박스플랏
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/eda/1501_2009/행정구_매출_박스플랏")
gu_list <- smallbz_total_1501_2009 %>% distinct(행정구역) %>% arrange(행정구역)
for(i in 1:25){
  smallbz_total_1501_2009 %>%
    mutate(년분기 = as.factor(paste0(년도,"_",분기))) %>% 
    filter(년분기 != "2020_3" & 행정구역 == gu_list[i,]) %>% 
    ggplot(aes(x = 소분류, y = log(매출총액/점포수), fill = 년도))+
    geom_boxplot(position = 'dodge')+theme(axis.text.x = element_text(angle = 90))+
    ggtitle(paste0(gu_list[i,],"매출_년도 및 업태"))+
    scale_y_continuous(breaks = seq(from = -5, to = 30, by = 5),limits = c(0,25))+
    ggsave(filename = paste0(gu_list[i,],".jpg"),width = 16,height = 8.14)
  cat(paste0(round(i/25,digits = 2L)*100,"% ",gu_list[i,]," ",i,"/25 ", "완료\n"))
}

#행정구 및 중분류별 소분류에 따른 매출추이 비교
gu_list <- smallbz_total_1501_2009 %>% distinct(행정구역) %>% arrange(행정구역)
MD_category <- list(오락관련서비스 = c("PC방","노래방","볼링장","전자게임장"),
                           개인및소비용품수리 = c("가전제품수리", "미용실","자동차수리","통신기기수리"),
                           숙박 = c("고시원","여관"),
                           스포츠 = c('골프연습장','당구장','스포츠클럽'),
                           개인 = c('네일숍','세탁소','자동차미용','피부관리실'),
                           교육 = c('스포츠 강습','예술학원','외국어학원','일반교습학원'),
                           보건 = c('일반의원','치과의원','한의원'),
                           부동산 = c("부동산중개업"),
                           기타상품전문 = c('시계및귀금속','안경','애완동물','의료기기','의약품','화장품','화초','예술품'),
                           기타생활용품 = c('가구','인테리어','조명용품','철물점','악기'),
                           무점포 = c('전자상거래업'),
                           오락및여가용품 = c('문구','서적','완구','운동&경기용품','자전거 및 기타운송장비'),
                           음식료품및담배 = c('미곡판매','반찬가게','수산물판매','슈퍼마켓','육류판매','청과상'),
                           의류 = c('가방','섬유제품','신발','일반의류','한복점','유아의류'),
                           전자제품 = c('가전제품','컴퓨터및주변장치판매','핸드폰'),
                           종합소매 = c('편의점'),
                           기타음식점 = c('분식전문점','제과점','치킨전문점','패스트푸드점'),
                           비알콜음료점 = c("커피-음료"),
                           일반음식점 = c('양식음식점','일식음식점','중식음식점','한식음식점'),
                           주점업 = c('호프-간이주점'),
                           자동차및부품판매 = c("중고차판매","자동차부품"),
                           연료 = c("주유소"),
                           전문서비스 = c('법무사사무소','변호사사무소','세무사사무소','회계사사무소'),
                           기타전문 = c("사진관"),
                           사업시설관리및지원 = c('건축물청소','여행사'),
                           임대 = c("비디오&서적임대"),
                           여가관련서비스 = c("독서실"))

setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/eda/1501_2009/행정구역_중분류별_소분류 매출변화 추이_log")
top_category <- smallbz_total_1501_2009 %>% distinct(대분류,중분류,소분류)
k <- 1
for(i in 1:nrow(gu_list)){
  for(j in 1:length(MD_category)){
    graph <- smallbz_total_1501_2009 %>% 
      mutate(년분기 = as.factor(paste0(년도,"_",분기))) %>% 
      filter(년분기 != "2020_3" & 행정구역 ==gu_list[i,] & 중분류 ==names(MD_category[j])) %>% 
      group_by(년도,분기,대분류,중분류,소분류,년분기) %>%
      summarise(매출총액 = log(sum(매출총액)/sum(점포수)))
      # arrange(년도,분기,소분류,desc(매출총액)) %>%
    if(dim(graph)[1]>0){
      graph %>% 
        ggplot(aes(x = 년분기, y=매출총액, color = 소분류,group=소분류))+
        geom_line(size =1.5)+
        ggtitle(paste0(gu_list[i,],"_",names(MD_category[j])))+
        ggsave(filename = paste0(gu_list[i,],"_",top_category[top_category$중분류==names(MD_category[j]),"대분류"][1],"_",names(MD_category[j]),".jpg"),width = 16,height = 8.14)
    }
    cat(paste0(round(k/(nrow(gu_list)*length(MD_category)),digits = 4L)*100,"% ",
               gu_list[i,],"_",top_category[top_category$중분류==names(MD_category[j]),"대분류"][1],"_",names(MD_category[j]),
               " ",k,"/",nrow(gu_list)*length(MD_category), " 완료\n"))
    k <- k+1
  }
}

#모든 값을 각 중분류의 평균값으로 적용하고,
#스케일 조정 및 정규분포화를 위해 매출 및 유동인구 데이터는 ln 적용
dataset <- smallbz_total_1501_2009 %>% 
  group_by(년도,분기,행정구역,대분류,중분류) %>% 
  summarise(매출총액 = log(mean(매출총액)/mean(점포수)),
                매출_월화수목 = log(mean(매출_월화수목)/mean(점포수)),
                매출_금토일 = log(mean(매출_금토일)/mean(점포수)),
                매출_0614 = log(mean(매출_0614)/mean(점포수)),
                매출_1421 = log(mean(매출_1421)/mean(점포수)),
                매출_2106 = log(mean(매출_2106)/mean(점포수)),
                총_유동인구수 = log(mean(총_유동인구수)),
                유동인구수_월화수목 = log(mean(유동인구수_월화수목)),
                유동인구수_금토일 = log(mean(유동인구수_금토일)),
                유동인구수_0614 = log(mean(유동인구수_0614)),
                유동인구수_1421 = log(mean(유동인구수_1421)),
                유동인구수_2106 = log(mean(유동인구수_2106)),
                확진자수 = mean(확진자수),
                생존률_1년차 = mean(생존률_1년차),
                생존률_3년차 = mean(생존률_3년차),
                생존률_5년차 = mean(생존률_5년차),
                숙박시설_수 = mean(숙박시설_수),
                지하철역_수 = mean(지하철역_수)) %>% 
  as.data.frame()

summary(dataset)
#일부 컬럼에서 값이 ln(0)로 -inf인 인덱스는 0 입력
vars <- 6:17
dataset[,vars] <- lapply(X = dataset[,vars],FUN = function(x){ifelse(x < 0,0,x)})
#train # test set 나누기
dataset <- dataset %>% mutate(년분기 = as.factor(paste0(년도,"_",분기)))
trainset <- dataset %>% filter(년분기 !='2020_3')
testset <- dataset %>% filter(년분기 =='2020_3')
#-----------------------------------------------------------------------------------------------------------

# #행정구별 시간대에 따른 매출 비율
# trainset %>% 
#   group_by(년도,분기,행정구역,중분류) %>% 
#   filter(년도 == 2020) %>% 
#   summarise(매출총액 = sum(매출총액),
#             매출_0614 = sum(매출_0614),
#             매출_1421 = sum(매출_1421),
#             매출_2106 = sum(매출_2106)) %>% 
#   mutate(매출비율_0614 = 매출_0614/(매출_0614+매출_1421+매출_2106),
#               매출비율_1421 = 매출_1421/(매출_0614+매출_1421+매출_2106),
#               매출비율_2106 = 매출_2106/(매출_0614+매출_1421+매출_2106)) %>% 
#   select(행정구역,매출비율_0614,매출비율_1421,매출비율_2106) %>% 
#   gather(시간대,매출비율,매출비율_0614:매출비율_2106) %>%
#   arrange(행정구역,시간대,매출비율) %>% 
#   group_by(행정구역) %>% 
#   mutate(시간대 = factor(x = 시간대, levels = c("매출비율_2106","매출비율_1421","매출비율_0614")),
#          매출비율_cumsum = cumsum(매출비율)-(0.5*매출비율)) %>% 
#   ggplot(aes(x = 행정구역, y = 매출비율, fill = 시간대))+
#   geom_bar(stat = "identity")+
#   geom_text(aes(label = paste0(round(매출비율,digits=2L),"%"), y=매출비율_cumsum))+
#   ggtitle("20년도_행정구역별 시간대에 따른 매출 비율")

#상관관계 확인
library(PerformanceAnalytics)
library(corrplot)
library(agricolae)
str(trainset)

#연속형 데이터 사이 상관관계 분석
chart.Correlation(R = trainset[,6:23])
windows()

corrplot(cor(trainset[,6:23],use = "na.or.complete"),method = "number")
#목표변수인 매출총액과
#매출_월화수목,매출_금토일,매출_0614,매출_1421,데이터는 강한 상관관계 있음
#입력변수로 채택

#연속형인 목표형 데이터와 명목형인 입력변수 t검정 및 아노바 검정
#년도(2015~2020 => T검정)
tapply(X = trainset$매출총액,INDEX = trainset$년도, FUN = shapiro.test)
table(trainset$년도)
#n>30 으로 정규성이라 가정하고 진행
bartlett.test(formula = 매출총액~년도, data = trainset)
#p-value 0.05미만으로 귀무가설을 채택하지 못하므로 이분산
oneway.test(formula = 매출총액~년도, data = trainset, var.equal=F)
duncan.test(y = aov(formula = 매출총액~년도, data = trainset),
            alpha = 0.05,
            trt = "년도",
            group=T,
            console = T)
#p-avlue 0.05이하로 년도에 따른 매출총액 값의 평균 중 적어도 하나이상은 다름
#2017 / 2018 / 이외년도로 구분되므로 일단 입력변수로 채택하여 유무에 따른 결과 비교

#분기(1,2,3,4 => anova)
by(data = trainset$매출총액, INDICES = trainset$분기, FUN = shapiro.test)
table(trainset$분기)
#n>30으로 정규성이라 가정하고 진행
bartlett.test(formula = 매출총액~분기, data = trainset)
aggregate(매출총액~분기,data=trainset,mean)
tapply(X = trainset$매출총액,INDEX = trainset$분기,FUN = mean)
#p-value 0.05 이상으로 이분산이라는 귀무가설을 채택하지 못하므로 등분산 만족
oneway.test(formula = 매출총액~분기, data = trainset, var.equal=T)
summary(aov(formula = 매출총액~분기, data = trainset))
anova(lm(formula = 매출총액~분기, data = trainset))
#p-value 0.05 이하로 분기 그룹에 따른 매출총액의 차이가 있음
#사후검정
library(laercio)
TukeyHSD(x = aov(formula = 매출총액~분기, data = trainset))
LDuncan(anova = aov(formula = 매출총액~분기, data = trainset))
library(agricolae)
duncan.test(y = aov(formula = 매출총액~분기, data = trainset),
            trt = "분기",
            alpha = 0.05,
            group = T,
            console = T)
#1,2,3분기 / 4분기 그룹으로 매출총액 평균이 유사함
#모델의 입력변수로 추가하여 있을 경우와 없을 경우 비교


#행정구역
tapply(X = trainset$매출총액, INDEX = trainset$행정구역, FUN = shapiro.test)
by(data = trainset$매출총액, INDICES = trainset$행정구역, FUN = shapiro.test)
table(trainset$행정구역)
#종로구, 송파구, 노원구, 구로구는 shapiro.test를 통과하지 못했으나
#n>30 초과로 정규분포라 가정
bartlett.test(formula = 매출총액~행정구역, data = trainset)
#p-value 0.05 이하로 귀무 채택, 즉 이분산
oneway.test(formula = 매출총액~행정구역,data = trainset, var.equal = F)
#적어도 한 그룹 이상의 매출총액  평균이 다름 => 사후검정 진행
#이분산의 사후검정
library(laercio)
TukeyHSD(x = aov(formula = 매출총액~행정구역, data = trainset))
library(agricolae)
duncan.test(y = aov(formula = 매출총액~행정구역, data = trainset),
            trt = "행정구역",
            alpha = 0.05,
            group = F,
            console = T)
#행정구에 따라 평균이 같거나 다른 경우가 있음
#입력변수 적용 전후 모델 성능 비교해보기

#대분류
by(data = trainset$매출총액,INDICES = trainset$대분류, FUN = shapiro.test)
table(trainset$대분류)
#정규분포 검정을 만족하지 못하지만, n>30이므로 정규성 가정
bartlett.test(formula = 매출총액~대분류, data = trainset)
#p-value 0.05 이하로 이분산
oneway.test(formula = 매출총액~대분류, data = trainset, var.equal = F)
#p-value 0.05 미만으로 대분류 그룹간 평균 차이 있음
#입력변수로 채택
duncan.test(y = aov(formula = 매출총액~대분류, data = trainset),
            trt = "대분류",
            console = T,
            group = T,
            alpha = 0.05)
#중분류
tapply(X = trainset$매출총액, INDEX = trainset$중분류, FUN = shapiro.test)
table(trainset$중분류)
#20개 주운류 중주점업,오락관련서비스,스포츠,숙박,부동산,기타생활용품,교육을 제외하고 정규성 없음
#단, n>30으로 정규성 가정하고 진행
bartlett.test(formula = 매출총액~중분류, data = trainset)
#p-value 0.05 이하로 이분산
oneway.test(formula = 매출총액~중분류, data = trainset,var.equal = F)
#중분류별 매출총액의 평균은 차이가 있다는, 귀무가설 채택
duncan.test(y = aov(formula = 매출총액~중분류, data = trainset),
            trt = "중분류",
            alpha = 0.05,
            group = T,
            console = T)
#일부 중분류가 같은 그룹으로 묶이지만, 입력변수에 추가하고 유무에 따른 결과 비교
#년분기
tapply(X = trainset$매출총액, INDEX = trainset$년분기, FUN = shapiro.test)
table(trainset[trainset$년분기!="2020_3",]$년분기)
#정규성이 없지만 N>30 이므로 정규성 가성
bartlett.test(formula = 매출총액~년분기, data = trainset)
#p-value 0.05미만으로 이분산
oneway.test(formula = 매출총액~년분기, data = trainset, var.equal = F)
#p-value 0.05 미만이지만으로 적어도 하나 다름 => 사후검정
duncan.test(y = aov(formula = 매출총액~년분기, data = trainset),
            trt = "년분기",
            console = T)
#사후검정 결과 그룹간 차이가 없는것으로 보임
#단, 모델에 입력 전후 결과 비교 해보기

#최종 입력변수
#확정 : 매출_월화수목,매출_금토일,매출_0614,매출_1421,대분류
#비교 : 매출_2106, 중분류,년도, 분기,행정구역,년분기
#train & test set 저장
setwd("C:/Users/ChangYong/Desktop/나노디그리/1.정규강의 학습자료/1차 프로젝트/소상공인/데이터")
save(trainset,testset,dataset,smallbz_total_1501_2009,file = "dataset_set.rda")