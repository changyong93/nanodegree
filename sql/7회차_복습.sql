/*
sql�� DML�� : select, insert, update, delete, merge
insert : ���̺� ������ �űԷ� �߰�
update : �̹� ����� ������ ����
delete : ����� ������ ����
merge : ���ǿ� ���� insert�� update ����
*/

/*insert
-���̺� �ű� ������ �߰�
-�⺻������ insert �ѹ��� �ϳ��� row�� �Է��ϳ�,
-�Է� ������ ���� �������� rows�� ���ÿ� �Է� ����
*/
/*
����1
insert into ���̺�� (�÷�1,�÷�2,....)
values (��1, ��2,.....)
-�� �� ���� �� row �Ѱ� �߰�
-�÷�1,�÷�2,...  & ��1, ��2,...�� ����, ����, ���������� ��ġ�ؾ� ��
-�÷��� ���� �����ϳ� ���� �� ��� �÷��� ���� ������� �Է��ؾ� ��
-insert �� �÷� ��ġ ����(�÷�2,�÷�1) �� ���� ����(��2, ��1)
-not null�� �ݵ�� �Է�
*/

create table emp(
    emp_no varchar2(30) not null,
    emp_name varchar2(80) not null,
    salary number,
    hire_date date);

--�⺻Ű ���� -> ���� �� not null + ���ϰ�
alter table emp
add constraints emp_pk primary key(emp_no);

select * from emp;
insert into emp (emp_no, emp_name, salary, hire_date) values(1,'ȫ�浿',1000,sysdate);
insert into emp (emp_no, emp_name) values(2,'������');
insert into emp (emp_name, emp_no) values('������', 3);
insert into emp values(4,'�������',1000,sysdate-1);
insert into emp values(5,'�Ż��Ӵ�',2000,to_date('2020-06-29 07:30:24','yyyy-mm-dd hh24:mi:ss')); 

/*����2
insert into ���̺��(�÷�1,�÷�2,...)
select expr1, expr2,....
  from ...
-�� �� ���� �� ���� ���� row �Է� ���� -> select ���� ��ȯ�ϴ� �����Ϳ� ���� �¿��
-�÷�1,�÷�2,...�� expr1, expr2,...�� ����, ����, ���������� ��ġ�ؾ� ��
-���̺�� ����(�÷�1,�÷�2,...) �κ��� ���� ����, ���� �� ��� �÷� �� �Է�
-not null �Ӽ��� �÷��� �ݵ�� �Է�
*/

insert into emp
select emp_no+10, emp_name, salary, hire_date
from emp;

truncate table emp;

insert into emp
select employee_id, first_name||' '||last_name, salary, hire_date
from employees
where department_Id = 90;
select * from emp;

create table emp_info1(
    emp_no varchar2(30) not null,
    emp_name varchar2(80) not null,
    salary number,
    hire_date date,
    department_name varchar2(80),
    country_name varchar2(80));
    
insert into emp_info1
select a.employee_id, a.first_name||' '||a.last_name, a.salary, a.hire_date
      ,b.department_name
      ,d.country_name
from employees a, departments b, locations c, countries d
where a.department_id = b.department_id(+)
  and b.location_id = c.location_id(+)
  and c.country_id = d.country_id(+)
order by 1;
select * from emp_info1;
truncate table emp_info1;


/*����3(unconditional Multitable insert)
insert all
into ���̺�1(�÷�1, �÷�2,...) values(��1, ��2,...)
into ���̺�2(�÷�1, �÷�2,...) values(��1, ��2,...)
...
select exp1, exp2,...
from...
-�� ���� �� ���� ���̺� ���� insert
-�÷�, ��, exp�� ����, ����, ������ ���°� ��ġ�ؾ� ��
-����Ŭ 9i���� �߰��� ���
-����Բ����� ���� ����ϴ� ��� ���� ���ٰ� �Ͻ�
*/

create table emp3(
    emp_no varchar2(30) not null,
    emp_name varchar2(80) not null,
    salary number,
    hire_date date,
    dept_id number);
create table emp2(
    emp_no varchar2(30) not null,
    emp_name varchar2(80) not null,
    salary number,
    hire_date date,
    dept_id number);
    create table emp1(
    emp_no varchar2(30) not null,
    emp_name varchar2(80) not null,
    salary number,
    hire_date date,
    dept_id number);
alter table emp1 add constraints emp1_pk primary key(emp_no);
alter table emp2 add constraints emp2_pk primary key(emp_no);
alter table emp3 add constraints emp3_pk primary key(emp_no);

