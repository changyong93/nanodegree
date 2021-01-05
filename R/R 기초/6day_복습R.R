#R 내장함수로 색깔 점 찍기
plot(0,0, pch=16, cex=10, col='black')
plot(0,0, pch=16, cex=10, col='pink')
plot(0,0, pch=16, cex=10, col='dodgerblue')
#plot(x, y, dot_shape, dot_size, color)
#windows()
#RGB( )함수와 #RRGGBB HEX코드 활용
rgb(10/255 , 200/255, 100/255)
plot(0,0, pch=16, cex=10, col='#0AC864')

#Rcolorbrewer 패키지
#팔레트, 자주 쓰이는 색상 조합 사용 가능
install.packages('RColorBrewer')
library(RColorBrewer)

#패키지 내의 모든 색상 조합 확인
display.brewer.all()
brewer.pal(9, 'Set1')
#특정 색상 조합에서 랜덤 n개(max 9개)의 색상 가져오기

# ggplot2 패키지 설치, 불러오기 
install.packages('ggplot2')
library(ggplot2)

#데이터 요약/처리를 위한 패키지 불러오기
library(dplyr)
library(tidyr)

#학습용 데이터셋이 들어있는 패키지
install.packages("gapminder")
library(gapminder)
data(gapminder)
head(gapminder)
data1 <- gapminder[gapminder$year == 2007,]
data2 <- gapminder[gapminder$year == c(2002,2007),]

#ggplot 패키지의 내장 함수로 그리기
#만약 우측 하단 결과창이 작을 경우 windows()로 창 띄워놓고 하기
#ggplot은 도화지 위에 물감을 쌓아서 그림을 완성해가는 느낌
#!=파이프라인 <-전체 데이블에서 조회할 데이터를 위해 조건을 추가하는,
#                내부로 들어가는 느낌

## 1.  그릴 부분의 도와지를 그려본다. (aes(x = , y=))
#x = gdpPercap / Y = lifeExp
ggplot(data1)+
  aes(x = gdpPercap) +
  aes(y = lifeExp)
data1 %>% ggplot(aes(x=gdpPercap, y=lifeExp))
ggplot(data1, aes(x=gdpPercap, y=lifeExp))

#산점도 추가
ggplot(data1)+
  aes(x = gdpPercap) +
  aes(y = lifeExp)+
  geom_point()
data1 %>% ggplot(aes(x=gdpPercap, y=lifeExp))+geom_point()
ggplot(data1, aes(x=gdpPercap, y=lifeExp))+geom_point()

#색지정
ggplot(data1) +
  aes(x = gdpPercap) +
  aes(y = lifeExp) + 
  geom_point() +
  aes(color = continent)

#모양 지정
ggplot(data1) +
  aes(x = gdpPercap) +
  aes(y = lifeExp) + 
  geom_point() +
  aes(color = continent)+
  aes(shape = continent)
#투명도 지정
ggplot(data1) +
  aes(x = gdpPercap) +
  aes(y = lifeExp) + 
  geom_point() +
  geom_point(size =3) + #강제로 크기 지정정
  aes(color = continent)+
  aes(shape = continent)+
  aes(size = pop)# 데이터 크기에 비례하여 크기 지정
  
#투명도 지정
ggplot(data1) +
  aes(x = gdpPercap) +
  aes(y = lifeExp) + 
  geom_point() +
  # geom_point(alpha = 0.1) + #투명도 전체를 강제 지정
  aes(color = continent)+
  aes(shape = continent)+
  aes(size = pop)+
  aes(alpha = lifeExp) #데이터 크기에 비례하여 투명조 지정

insurance <- read.csv('insurance.csv')
head(insurance)
#1. bmi에 따라서 charges가 어떻게 변하는지 점그래프를 그리시오
## region을 색으로 지정
## sex를 모양으로 지정
## 투명도는 0.7
insurance %>% 
  ggplot(aes(x=bmi, y=charges, color=region,shape=sex))+geom_point(alpha=0.7)


#2. age에 따라서 charges가 어떻게 변하는지 점그래프를 그리시오
## bmi 색으로 지정
## smoker를 모양으로 지정
insurance %>% 
  ggplot(aes(x=age, y=charges, color=bmi,shape=smoker))+geom_point(alpha=0.7)


###########################################
#막대그래프
#범주형 데이터를 사용
ggplot(data1)+
  aes(x=continent)+
  geom_bar()+
  aes(fill=continent)+ #특정 변수로 색 지정
  scale_fill_brewer('Set1') #팔레트 색상 조합으로 색 지정

