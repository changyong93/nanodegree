--��������
select a.employee_id
      ,a.first_name
      ,a.department_id
      ,b.department_name
from employees a
    ,departments b
where a.department_id = b.department_id
order by 1;
--178�� ����� �����ִµ�, department_id ���� Null�̶� ��ȸ�ȵ�
--������ ����� ������ �������� ���ؼ� b.department_id�� ���� ���� a.department_id�� ��� ���� �����;� ��
-- --> �ܺ�����

select a.employee_id
      ,a.first_name
      ,a.department_id
      ,b.department_name
from employees a
    ,departments b
where a.department_id = b.department_id(+)
order by 1;
--a.~~ = b.~~(+)�� b�� ��ġ���� �ʴ� a�� ��� ������ ��������

select a.employee_id
      ,a.first_name
      ,b.department_id
      ,b.department_name
from employees a
    ,departments b
where a.department_id(+) = b.department_id
order by 1;
--a.~~(+) = b.~~�� a�� ��ġ���� �ʴ� b�� ��� ������ ��������
--��, b�� ��� ������ ������ ��� department_id�� ��Ī�� b�� �ؾ� a�� ��ġ���� �ʾƵ� ��� department_id ������ ������
--���̺� ���谡 ����� �Ǿ� �ְ�, �����Ͱ� ����� �ԷµǾ� ������ �����������ε� ��� �����Ͱ� ��ȸ������
--���� �̽�, ������ �Է� �̽��� ���������Ͱ� ���� ��� �ܺ������� ����ؾ� ��
--��� ��/�ܺ� ������ ����Ŭ ����̰�, SQL ǥ���� ANSI ���� ������ ����

--ANSI ����
-- ���� : inner join
-- �ܺ� : left outer join, right outer join, full outer join

--inner join (����Ŭ ����)
select a.employee_id emp_id
      ,a.department_id a_dept_id
      ,b.department_id b_dept_id
      ,b.department_name dept_name
from employees a
    ,departments b
where a.department_id = b.department_id
order by 1;

--inner join (ANSI ����)
select a.employee_id emp_id
      ,a.department_id a_dept_id
      ,b.department_id b_dept_id
      ,b.department_name dept_name
from employees a
inner join departments b
on a.department_id = b.department_id
order by 1;

--left outer join(����Ŭ ����)
select a.employee_id emp_id
      ,a.department_id a_dept_id
      ,b.department_id b_dept_id
      ,b.department_name dept_name
from employees a
    ,departments b
where a.department_id = b.department_id(+)
order by 1;

--left outer join(ANSI ����)
select a.employee_id emp_id
      ,a.department_id a_dept_id
      ,b.department_id b_dept_id
      ,b.department_name dept_name
from employees a
left outer join departments b
on a.department_id = b.department_id
order by 1;

--right outer join(����Ŭ ����)
select a.employee_id emp_id
      ,a.department_id a_dept_id
      ,b.department_id b_dept_id
      ,b.department_name dept_name
from employees a
    ,departments b
where a.department_id(+) = b.department_id
order by 1;

--right outer join(ANSI ����)
select a.employee_id emp_id
      ,a.department_id a_dept_id
      ,b.department_id b_dept_id
      ,b.department_name dept_name
from employees a
right outer join departments b
on a.department_id = b.department_id
order by 1;

--full outer join(ANSI�� ����, ����Ŭ�� �Ұ�)
select a.employee_id
      ,a.department_id
      ,b.department_id
      ,b.department_name
from employees a
full outer join departments b
on a.department_id = b.department_id
order by 1;
/*
���� ������ �Ϲ� ���� -> �������� ����
�ܺ� ������ ANSI ���� -> ������ �� ���뼺
*/

--Cartesian Product
--��� ����(����Ǽ�)�� �ο찡 ��ȸ��
--���� ������ �����Ƿ� ������ ������ �ƴϸ�, ���� ���Ǵ� ��찡 ����
select a.employee_id
      ,a.department_id
      ,b.department_id
      ,b.department_name
from employees a
cross join departments b
order by 1;

--self join(����Ŭ ����)
select * from employees;
select a.employee_id
      ,a.first_name||' '||a.last_name emp_name
      ,a.manager_id
      ,b.first_name||' '||b.last_name manager_name