insert all
into emp1(emp_no, emp_name, salary, hire_date, dept_id) values(emp_no, emp_name, salary, hire_date, dept_id)
into emp2(emp_no, emp_name, salary, hire_date, dept_id) values(emp_no, emp_name, salary, hire_date, dept_id)
into emp3(emp_no, emp_name, salary, hire_date, dept_id) values(emp_no, emp_name, salary, hire_date, dept_id)
select employee_id emp_no
      ,first_name||' '||last_name emp_name
      ,salary
      ,hire_date
      ,department_id dept_id
from employees;
select * from emp1;
select * from emp2;
select * from emp3;
truncate table emp1;
truncate table emp2;
truncate table emp3;

insert all
into emp1(emp_no, emp_name, salary, hire_date, dept_id) values(emp_no, emp_name, salary, hire_date, dept_id)
into emp2(emp_no, emp_name, salary, hire_date, dept_id) values(emp_no, emp_name, salary, hire_date, dept_id)
into emp3(emp_no, emp_name, salary) values(emp_no, emp_name, salary)
select employee_id emp_no
      ,first_name||' '||last_name emp_name
      ,salary
      ,hire_date
      ,department_id dept_id
from employees;

/*����4-1(conditional Multitable insert)
����
insert all
when ���� 1 then
  into ���̺�1(�÷�1, �÷�2,...) values(��1, ��2,...)
when ���� 2 then
  into ���̺�2(�÷�1, �÷�2,...) values(��1, ��2,...)
else into...
select exp1, exp2,...
from...
...
select exp1, exp2,...
from...

����4-2(conditional Multitable insert)
����
insert first
when ���� 1 then
  into ���̺�1(�÷�1, �÷�2,...) values(��1, ��2,...)
when ���� 2 then
  into ���̺�2(�÷�1, �÷�2,...) values(��1, ��2,...)
else into...
select exp1, exp2,...
from...
...
select exp1, exp2,...
from...
insert all : when ������ �´� ��� ���̺� insert
insert first : when ���� �ۼ� ������� �����Ͽ� ������ �´� ��� �ش� table�� insert
               ���� ���ǵ� when ù �������� ����
*/
select * from emp1;
select * from emp2;
select * from emp3;
truncate table emp1;
truncate table emp2;
truncate table emp3;
insert all
when dept_id = 20 then
  into emp1(emp_no, emp_name, salary, hire_date, dept_id) values(emp_no, emp_name, salary, hire_date, dept_id)
when dept_id between 30 and 50 then
  into emp2(emp_no, emp_name, salary, hire_date, dept_id) values(emp_no, emp_name, salary, hire_date, dept_id)
when dept_id > 50 then --�ƴϸ� else�� ������ ����� �� ���� ����, �� null�� ���� ����
  into emp3(emp_no, emp_name, salary, hire_date, dept_id) values(emp_no, emp_name, salary, hire_date, dept_id)
select employee_id emp_no
      ,first_name||' '||last_name emp_name
      ,salary
      ,hire_date
      ,department_id dept_id
from employees;

select * from emp1;
select * from emp2;
select * from emp3;
truncate table emp1;
truncate table emp2;
truncate table emp3;
insert all
--insert first
when salary >=2500 then
  into emp1(emp_no, emp_name, salary, hire_date, dept_id) values(emp_no, emp_name, salary, hire_date, dept_id)
when salary >= 5000 then
  into emp2(emp_no, emp_name, salary, hire_date, dept_id) values(emp_no, emp_name, salary, hire_date, dept_id)
when salary >= 7000 then
  into emp3(emp_no, emp_name, salary, hire_date, dept_id) values(emp_no, emp_name, salary, hire_date, dept_id)
select employee_id emp_no
      ,first_name||' '||last_name emp_name
      ,salary
      ,hire_date
      ,department_id dept_id
from employees;

/*update����
- ���̺� ����� ������ ����
- �÷� ���� ���� ���ǿ� ���� ���� ���� row ó�� ����
- where ���� ���� ����

����
update ���̺��
set �÷�1 = ���氪1
   ,�÷�2 = ���氪2
   ,...
where ����
-�����Ϸ��� �÷��� ���氪�� ������ ���� �¾ƾ� �ϸ�
-���氪 �׸񿡴� ǥ���İ� ���������� ����
where �Է� : ���ǿ� �´� row�� ó��
where ���Է� : ��ü ó��
*/

select * from emp;
update emp
set salary = 0
where salary <20000;

alter table emp
add retire_date date;

update emp
set retire_date=sysdate
where emp_no = 102;

