# 데이터 분석가 _ james         \
#                                \
# 스크립트 실행(Run a script)    \
##  : Windows : 'Ctrl + Enter'   \
##  : MAC     : 'Command + Enter'\
#---------------------------------

#1. 상관관계분석(Correlation)

height<-c(164,175,166,185)
weight<-c(62,70,64,86)

cor(height,weight) #상관관계 계산
cor(iris$Sepal.Length,iris$Sepal.Width)
round(cor(height,weight),3)

# install.packages("moonBook") 데이터셋 패키지
library(moonBook)
data(acs)
# install.packages("psych")
library(psych)
str(acs)
acs2<-acs[,c(1,6:9)] #연속형 데이터만 선택, 상관관계는 연속형 데이터로 상관관계 계산
cor(acs2) #자신과의 상관관계는 1인데, NA 결측치가 있으므로 하기 유수로 만드는 명령어 사용
#na가 존재할시 na 제외후 계산
cor(acs2,use="na.or.complete") #na 제외하고 계산하는 유수 명령어
windows()
#산점도행렬
pairs.panels(acs2) #psych 패키지 내장 함수, 그래프는 chart.Correlation이 더 보기 좋게 나옴
                   #cor의 유수기능이 내장되어 있어 따로 결측치 처리안해도 됌



# install.packages("PerformanceAnalytics");
library(PerformanceAnalytics)
#산점도행렬
chart.Correlation(acs2, histogram=TRUE, pch=19) #pairs.panels과 같으나 조금 더 가시성 좋게 표현
                                                #histogram F 시 히스토그램 대신 중복인 것은 데이터 이름 출력
                                                #pch는 포인트 종류
                                                #상관관계에서 귀무/대립 가설은 상관관계가 '있다'/'없다'인데, 
                                                #별표는 유의확률로 별이 하나면 유의수준 0.05 기준으로 유의하며 값은 독립이다는 의미.
                                                #상관관계에서는 크게 안봐도 되는게, 값이 작으면 유의확률이 작아므로 별표는 크게 의미 두지 말고 값을 확인 
                                               #cor의 유수기능이 내장되어 있어 따로 결측치 처리안해도 됌
#킹콩 data의 추가 -> 데이터 하나의 큰 영향
dat<-data.frame(
  a=c(15,20,25,27,31,25,23,23,42,12,34,23,40),
  b=c(50,55,52,52,56,54,62,56,70,46,43,50,54)
)
plot(dat$a,dat$b)
abline(lm(dat$b~dat$a)) #lm : linear Regression model
                        #각 점들과 선의 오차가 최소로 되는 선을 긋는 것
cor(dat$a,dat$b)


#outlier 추가
dat[14,]<-c(200,230) #상관계수도 각 값과의 분산을 기반으로 하는데 아웃라이어가 있으면 직선의 형태가 달라지므로, 아웃라이어 처리가 중요함
                     #IQR*1.5 이상은 뺴든가 하는 방식으로 처리를 고려해야 함
                     #넣은 상태에서 하면 바이어스가 있을 수 있음
                     #평균이랑 비슷한 의미
plot(dat$a,dat$b)    
abline(lm(dat$b~dat$a))
cor(dat$a,dat$b)

#heatmap expression
# install.packages("corrplot")
library(corrplot)
(windows())
corrplot(cor(acs2,use="na.or.complete")) #na값(결측값) 처리 후 상관관계표 그리기기
corrplot(cor(acs2,use="na.or.complete"),method="square")
corrplot(cor(acs2,use="na.or.complete"),method="ellipse")
corrplot(cor(acs2,use="na.or.complete"),method="number")
corrplot(cor(acs2,use="na.or.complete"),method="shade")
corrplot(cor(acs2,use="na.or.complete"),method="color")
corrplot(cor(acs2,use="na.or.complete"),method="pie")