from employees a
    ,employees b
where a.manager_id = b.employee_id
order by 1;

--self join(ANSI ����)
select * from employees;
select a.employee_id
      ,a.first_name||' '||a.last_name emp_name
      ,a.manager_id
      ,b.first_name||' '||b.last_name manager_name
from employees a
inner join employees b
on a.manager_id = b.employee_id
order by 1;

--5.2.1
select * from employees;
select * from jobs;
select a.employee_id
      ,a.first_name||' '||a.last_name emp_name
      ,a.job_id
      ,a.salary
      ,b.min_salary
      ,b.max_salary
from employees a
inner join jobs b
on a.job_id = b.job_id
where a.salary between b.min_salary and b.max_salary;

--5.2.5
select * from departments;
select * from locations;
select a.first_name||' '||a.last_name emp_name
      ,a.salary
      ,a.department_id
      ,b.department_name
      ,c.country_id
from employees a
    ,departments b
    ,locations c
where 1=1
and a.first_name = 'David'
and a.salary >=6000
and a.department_id = b.department_id
and b.location_id = c.location_id;

--5.2.6
select * from orders;
select * from customers;
select * from stores;
select * from staffs;

select a.order_id
      ,a.order_date
      ,b.first_name||' '||b.last_name customer_name
      ,c.store_name
      ,d.first_name||' '||d.last_name staff_name
from orders a
inner join customers b
on a.customer_id = b.customer_id
inner join stores c
on a.store_id = c.store_id
inner join staffs d
on a.staff_id = d.staff_id
where order_date between to_date('20180101','yyyymmdd') and to_date('20180131','yyyymmdd')
order by 2,3;

--5.2.7
select * from orders;
select * from order_items;
select to_char(a.order_date,'YYYY-MM') months
      ,round(sum(b.quantity*b.list_price),2) order_amt
from orders a
    ,order_items b
where 1=1
and a.order_date between to_date('20180101','yyyymmdd') and to_date('20181231','yyyymmdd')
and a.order_id = b.order_id
group by to_char(a.order_date,'YYYY-MM')
order by 1;

--5.2.8
select * from orders;
select * from order_items;
select * from products;
select * from brands;

select to_char(a.order_date, 'YYYY-Q') quarter
      ,d.brand_name
      ,round(sum(b.quantity*b.list_price),2) order_amt
from orders a
inner join order_items b
on a.order_id = b.order_id
inner join products c
on b.product_id = c.product_id
inner join brands d
on c.brand_id = d.brand_id
where a.order_date between to_date('20180101','yyyymmdd') and to_date('20181231','yyyymmdd')
group by to_char(a.order_date, 'YYYY-Q'), d.brand_name
order by 1,3 desc;

--5.2.9
select * from orders;
select * from stores;
select * from order_items;
select * from products;
select * from brands;
select to_char(a.order_date,'YYYY') year
      ,b.store_name
      ,round(sum(c.quantity*c.list_price),2) order_amt
from orders a
    ,stores b
    ,order_items c
where a.store_id = b.store_id
  and a.order_id = c.order_id
group by to_char(a.order_date,'YYYY')
        ,b.store_name
order by 1,2;
-----------------------------------------------------------------------------------------------------------------
--�м��Լ� - grouy���� �޸� �ο�� ����

--row.number()
select b.department_id
      ,b.department_name
      ,a.first_name||' '||a.last_name emp_name
      ,row_number() over (partition by b.department_id
                          order by a.salary) dept_sal_seq
      ,a.salary
from employees a
    ,departments b
where a.department_id = b.department_id
order by 2, 4;


--rank()
select b.department_id
      ,b.department_name
      ,a.salary
      ,sum(salary) over (partition by b.department_id order by a.salary) dept_sal_cumsum
      ,sum(salary) over (partition by b.department_id) dept_sal_sum
      ,row_number() over (partition by b.department_id order by a.salary desc) dept_sal_seq
      ,rank() over (partition by b.department_id order by a.salary desc) dept_sal_rank
      ,dense_rank() over (partition by b.department_id order by a.salary desc) dept_sal_dence_rank
      ,round(avg (salary) over (partition by b.department_id)) dept_sal_avg
      ,max(salary) over (partition by b.department_id) dept_sal_max
      ,lead(salary,2,0) over (partition by b.department_id order by salary) dept_sal_lead
      ,lag(salary,2,0) over (partition by b.department_id order by salary) dept_sal_lag
