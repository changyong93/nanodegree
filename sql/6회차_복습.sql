/*
서브 쿼리
 - 일반 쿼리(메인 쿼리, 주 쿼리) 안의 보조(하위) 쿼리
 - 메인 쿼리와 서브 쿼리가 합쳐져 한 문장을 이룸
 - 서브 쿼리는 하나의 select 문장으로, 괄호로 둘러싸인 형태
 - 메인 쿼리 기준 여러 개의 서브 쿼리 사용 가능
 - 서브 쿼리 내에 조인으로 여러 개의 테이블 합칠 수 있음
 
서브 쿼리
 - 스칼라 서브 쿼리(scalar subqurey)
 - 인라인 뷰
 - 중첩 서브 쿼리(nested Subquery)
*/



--스칼라 서브쿼리
-- - 메인 쿼리의 select 절에 위치하며, 하나의 컬럼이나 표현식처럼 사용
-- - 스칼라 서브 쿼리가 반환하는 로우 수는 1개
-- - 별칭 적용
-- - 서브 쿼리 내에 메인 쿼리와 조인을 하여 여러 건이 조회될 가능성 방지
select a.employee_id,
       a.first_name||' '||a.last_name as emp_name,
       a.department_id,
       (select b.department_name
        from departments b
        where a.department_id = b.department_id) dept_name
from employees a
order by 1;
-- 스칼라 서브쿼리 내에 하나 이상의 컬럼을 가져오면 오류 발생
-- 조인으로도 동일한 데이터 조회 가능
-- 단, 스칼라 서브 쿼리는 각 행마다 서브쿼리에 in-out을 반복하는데에 반해
-- 조인은 전체를 스캔 후 하므로 성능 상 조인이 우위이므로, 과도한 사용은 자제
-- 대신 스칼라 쿼리는 메인 쿼리 기준으로 스칼라 쿼리를 반환하므로, left outer join과 같음
select a.employee_id,
       a.first_name||' '||a.last_name as emp_name,
       a.department_id,
       (select b.department_name
        from departments b
        where a.department_id = b.department_id
        ) dept_name,
       ( select d.country_name
         from departments b,
              locations c,
              countries d
         where a.department_id = b.department_id
         and b.location_id = c.location_id
         and c.country_id = d.country_id
       ) country_name
from employees a
order by 1;
--여러 개의 스칼라 서브 쿼리를 쓸 경우 각각의 서브쿼리 내에서 조인을 통해 테이블 불러와야 함
-- 다른 서브쿼리 참조 불가
-- 이를 가능하게 해주는 명령어는 5.3 section에서 진행

--인라인뷰
-- - 메인쿼리의 from 절에 위치
-- - 서브쿼리 자체를 하나의 테이블로 인식
-- - 스칼라 서브쿼리와 달리 여러 개의 로우, 컬럼, 표현식을 가져올 수 있음
-- - 별칭 필수
-- - Lateral(오라클 12C이상 추가기능) 유무에 따라 메인 쿼리와 연결 방법 나뉨
-- - lateral X -> 메인쿼리의 where절 이용 / lateral O -> 서브쿼리의 where or 메인쿼리의 where 선택적 이용
-- - 또한, lateral 사용 시, 인라인 뷰가 여러 개일 때, 먼저 쓴 인라인 뷰를 다음 인라인 뷰에서 참조 가능

-- lateral 없는 상태의 인라인뷰
select a.employee_id,
       a.first_name||' '||a.last_name as emp_name,
       a.department_id,
       c.dept_name
from employees a,
     (select b.department_id,
             b.department_name dept_name
      from departments b) c
where a.department_id = c.department_id
order by 1;

-- lateral 상태의 인라인뷰
select a.employee_id,
       a.first_name||' '||a.last_name as emp_name,
       a.department_id,
       c.dept_name
from employees a,
     lateral
     (select b.department_id,
             b.department_name dept_name
      from departments b
      where a.department_id = b.department_id) c