#cor의 비모수적인 표현들
#1. spearman
#2. kendall's tau
cor(height,weight) #pearson이 default
cor(height,weight,method="spearman") #스피어맨 캔달 메소드 찾아보기
cor(height,weight,method="kendall") #잘 사용은 안하나 알아두면 좋음
#1,2 모두 비선형 상관관계로,
#피어슨이 0.97로 일차인 선형 상관관계를 구한 거라면
#스피어맨은 비선형으로 이차 등을 분석
#켄달은 concordant pair 개수에 따른 상관관계 분석
#=>양의기울기P/음의기울기Q로, P=4, Q=0이므로 (P-Q)/(P+Q)로 1
#피어슨,스피어맨,켄달타우 비교 https://bskyvision.com/116
#비선형 https://ekdud7667.tistory.com/entry/%EB%B9%84%EC%84%A0%ED%98%95-%EC%83%81%EA%B4%80%EA%B4%80%EA%B3%84-%EC%8A%A4%ED%94%BC%EC%96%B4%EB%A7%8C-%EC%83%81%EA%B4%80%EA%B3%84%EC%88%98-%EC%BC%84%EB%8B%AC%ED%83%80%EC%9A%B0
?cor

############### 연습문제 ###############

data(iris)
#1. iris에서 연속형 데이터를 갖고 상관관계를 구하고 Sepal.Length와 가장 상관있는 변수는 무엇인가?
#(2가지 이상의 시각화를 그려보시오)
head(iris)
cor(iris[,1:4])
corrplot(cor(iris[,1:4],use="na.or.complete"),method = "square")
corrplot(cor(iris[,1:4],use="na.or.complete"),method = "number")
corrplot(cor(iris[,1:4],use="na.or.complete"),method = "color")
pairs.panels(iris[,1:4])
chart.Correlation(iris[,1:4],histogram = T,pch=19)

#####
data(mtcars)
head(mtcars)
#mpg에서 qesc까지의 변수를 갖고 상관관계를 구하시오
corrplot(cor(mtcars[,1:7],use="na.or.complete"),method = "number")
corrplot(cor(mtcars[,1:7],use="na.or.complete"),method = "color")
corrplot(cor(mtcars[,1:7],use="na.or.complete"),method = "shade")
chart.Correlation(mtcars[,1:7],histogram=TRUE, pch = 19)
pairs.panels(mtcars[,1:7])
##################################

#2. 2 집단에대한 평균비교 t-test 
#=> 각각의 집단(1집단, 2집단)

t_data<-data.frame(
  group=c(1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2),
  score=c(100,100,80,50,40,90,20,50,50,70,30,40,30,70,30,40,30,60,30,60),
  age=c(80,20,30,70,90,20,30,60,50,50,20,30,20,20,25,10,13,12,11,10))

ggplot(t_data,aes(x=factor(group),y=score,fill=factor(group))) + geom_boxplot()

#정규성검정

#정규성 검정 -  shapiro
shapiro.test(t_data$score) #p-value가 0.05이상이면 귀무가설 채택 => 정규성띄움
                           #w값은 검정통계량이라 하는데 알고만 넘어가면 됌
                           #https://m.blog.naver.com/PostView.nhn?blogId=pmw9440&logNo=221466236755&proxyReferer=https:%2F%2Fwww.google.com%2F


#등분산성 검정(F검정)

t_data_1<-t_data[t_data$group==1,]
t_data_2<-t_data[t_data$group==2,]
var.test(t_data_1$score,t_data_2$score)  #p-value가 0.05이상이므로 귀무가설 채택=> 등분산
#F값은, data1/data2의 분산비 

#t_test방법 2가지 존재

#1번 t.test방법(T검정)
t.test(t_data_1$score,t_data_2$score,var.equal=T) #var.equal = T가 Default
                                                  #0.05이하므로 드 그룹간 차이가 발생한다
                                                  #t는 검정통계량 값이라는데 다시 찾아볼 것
                                                 #https://m.blog.naver.com/PostView.nhn?blogId=sendmethere&logNo=221333164258&categoryNo=7&proxyReferer=https:%2F%2Fwww.google.com%2F

#2번 t.test방법
t.test(score~group,data=t_data,var.equal=T) #score(값)~group(그룹) 순서 지켜야 함

#등분산이 아닐경우
var.test(t_data_1$age,t_data_2$age) #0.05이하므로 대립가설 채택 => 등분산 X
t.test(t_data_1$age,t_data_2$age,var.equal=F) #0.05 이하므로 x와 y에 대한 나이 차이 있다



