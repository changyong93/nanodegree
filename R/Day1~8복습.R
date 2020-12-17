#####Day 1#####
x1 <- 10
v1 <- c(T,F,T)

seq(1,7,2) #1~7까지 2씩 증가(by : default)
seq(1,7,by=2) #1~7까지 2씩 증가
seq(1,7,length=2) #1~7 등분 개수

rep(1:3,2) #1~3까지 2회 반복(times(=time) : Default)
rep(1:3,times=2)
rep(1:3,times=c(1,2,3)) #1,2,3을 1,2,3번 반복 수행
rep(1:3,times=c(1:3)) #1,2,3을 1,2,3번 반복 수행
rep(1:3,length = 3) #1~3의 출력 개수가 3개가 될 때까지 반복 수행
rep(1:3,each = 10) #1~3을 각 10번씩 반복 출력


# rep, seq를 한번에 사용하는 문 예제문제
#1. 1~100까지 짝수를 2번씩 출력(2 2 4 4 6 6 .... 100 100)
rep(seq(2,100,2),each = 2)
# 2. 1~5까지 숫자만큼 반복 출력(1 2 2 3 3 3 4 4 4 4 5 5 5 5 5)
rep(1:5,1:5)


factor(c("MALE","FEMALE","MALE"))
gender
factor(c("MALE","FEMALE","MALE"),levels=c("MALE","FEMALE"),labels = c("남자","여자"))

ordered(c(4,1,2,3,1,1,1),levels=c(1,2,3,4), labels=c("20대이하","30대","40대","50대이상"))
cut(c(16,3,29,40,66,12,34),
    breaks = c(0,20,40,60,80),
    include.lowest = T,
    right = T,
    labels= c("0~20","21~40","41~60","61~80"))

matrix(1:9, nrow = 3)
matrix(1:9, ncol = 3)
matrix(1:9, nrow = 3, byrow=T)

# 연습문제
# 1. 다음 벡터 생성
A <- rep(seq(1,3,0.5), 1:5)
B <- 1:15
M <- matrix(c(B,A), ncol = 5, byrow = T)
mm <- data.frame(matrix(c(B,A), ncol = 5, byrow = T))
colnames(M) <- paste0("col",1:5)
names(mm) <- paste("col",1:5)

#특정 row & col 을 선택하거나, 불필요한 row & col 지우기
M[c(1,4,6),c(1,3,5)]

as.data.frame(data) #data를 data.frame형태로 변경
data.frame(data) #data로 데이터프레임 생성

exm <- list(c("Abe", "Bob", "Carol", "Deb"),c("Weight","Height"))
names(exm) <- c("names","features")
exm$names
exm[[1]]

#--------------------------------------------------------------------------------
#####Day 2#####