order by 1;
--lateral이 있을 경우, 메인 쿼리와 인라인 뷰(서브쿼리)를 이어주는 쿼리 위치를 서브쿼리 내 or 메인 쿼리에 선택적으로 작성 가능함

--서브쿼리 인라인뷰 여러개
select a.employee_id, a.first_name||' '||a.last_name as emp_name,
       dept.department_name,
       loc.street_address, loc.city, loc.country_name
from employees a,
     (select b.*
      from departments b) dept,
      (select c.location_id, c.street_address, c.city,
              d.country_name
      from locations c, countries d
      where c.country_id = d.country_id ) loc
where a.department_id = dept.department_id
and dept.location_id = loc.location_id
order by 1;

--서브쿼리 인라인뷰 여러개(lateral)
select a.employee_id, a.first_name||' '||a.last_name as emp_name,
       dept.department_name,
       loc.street_address, loc.city, loc.country_name
from employees a,
     lateral (select b.*
      from departments b
      where a.department_id = b.department_id) dept,
      lateral (select c.location_id, c.street_address, c.city,
              d.country_name
      from locations c, countries d
      where c.country_id = d.country_id
      and dept.location_id = c.location_id) loc
order by 1;

--서브쿼리 인라인뷰 여러개 lateral 사용하여 region_id 추가
select a.employee_id,
       a.first_name||' '||a.last_name as emp_name,
       dept_loc.department_name, dept_loc.street_address, dept_loc.city,
       reg.country_name, reg.region_name
from employees a,
     (select b.department_id, b.department_name,
             c.location_id, c.street_address, c.city, c.country_id
      from departments b, locations c
      where b.location_id = c.location_id) dept_loc,
      lateral (select d.country_id,
                      d.country_name,
                      e.region_name
              from countries d, regions e
              where d.region_id = e.region_id
              and d.country_id = dept_loc.country_id) reg
where a.department_id = dept_loc.department_id
order by 1;

--서브쿼리 인라인뷰 사원 급여 평균 계산

select a.department_id, a.employee_id, a.last_name, a.salary,
       dept_id.department_id, dept_id.avg_salary
from employees a,
     (select avg(b.salary) avg_salary, c.department_id 
      from employees b, departments c
      where b.department_id = c.department_id
      group by b.department_id) dept_id
where a.department_id = dept_id.department_id
order by 1;

/*중첩 서브쿼리 = 서브 조인
 - where 절에 위치
 - 조건절의 일부로 사용
 - 서브쿼리 최종 반환과 메이눠키 테이블의 특정 컬럼 값 비교
 - 알리아스 불가
 - 서브쿼리가 반환하는 로우 커럼 표현식 수는 1개 이상
 - in+서브 쿼리 or exist+서브 쿼리, 연산자+서브쿼리 등*/

--in 서브쿼리 -서브쿼리의 반환값이 메인 쿼리에 있는지
select a.*
from departments a
where department_id in (select department_id
                        from employees);
-- exist 서브쿼리 - 서브쿼리의 반환 값이 메인 쿼리에 존재하는지 체크하는데
--                한 번 체크한 값은 넘어가고 다음 값 체크 ex) 1.10, 2.20, 3.10, 4.30이 있으면 1.10을 체크했을 경우 10이 있다고 판단하여 3.10은 체크 안하고 넘어감    
select a.*
from departments a
where exists (select 1
              from employees b
              where a.department_id = b.department_id)
order by 1;

select a.*
from departments a
where exists (select 1
                from employees b
               where b.department_id = a.department_id
                 and b.salary>10000);
                 
select a.employee_id, a.first_name||' '||a.last_name as emp_name
from employees a
where (a.job_id, a.salary) in (select b.job_id, b.min_salary
                                 from jobs b
                                 where a.job_id = b.job_id);

--중첩 서브쿼리 - pATABALLA란 사원의 SALARY와 commission_pct 합보다 큰 사원 조회
select last_name, employee_id,
       salary + nvl(commission_pct,0) total_salary,
       job_id, department_id
from employees
where (salary + nvl(commission_pct,0)) > (select salary + nvl(commission_pct,0)
                                            from employees
                                           where last_name = 'Pataballa')