select * from emp_info1;
update emp_info1
set emp_name = emp_name||' (middle)'
where salary between 10000 and 20000;
--������Ʈ Ȯ��
select * from emp_info1
where salary not between 10000 and 20000
and instr(emp_name, '(middle)')>0;

/*delete��
- ���̺� ����� ������ ����
- row���� ����
- whrer�� ������ ���� ���� ����, �̼��� �� row ��ü ���� => delete + commit = truncate table
����
delete (from) ���̺��
where ����
-from ���� ����
*/
select * from emp;
delete from emp
where emp_no in(101,102);

select * from emp1;
delete emp1
where emp_name like 'J%';
commit;

create table emps_copy as
select * from employees;

--7.1.1
insert into departments
select 500, 'IT2', manager_id, location_id
from departments
where department_name ='IT';

--7.1.2
select * from departments;
update departments
--set manager_id = nvl2(manager_id,110,100)
set manager_id = case when manager_id is null then 100 else 110 end
where department_id>=280;

--7.1.3
select * from departments;
delete departments
where department_id>=280;

--7.1.4
select * from covid19;
create table covid19_kor as
select *
from covid19
where iso_code = 'KOR'
  and dates between to_date('20200501','yyyymmdd') and to_date('20201031','yyyymmdd');
select * from covid19_kor order by 4;

/*transaction ó��
���̺� ���� �� commit -> ���̺� ����
���̺� ���� �� rollback -> ���̺� ����
*/

/*merge��
 - insert�� update�� �ѹ��� ó��
 - ��� ���̺� ���ǿ� ���� insert or update ����
 - �Ϲ������� ���̺��� �ֿ�Ű ���� üũ, �ش� ���� ���� �� update, �ƴϸ� insert

����
merge into ���̺��
using �������̺� ro ��������
on ��������
when mahtched then update set �÷�1 = ��1, �÷�2 = ��2,...
when not matched then insert (�÷�1, �÷�2,...) values(��1, ��2,...);
*/

create table dept_mgr as select * from departments;
alter table dept_mgr add constraints dept_mgr_pk primary key(department_id);

select * from dept_mgr;
merge into dept_mgr a
using (select 280 dept_id, '������(merge)' dept_name from dual
       union all
       select 285 dept_id, '�渮��(merge)' dept_name from dual
       ) b
on (a.department_id = b.dept_id)
when matched then update set a.department_name = b.dept_name
when not matched then insert (a.department_id, a.department_name) values(b.dept_id, b.dept_name);

merge into dept_mgr a
using (select 280 dept_id, '������(merge)2' dept_name from dual
       union all
       select 285 dept_id, '�渮��(merge)2' dept_name from dual
       ) b
on (a.department_id = b.dept_id)
when matched then update set a.department_name = b.dept_name
when not matched then insert (a.department_id, a.department_name) values(b.dept_id, b.dept_name);

merge into dept_mgr a
using (select 280 dept_id, '������(merge)3' dept_name from dual
       union all
       select 290 dept_id, '�渮��(merge)' dept_name from dual
       ) b
on (a.department_id = b.dept_id)
when matched then update set a.department_name = b.dept_name
when not matched then insert (a.department_id, a.department_name) values(b.dept_id, b.dept_name);

/*view
 - �ϳ� Ȥ�� �� �̻��� �ٸ� ���̺��̳� ��� ������ ���� ��ü (���̺�ó�� ����)
 - �� ��ü���� �����Ͱ� ������� ����(����Ǵ� �䵵 ������ �츮 ���ؿ��� �Ⱦ˷��ֽ�)
 - �� ��� �ʱ� �ۼ��� ������� �����Ͽ� �� ��ȸ��
 - �ϳ��� �䰡 �� �ٸ� �信�� ��� �� �� ����
 
�� ���� : create or replace view ���̸� as select...;
�� ���� : create or replace view ���̸� as select...;
�� ���� : drop view ���̸�;
*/
create or replace view emp_dept_v as
select a.employee_id, a.first_name||' '||a.last_name emp_name
      ,b.department_id, b.department_name
from employees a, departments b
where a.department_id = b.department_id;
select * from emp_dept_v;

grant select on emp_dept_v to hr2;

select * from employees;
--salary �����ϰ� �÷� �����ϱ�
select ',a.'||column_name from user_tab_cols
where table_name = 'EMPLOYEES';
select a.EMPLOYEE_ID
       ,a.FIRST_NAME
       ,a.LAST_NAME
       ,a.EMAIL
       ,a.PHONE_NUMBER
       ,a.HIRE_DATE
       ,a.JOB_ID
       ,a.COMMISSION_PCT
       ,a.MANAGER_ID
       ,a.DEPARTMENT_ID
from employees a;
