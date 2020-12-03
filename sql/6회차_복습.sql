/*
���� ����
 - �Ϲ� ����(���� ����, �� ����) ���� ����(����) ����
 - ���� ������ ���� ������ ������ �� ������ �̷�
 - ���� ������ �ϳ��� select ��������, ��ȣ�� �ѷ����� ����
 - ���� ���� ���� ���� ���� ���� ���� ��� ����
 - ���� ���� ���� �������� ���� ���� ���̺� ��ĥ �� ����
 
���� ����
 - ��Į�� ���� ����(scalar subqurey)
 - �ζ��� ��
 - ��ø ���� ����(nested Subquery)
*/



--��Į�� ��������
-- - ���� ������ select ���� ��ġ�ϸ�, �ϳ��� �÷��̳� ǥ����ó�� ���
-- - ��Į�� ���� ������ ��ȯ�ϴ� �ο� ���� 1��
-- - ��Ī ����
-- - ���� ���� ���� ���� ������ ������ �Ͽ� ���� ���� ��ȸ�� ���ɼ� ����
select a.employee_id,
       a.first_name||' '||a.last_name as emp_name,
       a.department_id,
       (select b.department_name
        from departments b
        where a.department_id = b.department_id) dept_name
from employees a
order by 1;
-- ��Į�� �������� ���� �ϳ� �̻��� �÷��� �������� ���� �߻�
-- �������ε� ������ ������ ��ȸ ����
-- ��, ��Į�� ���� ������ �� �ึ�� ���������� in-out�� �ݺ��ϴµ��� ����
-- ������ ��ü�� ��ĵ �� �ϹǷ� ���� �� ������ �����̹Ƿ�, ������ ����� ����
-- ��� ��Į�� ������ ���� ���� �������� ��Į�� ������ ��ȯ�ϹǷ�, left outer join�� ����
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
--���� ���� ��Į�� ���� ������ �� ��� ������ �������� ������ ������ ���� ���̺� �ҷ��;� ��
-- �ٸ� �������� ���� �Ұ�
-- �̸� �����ϰ� ���ִ� ��ɾ�� 5.3 section���� ����

--�ζ��κ�
-- - ���������� from ���� ��ġ
-- - �������� ��ü�� �ϳ��� ���̺�� �ν�
-- - ��Į�� ���������� �޸� ���� ���� �ο�, �÷�, ǥ������ ������ �� ����
-- - ��Ī �ʼ�
-- - Lateral(����Ŭ 12C�̻� �߰����) ������ ���� ���� ������ ���� ��� ����
-- - lateral X -> ���������� where�� �̿� / lateral O -> ���������� where or ���������� where ������ �̿�
-- - ����, lateral ��� ��, �ζ��� �䰡 ���� ���� ��, ���� �� �ζ��� �並 ���� �ζ��� �信�� ���� ����

-- lateral ���� ������ �ζ��κ�
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

-- lateral ������ �ζ��κ�
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
--lateral�� ���� ���, ���� ������ �ζ��� ��(��������)�� �̾��ִ� ���� ��ġ�� �������� �� or ���� ������ ���������� �ۼ� ������

--�������� �ζ��κ� ������
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

--�������� �ζ��κ� ������(lateral)
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

--�������� �ζ��κ� ������ lateral ����Ͽ� region_id �߰�
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

--�������� �ζ��κ� ��� �޿� ��� ���

select a.department_id, a.employee_id, a.last_name, a.salary,
       dept_id.department_id, dept_id.avg_salary
from employees a,
     (select avg(b.salary) avg_salary, c.department_id 
      from employees b, departments c
      where b.department_id = c.department_id
      group by b.department_id) dept_id
where a.department_id = dept_id.department_id
order by 1;

/*��ø �������� = ���� ����
 - where ���� ��ġ
 - �������� �Ϻη� ���
 - �������� ���� ��ȯ�� ���̴�Ű ���̺��� Ư�� �÷� �� ��
 - �˸��ƽ� �Ұ�
 - ���������� ��ȯ�ϴ� �ο� Ŀ�� ǥ���� ���� 1�� �̻�
 - in+���� ���� or exist+���� ����, ������+�������� ��*/

--in �������� -���������� ��ȯ���� ���� ������ �ִ���
select a.*
from departments a
where department_id in (select department_id
                        from employees);
-- exist �������� - ���������� ��ȯ ���� ���� ������ �����ϴ��� üũ�ϴµ�
--                �� �� üũ�� ���� �Ѿ�� ���� �� üũ ex) 1.10, 2.20, 3.10, 4.30�� ������ 1.10�� üũ���� ��� 10�� �ִٰ� �Ǵ��Ͽ� 3.10�� üũ ���ϰ� �Ѿ    
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

