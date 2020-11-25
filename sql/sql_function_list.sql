/* 오라클 접속 순서
    1. SYSTEM 계정 접속
    2. CDB, PDB 접속
    3. Tablespace 생성 & 사용자 계정 생성(orauser, tablespace 옵션 포함)
    4. HR계정 unlock 후 접속*/


--cdb 계정에서    
show con_name;
select con_id, name from v$pdbs;
select name, cdb from v$database;
show pdbs

--pdb system 계정에서
show con_name;
create tablespace ora_tb datafile 'C:\app\ChangYong\product\18.0.0\oradata\XE\XEPDB1\ora_tb.dbf'
size 100m autoextend on next 10m maxsize unlimited;

create user orauser identified by chang default tablespace ora_tb;
grant DBA to orauser;

--pdb system 계정 혹은 orauser 계저도 가능(DBA 롤 부여)
alter user hr identified by hr account unlock;

--SQL 종류-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DDL
create table 테이블명; --객체 생성
drop table 테이블명; --객체 삭제
alter table 테이블명; --객체 수정
truncate table 테이블명; --객체 데이터 전체 삭제
rename table 테이블명 to 테이블명; -- 객체 이름 변경
--DML
select * from 테이블명 --테이블 조회
insert into 테이블(컬럼명1, 컬럼명2, ,,,) values(데이터1, 데이터2,...) --데이터 입력/저장
update emp set salary =5000 from where salary in null; --기존 데이터 수정
delete from emp where salary <=10000; --데이터 삭제
--TCL
commit; --커밋
rollback; -- 롤백
--DCL
grant DBA to orauser; --권한/롤 할당
revoke DBA from orauser; 권할/롤 회수
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*데이터 확인*/
desc emp -- 테이블 구조 확인
select * from emp; -- 테이블 모든 레코드(행, row) 확인
select distinct * from emp; -- 중복 데이터 삭제
select distinct * from employees where mod(employee_id, 2) = 0; --employee_id의 짝수 번호만 출력
/*데이터 조건별 검색*/
select * from emp where salary > 5000 order by salary desc; -- salary 5000이상으로 내림차순으로 정리, 
                                                            --여러개일 경우 salary desc, first_name; 혹은 2 desc ,3, phone_number desc ;도 가능(번호는 좌측부터 컬럼 순서대로)
select * from employees order by salary desc; -- asc(오름차순)default, 생략 가능 / desc내림차순

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*modify*/
alter table emp modify col1 number not null; --컬럼 정보 수정

--연산자-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--기본연산자
select 10 + 4 as plus from dual;
select 10 - 4 as minus_ from dual;
select 10 * 4 as multifly from dual;
select 10 / 4 as devide from dual;
select -10 as minus_number from dual;
select +10 as plus_number from dual;
select 10 || 4 as "문자결합" from dual;

--비교 연산자
select * from employees where salary = 24000; -- salary가 24000인 레코드
select * from employees where not(salary = 24000); -- salary가 24000이 아닌 레코드
select * from employees where salary != 24000; -- salary가 24000이 아닌 레코드
select * from employees where salary <> 24000; -- salary가 24000이 아닌 레코드
select * from employees where salary > 24000;-- salary가 24000 초과인 레코드
select * from employees where salary >= 24000;-- salary가 24000 이상인 레코드
select * from employees where salary < 24000;-- salary가 24000 미만인 레코드
select * from employees where salary <= 24000;-- salary가 24000 이하인 레코드
select * from employees where salary between 2000 and 24000;-- salary가 2000이상 24000이하 사이인 레코드
select * from employees where salary not between 2000 and 24000;-- salary가 2000이상 24000이하가 아닌 레코드
select * from employees where salary < 24000 and salary > 2000;-- salary가 24000초과 & 2000미만인 레코드
select * from employees where salary = 24000 or salary < 2000;-- salary가 24000이거나 2000미만인 레코드

--기타연산자
select * from employees where commission_pct is null;-- commission_pct가 비어있는 레코드
select * from employees where commission_pct is not null;-- commission_pct가 비어있는 않은 레코드
select * from employees where job_id like 'SA%'; -- job_id에 SA문자가 포함된 레코드
select * from employees where job_id not like 'SA%'; -- job_id에 SA문자가 포함되어 있지 않는 레코드
select * from employees where job_id in ('AD_PRES','AD_VP'); -- job_id에 AD_PRES or AD_VP인 레코드(2개이상은 ,로 여러개 가능)
select * from employees where job_id not in ('AD_PRES','AD_VP'); -- job_id에 AD_PRES or AD_VP가 아닌 레코드

