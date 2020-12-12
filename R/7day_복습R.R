#기초통계
mean(iris$Sepal.Length) #평균
var(iris$Sepal.Length) #분산
sd(iris$Sepal.Length) #표준편차
summary(iris$Sepal.Length) #사분위수, min, max
quantile(iris$Sepal.Length,seq(0,1,0.1)) #%별 값 계산

x <- factor(c('a','a','b','c','c','b','d','a','d','e'))
table(x) #비율 계산
which.max(table(x)) #최대 빈도수 변수 이름 및 위치 반환
prop.table(table(x)) #factor 비율 계산

#추출
x1 <- sample(1:10,100, replace = T)
table(x1)
x2 <- sample(c('a','b'),100,prob = c(0.3,0.7), replace = T)
table(x2)

#층화추출 sampling 패키지 사용
library(sampling)
strata(data=iris, c("Species"), size = c(3,1,1), method="srswor")
strata(data=iris, c("Species"), size = c(3,1,1), method="srswr")
#==> srswor 비복원 추출 / srswr 복원추출

RB <- sample(c(0,1),400, prob=c(0.4,0.6), replace=T)
table(RB)
library(ggplot2)
ggplot(NULL)+ 
  geom_bar(aes(x=as.factor(RB),fill=as.factor(RB)))+
  xlab("")+ylab("")+
  scale_x_discrete(labels = c("실패","성공"))+
  labs(fill = "실패 vs 성공")+
  scale_fill_discrete(labels = c("실패","성공"))

#이항분포
#동전을 5회 던졌을 때 앞면이 나오는 횟수
rbinom(n=100,size=5,prob=0.5)
table(rbinom(n=100,size=5,prob=0.5))
data.frame(n=rbinom(n=30,size=5,prob=0.5)) %>% 
  ggplot(aes(x=n))+geom_bar()
#이항분포에서 n>=30 시 정규분포화 가능

#동전을 5회 던졌을 떄 앞면이 나오는 횟수마다 확률 확인
#확률밀도확인
dbinom(x=3,size=5,prob = 0.5)
#누적확률확인
pbinom(q=2,size=5,prob=0.5) #0,1,2,3,4,5

##연속확률분포
R = rnorm(n=100000,mean=0,sd=1)
mean(R); sd(R)

ggplot(NULL)+
  geom_histogram(aes(x=R, y=..density..), binwidth = 0.1, fill = 'white', color = 'black')+
  # geom_histogram(aes(x=R), binwidth = 0.1, fill = 'white', color = 'black') 이렇게 써도 그림은 같으나 누적 횟수로 되어 확률 보기가 힘듬
  scale_x_continuous(limits = c(-4,4))+ 
  scale_y_continuous(expand = c(0,0), limits = c(0,0.45))+
  xlab("")+ylab("확률")

#정규분포 그리기
x <- seq(-4,4, length = 10000)
y <- dnorm(x,0,1)
plot(x,y,type = 'l')

x1 <- seq(-1,1.5,length = 1000)
y1 <- dnorm(x1,0,1)
polygon(c(-1,x1,1.5),c(0,y1,0), col = 'gray')
pnorm(1.5,0,1)-pnorm(-1,0,1)
pnorm(1.5,0,1)-pnorm(1,0,1,lower.tail=F)
qnorm(0.975,0,1)#단측기준

rnorm(n, mean = , sd = ) # 평균과 분산에 해당하는 랜덤 샘플, 
dnorm(x, mean = , sd = ) # 확률 밀도함수
pnorm(p, mean = , sd = ) # 누적 분포함수
qnorm(n, mean = , sd = ) # 분쉬수 함수

library(dplyr)
library(tidyr)

k1 <- c()
p1 <- c()
p2 <- c()

for(k in seq(-15,15,by=0.01)){
  p_1 = dnorm(k, 0, 1)
  p_2 = dnorm(k, 0, 5)
  k1 = append(k1,k)
  p1 = append(p1,p_1)
  p2 = append(p2,p_2)
}

df <- data.frame(k1,p1,p2)
df %>% 
  gather(변수,value,p1:p2) %>% 
  ggplot()+
  geom_line(aes(x=k1,y=value, color=변수), size = 1.2)+
  geom_vline(xintercept = 0, linetype = 'dashed', size = 1.5)+
  theme(legend.position = '')+
  xlab("")+ylab("")+
  scale_y_continuous(expand = c(0,0))
  

ggplot(NULL)+
  geom_line(aes(x=k1,y=p1))

x1 = rnorm(n = 1000, mean = 20, sd = 5)
x2 = scale(x1) #정규화

DF = data.frame(
  x1 = x1,
  x2 = x2
)