order by 1;

--중첩 서브쿼리
select a.department_id, a.employee_id, a.last_name, a.salary
from employees a
where a.salary > (select avg(b.salary)
                    from employees b
                   where a.department_id = b.department_id)
order by 1;



select * from jobs;
select * from employees
where last_name = 'Pataballa';
select * from departments;

--6.1.1
--사원별 사번, 이름 직업, 급여와 직업 그룹별 평균 급여
select a.employee_id,
       a.first_name||' '||last_name emp_name,
       a.job_id,
       a.salary
       ,(select avg(b.salary)
           from employees b
          where a.job_id = b.job_id
       group by b.job_id) avg_salary
from employees a;

--6.1.2
SELECT b.department_name, loc.street_address, loc.country_name
FROM departments b
    ,( SELECT l.location_id, l.street_address, c.country_name
    FROM locations l, countries c
    WHERE l.country_id = c.country_id ) loc
WHERE b.location_id = loc.location_id;

SELECT b.department_name, loc.street_address, loc.country_name
FROM departments b
    ,lateral ( SELECT l.location_id, l.street_address, c.country_name
                 FROM locations l, countries c
                WHERE l.country_id = c.country_id
                  and b.location_id = l.location_id) loc;

--6.1.3
SELECT employee_id, job_id, salary
FROM employees
WHERE (job_id, salary ) IN ( SELECT job_id, min_salary
                               FROM jobs);
                               
SELECT a.employee_id, a.job_id, a.salary
FROM employees a
WHERE exists (SELECT 1
                FROM jobs b
               where a.job_id = b.job_id
                 and a.salary = b.min_salary);
                 
--6.1.4
SELECT *
FROM departments
WHERE department_id not IN( SELECT a.department_id
                              FROM employees a
                             where department_id is not null);

--6.1.5
select * from covid19;

select a.months
       ,a.continent
       ,a.country
       ,a.new_cases
       ,conti.continent_cases
       ,round((a.new_cases/conti.continent_cases)*100,2) rates
from (select to_char(dates, 'YYYY-MM') months, continent, country, sum(new_cases) new_cases
        from covid19
    group by to_char(dates, 'YYYY-MM'), continent, country
      having sum(new_cases)> 0) a
     ,(select to_char(b.dates, 'YYYY-MM') months, b.continent, sum(b.new_cases) continent_cases
         from covid19 b
     group by to_char(b.dates, 'YYYY-MM'), b.continent) conti
where a.continent is not null
and a.continent = conti.continent
and a.months = conti.months
order by 1,2,4 desc;

--6.1.6
select * from covid19;

select to_char(dates, 'MM') months
       ,sum(new_tests) 검사수
       ,sum(new_cases) 확진자수
       ,round((sum(new_cases)/sum(new_tests))*100,2) 확진율
from covid19
where 1=1
and iso_code = 'KOR'
and dates between to_date('20200101', 'yyyymmdd') and to_date('20201231','yyyymmdd')
group by to_char(dates, 'MM')
order by 1;

/*
With 절 or CTE(common table Expression
 - 서브 쿼리의 일종
 - with 절(clause)이라고도 하고, CTE라고도 함
 - 하나의 서브쿼리를 또 다른 서브쿼리에서 참조하여 사용
 - 11g까지는 with절 사용 -> 12C이후부턴 lateral로도 가능
 
 with alias as (서브쿼리) 형태
 - with는 한 번만 명칭 그 이후 서브쿼리마다 콤마(,)로 구분
 - 인라인뷰와 같으나, 논리의 순서대로 작성할 수 있음
 - 단 temp 테이블 스페이스의 공간을 점유하므로 성능상 좋지 않음
 - 일반적인 경우 일반 서브쿼리를 사용하고, 서브쿼리 사용이 원활하지 않을 때 with절 사용
*/

--with절
with dept as (select department_id, department_name dept_name
                from departments)
select a.employee_id, a.first_name||' '||a.last_name emp_name
      ,b.department_id, b.dept_name