#대응 T-test의 수행(전/후비교) - paried=T를 붙여줌
#샤피로 테스는 전후 그룹 각각 진행해서 정규성 검증
before_op = c(137,119,117,122,132,110,114,117)
after_op = c(126,111,117,116,135,110,113,112)

t.test(before_op,after_op,paired=T) #0.05 이상이므로 유의수준에서 벗어나므로 차이가 없음=> 귀무가설 채택


mid = c(16, 20, 21, 22, 23, 22, 27, 25, 27, 28)
final = c(19, 20, 24, 24, 25, 25, 26, 26, 28, 32)
t.test(mid,final, paired=TRUE)



################## T검정 연습해보기 ###################

# 1
a = c(175, 168, 168, 190, 156, 181, 182, 175, 174, 179)
b = c(185, 169, 173, 173, 188, 186, 175, 174, 179, 180)

### 다음 데이터를 갖고 T검정을 하시오 (정규성 생략)
shapiro.test(a)
shapiro.test(b)
#A,B집단 모두 유의수준 0.05 이상이므로 정규성을 가짐
var.test(a,b)
#p-value가 0.05 이상이므로 등분산이다
t.test(a,b,var.equal = T)
#p-value는 0.356으로 0.05이상이므로 귀무가설 채택

#가설검정 프로세스
#귀무 : A 집단과 B 집단의 차이가 없다
#대립 : A 집단과 B 집단의 차이가 있다
#유의확률은 0.356이므로 유의수준 0.05보다 크므로 귀무가설 채택
#즉, A집단과 B집단의 차이가 없다

# 2
data(mtcars)
# am 변수에 따라 mpg가 차이가 있는지 확인하시오
head(mtcars)
am_0 <- mtcars[mtcars$am==0,]
am_1 <- mtcars[mtcars$am==1,]
shapiro.test(am_0$mpg)
shapiro.test(am_1$mpg)
t.test(am_0$mpg,am_1$mpg, var.equal = T)
#독립표본 T검증
#귀무가설 : mtcars의 am = 0,1일떄의 mpg 평균 차이가 없다
#대립가설 : mtcars의 am = 0,1일떄의 mpg 평균 차이가 있다
#=>해석 : 두 집단은 정규성을 띄고, 등분산이며, p-value(유의확률)가 0.05 이하이므로, 귀무가설을 참일 때 대립가설을 채택할 1종 오류를 범할 확률이 5% 이하이므로 대립가설을 채택
#즉 두 집단간 평균 차이가 발생한다

# 3 추가자료문제
#A제약회사에서 체중조절할 수 있는 건강식품을 개발했는데, 정말 체중 조절 효과가 있는가
#귀무 : 체중 변화가 없다, 대립 : 체중 변화가 있다
bf <- c(75, 74, 75, 75, 83, 77, 82, 62, 77, 82, 72, 75, 78, 71, 68,
        76, 71, 54, 75, 77, 82, 74, 76, 70, 77, 82, 62, 77, 82, 68)
af <- c(73, 74, 76, 71, 76, 68, 75, 61, 68, 75, 70, 71, 71, 70, 67,
        73, 74, 50, 76, 68, 75, 74, 73, 69, 68, 75, 61, 68, 75, 67)
shapiro.test(bf)
shapiro.test(af)
wilcox.test(bf,af,paired=T)
t.test(bf,af,paired = T)

#4 추가자료문제
#독립표본 
aa <- c(3,4,6,5,5)
bb <- c(7,6,8,7,5,8)
shapiro.test(aa)
shapiro.test(bb)
var.test(aa,bb)
t.test(aa,bb,var.equal = F)
######################################################

#3.3개이상의 평균비교 시 분산분석 - Anova(Analysis of Variance)

# install.packages("laercio")
library(laercio)
anova_data<-data.frame(
  group=c(1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3),
  score=c(50.5, 52.1, 51.9, 52.4, 50.6, 51.4, 51.2, 52.2, 51.5, 50.8,47.5, 47.7, 46.6, 47.1, 47.2, 47.8, 45.2, 47.4, 45.0, 47.9,46.0, 47.1, 45.6, 47.1, 47.2, 46.4, 45.9, 47.1, 44.9, 46.2))

