create table emp(
    emp_no    varchar2(30) not null,
    emp_name  varchar2(80) not null,
    salary    number           null,
    hire_date date             null);

alter table emp modify emp_name varchar2(100);
alter table emp add emp_name2 varchar2(80);
alter table emp rename column emp_name2 to emp_name3;
alter table emp drop column emp_name3;
desc emp;
select * from emp;


--1.
create table emp1(
    emp_no    varchar2(30) primary key,
    emp_name  varchar2(80) not null,
    salary    number           null,
    hire_date date             null);

--2
create table emp2(
    emp_no    varchar2(30) not null,
    emp_name  varchar2(80) not null,
    salary    number           null,
    hire_date date             null,
    primary key(emp_no));

--3
create table emp3(
    emp_no    varchar2(30) not null,
    emp_name  varchar2(80) not null,
    salary    number           null,
    hire_date date             null);

alter table emp3 add constraints emp3_pk primary key(emp_no);

create table dept_test(
    dept_no     number       not null,
    dept_name   varchar2(50) not null,
    detp_desc   varchar2(100)    null,
    create_date date             null);

alter table dept_test add constraints dep_test_pk primary key(dept_no);

drop table dept_test;

create table country_test(
    country_id number not null,
    country_name varchar2(100) not null);
    
alter table country_test add constraints country_test_pk primary key(country_id);
alter table country_Test add  region_id number null;
alter table country_Test modify region_id number not null;
desc country_test;

select * from employees;
select employee_id, first_name, last_name, salary from employees where salary >=5000 order by salary desc;
select * from employees where salary n<= 2400 and salary >=20000;

select * from locations;
desc locations;

select * from locations where location_id>=2000 and location_id < 3000;

select * from employees where first_name = 'David' and salary >=6000;
select * from departments where department_id = 80;
select * from locations where location_id = 2500;

select 3*3 as multiply from dual;

select * from employees where phone_number like '515%' and phone_number like '%69';
select * from employees;

select first_name, last_name,first_name|| ' ' || last_name from employees;

select country_id, country_name, region_id from countries;
select country_id, country_name,
    case region_id when 1 then '����'
                   when 2 then '�Ƹ޸�ī'
                   when 3 then '�ƽþ�'
                   else '�ߵ� �� ������ī'
    end as region_name
from countries;
    
select employee_id, first_name, last_name, salary, job_id,
    case when salary between  1    and 5000  then '����'
         when salary between 5001  and 10000 then '�߰�'
         when salary between 10001 and 15000 then '����'
         else '�ֻ���'
    end as salary_rank
from employees;

select * from employees where manager_id is null;

select salary, commission_pct,
    case when commission_pct is null then salary
         else salary + (salary * commission_pct)
    end total_salary
from employees order by commission_pct;

select * from employees where commission_pct is null;

select * from employees where rownum <1;

select * from locations where city like 'S%' order by city desc;

select * from locations where country_id ='CH';

select postal_code ||' - '|| street_address ||' - '|| city ||' - '|| state_province ||' - '|| country_id as �ּ�
from locations where country_id = 'US';

update locations set postal_code = '99999' where postal_code is null;

select postal_code ||' - '|| street_address ||' - '|| city ||' - '|| state_province ||' - '|| country_id as �ּ�
from locations where country_id = 'UK' and postal_code is not null;

update locations set postal_code = '99999' where postal_code is null;
select postal_code ||' - '|| street_address ||' - '|| city ||' - '|| state_province ||' - '|| country_id as �ּ�
from locations where country_id = 'UK';

/*select postal_code ||' - '|| street_address ||' - '|| city ||' - '|| state_province ||' - '|| country_id as �ּ�,
case when postal_code is null then '99999'
     else postal_code
end as postal_code
from locations where country_id = 'UK';*/