ggplot(data1)+
  aes(x=continent)+
  aes(y=lifeExp)+
  geom_bar(stat = "identity")+
  aes(fill=continent)
#막대그래프에 첫번째 코드와 같이 동일한 변수로 x,y넣을 경우
#geom_bar 설정을 할 필요가 없으나, x,y 변수가 다르면 count가 아니므로 stat = identity 추가

#contienet마다 lifeExp의 평균을 그리고 싶으면??
data2 %>%
  filter(year %in% c(2002,2007)) %>%
  group_by(continent,year) %>% 
  summarise(mean = mean(lifeExp)) %>% 
  ggplot()+
  aes(x = continent)+
  aes(y = mean)+
  geom_bar(stat = "identity", alpha =0.7)+
  aes(fill = continent)+
  scale_fill_brewer(palette='Set1')+
  facet_grid(~year)
#팔레트 색상으로 지정을 하고싶으면
#fill로 우선 색칠 후 scale_fill_brewer로 덮기

###########################################
############### 연습해보기  ###############
###########################################
head(insurance)

#1. insurance 데이터에서 region별 charges의 중앙값을 구한후 막대그래프를 그리시고
##  region을 색으로 지정
## 투명도는 0.7
insurance %>% 
  group_by(region) %>% 
  summarise(median = median(charges)) %>% 
  ggplot()+
  aes(x = region, y=median, fill=region)+
  geom_bar(stat = "identity", alpha=0.7)



#2. insurance 데이터에서 sex, smoker별 charges의중앙값을 구한후 막대그래프를 그리시고
## x축은 smoker이며 sex를 색으로 구분
##  region을 색으로 지정
## 투명도는 0.7
#누적막대를 옆으로 펼칠려면 postion = "dodge"추가
## 내가만든 추가 문제 - 지역별로도 보기

insurance %>% 
  group_by(sex, smoker,region) %>% 
  summarise(median = median(charges)) %>%
  # arrange(region,smoker, sex) %>% 
  ggplot()+
  aes(x=smoker, y=median, fill=sex)+
  geom_bar(stat="identity", alpha=0.7, position = "dodge")+
  facet_grid(~region)

######박스 그래프
gapminder %>%
  ggplot(aes(x=continent, y= lifeExp)) + 
  geom_boxplot()

gapminder %>%
  ggplot(aes(x=continent, y= lifeExp, fill= continent)) + 
  geom_boxplot()

gapminder %>%
  ggplot(aes(x=continent, y= lifeExp, fill= continent)) + 
  geom_boxplot(alpha = 0.5)

gapminder %>% 
  group_by(continent) %>%
  dplyr::summarise(mean = mean(lifeExp)) %>%
  ggplot(aes(x=continent, y= mean, fill= continent)) + geom_boxplot()
#filter를 통해서 원하는 변수를 축약해서 그려주는 형태로 많이 씀
#데이터를 요약하면 안됨

#히스토그램
#단점1,하나의 변수에 대한 결과만 볼 수 있음
#단점2, 바 사이즈 조정에 따른 분포가 달라짐
#       ->이럴 경우 박스 플랏 사용
#단 한 데이터에 대해 현업 미팅과 같이 데이터를 공유하는 자리에서는
#히스토그램이 유용하게 사용됨
gapminder %>% 
  ggplot(aes(x=lifeExp))+
  geom_histogram()+
  facet_grid(~continent)

#선 그래프 데이터 변화 추이를 볼 떄 유용함
gapminder %>% 
  group_by(year) %>% 
  dplyr::summarise(sum = sum(lifeExp),mean=mean(lifeExp)) %>% 
  ggplot(aes(x=year, y=sum))+
  # geom_line()
  geom_bar(stat="identity")+
  geom_line()+
  geom_line(aes(x=year, y=mean))+
  geom_line(aes(x=year, y=sum/2))
  # 이렇게 두 가지를 쓰면 하나의 그래프로 나옴

# 선 그래프, 여러 그룹을 그리고자 할 경우
gapminder %>%
  group_by(year,continent) %>%
  dplyr::summarise(mean = mean(lifeExp)) %>%
  ggplot(aes(x=year, y=mean , group=continent ,color= continent))+
  geom_line()

###########################################
############### 연습해보기  ###############
###########################################

