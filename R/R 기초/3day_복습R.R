rm(list = ls())

if(조건1){
  #조건 1이 True일 때 실행문
} else{
  #조건 1이 False일 때 실행문
}
if(조건1){
  #조건 1이 True일 때 실행문
} else if(조건2) {
  #조건 1이 False이고, 조건 2가 True일 때 실행문
} else{
  #조건1, 조건2 모두 False일 때 실행문
}

x <- 1:5
if(length(x)==5){ #논리값에 대한 판단
  print(5)
} else if(length(x)==4){
  print(4)
} else{
  "알수없음"
}

# 두개이상의 논리값에 대한 판단, if, elseif, else문으로 쓸 수 있으나
# ifelse로 쓸 수도 있음
x <- 1:4
y <- c(2,1,4,5)
ifelse(sum(x-y) > 0, "pos", ifelse(sum(x-y) < 0, "negative", "zero"))


############ if, ifelse 연습문제
# 문제 1
# a의 평균이 15이상이면 "평균이상" 아니면 "평균미만"으로 출력하시오
a <- seq(1,30,4)
if(mean(a) >=15){
  "평균이상"
} else {
  "평균미만"
}
ifelse(mean(a) >= 15, "평균이상", "평균미만")

# 문제 2
# if , else if , else를 사용해서 tmep 조건을 만드시오
# 0이하면 freezing, 10이하면 cold, 20이하면 cool, 30이하면 warm, 그외는 hot이 출력되게 하시오
temp <- 25
if(temp <= 0){
  "freezing"
} else if(temp <= 10){
  "cold"
} else if(temp <= 20){
  "cool"
} else if(temp <= 30){
  print("warm")
} else{
  "hot"
}


# 문제 2_1
temp <-c(5,20,-6,37,24,13)
# 문제 2번의 값을 ifelse 로 바꿔서 값을 변경하시오
ifelse(temp <= 0, "freezing",
       ifelse(temp <=10, "cold",
              ifelse(temp <=20, "cool",
                     ifelse(temp <= 30,"warm","hot"))))

# 문제 3
# - ifelse 를 사용해서 iris의 Sepal.Length가 6보다 크면 1 작으면 0 변수 생성하시오
# - new라는 변수 추가하고 new가 1인 Sepal.Width의 합을 구하시오
data(iris)
iris$new <- ifelse(iris$Sepal.Length>6,1,0)
sum(iris[iris$new==1,"Sepal.Width"])
##################################################################################################################
rm(list = ls())
die <- 1:6
rolls <- expand.grid(die, die)
rolls$values <- rolls$Var1 + rolls$Var2
prob <- c("1" = 1/6, "2" = 1/6, "3" = 1/6, "4" = 1/6, "5" = 1/6, "6" = 1/6)
rolls$prob1 <- prob[rolls$Var1]
rolls$prob2 <- prob[rolls$Var2]
rolls$prob <- rolls$prob1 * rolls$prob2
sum(rolls$values * rolls$prob) #주사위 기댓값

wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
prob <- c("DD" = 0.03, "7" = 0.03, "BBB" = 0.06, 
          "BB" = 0.1, "B" = 0.25, "C" = 0.01, "0" = 0.52)

rm(list = ls())
############ expand.grid 연습
#1번 문제
# wheel 과 같이 총 7개의 경우의 수가 있다.
# 각 확률은 prob와 같고 총 3번의 시도를 했을 경우에 0.001보다 높은 경우의 수 개수는?
# (3번 추출하며 각각 독립이다)
# (DD, BBB, 7) 과 (DD , 7 , BBB)는 다른 경우의 수다
wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
prob <- c("DD" = 0.03, "7" = 0.03, "BBB" = 0.06, 
          "BB" = 0.1, "B" = 0.25, "C" = 0.01, "0" = 0.52)