--like + in regexp_like(column명, '문자1|문자2|문자3,...' , match parameter(옵션)
select * from employees where regexp_like(job_id, 'PRES|AD', 'i'); 
/* match parameter
    i : 대소문자 구별없이 매칭
    c : 대소문자 구별하여 매칭
    n : 원래 점('.')이 와일드카드에서는 '하나의 문자와 대응'이란 뜻인데, 이걸 마침표의 역할로 하게 하겠다는, 즉 개행 문자와 일치
        점은 디폴트에서 개행문자가 아니라 와일드카드에서 가지는 의미로 사용
    m : 멀티플라이 모드 파라미터, '대상 문자열(컬럼명)'이 한 줄이 아니라 여러 줄을 가질 때 사용할 수 있는 옵션
        m파라미터를 가지고 오라클으 ㄴ'^'가 나오면 시작점으로 $를 끝점으로 생각하고 수행
    x : whitespace 문자가 무시(본래 디폴트는 무시 안함)
        *whitepsace -> 공백, 탭 개행, 캐리지리턴 등 비스무리한 것들 모두 포함
https://jhnyang.tistory.com/292 페이지 참고*/

--집계 함수
count() 개수 반환
max() 최댓값 반환
min() 최솟값 반환
sum() 합계 반환
avg() 평균 반환
--case---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--단순형 case
select country_id, country_name,
    case region_id when 1 then '유럽'
                   when 2 then '아메리카'
                   when 3 then '아시아'
                   when 4 then '중동 및 아프리카'
    end as region_name
from countries;
--region_id를 조건에 따라 구분하여 새로운 컬럼에 저장하여 조회

--검색형 case
select employee_id, first_name, last_name, salary, job_id,
    case when salary between 1 and 5000 then '낮음'
         when salary between 5001 and 10000 then '중간'
         when salary between 10001 and 15000 then '높음'
         else '최상위'
    end salary_rank
from employees;
-- 특정 컬럼의 값을 조건에 맞게 검색하여 새로운 컬럼에 저장하여 조회

--select case 시 컬럼 전체 조회(*)도 하고 싶을 경우
select p.*,
    case when salary between 1 and 5000 then '낮음'
         when salary between 5001 and 10000 then '중간'
         when salary between 10001 and 15000 then '높음'
         else '최상위'
    end salary_rank
from employees p;
--employees를 알리아스 p로 정의해놓고 p의 all을 검색하면 됌




-- 의사컬럼---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--rownum
select first_name, last_name, rownum from employees;
select * from employees where rownum <=20;
/*
쿼리 수행 후 조회된 각 로우에 대해 rownum 의사컬럼은 그 순서를 가리키는 수를 반환
row1~row100이 각각 1~100과 같이 번호 부여됨
주로 where 절에서 쿼리 결과로 반환되는 로우 수 제어할 때 사용

단, 상위부터 데이터 개수를 제한하는 함수는 하기 함수도 가능
*/
select * from employees limit 20;


------------------------------------------------------------------------------------------------------------------------------------------------------------
--문자형
select abs(10) from dual; -- 절대값 ***************
select ceil(9.5) from dual; -- 올림
select floor(9.5) from dual; -- 내림
select exp(9.5) from dual; -- 지수함수
select ln(9.5) from dual; -- 자연로그 함수
select log(10, 1000) from dual; --로그 함수

--숫자형
select mod(100,3) from dual; --나머지 ***************
select power(2,3) from dual; --2^3승
select round(11.03,2) from dual; --소수n 자리에서 반올림 ***************
select sign(1) from dual; -- n>0 ->1 / n<0, ->-1, n = 0 ->0 qksghks
select sqrt(4) from dual; -- 제곱근
select trunc(3.542,2) from dual; --소수 n자리에서 생략 ***************

--문자형
select concat('A','B') from dual; -- = 'A'||'B'와 같음, 단 문자열 두개만
select initcap('SQL') from dual; --문자열 중 첫 알파벳 대문자, 나머진 소문자
select lower('Sql') from dual; -- 소문자화 ***************
select upper('Sql') from dual; -- 대문자화 ***************
select lpad('Sql', 5, '*') from dual; -- (expr1, n ,expr2), n-expr1 자리수만큼 expr1의 왼쪽에 expr2를 채워 반환
select rpad('Sql', 5, '*') from dual; -- (expr1, n ,expr2), n-expr1 자리수만큼 expr1의 오른쪽에 expr2를 채워 반환
select ltrim('**sql**','*') from dual; -- (expr1,expr2) expr1의 왼쪽에서 expr2를 제거한 상태로 반환
select rtrim('**sql**','*') from dual; -- (expr1,expr2) expr1의 오른에서 expr2를 제거한 상태로 반환
select substr('abcde',3,2) from dual;-- (chr,n,p) chr의 n째에서 p개만큼 출력, n은 좌측기준 +1부터, 우측기준 -1
select trim(' abc def ') from dual;-- 양쪽 끝의 공백을 제거한 상태로 출력
select ascii('a') from dual;--아스키코드(ASCII)로 출력
select lengthb('abc') from dual; --문자의 바이트수 출력
select replace('abc', 'b', 'd') from dual; --(chr, search_str, rep_str) chr에서 search_str을 찾아 rep_str로 변환
select instr('ababab','a',1,3) from dual; --(chr1, chr2, n1, n2) chr1에서 chr2찾는데, 문자열의 n1위치에서 n2번째의 chr2 찾기, n1생략시 1, n2 생략시 1

--날짜형
select sysdate from dual; --현재시간 날짜 반환 단, 도구 환경설정에서 설정해야 시간이 나오며, 이는 환경설정마다 다르므로 해당 결과와 같이 나타낼 경우 다른 함수 적용
select add_months(sysdate, 1) from dual; --(date,n) date에 n개월을 더한 날짜를 반환
--**add_date는 그냥 sysdate + n일로 
select months_between(sysdate+60, sysdate) from dual; -- date1과 date2 사이 개월수 반환, date1 > date2면 양수 반대면 음수
select last_day(sysdate) from dual; --date가 속한 월의 마지막 일자 반환
select next_day(sysdate, '수요일') from dual;--(date, expr) date날짜 기준으로 expr에 명시한 날짜 반환
select round(sysdate, 'HH24') from dual; --YYYY,HH,HH24,MI,DD 등 가능 단 생략시 DD HH 12시간 기준 HH24 24시간 기준

--형변환
select to_number('213') from dual; -- 문자형 to 숫자형
select to_char(12345, '99,999') from dual; -- 숫자형을 format에 맞게 문자형으로 변경, 단 포맷 형태가 숫자보다 길어야 함
select to_char(12345, '9999,999') from dual; -- 9 대신 1도 가능하나 숫자 크기가 더 커야하므로 9로 하는게 편함
select to_char(1234.5, '99,99.9') from dual; -- 포맷은 ,(컴마) / .(소수점)도 이용 가능
select to_char(sysdate, 'YYYY-MM-DD- HH24:MI:SS') from dual; --날짜형 date를 date_format에 맞게 문자형으로 변경
select to_char(sysdate, 'YYYY') from dual; -- 연도표시 : YYYY, YYYY, YY, YY
select to_char(sysdate, 'MONTH') from dual; -- 월 표시 : MONTH, MON
select to_char(sysdate, 'MM') from dual; -- 월 표시(1~12)
select to_char(sysdate, 'D') from dual; -- 주중일자 표시, 1(일요일)~7(토요일)
select to_char(sysdate, 'DAY') from dual; -- 주중일자 요일로 표시(DAY)
select to_char(sysdate, 'DD') from dual; -- 일자 표시(01~31)
select to_char(sysdate, 'DDD') from dual; -- 일자 표시(001~365)
select to_char(sysdate, 'DL') from dual; -- 년,월,일,요일 표시
select to_char(sysdate, 'HH') from dual; -- 시간 표시 HH(=HH12) 1~12시간 / HH24 1~24 시간
select to_char(sysdate, 'MI') from dual; --분 표시
select to_char(sysdate, 'SS') from dual; --초 표시
select to_char(sysdate, 'WW') from dual; --주 표시(1~53주차)
select to_char(sysdate, 'W') from dual; -- 해당 월의 몇주차인지 표시(1~5(?))
select to_date('2020-06-05 23:52:01','YYYY-MM-DD HH24:MI:SS') from dual; --문자형 char을 date_format에 맞게 날짜형으로 변경

--Null 처리 함수
select NVL(Null, 'A') from dual; -- (expr1, expr2) expr1가 Null이면 expr2 출력
select NVL2(Null, 'A', 'B') from dual; -- (expr1, expr2, expr3) expr1가 Null이면 expr3, 아니면 expr2
select coalesce(null, null, 'b', null) from dual; --(expr1,expr2,...,exprn) expr1->exprn 순서대로 진행하며 null이 아닌 값 출력
select nullif('a','b') from dual; --(expr1, expr2) expr1과 expr2가 같으면 null, 아니면 expr1

--기타 함수
select decode('a2', 'a1', 1, 'a2', 2, 3) from dual;--(expr, val1, result1,....,valn, resultn, default_value)
                                                   --expr이 val1부터 valn까지 순서대로 매칭하여 동일한 값의 result_k값 반환, 하나도 없으면 default_value 출력