from employees a, dept b
where a.department_id = b.department_id;

--employee_id, emp_name, dept_name, street_address, cuntry_name
with dept as (select location_id, department_id, department_name as dept_name
                from departments),
     loc_con as (select b.department_id, b.dept_name
                       ,c.street_address
                       ,d.country_name
                   from dept b, locations c, countries d
                  where b.location_id = c.location_id
                    and c.country_id = d.country_id)
select a.employee_id, a.first_name||' '||a.last_name emp_name
      ,e.dept_name, e.street_address, e.country_name
from employees a, loc_con e
where a.department_id = e.department_id;

--employee_id, emp_name, dept_name, street_address, cuntry_name,region_name
with emp_info as (select b.department_id, b.department_name as dept_name
                         ,c.street_address
                         ,d.country_name
                         ,e.region_name
                    from departments b, locations c, countries d, regions e
                   where b.location_id = c.location_id
                     and c.country_id = d.country_id
                     and d.region_id = e.region_id
)
select a.employee_id, a.first_name||' '||a.last_name emp_name
      ,f.dept_name, f.street_address, f.country_name, f.region_name
from employees a, emp_info f
where a.department_id = f.department_id;

--country_name salary_amt(sal_amt)
with main as(select country_name, sum(salary)
               from employees a, departments b
                   ,locations c, countries d
              where a.department_id = b.department_id
                and b.location_id = c.location_id
                and c.country_id = d.country_id
           group by d.country_name)
select *
from main
order by 1;

with count_sal as(select sum(a.salary) sal_amt, c.country_id
                    from employees a
                        ,departments b
                        ,locations c
                   where a.department_id = b.department_id
                     and b.location_id = c.location_id
                group by c.country_id)
         ,main as (select b.country_name, a.sal_amt
                     from count_sal a
                         ,countries b
                    where a.country_id = b.country_id)
select *
from main
order by 1;

--top 5 query rownum
select *
from (select employee_id
          ,first_name||' '||last_name emp_name
          ,salary
        from employees
    order by salary desc)
where rownum <=5;


--top 5 query 분석함수 row_number
select *
from (select employee_id
          ,first_name||' '||last_name emp_name
          ,salary
          ,row_number() over (order by salary desc) row_seq
        from employees
    order by salary desc)
where row_seq <=5;

--top 5 query 분석함수 fetch first n rows only (oracal 12C 이후부터 가능)
select employee_id
      ,first_name||' '||last_name emp_name
      ,salary
from employees
order by salary desc
fetch first 5 rows only;

--상위 5퍼센트(with ties 시 중복 허용)
select employee_id
      ,first_name||' '||last_name emp_name
      ,salary
from employees
order by salary
--fetch first 5 percent rows only;
fetch first 5 percent rows with ties;
select * from employees;
select * from departments;
select * from locations;
select * from countries;
select * from regions;

--6.2.1
select * from covid19;
select *
from (select country, sum(new_cases)
        from covid19
       where 1=1
         and dates between to_date('20200101','yyyymmdd') and to_date('20201231','yyyymmdd')
         and country <> 'World' 
    group by country
      having sum(new_Cases) is not null
    order by 2 desc)
fetch first 5 rows only;

--6.2.2
select * from covid19
where country = 'Peru';
select *
from (select country
            ,sum(population)/count(country) popu
            ,sum(new_deaths) death
            ,round(sum(new_deaths)/(sum(population)/count(country))*100,5) rates
        from covid19
       where 1=1
         and country <> 'World'
         and dates between to_date('20200101','yyyymmdd') and to_Date('20201231','yyyymmdd')
         and population is not null
         and new_deaths is not null
    group by country
    order by rates desc)
fetch first 20 rows only;

select * from score_table;

select years,gubun, sum(국어), sum(영어), sum(수학), sum(과학), sum(지리), sum(독일어)
from(select years, gubun
          ,case when subjects = '국어' then score else 0 end 국어
          ,case when subjects = '영어' then score else 0 end 영어
          ,case when subjects = '수학' then score else 0 end 수학
          ,case when subjects = '과학' then score else 0 end 과학
          ,case when subjects = '지리' then score else 0 end 지리
          ,case when subjects = '독일어' then score else 0 end 독일어
    from score_table)