ggplot(anova_data,aes(x=factor(group),y=score,fill=factor(group))) + geom_boxplot()

tapply(anova_data$score,anova_data$group,mean)
tapply(anova_data$score,anova_data$group,max)

#등분산성 test
bartlett.test(score~as.factor(group),data=anova_data) #factor로 안 되있을까봐 factor로 묶는거고
                                                      #세그룹 이상이므로 앞의 형태로 기입해야 함
                                                      #T검정이랑 과정은 같고 사후 검정이 있냐없냐의 차이이

#oneway.test
oneway.test(score~group,data=anova_data,var.equal = T)
#가설검정에 특화된 함수

?aov
a1<-aov(score~group,data=anova_data) 
summary(aov(score~group,data=anova_data))
#oneway.test와 같으나 분산분석표형태로 바로 볼 수 있음
#p-value = Pr(>F)


#사후분석
library(laercio)
LDuncan(a1, "group")
#laerio 내장 함수

#group에 해당하는 부분이 문자형 이어야함
TukeyHSD(aov(score~as.character(group),data=anova_data)) #던칸과 똑같음
#단, character 형태로 데이터 입력해야 함
plot(TukeyHSD(aov(score~as.character(group),data=anova_data)))



######################
#### 등분산이 아닐경우

anova_data2<-data.frame(
  group=c(1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3),
  score=c(70, 30, 20.3, 85.3, 50.6, 51.4, 51.2, 52.2, 51.5, 50.8,47.5, 47.7, 46.6, 47.1, 47.2, 47.8, 45.2, 47.4, 45.0, 47.9,46.0, 47.1, 45.6, 47.1, 47.2, 46.4, 45.9, 47.1, 44.9, 46.2))

#등분산성 test
bartlett.test(score~as.factor(group),data=anova_data2)


#oneway.test
oneway.test(score~group,data=anova_data2,var.equal = F)

a2<-aov(score~group,data=anova_data2)
summary(aov(score~group,data=anova_data2))

#사후분석
library(laercio)
LDuncan(a2, "group")
#"group"불필요

#group에 해당하는 부분이 문자형 이어야함
TukeyHSD(aov(score~as.character(group),data=anova_data2)) #anova만 가능
plot(TukeyHSD(aov(score~as.character(group),data=anova_data2)))


################## F검정 연습해보기 ###################
data(iris)
#1. iris에서 Species마다 Sepal.Width의 차이가 있는지 확인하시오
# 사후 검정과 해석을 적으시오
unique(iris$Species)
set <- iris[iris$Species=='setosa',]
ver <- iris[iris$Species=='versicolor',]
vir <- iris[iris$Species=='virginica',]
shapiro.test(set$Sepal.Width)
shapiro.test(ver$Sepal.Width)
shapiro.test(vir$Sepal.Width)

bartlett.test(iris$Sepal.Width~iris$Species,data=iris)
oneway.test(iris$Sepal.Width~iris$Species,data=iris, var.equal = T)
summary(aov(iris$Sepal.Width~iris$Species,data=iris))