--��ø �������� - pATABALLA�� ����� SALARY�� commission_pct �պ��� ū ��� ��ȸ
select last_name, employee_id,
       salary + nvl(commission_pct,0) total_salary,
       job_id, department_id
from employees
where (salary + nvl(commission_pct,0)) > (select salary + nvl(commission_pct,0)
                                            from employees
                                           where last_name = 'Pataballa')
order by 1;

--��ø ��������
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
--����� ���, �̸� ����, �޿��� ���� �׷캰 ��� �޿�
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
       ,sum(new_tests) �˻��
       ,sum(new_cases) Ȯ���ڼ�
       ,round((sum(new_cases)/sum(new_tests))*100,2) Ȯ����
from covid19
where 1=1
and iso_code = 'KOR'
and dates between to_date('20200101', 'yyyymmdd') and to_date('20201231','yyyymmdd')
group by to_char(dates, 'MM')
order by 1;

/*
With �� or CTE(common table Expression
 - ���� ������ ����
 - with ��(clause)�̶�� �ϰ�, CTE��� ��
 - �ϳ��� ���������� �� �ٸ� ������������ �����Ͽ� ���
 - 11g������ with�� ��� -> 12C���ĺ��� lateral�ε� ����
 
 with alias as (��������) ����
 - with�� �� ���� ��Ī �� ���� ������������ �޸�(,)�� ����
 - �ζ��κ�� ������, ���� ������� �ۼ��� �� ����
 - �� temp ���̺� �����̽��� ������ �����ϹǷ� ���ɻ� ���� ����
 - �Ϲ����� ��� �Ϲ� ���������� ����ϰ�, �������� ����� ��Ȱ���� ���� �� with�� ���
*/

--with��
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


--top 5 query �м��Լ� row_number
select *
from (select employee_id
          ,first_name||' '||last_name emp_name
          ,salary
          ,row_number() over (order by salary desc) row_seq
        from employees
    order by salary desc)
where row_seq <=5;

--top 5 query �м��Լ� fetch first n rows only (oracal 12C ���ĺ��� ����)
select employee_id
      ,first_name||' '||last_name emp_name
      ,salary
from employees
order by salary desc
fetch first 5 rows only;

--���� 5�ۼ�Ʈ(with ties �� �ߺ� ���)
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

select years,gubun, sum(����), sum(����), sum(����), sum(����), sum(����), sum(���Ͼ�)
from(select years, gubun
          ,case when subjects = '����' then score else 0 end ����
          ,case when subjects = '����' then score else 0 end ����
          ,case when subjects = '����' then score else 0 end ����
          ,case when subjects = '����' then score else 0 end ����
          ,case when subjects = '����' then score else 0 end ����
          ,case when subjects = '���Ͼ�' then score else 0 end ���Ͼ�
    from score_table)
group by years, gubun;

select years,gubun, sum(����), sum(����), sum(����), sum(����), sum(����), sum(���Ͼ�)
from(select years, gubun
           ,decode(subjects,'����',score,0) ����
           ,decode(subjects,'����',score,0) ����
           ,decode(subjects,'����',score,0) ����
           ,decode(subjects,'����',score,0) ����
           ,decode(subjects,'����',score,0) ����
           ,decode(subjects,'���Ͼ�',score,0) ���Ͼ�
    from score_table)
group by years, gubun;

with mains as (select years, gubun
          ,case when subjects = '����' then score else 0 end ����
          ,case when subjects = '����' then score else 0 end ����
          ,case when subjects = '����' then score else 0 end ����
          ,case when subjects = '����' then score else 0 end ����
          ,case when subjects = '����' then score else 0 end ����
          ,case when subjects = '���Ͼ�' then score else 0 end ���Ͼ�
         from score_table)
select years,gubun, sum(����), sum(����), sum(����), sum(����), sum(����), sum(���Ͼ�)
from mains
group by years, gubun;

select *
from score_table
pivot (sum(score)
    for subjects in('����','����','����','����','����','���Ͼ�')
    );
    
select * from score_col_table;

select years, gubun, '����' as subject, korean as score
from score_col_table
union all
select years, gubun, '����' as subject, math as score
from score_col_table
union all
select years, gubun, '����' as subject, english as score
from score_col_table
union all
select years, gubun, '����' as subject, science as score
from score_col_table
union all
select years, gubun, '����' as subject, geology as score
from score_col_table
union all
select years, gubun, '���Ͼ�' as subject, german as score
from score_col_table
order by 1, 2;

select * from score_col_table
unpivot(score
        for subjects in(
                korean as'����'
               ,english as '����'
               ,math as '����'
               ,science as '����'
               ,geology as '����'
               ,german as '���Ͼ�'));
               
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