#1 insurance데이터에서 children이 0보다 크면 1, 0이면 0인 변수 ch_data를 만드시오
windows()
insurance1 <- insurance %>% 
  mutate(ch_data = as.factor(ifelse(children>0,1,0)))



#2 insurance데이터를 활용해서 막대그래프를 그리시오
## x축은 region y축은 charges이며 ch_data를 색으로 구분
windows()
insurance %>% 
  mutate(ch_data = as.factor(ifelse(children>0,1,0))) %>%
  ggplot(aes(x=region,y=charges,fill=ch_data))+
  geom_bar(stat="identity",alpha=0.7,position = "dodge")+
  facet_grid(c(~smoker,~sex))
  facet_grid()


#3 insurance데이터를 활용해서 막대그래프를 그리시오
## x축은 charges ch_data를 색으로 구분
## region마다 4개의 그래프를 그리시오
windows()
insurance %>% 
  mutate(ch_data = as.factor(ifelse(children>0,1,0))) %>% 
  ggplot(aes(x=charges, fill=ch_data))+
  geom_histogram()+
  facet_grid(~region)

#4 insurance데이터를 활용해서 막대그래프를 그리시오
## x축은 region y축은 charges이며 ch_data를 색으로 구분
## (누적 막대그래프와 ch_data별 비교 막대그래프)
windows()
insurance %>% 
  mutate(ch_data=as.factor(ifelse(children>0,1,0))) %>%
  group_by(region, ch_data) %>%
  summarise(sum=sum(charges))
  ggplot(aes(x=region,y=charges,fill=ch_data))+
  geom_bar(stat = "identity", position = "dodge")
  #sum을 안하고 dodge를 하게 될 경우 누적된 데이터가 다 옆으로 펼쳐짐
  #그래서 가장 높은 값이 나오게 됌
  # geom_bar(stat = "identity")
  options("scipen" = 100)  
  
  insurance1 %>%
    ggplot(aes(x=region, y=charges, fill=factor(ch_data))) +
    geom_bar(stat="identity")
  
  insurance1 %>%
    ggplot(aes(x=region, y=charges, fill=factor(ch_data))) +
    geom_bar(stat="identity",position = "dodge")
  
###ggplot 추가
hr <- read.csv("HR_comma_sep.csv")
hr$left <- as.factor(hr$left)
hr$salary <- factor(hr$salary, levels=c("low","medium","high"))

#테마 변경
ggplot(hr,aes(x=salary)) +
  geom_bar(aes(fill=salary)) +
  theme_classic()

#제목 추가
ggplot(hr,aes(x=salary)) +
  geom_bar(aes(fill=salary)) +
  ggtitle("제목")

#범례 제목 수정
ggplot(hr,aes(x=salary)) +
  geom_bar(aes(fill=salary)) +
  labs(fill = "범례제목")

#범례 테두리 & 위치 선정
graph1<- ggplot(hr,aes(x=salary)) +
  geom_bar(aes(fill=salary))

graph1 + theme(legend.position = 'top')
graph1 + theme(legend.position = 'none')
graph1 + theme(legend.position = 'bottom')
graph1 + theme(legend.position = 'left')
graph1 + theme(legend.position = 'right')
graph1 + theme(legend.position = c(0.9,0.5))

#축변경
#이산형 - discrete
#연속형 - continuous
ggplot(hr,aes(x = salary)) +  
  geom_bar(aes(fill = salary)) +
  theme_bw()+
  scale_x_discrete(labels = c("하","중","상"))+
  scale_fill_discrete(labels = c("하","중","상"))+
  scale_y_continuous(breaks=seq(0,8000,1000))

ggplot(HR,aes(x = salary)) +  
  geom_bar(aes(fill = salary)) +
  theme_bw()+
  ylim(0,6000)

ggplot(HR,aes(x = salary)) +  
  geom_bar(aes(fill = salary)) +
  theme_bw()+
  scale_fill_brewer(palette = 'Set1')
  scale_fill_manual(values = c("red","blue","green"))
##1.은 팔레트로 지정, 2.는 bar별로 색 지정
  
#글자크기, 각도 조정
#coord_flip() : 대칭 그래프
#theme_bw : 글자체 수정
ggplot(hr,aes(x = salary)) +  
  geom_bar(aes(fill = salary)) +
  theme_bw()+
  coord_flip()+
  theme(legend.position = 'top',
        axis.text.x = element_text(size = 15, angle=90),
        axis.text.y = element_text(size = 15),
        legend.text = element_text(size = 15))