from employees a
    ,departments b
where a.department_id = b.department_id
order by 2, 4 desc;

--5.3.1
select a.department_id
      ,b.department_name
      ,a.first_name||' '||a.last_name emp_name
      ,a.hire_date
      ,a.salary
      ,sum(salary) over (partition by a.department_id order by a.hire_date, a.salary) �����հ�
from employees a
inner join departments b
on a.department_id = b.department_id
order by 2,4,5;
----------------------------------------------------------------------5���� ��-----------------------------------------------------

select a.employee_id
      ,a.first_name||' '||last_name emp_name
      ,b.department_id dept_id
      ,b.department_name dept_name
from employees a
    ,departments b
where a.department_id = b.department_id(+)
order by 1;

select a.employee_id
      ,a.first_name||' '||last_name emp_name
      ,b.department_id dept_id
      ,b.department_name dept_name
from employees a
left outer join departments b
on a.department_id = b.department_id
order by 1;
--scalar subquery
select a.employee_id
      ,a.first_name||' '||last_name emp_name
      ,a.department_id dept_id
      ,(select b.department_name
          from departments b
         where a.department_id = b.department_id) dept_name
from employees a
order by 1;

--inline view
--lateral ���� ������ ������������ ����
select a.employee_id
      ,a.first_name||' '||last_name emp_mane
      ,a.department_id dept_id
      ,dept.dept_name
from employees a
    ,(select b.department_id, b.department_name dept_name
        from departments b) dept
where a.department_id = dept.department_id
order by 1;

--inline view
--lateral
select a.employee_id
      ,a.first_name||' '||last_name emp_mane
      ,a.department_id dept_id
      ,dept.dept_name
from employees a
    ,lateral (select b.department_id, b.department_name dept_name
        from departments b
       where a.department_id = b.department_id) dept
order by 1;

--��ø��������(nested subquery)
--in
select a.*
from departments a
where a.department_id in (select b.department_id
                            from employees b);
select a.*
from departments a
where a.department_id  not in (select b.department_id
                            from employees b
                            where b.department_id is not null); --null�� �ν��Ͽ� �Լ��� ����� ����
--exists
select a.*
from departments a
where exists (select 1
                from employees b
               where a.department_id = b.department_id);
               
--6.1.2
select b.department_name, loc.street_address, loc.country_name
from departments b
,lateral (select l.location_id, l.street_address, c.country_name
            from locations l, countries c
           where l.country_id = c.country_id
             and b.location_id = l.location_id) loc;
             
--6.1.3
select employee_id, job_id, salary
from employees
where (job_id, salary) in (select job_id, min_salary
                             from jobs);
                             
select a.employee_id, a.job_id, a.salary
from employees a
where exists (select 1
                from jobs b
               where a.job_id = b.job_id
                 and a.salary = b.min_salary);

--6.1.4
select *
from departments
where department_id not in
      (select a.department_id
         from employees a
        where a.department_id is not null);
        
--6.1.5
select * from covid19;

select to_char(a.dates, 'YYYY-MM') months ,a.continent, a.country, sum(a.new_cases) new_cases
      ,(select sum(b.new_cases) from covid19 b
         where to_char(a.dates, 'YYYY-MM') = to_char(b.dates, 'YYYY-MM')
           and a.continent = b.continent
      group by to_char(b.dates, 'YYYY-MM'), b.continent) continent_cases
      ,round(sum(a.new_cases)/(select sum(b.new_cases) from covid19 b
         where to_char(a.dates, 'YYYY-MM') = to_char(b.dates, 'YYYY-MM')
           and a.continent = b.continent
      group by to_char(b.dates, 'YYYY-MM'), b.continent)*100,2) rates
from covid19 a
where 1=1
and continent is not null
group by to_char(a.dates, 'YYYY-MM'), a.continent, a.country
having sum(a.new_cases) > 0
order by 1,2,4 desc;