DF %>% 
  gather("variable","value") %>%
  mutate(variable = ifelse(variable == "x1", "비표준화","표준화")) %>%
  ggplot() +
  geom_density(aes(x = value, fill = variable), alpha = 0.4) +
  theme_bw() +
  theme(legend.position = c(0.8,0.6)) +
  xlab("") + ylab("") + labs(fill = "")

# 문제) 어느 실험실의 연구원이 어떤 식물로부터 하루 동안 추출하는 호르몬의 양은 평균이 30.2mg, 
# 표준편차가 0.6mg인 정규분포를 따른다고 한다. 어느 날 이 연구원이 하루 동안 추출한 호르몬의 양이 29.6mg 이상이고 
# 31.4mg 이하일 확률을 오른쪽 표준정규분포표를 이용하여 구한 것은?(2016년 9월 모의고사 가형 10번)
m <- 30.2
a <- 0.6
x1 <- 29.6
x2 <- 31.4
z1 <- (x1-m)/a
z2 <- (x2-m)/a

pnorm(z2,0,1) - pnorm(z1,0,1)

x <- c()
y <- c()

for(k in seq(-5,5,by=0.01)){
  temp <- dnorm(k,0,1)
  x <- append(x,k)
  y <- append(y,temp)
}
ggplot(NULL)+
  geom_line(aes(x=x,y=y))+
  geom_area(aes(x=ifelse(x>z1 & x<z2,x,0),y=y), fill='royalblue')+
  scale_x_continuous(breaks = seq(-5.5,5.5,by=1))+
  scale_y_continuous(expand = c(0,0), limits = c(0,0.45))+
  xlab("")+ylab("")+
  theme_bw()

###### PT에 있는 문제 풀어보기
# [2015학년도 수능] 어느 연구소에서 토마토 모종을 심은 지 주가 지났을 때, 
# 줄기의 길이를 조사한 결과 토마토 줄기의 길이는 평균이 
# 30cm 표준편차가 2cm인 정규분포를 따른다고 한다. 
# 이 연구소에서 토마토 모종을 심은 지 주가 지났을 때, 
# 토마토 줄기 중 임의로 선택한 줄기의 길이가 27cm이상이고 32cm 이하일 확률을 
# 오른쪽 표준정규분포표를 이용하여 구한 것은? [3점]
m <- 30;a <- 2
x1 <- 27 ; x2 <- 32
z1 <- (x1-m)/a ; z2 <- (x2-m)/a

x <- c(); y <- c()
for(k in seq(-5,5,by=0.01)){
  temp <- dnorm(k,0,1)
  x <- append(x,k)
  y <- append(y,temp)
}
ggplot(NULL)+
  geom_line(aes(x=x,y=y))+
  geom_area(aes(x=ifelse(x>=z1 & x<=z2,x,0),y=y), fill='red')+
  scale_y_continuous(limits = c(0,0.45),expand = c(0,0))+
  scale_x_continuous(breaks = seq(-5,5,by=1))
pnorm(z2,0,1)-pnorm(z1,0,1)

# mtcars 데이터에서 mpg는 평균 23이다 라고 말할 수 있는가?
# 가설검정하여라
rm(list = ls())
data(mtcars)
head(mtcars)
#귀무가설 mpg 평균은 23이 맞다
#대립가설 mpg 평균은 23이 아니다
m <- mean(mtcars$mpg)
sd <- sd(mtcars$mpg)
z <- (23-m)/sd

x <- c() ; y <- c()
for(k in seq(-4,4,0.01)){
  temp <- dnorm(k,0,1)
  x <- append(x,k)
  y <- append(y,temp)
}

ggplot(NULL)+
  geom_line(aes(x=x,y=y))+
  geom_area(aes(x=ifelse(x<=qnorm(0.95,0,1),x,0),y=y),fill='blue',alpha = 0.5)+
  geom_vline(xintercept = z, color = 'red', size = 1.5)+
  scale_y_continuous(limits = c(0,0.45))
1-pnorm(z,0,1)
#p-value 확인 시 0.315로 유의수준 0.05보다 크므로(95% 신뢰구간 범위 내 위치), 귀무가설이 참일 때 대립가설을 선택할 1종오류를 범할 확률이 31.5% 이상이므로 귀무가설 채택, 대립가설 기각

# 중심극한 정리
z<-c()
for(i in 1:10){
  z <- c(z,round(mean(sample(1:6,6,replace = T)),2))
}

ggplot(NULL) +
  geom_bar(aes(x = as.factor(z), fill = as.factor(z))) +
  theme_bw() +
  xlab("") + ylab("") +
  theme(legend.position = 'none')  


z<-c()
for(i in 1:1000){
  z <- c(z,round(mean(sample(1:6,6,replace = T)),2))
}

ggplot(NULL) +
  geom_bar(aes(x = as.factor(z), fill = as.factor(z))) +
  theme_bw() +
  xlab("") + ylab("") +
  theme(legend.position = 'none')  