ggplot(NULL)+
  geom_vline(xintercept = 10, #수직선
             col='royalblue', size=2)+
  geom_hline(yintercept = 10, #수평선
             col='royalblue', size=2)+
  geom_abline(intercept = 0,
             slope=1, size=2)+ #직선
  theme_bw()

#heatmap
agg2 <- insurance %>% 
  mutate(bmi_grp = cut(bmi,
                       breaks=c(0,30,35,40,100),
                       labels=c('G1','G2','G3','G4'))) %>% 
  group_by(region, bmi_grp) %>% 
  summarise(q90=quantile(charges,0.9))
#+색지정
agg2 %>% 
  ggplot(aes(x=region,y=bmi_grp,fill=q90))+
  geom_tile()+
  scale_fill_gradient(low='white', high='blue')
  # scale_fill_distiller(palette='OrRd')
  #display.brewer.all() palette 색 찾기


###########################################
############### 연습해보기  ###############
###########################################

# (실습) NHIS에서 AGE_GROUP, DSBJT_CD별 EDEC_TRAMT 평균 계산 후 저장
#        저장된 데이터로 열지도 시각화
#어떤 범주형과 어떤 범주형에 대해 전처리 후 히트맵을 그려야 함
head(NHIS)
NHIS %>% 
  group_by(AGE_GROUP,DSBJT_CD) %>% 
  summarise(mean = mean(EDEC_TRAMT)) %>% 
  ggplot(aes(x=AGE_GROUP,y=DSBJT_CD,fill=mean))+
  geom_tile()+
  scale_fill_distiller(palette = "YlOrRd",trans = "reverse")
  display.brewer.all()


###########################################
# tidyr + dplyr + ggplot을 한번에

# 데이터 불러오기
## 역변호가 150인 서울역 데이터 
library(openxlsx)
subway_2017_origin = read.xlsx('subway_1701_1709.xlsx')
names(subway_2017)[6:25] <- paste0('H', substr(names(subway_2017)[6:25], 1, 2))

head(subway_2017)
# gather( ) 함수를 활용하여 H05부터 H24까지 변수를 모아
# '시간대'와 '승객수'으로 구분하는 데이터 subway2 만들기
subway2 = gather(subway_2017, 시간대, 승객수, H05:H24)
head(subway2)
## 위에서 만든 subway2 데이터와 dplyr 패키지를 활용하여
# 역명/시간대별 전체 승객수 합계 계산 (승객수 합계의 내림차순으로 정렬)

### 이러한 tidyr을 통해서 데이터를 시각화하기
### 시간대별로 승객 합계 막대차트로 그려보기!
windows()
subway2 %>% 
  group_by(역명, 시간대) %>% 
  summarise(sum = sum(승객수)) %>% 
  arrange(desc(sum)) %>% 
  ggplot(aes(x=시간대,y=sum,fill=시간대))+
  geom_bar(stat="identity")

subway2 %>% 
  group_by(역명, 시간대) %>% 
  summarise(SUM = sum(승객수)) %>% 
  arrange(desc(SUM)) %>%
  ggplot(aes(x=시간대,y=SUM,fill=시간대)) + geom_bar(stat="identity")

names(subway_2017_origin)[6:25] <- paste0('H',substr(names(subway_2017_origin)[6:25],1,2))
subway_2017_origin %>% 
  gather(시간대,승객수,H05:H24) %>% 
  group_by(역명,시간대) %>% 
  summarise(sum=sum(승객수)) %>% 
  ggplot(aes(x=시간대,y=sum,fill=시간대))+
  geom_bar(stat="identity")

##
rm(list = ls())
data(iris)
head(iris)

#Species별 Sepal.Length의 중앙값을 구하고, 이를 막대 그래프로 나타내기
iris %>% 
  group_by(Species) %>% 
  summarise(SL_mda = median(Sepal.Length)) %>% 
  ggplot(aes(x=Species, y=SL_mda, fill=Species))+
  geom_bar(stat="identity",color ='black')+
  ggtitle("iris종별 Sepal.Length 중앙값")+
  labs(fill = "Species종")+
  theme(legend.position = 'bottom')+
  scale_x_discrete(labels = c("세토사","벌시컬러","버지니아"))+
  scale_y_continuous(breaks=seq(0,10,1))+
  scale_fill_discrete(labels = c("세토사","벌시컬러","버지니아"))+
  ylim(0,10)+
  geom_hline(yintercept = 5, size=0.1)