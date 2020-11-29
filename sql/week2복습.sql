--함수
---숫자형
select abs(-7), abs(7), abs(0) from dual; --절댓값
select ceil(7.6), floor(7.6) from dual; --올림,내림
select exp(5), ln(exp(5)), log(10,1000) from dual; --지수함수, 자연로그 함수, 로그 함수
select mod(17,3), sign(-17), sign(17), sign(0) from dual;--몫, 정수 부호
select power(2,3), sqrt(4) from dual; --지승, 루트
select round(3.545,2), round(3.545,1),trunc(3.545,2),trunc(3.545,1) from dual; --특정 소수점에서 반올림,내림
select concat('a','b'), 'a'||'b'||'c' from dual; --문자열 합치기
select initcap('aBc'), initcap('ko-changyong'), lower('ko-changyong'), upper('ko-changyong') from dual;--첫문자 대문자, 소문자변환, 대문자변환
select lpad('sql',5,'*'), rpad('sql',5,'*') from dual; -- 문자개수 기준 좌 혹은 우 입력 문자 추가하기
select ltrim('**sql**','*'), rtrim('**sql**','*') from dual; --특정 문자열을 좌 혹은 우에서 빼기
select substr('abcedf',1,2) from dual; --1번 문자 위치부터 2개 가져오기
select trim(' ab cd '), ascii('a'), length('a b c 강'), lengthb('a b c 강') from dual; --좌우 스페이스 제거, 아스키코드로 변환, 문자개수, 문자바이트
select replace('산은산','산','물') from dual; --문자열 대체

--날짜형
select sysdate from dual; --SQL 환경의 현재 시간 조회
select add_months(sysdate,1) from dual; --월 변경, + / - 둘 다 가능
select months_between(sysdate, '2020-09-01') from dual; --두 날짜의 월 차이 계산
select last_day(sysdate), next_day(sysdate, '금') from dual; --입력날짜의 월말 날짜 반환, 입력 요일의 돌아오는 날짜 반환
select round(sysdate, 'DD') from dual; --반올림 YYYY, MM, DD, HH24, MI, 미기입(=일자 기준, default)
select trunc(sysdate, 'DD') from dual; --내림 YYYY, MM, DD, HH24, MI, 미기입(=일자 기준, default)

--Quiz
--3.1.1
select initcap('홍길동'), upper('홍길동'), lower('홍길동') from dual;
----알파벳이 아니라 대소문자 구분이 없어서 같음

--3.1.2
select substr('Isthis the real life? Is this just fantasy?', instr('Isthis the real life? Is this just fantasy?', 'fantasy?')) from dual;

--3.1.3
select last_day(sysdate)+1,trunc(add_months(sysdate,1), 'MM'),round(sysdate, 'mm') from dual;

--3.1.4
select * from employees;
select employee_id, hire_date, round(months_between(sysdate, hire_date)) as 근속월수
from employees
where employee_id <=110;

--3.1.5
select * from employees;
select phone_number, lpad(replace(phone_number, '.', '-'), 20,' ') as phone_number2 from employees;

--3.1.6
select * from locations;
select street_address,
       substr(street_address,instr(street_address, ' ',1)+1) as street_address2
from locations
where location_id <=2400;

-----------------------------------------------------------------------------------------------------------
--형변환 함수
select to_number('12345.6779'), to_number('-12.0') from dual; --문자-> 숫자형 단 문자형을 숫자로 변환 불가
select to_char(1234.5678,'999,999.9999'),to_char(1234.5678,'999.9999') from dual; --자리수는 넉넉히
select to_char(sysdate, 'DDD') from dual; --날짜를 문자로 변환 YYYY,HH,DDD,DD,D,Day, HH24,HH,MI,SS,W,WW
select to_char(sysdate, 'DD') from dual; --날짜를 문자로 변환
select to_char(sysdate, 'D') from dual; --날짜를 문자로 변환
select to_char(sysdate, 'Day') from dual; --날짜를 문자로 변환
select to_date('2020-10-31' ,'YYYY-MM-DD') from dual; --문자를 날짜로 변환
select to_date('2020-10-31' ,'YYYYMMDD') from dual; --문자를 날짜로 변환 단, 날짜로 변환시 문자열과 유사한 형태로 날짜 format을 맞춰야 함
select nvl('a','b'),nvl(null,'b'), nvl2(null,'b','c'), nvl2('a','b','c') from dual; --nvl은 null이면 뒷 문자를, 아니면 앞 문자 반환이고, nvl2은 null이면 두번째 값을 아니면 세번쨰 값을 반환
select coalesce(null, null, null, 'a', null, 'b') from dual; --null아닌 첫번째 값 반환
select nullif(100,100), nullif(100,1000) from dual; --입력값 두 개가 같으면 null 아니면 앞 값 반환
select decode(1,2,3,1,4,5) from dual;

--Quiz
--3.2.1
select to_char(last_day(to_date('2019-08-20','yyyy-mm-dd')),'day') from dual;

--3.2.2
select employee_id, first_name, last_name, salary, commission_pct,
       case when commission_pct is null then salary
            else salary + (salary * commission_pct)
       end real_salary
from employees;

select employee_id, first_name, last_name, salary, commission_pct,
       salary+(salary*nvl(commission_pct,0)) as real_salary
from employees;

--3.2.3
select employee_id, first_name, last_name, salary, commission_pct,
       salary+(salary*decode(commission_pct,null,0,commission_pct)) as real_salary
