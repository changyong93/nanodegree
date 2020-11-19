--cdb, pdb 생성
-- system 계정으로 cdb,pdb 접속
-- table 생성

create user orauser identified by chang default tablespace ora_tb;
grant dba to orauser;

alter user hr identified by hr account unlock;

create table emp(
    emp_no varchar(30) not null,
    emp_name varchar(80) not null,
    salary number null,
    hire_date date null);
    
desc emp;

alter table emp modify emp_name varchar2(100);
alter table emp add emp_name2 varchar2(80);
alter table emp rename column emp_name2 to emp_name3;
alter table emp drop column emp_name3;
drop table emp;


create table country_test(
    country_id number not null,
    country_name varchar2(100) null);
    
alter table country_test add constraints country_test_pk primary key(country_id);
alter table country_test add region_id number;
alter table country_Test modify region_id number not null;
desc country_test;
drop table country_Test;

select * from employees;
select employee_id, first_name, last_name, salary from employees where salary>=5000 order by salary desc;
select * from employees where employee_id !=100;
select * from employees;
select * from employees order by 2 , last_name desc;

desc employees;
desc locations;

select * from employees where first_name = 'David' and salary >=6000;
select * from departments where department_id = 80;
select * from locations where location_id = 2500;

select * from employees;
select * from employees where manager_id is null;
select * from employees where manager_id is not null;
select * from employees where job_id like '%AD%';
select *,
    case when salary between 1 and 5000 then 1
         when salary between 5001 and 10000 then 2
         when salary between 10001 and 15000 then 3
        else 4
    end salary_rank    
from employees;

select * from employees;

select * from employees where manager_id is null;

select salary, commission_pct,
    case when commission_pct is null then salary
         else salary + (salary * commission_pct)
    end total_salary     
from employees;

select * from locations where postal_code = '1730';
select postal_code || ' - ' || street_address || ' - ' || city || ' - ' || state_province || ' - ' || country_id as 주소 from locations where country_id = 'CH';
select postal_code || ' - ' || street_address || ' - ' || city || ' - ' || state_province || ' - ' || country_id as 주소 from locations where country_id = 'UK';

select * from emp;
desc emp;
insert into emp (emp_no, emp_name) values ('3', 'chong');
insert into emp values ('4', 'qhong');

update emp set salary = 5000 where salary is null;

select * from employees where job_id in('AD_PRES', 'AD_VP','IT_PROG','FI_MGR');
select job_id from employees order by job_id;

desc employees;
select * from employees;

select * from employees where job_id in ('AD%', 'IT%', 'PU%');
