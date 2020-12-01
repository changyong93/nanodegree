--내부 조인
Select a.employee_id,
       a.first_name,
       b.department_id,
       b.department_name,
       b.location_id,
       c.street_address,
       c.city
from employees a,
       departments b,
       locations c
where a.department_id = b.department_id
  and b.location_id = c.location_id
order by a.employee_id;

--ANSI 내부 조인
Select a.employee_id,
       a.first_name,
       b.department_id,
       b.department_name,
       b.location_id,
       c.street_address,
       c.city
from employees a
inner join departments b
on a.department_id = b.department_id
inner join locations c
on b.location_id = c.location_id
order by a.employee_id;



--외부 조인
Select a.employee_id,
       a.first_name,
       b.department_id,
       b.department_name,
       b.location_id
from employees a,
     departments b
where a.department_id(+) = b.department_id
order by a.employee_id;

--ANSI LEFT outer 조인

Select a.employee_id,
       a.first_name,
       b.department_id,
       b.department_name,
       b.location_id,
       c.street_address,
       c.city
from employees a
left outer join departments b
on a.department_id = b.department_id
left outer join locations c
on b.location_id = c.location_id
order by a.employee_id;

--seft 조인
select * from employees;
select a.employee_id,
       a.first_name||a.last_name as emp_name,
       a.manager_id,
       b.first_name||b.last_name as manager_name
from employees a
inner join employees b
on a.manager_id = b.manager_id
order by 1;

--5.1.1
select * from jobs;
select * from employees;

select a.employee_id,
       a.first_name||' '||a.last_name as emp_name,
       a.salary,
       b.min_salary,
       b.max_salary
from employees a, jobs b
where a.job_id = b.job_id
and a.salary not between b.min_salary and b.max_salary;

select a.employee_id,
       a.first_name||' '||a.last_name as emp_name,
       a.salary,
       b.min_salary,
       b.max_salary
from employees a
inner join jobs b
on a.job_id = b.job_id
and a.salary not between b.min_salary and b.max_salary;

--5.1.2

select * from job_history order by 1;

select a.employee_id,
       a.first_name || ' ' || a.last_name emp_names,
       b.*
from employees a, job_history b
where a.employee_id(+) = b. employee_id
order by 1;
--외부 조인을 해도 내부조인과 같은 이유는
--조회 조건에 부합되지 않은 job_history의 employee_id 컬럼의 데이터가 없음
--> 누락 데이터가 없으므로 내부 조인만으로 조회 가능

SELECT a.employee_id
,a.first_name || ' ' || a.last_name emp_name
,a.manager_id
,b.first_name || ' ' || b.last_name manager_name
FROM employees a
,employees b
WHERE a.manager_id = b.employee_id
ORDER BY 1;

--5.1.3
select * from employees;
select a.employee_id,
       a.first_name||' '||a.last_name as emp_name,
       a.manager_id,
       b.first_name||' '||b.last_name as manager_name
from employees a, employees b
where a.manager_id = b.employee_id
order by 1;

select a.employee_id,
       a.first_name||' '||a.last_name as emp_name,
       a.manager_id,
       b.first_name||' '||b.last_name as manager_name
from employees a
inner join employees b
on a.manager_id = b.employee_id
order by 1;
--내부 조인으로, 100번은 오너로 매니저가 따로 없으므로 제외됨

--5.1.4
select * from employees;
select a.employee_id,
       a.first_name||' '||a.last_name as emp_name,
       a.manager_id,
       b.first_name||' '||b.last_name as manager_name
from employees a
left outer join employees b
on a.manager_id = b.employee_id
order by 1;

--5.1.5
select * from employees;
select * from departments;
select * from locations;
select a.employee_id,
       a.first_name || ' ' || last_name as emp_name,
       a.salary,
       a.department_id,
       b.location_id,
       c.country_id
from employees a
inner join departments b
on a.department_id = b.department_id
inner join locations c
on b.location_id = c.location_id
where 1=1
and a.first_name = 'David'
and a.salary >=6000;

--5.1.6
select * from orders;
select * from customers;
select * from stores;
select * from staffs;

select a.order_id,
       a.order_date,
       b.first_name||' '||b.last_name as customer_name,
       c.store_name,
       d.first_name||' '||d.last_name as staff_name
from orders a
inner join customers b
on a.customer_id = b.customer_id
inner join stores c
on a.store_id = c.store_id
inner join staffs d
on a.staff_id = d.staff_id
where to_char(order_date, 'YYYY') = '2018'
order by 2;

--5.1.7
select * from orders;
select * from order_items;

select to_char(a.order_date, 'YYYY-MM') months,
      round(sum(b.quantity*b.list_price),2) order_amt
from orders a
     ,order_items b
where 1=1
and to_char(a.order_date, 'YYYY') = '2018'
and a.order_id = b.order_id
group by to_char(a.order_date, 'YYYY-MM')
order by 1;

select to_char(a.order_date, 'YYYY-MM') months,
      round(sum(b.quantity*b.list_price),2) order_amt
from orders a
inner join order_items b
on a.order_id = b.order_id
where 1=1
and to_char(a.order_date, 'YYYY') = '2018'
group by to_char(a.order_date, 'YYYY-MM')
order by 1;

--5.1.8
select * from orders;
select * from order_items;
select * from products;
select * from brands;

select to_char(a.order_date, 'YYYY-Q') quarter,
       d.brand_name,
       round(sum(b.quantity*b.list_price),2) order_amt
from orders a
inner join order_items b
on a.order_id = b.order_id
inner join products c
on b.product_id = c.product_id
inner join brands d
on c.brand_id = d.brand_id
where 1=1
and a.order_date between tO_date('20180101', 'YYYY-MM-DD') and to_date('20181231','YYYY-MM-DD')
group by to_char(a.order_date, 'YYYY-Q'), d.brand_name 
having sum(b.quantity*b.list_price) >=10000
order by 1,3 desc;

--5.1.9
select * from orders;
select * from order_items;
select * from stores;

select to_char(a.order_date, 'YYYY') years,
       b.store_name,
       round(sum(c.quantity*c.list_price),2) order_amt
from orders a
inner join stores b
on a.store_id = b.store_id
inner join order_items c
on a.order_id = c.order_id
group by to_char(a.order_date, 'YYYY'), b.store_name
order by 1;

------------------------------------------
--분석함수
select * from employees;

select employee_id, salary, job_id,
--sum(salary) over (partition by job_id)
lead(salary,1,0) over (partition by job_id
                       order by salary)
from employees
where 1=1
order by 3, 2;

------------------------------------------
--5.3.1
select * from employees;

select a.department_id,
       b.department_name,
       a.first_name||' '||a.last_name as emp_name,
       a.hire_date,
       a.salary,
       sum(a.salary) over(partition by a.department_id
                        order by a.hire_date) 누적합계
from employees a
inner join departments b
on a.department_id = b.department_id
order by 2,4;