from employees;

--3.2.4
select  to_date('2020-10-31', 'YYYY-MM-DD')-to_date('0001-01-01','YYYY-MM-DD') from dual;

--------------------------------------------------------------------------------------------------------------
--집계쿼리

--groupby절

select to_char(hire_date,'YYYY') hire_year
from employees
group by to_char(hire_date,'YYYY')
order by 1;

--집계함수
select min(salary), max(salary), count(*)
from employees;

--groupby + 집계함수 = 집계쿼리
select to_char(hire_date,'YYYY') hire_year,
       count(*), min(salary), max(salary)
from employees
group by to_char(hire_date,'YYYY')
order by 1;

--2004년 이후, 급여 평균 5천이상의 입사 년도와 부서별 총 인원수와 급여총액, 급여 평균
select * from employees;
select to_char(hire_date,'YYYY') hire_year,
       department_id,
       round(avg(salary)), sum(salary)
from employees
where to_char(hire_date,'YYYY') >=2004
having avg(salary) >=5000
group by to_char(hire_date,'YYYY'), department_id
order by 1,2;

--quiz
--4.1.1
select * from locations;
select country_id,count(*)
from locations
group by country_id;

--4.1.2
select * from employees;
select to_char(hire_date, 'q'),
       count(*)
from employees
group by to_char(hire_date, 'q')
order by 1;

--4.1.3
select job_id, round(avg(salary),0) avg_salary,
       round(avg(salary)/count(*)) avg_salary1
from employees
group by job_id
order by 1;

--4.1.4
select * from covid19;
select to_char(dates, 'MM'), sum(new_cases)
from covid19
where iso_code = 'KOR'
group by to_char(dates, 'MM')
order by 1;

--4.1.5
select to_char(dates, 'YYYY-MM') MONTHS,
       sum(new_cases) 확진자수,
       sum(new_deaths) 사망자수,
       decode(sum(new_deaths), 0, 0, round(sum(new_deaths)/sum(new_cases)*100,2)) 사망률
from covid19
where iso_code = 'KOR'
group by to_char(dates, 'YYYY-MM')
order by 1;

select to_char(dates, 'YYYY-MM') MONTHS,
       sum(new_cases) 확진자수,
       sum(new_deaths) 사망자수,
       case when sum(new_deaths) = 0 then 0
            else round(sum(new_deaths)/sum(new_cases)*100,2)
       end 사망률
from covid19
where iso_code = 'KOR'
group by to_char(dates, 'YYYY-MM')
order by 1;

--4.1.6
select * from covid19;
select country, sum(new_cases) 확진자
from covid19
where 1=1
and to_char(dates, 'YYYY-MM') = '2020-10'
and country <> 'World'
having sum(new_cases) is not null
group by country
order by 2 desc;

---------------------------------------------------------------------------------------------------------------
--집합쿼리
select job_id
from employees
where 1=1
and salary between 2000 and 5000
--union --합집합(중복 제거) 단, 중복 제거 연산이 추가되어 연산이 오래걸림, 서브쿼리 문으로 대체
union all --합집합(중복 포함)
--intersect --교집합
--minus  --차집합
select job_id
from employees
where 1=1
and salary between 5001 and 6000
order by job_id;

--4.2.1
--order by의 column 명을 알리아스로 작성하거나 알리아스 제거

--4.2.2
select * from employees;
select to_char(hire_date, 'YYYY') hire_year,
       employee_id, hire_date
from employees
where to_char(hire_date, 'YYYY') = '2001'
union
select to_char(hire_date, 'YYYY') hire_year,
       employee_id, hire_date
from employees
where to_char(hire_date, 'YYYY') = '2003'
order by 1,3;

--4.2.3
select * from employees;
select job_id, sum(salary)
from employees
group by job_id
union
select 'total', sum(salary)
from employees;

--4.2.4
select * from covid19;

select country
from covid19
where 1=1
and to_char(dates, 'YYYY') = '2020'
and to_char(dates, 'MM') < 7
having sum(new_cases)>=10000
group by country, to_char(dates, 'MM')
intersect
select country
from covid19
where 1=1
and to_char(dates, 'YYYY') = '2020'
and to_char(dates, 'MM') >= 7
having sum(new_cases) <=1000
group by country, to_char(dates, 'MM');

select country, sum(new_cases)
from covid19
where country in (select country
    from covid19
    where 1=1
    and to_char(dates, 'YYYY') = '2020'
    and to_char(dates, 'MM') < 7
    having sum(new_cases)>=10000
    group by to_char(dates, 'MM'), country
    intersect
    select country
    from covid19
    where 1=1
    and to_char(dates, 'YYYY') = '2020'
    and to_char(dates, 'MM') >= 7
    having sum(new_cases) <=1000
    group by to_char(dates, 'MM'), country)
group by country;


select country, sum(new_cases)
from covid19
where country in
    (select country
    from covid19
    where 1=1
    and to_char(dates, 'YYYY') = '2020'
    and to_char(dates, 'MM') < 7
    having sum(new_cases) >=10000
    group by to_char(dates, 'MM'), country
    intersect
    select country
    from covid19
    where 1=1
    and to_char(dates, 'YYYY') = '2020'
    and to_char(dates, 'MM') >= 7
    having sum(new_cases) <=1000
    group by to_char(dates, 'MM'), country)
group by country;