df <- expand.grid(wheel, wheel, wheel)
df$prob1 <- prob[df$Var1]
df$prob2 <- prob[df$Var2]
df$prob3 <- prob[df$Var3]
df$prob <- df$prob1 * df$prob2 * df$prob3
nrow(df[df$prob > 0.001,])
#2번 문제
# 동전을 3번 던질 떄 확률은 0.3과 0.7이다
# 첫번째에 앞이나오고 그리고(&) 세번째에 뒤가 나올 확률을 구하시오

coin <- c("앞","뒤")
prob <- c("앞" = 0.3, "뒤" = 0.7)

df <- expand.grid(coin, coin, coin)
df$prob1 <- prob[df$Var1]
df$prob2 <- prob[df$Var2]
df$prob3 <- prob[df$Var3]
df$prob <- df$prob1 * df$prob2 * df$prob3
sum(df[df$Var1 =='앞' & df$Var3=='뒤',"prob"])

##################################################################################################################
rm(list = ls())

for (Value in that){
  #Value가 that 동안 실행할 실행문
}

char <- rep(0,4)
for (i in 1:4){
  char[i] <- i*2
}
############ for문 연습
#1번 문제
# for문을 사용해서 1부터 100까지의 누적합을 구하시오
sum <- 0
for (i in 1:100){
  sum <- sum+i
}

#2번 문제
# for문을 사용해서 위의 주사위 20번 던진 누적 합을 구하시오
sum2 <- 0
sample(1:6,1)
for(i in 1:20){
  sum2 <- sum2 + sample(1:6,1)
}
sum2
##################################################################################################################
rm(list = ls())

while(condition){
  #condition 조건을 만족할 경우 실행할 실행문
} #condition이 무한 loop에 빠지지 않도록 주의

i <- 1
while(i < 6){
  print(i)
  i <- i+1
}
# 1~10까지 누적합 구하기 (cumulative sum by while) : while(condition) { expression }
z <- 0
i <- 1
while( i <= 10) {
  z = z + i
  cat("cumulative summation",z, "\n") #cat = print이랑 비슷하나 특정 변수를 같이 출력 할 수 있음
  i = i + 1
}

repeat{
  #실행문 및 조건
  if(조건) break}
#repeat는 반복문으로 while과 유사하나 condition 조건이 없음
#이럴 경우 무한 loop가 되어 프로그램에 문제가 생기는데
#이를 방지하기 위해 if(조건) break를 넣어서 조건을 수렴하면 loop 중단

############  for, while 문 연습

#1번 문제 구구단 만들어보기
# 2단부터 9단까지 출력해보기

#ex)
# 2 4 6 8 10 12 14 16 18
# 3 6 9 12 ....
# .....
# 9 18 27 36 ....

#1_1 for문
#seq(값 , by = 차이, length.out = 길이)
for(i in 1:9){
  cat(i,"단 : ",seq(i, by =i, length.out = 9),"\n")
}
for(i in 1:9){
  cat(i,"단 : ")
  for(k in 1:9){
    cat(i*k,"")
  }
  cat("\n")
}
#1_2 while문
#while문
i <- 1
while(i < 10){
  cat(i,"단 : ",seq(i, by =i, length.out = 9),"\n")
  i <- i+1
}
##################################################################################################################
rm(list = ls())

myfunction <- function(){
  print("hello")
}
myfunction()

make_sum <- function(x,y){
  return(x+y) #return은 함수의 반환값을 표기해주는 명령어로
}             #return이 없을 경우 마지막 명령문의 값 반환 
make_sum(3,5)

pp <- function(x,y=2){ #함수의 input 변수에 기본값 지정
  x^y                 
}
pp(2,5) #input 데이터 중 y가 안들어왔을 경우 기본값 2로 반환
pp(2)

dt <- function(x,y){
  add <- x+y
  mul <- x*y #여기서 끝낼 경우 add는 없어지고 mul값만 반환
  #c(add,mul) #이렇게 해줄 경우 값만 반환
  c(add = add,mul = mul) #값과 알리아스 같이 반환
}
aa <- dt(3,5)
aa[1]

