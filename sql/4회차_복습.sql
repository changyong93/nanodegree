--group by절
--group by와 집계 함수를 단독으로 사용은 가능하나, 일반적으로 둘 다 사용해서 기본적 데이터 분석
/* 구문
select expr1, expr1,
from...
where...
having ...
group by...
order by...*/

--집계함수-- count, max, min, sum, avg
select * from employees;
select count(*) from employees; --row수 반환
select max(salary) from employees; --최대 급여 반환
select min(salary) from employees; --최소 급여 반환
select sum(salary) from employees; --급여 총액 반환
select avg(salary) from employees; --급여 평균 반환

--group by절-- select와 group by에 별칭을 제외하고 동일한 이름과 형태로 조회 항목이 포함되어 있어야 함
select to_char(hire_date, 'YYYY') hire_year
from employees
group by to_char(hire_date, 'YYYY')
order by 1;

--직무별 최대 급여, 최소 급여 조회하기--
select job_id, count(*), max(salary), min(salary)
from employees
group by job_id
order by job_id;

--입사 년도 및 부서별 평균 급여, 급여 총액 조회하기--
select to_char(hire_date, 'YYYY') hire_year,
       department_id, round(avg(salary)), sum(salary)
from employees
where 1=1
and to_char(hire_date, 'YYYY') >='2004'
group by to_char(hire_date, 'YYYY'), department_id
order by to_char(hire_date, 'YYYY');

--급여 평균이 5000 이상, 2004년 이후 입사 년도 및 부서별 평균 급여, 급여 총액 조회하기--
select to_char(hire_date, 'YYYY') hire_year,
       department_id, round(avg(salary)), sum(salary)
from employees
where 1=1
and to_char(hire_date, 'YYYY') >=2004
having avg(salary)>=5000
group by to_char(hire_date, 'YYYY'), department_id
order by to_char(hire_date, 'YYYY');

--having절을 이용하여 사원수가 2이상인 부서 및 입사년도별 평균 급여, 급여총액 구하기
select to_char(hire_date, 'YYYY') hire_year, department_id,
       count(*), round(avg(salary)), sum(salary)
from employees
where 1=1
having count(*) > 1
group by to_char(hire_date, 'YYYY'), department_id
order by to_char(hire_date, 'YYYY');

--distinct절을 이용하여 중복 데이터 제거
select job_id
from employees
group by job_id;

select distinct job_id
from employees;

select distinct to_char(hire_date, 'YYYY') hire_year, department_id
from employees
order by 1,2;

select substr(phone_number,1,3) ,job_id, sum(salary)
from employees
group by substr(phone_number,1,3), job_id
order by 1,2;

--rollup--
select substr(phone_number,1,3) ,job_id, sum(salary)
from employees
group by rollup(substr(phone_number,1,3), job_id)
order by 1,2;

select substr(phone_number,1,3) ,job_id, sum(salary)
from employees
group by cube(substr(phone_number,1,3), job_id)
order by 1,2;

-------------
/*4.1.1 locations 테이블에는 전 세계에 있는 지역 사무소 주소 정보가 나와 있습니다.
각 국가별로 지역 사무소가 몇 개나 되는지 찾는 쿼리 작성 */
select * From locations;
select count(*), country_id
from locations
group by country_id;

/*4.1.2 employees 테이블에서 년도에 상관 없이 분기별로 몇 명의 사원이 입사했는지 구하는 쿼리를 작성 */
select * from employees;
select to_char(hire_date, 'q'), count(*)
from employees
group by to_char(hire_date, 'q')
order by to_char(hire_date, 'q');

/*4.1.3 다음 쿼리는 employees 테이블에서 job_id별로 평균 급여를 구한 것인데, 여기서 평균을
직접 계산하는 avg_salary1 이란 가상 컬럼을 추가(평균 = 총 금액/사원수*/
select job_id, round(avg(salary),0) avg_salary,
       sum(salary)/count(*) avg_salary1
from employees
group by job_id
order by 1;

/*4.1.4 COVID19 테이블에서 한국(ISO_CODE 값이 KOR)의 월별 코로나 확진자 수를 조회하는 쿼리 작성*/
select * From covid19;

select to_char(dates, 'YYYY-MM'), sum(new_cases)
from covid19
where iso_code='KOR'
group by to_char(dates, 'YYYY-MM')
order by to_char(dates, 'YYYY-MM');

/*4.1.5 COVID19 테이블에서 한국 데이터에 대해 다음 결과가 나오도록 쿼리 작성 */
select * From covid19;