LDuncan(aov(iris$Sepal.Width~iris$Species,data=iris))
TukeyHSD(aov(iris$Sepal.Width~iris$Species,data=iris))
plot(TukeyHSD(aov(iris$Sepal.Width~iris$Species,data=iris)))
#귀무 : 모든 집단의 평균 같다
#대립 / 모든 집단의 평균 중 하나 이상이 다르다
#해설
#세 그룹이 모두 정규성을 띄고, 등분산이며,
#유의확률 계산 시 0.05이하이므로 적어도 하나 이상은 다르다(귀무가설 기각)
#사후분석 결과 모든 그룹의 평균이 다름
#2 mtcars데이터에서 gear따라 mpg의 차이가 있는지 확인하시오
# 사후 검정과 해석을 적으시오
data(mtcars)
head(mtcars)
unique(mtcars$gear)
shapiro.test(mtcars[mtcars$gear==3,"mpg"])
shapiro.test(mtcars[mtcars$gear==4,"mpg"])
shapiro.test(mtcars[mtcars$gear==5,"mpg"])
bartlett.test(mtcars$mpg~as.factor(mtcars$gear),data=mtcars)
oneway.test(mtcars$mpg~as.factor(mtcars$gear),data=mtcars,var.equal = T)
summary(aov(mtcars$mpg~as.character(mtcars$gear),data=mtcars))
LDuncan(aov(mtcars$mpg~as.character(mtcars$gear),data=mtcars))
TukeyHSD(aov(mtcars$mpg~as.character(mtcars$gear),data=mtcars))
plot(TukeyHSD(aov(mtcars$mpg~as.character(mtcars$gear),data=mtcars)))
#귀무 : 평균 다 같다 / 대립 : 적어도 하나 이상 평균 다르다
#해설
#모든 그룹이 정규성을 띄고, 등분산이며,
#유의확률 계산 시 0.05이하로 적어도 하나 이상 평균 다름(대립가설 채택)
#사후 분석 시 3 그룹만 평균이 다르다.

#######################################################

#문자형 데이터분석
data(acs)
head(acs)

# 성별과 비만은 연관이 있을까?

table(acs$sex,acs$obesity)

acs %>% 
  dplyr::count(sex,obesity) %>%
  ggplot(aes(x=sex,y=n,fill=obesity)) + geom_bar(stat="identity",position = "dodge")


chisq.test(acs$sex,acs$obesity,correct = F)
chisq.test(table(acs$sex,acs$obesity))
#남자와 여자에 대한 비만율은 동립적

# correct?
# 비 연속적 이항분포에서 확률이나 비율을 알기 위하여 연속적 분포인
# 카이제곱 분포를 이용할 떄는 연속성을 가지도록 비연속성을 교정해야할 필요하 있을 떄 사용하는 방법
# 보통 2X2 행렬에서 자주 사용함


install.packages("gmodels")
library(gmodels)

CrossTable(acs$sex,acs$obesity,chisq=T,prop.t=F)
CrossTable(table(acs$sex,acs$obesity))
0.089 + 0.175 + 0.045 + 0.088

# 일반횟수
# 카이 제곱 ( 기대치 비율 )
# 행을 기준으로 비율 값 ( 가로로 읽는다. )
# 컬럼을 기준으로 비율 값 ( 세로로 읽는다. )
# 전체를 기준으로 비율 값

# 성별과 비만은 연관이 있을까?

table(acs$sex,acs$smoking)
acs %>% 
  dplyr::count(sex,smoking) %>%
  ggplot(aes(x=sex,y=n,fill=smoking)) + geom_bar(stat="identity",position = "dodge")

chisq.test(acs$sex,acs$smoking,correct = F)
chisq.test(table(acs$sex,acs$smoking),correct = F)


#자료 생성
dat <- matrix(c(20,24,15,5),ncol=2)
row.names(dat) <- c("흡연","비흡연")
colnames(dat)<- c("정상","비정상")
dat
fisher.test(dat)


xtab <- matrix(c(384, 536, 335,951, 869, 438),nrow=2)
dimnames(xtab) <- list(
  stone = c("yes", "no"),
  age = c("30-39", "40-49", "50-59")
)

colSums(xtab)
prop.trend.test(xtab[1,],colSums(xtab))
mosaicplot(t(xtab),col=c("deepskyblue", "brown2")) #히트맵이랑 유사한 그래프
# 나이 비율이 동일하지 않다


################## 카이제곱 연습해보기 ###################
# 1
install.packages("MASS")
library(MASS)
data(survey)
head(survey)
# survey 데티어에서 Sex변수와 Smoke가 연관이 있는지 검정하여라
# 시각화 포함
aa <- survey[,c(1,9)]
library(dplyr)
aa <- tidyr::drop_na(aa)
aa$
chisq.test(aa$sex,aa$Smoke,correct = T)
table(survey$sex,survey$Smoke)
length(survey$Smoke)
summary(survey)
survey_t <- as.character(survey$sex)

# 2
delivery = read.csv('SKT.csv', fileEncoding='UTF-8')
head(delivery)
# 요일별 업종의 차이가 있는지 검정하여라


#######################################################