select a.months
       ,a.continent
       ,a.country
       ,a.new_cases
       ,conti.continent_cases
       ,round((a.new_cases/conti.continent_cases)*100,2) rates
from (select to_char(dates, 'YYYY-MM') months, continent, country, sum(new_cases) new_cases
        from covid19
      group by to_char(dates, 'YYYY-MM'), continent, country
      having sum(new_cases)>0) a
    ,(select to_char(b.dates, 'YYYY-MM') months, b.continent, sum(b.new_cases) continent_cases
        from covid19 b
      group by to_char(b.dates, 'YYYY-MM'), b.continent) conti
where a.months = conti.months
  and a.continent = conti.continent
  and a.continent is not null
order by 1,2,4 desc;

--6.1.6
select * from covid19
where dates between to_date('20200101','yyyymmdd') and to_date('20201231','yyyymmdd')
  and iso_code = 'KOR'
order by 4;
select to_char(dates, 'MM') months
      ,sum(new_tests) �˻��
      ,sum(new_cases) Ȯ���ڼ�
      ,round(sum(new_cases)/sum(new_tests)*100,2) Ȯ����
from covid19
where dates between to_date('20200101','yyyymmdd') and to_date('20201231','yyyymmdd')
  and iso_code = 'KOR'
group by to_char(dates, 'MM')
order by 1;

--6.2.1
select * from covid19;
select country, sum(new_cases)
from covid19
where to_char(dates,'yyyy') ='2020'
and country !='World'
group by to_char(dates,'yyyy'), country
having sum(new_cases) is not null
order by 2 desc
fetch first 5 rows only;

--6.2.2
select country
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
order by rates desc
fetch first 20 rows only;

--6.2.a ���� �ٽ� Ǯ���
--emp_id, emp_name, dept_name, stt_add, country_name
select * from employees;
select * from departments;
select * from locations;
select * from countries;
with emp as (select a.employee_id, a.first_name||' '||a.last_name emp_name,
                    b.department_name dept_name, b.location_id
               from employees a, departments b
              where a.department_id = b.department_id)
,loc_ctr as (select c.employee_id, c.emp_name, c.dept_name,
                    d.street_address,
                    e.country_name
               from emp c, locations d, countries e
              where c.location_id = d.location_id
                and d.country_id = e.country_id)
select g.*
from employees f, loc_ctr g
where f.employee_id = g.employee_id
  and f.first_name = 'David'
order by 1;


--6.3.1
select continent, sum(q1), sum(q2), sum(q3), sum(q4)
from(select continent, to_char(dates, 'q')
           ,case when to_char(dates, 'q') = 1 then sum(new_cases) else 0 end q1
           ,case when to_char(dates, 'q') = 2 then sum(new_cases) else 0 end q2
           ,case when to_char(dates, 'q') = 3 then sum(new_cases) else 0 end q3
           ,case when to_char(dates, 'q') = 4 then sum(new_cases) else 0 end q4
    from covid19
    where dates between to_date('20200101','yyyymmdd') and to_Date('20201231','yyyymmdd')
    and continent is not null
    group by continent, to_char(dates, 'q'))
group by continent
order by 1;

--6.3.2
select * from orders;
select * from order_items;
select * from products;
select sale_year, sum(m6) model_2016, sum(m7) model_2017, sum(m8) model_2018
from (select to_char(a.order_date, 'yyyy') sale_year
          ,case when c.model_year = '2016' then sum(b.quantity*b.list_price) else 0 end m6
          ,case when c.model_year = '2017' then sum(b.quantity*b.list_price) else 0 end m7
          ,case when c.model_year = '2018' then sum(b.quantity*b.list_price) else 0 end m8
    from orders a, order_items b, products c
    where b.order_id = a.order_id
      and b.product_id = c.product_id
    group by to_char(a.order_date, 'yyyy'), c.model_year)
group by sale_year
order by 1;

select *
from(select to_char(a.order_date, 'yyyy') sale_year, c.model_year, nvl(sum(b.quantity*b.list_price),0) sum_amt
from orders a, order_items b, products c
where b.order_id = a.order_id
and b.product_id = c.product_id
group by to_char(a.order_date, 'yyyy'), c.model_year)
pivot(sum(sum_amt) for model_year in ('2016','2017','2018'))
order by 1;