group by years, gubun;

select years,gubun, sum(국어), sum(영어), sum(수학), sum(과학), sum(지리), sum(독일어)
from(select years, gubun
           ,decode(subjects,'국어',score,0) 국어
           ,decode(subjects,'영어',score,0) 영어
           ,decode(subjects,'수학',score,0) 수학
           ,decode(subjects,'과학',score,0) 과학
           ,decode(subjects,'지리',score,0) 지리
           ,decode(subjects,'독일어',score,0) 독일어
    from score_table)
group by years, gubun;

with mains as (select years, gubun
          ,case when subjects = '국어' then score else 0 end 국어
          ,case when subjects = '영어' then score else 0 end 영어
          ,case when subjects = '수학' then score else 0 end 수학
          ,case when subjects = '과학' then score else 0 end 과학
          ,case when subjects = '지리' then score else 0 end 지리
          ,case when subjects = '독일어' then score else 0 end 독일어
         from score_table)
select years,gubun, sum(국어), sum(영어), sum(수학), sum(과학), sum(지리), sum(독일어)
from mains
group by years, gubun;

select *
from score_table
pivot (sum(score)
    for subjects in('국어','영어','수학','과학','지리','독일어')
    );
    
select * from score_col_table;

select years, gubun, '국어' as subject, korean as score
from score_col_table
union all
select years, gubun, '수학' as subject, math as score
from score_col_table
union all
select years, gubun, '영어' as subject, english as score
from score_col_table
union all
select years, gubun, '과학' as subject, science as score
from score_col_table
union all
select years, gubun, '지리' as subject, geology as score
from score_col_table
union all
select years, gubun, '독일어' as subject, german as score
from score_col_table
order by 1, 2;

select * from score_col_table
unpivot(score
        for subjects in(
                korean as'국어'
               ,english as '영어'
               ,math as '수학'
               ,science as '과학'
               ,geology as '지리'
               ,german as '독일어'));
               
--6.3.1
select * from covid19;
select continent, sum(q1), sum(q2), sum(q3), sum(q4)
from(select continent
          ,case when to_char(dates,'q') = '1' then sum(new_cases) else 0 end Q1
          ,case when to_char(dates,'q') = '2' then sum(new_cases) else 0 end Q2
          ,case when to_char(dates,'q') = '3' then sum(new_cases) else 0 end Q3
          ,case when to_char(dates,'q') = '4' then sum(new_cases) else 0 end Q4
    from covid19
    where continent is not null
      and to_char(dates, 'YYYY') ='2020'
    group by continent, to_char(dates,'q'))
group by continent
order by 1;

--6.3.2
select * from orders;
select * from order_items;
select * from products;

select sale_year
      ,nvl(model_2016,0) model_2016
      ,nvl(model_2017,0) model_2017
      ,nvl(model_2018,0) model_2018
from(select to_char(a.order_date, 'YYYY') sale_year
            ,c.model_year
            ,nvl(sum(b.quantity*b.list_price),0) amt
       from orders a, order_items b, products c
      where a.order_id = b.order_id
        and b.product_id = c.product_id
   group by to_char(a.order_date, 'YYYY'), c.model_year)
   pivot(sum(amt)
   for model_year in ('2016' as model_2016, '2017' as model_2017, '2018' as model_2018))
order by 1;
               

SELECT *
FROM ( SELECT TO_CHAR(a.order_date, 'YYYY') sale_year
,c.model_year
,NVL(SUM(b.list_price * quantity),0) amt
FROM orders a
,order_items b
,products c
WHERE 1=1
AND a.order_id = b.order_id
AND b.product_id = c.product_id
GROUP BY TO_CHAR(a.order_date, 'YYYY')
,c.model_year
) PIVOT
( SUM(amt) for model_year in ('2016' AS model_2016,'2017' AS model_2017, '2018' AS model_2018) )
ORDER BY 1; 