#인수의 개수가 가변적인 상황
my_f <- function(x,...........){ #.. 2개 이상 기입 시 가변 인수로 인식
  print(x)
  summary(...........) #가변 인수의 점 개수 일치시켜야 함
}
z <- 1:20
zz <- my_f("hi",z)

############ function 연습
#1 
# 성적을 입력했을경우 40점 이하는 "C", 70점 이하는 "B" 
# 71점 이상은 "A"를 출력하는 function을 만드시오

my_grade <- function(x){
  ifelse(x <= 40 & x>=0 , print("C"),
         ifelse(x <= 70, print("B"), print("A")))
}
my_grade(70)

grade <- function(x) {
  if(x>=0 & x<=40){
    print("C")
  } else if(x<=70){
    print("B")
  } else {print("A")}
}
grade(20)
##################################################################################################################
rm(list = ls())
apply(x,margin,func) #벡터로 출력
#x : 배열 또는 행렬 / margin : 함수 적용 방향(1=행방향,2=열방향)
#func : 적용 함수

sum(1:10)
d <- matrix(1:9, ncol=3)
apply(d, 1, sum) #행별로 sum
apply(d, 2, sum) #열별로 sum

rowSums(x, na.rm=FALSE) #x : 배열 또는 숫자를 저장한 DF
colSums(x, na.rm=FALSE) #ma.rm : NA 제외할지 여부

apply(iris[, 1:4],1,sum)
rowSums(iris[, 1:4])

apply(iris[, 1:4],2,sum)
colSums(iris[, 1:4])

lapply(x,func, ... ) #리스트 형태로 데이터 출력
#x:벡터,리스트,표현식,DF
#func 적용 함수
# 추가 인자로, 이 인자들은 Func에 전달됨
result <- lapply(x <- 1:3, function(x){x*2})
unlist(result)
y <- unlist(x, recursive = T, use.names = T)
x <- list(a=1:3, b=4:6)

lapply(x, mean)

lapply(iris[,1:4], mean)

data.frame(do.call(cbind, lapply(iris[,1:4], mean)))

x <- list(data.frame(name="foo", value=1),data.frame(name="bar", value=2))
x
unlist(x)
do.call(rbind,x)
do.call(cbind,x)
#조건별로 unlist와 do.cal 적절히 판단하여 쓰기
#상기 데이터는 name과 value column에 따라 row를 쌓고 싶은 것이므로
#do.cal(rbind,x)가 적합함

sapply(iris[, 1:4], mean)
apply(iris[, 1:4],2, mean)

sapply(iris[,1:4], function(x){x>3})

sapply(iris, class)

tapply(1:10, rep(1, 10), sum) #구분없이 1:10까지 sum으로 합쳐짐
tapply(1:10, 1:10 %% 2 == 1, sum) #홀수,짝수 그룹이 생성되어 합쳐짐
tapply(iris$Sepal.Length, iris$Species, mean) #Species종에 따라 Sepal.Length mean

############ apply 종류 연습
#문제 1
# iris에서 각 행바다(1~4열)의 분산 열을 추가하시오 (var)
iris$var <- apply(iris[,1:4],1,var)
rm(list = ls())
#문제 2
# function을 활용해서 iris[,1:4]의 모든 값들은 제곱하시오
apply(iris[,1:4],2,function(x){x^2})
lapply(iris[,1:4],function(x){x^2})
sapply(iris[,1:4],function(x){x^2},simplify = T)
sapply(iris[,1:4],function(x){x^2},simplify = F) #= lapply


#문제 3
# iris에서 for문을 활용해서 숫자형(iris[,1:4]) 값을 Species별 평균을 구하시오
# z변수에 저장
i <- 1
z <- c()
for(i in 1:4){
  species_mean_cal <- tapply(iris[,i], iris$Species,mean)
  z <- rbind(z,t(species_mean_cal)) #이렇게 하면 알아서 df화 됨
}
z