select to_char(dates, 'YYYY-MM') MONTHS,
       sum(new_cases) 확진자수,
       sum(new_deaths) 사망자수,
       decode(sum(new_cases), 0 , 0, round(sum(new_deaths)/sum(new_cases)*100,2)) 사망률
from covid19
where 1=1
and iso_code='KOR'
group by to_char(dates, 'YYYY-MM')
order by 1;

/*4.1.6 COVID19 테이블에서 2020년 10월에 가장 많은 확진자가 나오 ㄴ상위 5개 국가는 어떤 나라일까요 */
select * from covid19;

select country, nvl(sum(new_cases),0)
from covid19
where 1=1
and country <>'World'
and to_char(dates,'YYYY-MM') ='2020-10'
group by country
order by 2 desc;

select country , nvl(sum(new_cases),0)
from covid19
where 1=1
and dates between to_date('20201001', 'YYYYMMDD')
              and to_date('20201031', 'YYYYMMDD')
and country != 'World'
group by country
order by 2 desc;

------------------------------------------------------------------------------------------
--union

select job_id
from employees
where 1=1
and salary between 2000 and 5000
minus
select job_id
from employees
where 1=1
and salary between 5001 and 6000
order by 1;

select job_id, salary
from employees
where 1=1
and salary between 2000 and 5000
union
select job_id, salary
from employees
where 1=1
and salary between 5001 and 6000
order by 1;

/*4.2.1 다음 쿼리를 실행하면 오류가 발생하는데 그 이유는?*/
-- 첫 select 절에 job_id의 alias를 jobs로 했으므로 order by도 job_id가 아닌 job로 해야 함
select job_id jobs
from employees
where department_id = 60
union
select job_id
from employees
where department_id = 90
order by job_id;

/*4.2.2 집합 연산자를 사용해 employees 테이블에서 2001과 2003년에 입사한 사원의 사원번호와 입사일자를 조회하는 쿼리 작성*/
select * from employees;

select employee_id, hire_date
from employees
where to_char(hire_date,'YYYY') = '2001'
union all
select employee_id, hire_date
from employees
where to_char(hire_date,'YYYY') = '2003';
order by 2;

/*4.2.3 employees 테이블에서 job_id 별로 급여(salary)의 합계를 구하고, 마지막에 전체 급여 합계를 구하는
쿼리를 union 연산자를 사용해 작성*/
select * from employees;

select job_id, sum(salary)
from employees
group by job_id
union
select '합계', sum(salary)
from employees
order by 1;

/*4.2.4 covid19 테이블에서 2020년 전반기(1월~6월)에는 월별 확진자가 10000명 이상이었는데,
후반기(7월~10월) 에는 월별 확진자가 1000명 이하로 떨어진 적이 있는 국가를 구하는 문장을 작성(hint : intersect)*/
select * from covid19;
select to_char(dates, 'YYYY-Q') from covid19;

select country
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
group by to_char(dates, 'MM'), country
order by 1;

select country
from covid19
where 1=1
and dates between to_Date('20200101','YYYYMMDD') and
                  to_date('20200630','YYYYMMDD')
group by to_char(dates,'YYYY-MM'), country
having nvl(sum(new_cases),0)>=10000
intersect
select country
from covid19
where 1=1
and dates between to_Date('20200701','YYYYMMDD') and
                  to_date('20201231','YYYYMMDD')
group by to_char(dates,'YYYY-MM'), country
having nvl(sum(new_cases),0)<=1000;

--보너스 문제 : Department_name 별로 num_data 컬럼값을 더하는 것이 아니라 곱한 결과를 조회하는 쿼리를 작성하시오.
create table GROUPBYMULTIPLY (
department_name VARCHAR2(100),
num_data NUMBER
);

insert into groupbymultiply values ('dept1', 10);
insert into groupbymultiply values ('dept1', 20);
insert into groupbymultiply values ('dept1', 30);
insert into groupbymultiply values ('dept2', 5);
insert into groupbymultiply values ('dept2', 7);
insert into groupbymultiply values ('dept2', 40);
insert into groupbymultiply values ('dept3', 69);
insert into groupbymultiply values ('dept3', 71);
insert into groupbymultiply values ('dept3', 12);
commit;

SELECT *
FROM groupbymultiply;

SELECT department_name,
SUM(num_data), 
FROM groupbymultiply
GROUP BY department_name
ORDER BY 1 ;

select department_name, round(exp(sum(ln(num_data))))
from groupbymultiply
GROUP BY department_name
order by 1;