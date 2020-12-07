/*
sql의 DML문 : select, insert, update, delete, merge
insert : 테이블에 데이터 신규로 추가
update : 이미 저장된 데이터 수정
delete : 저장된 데이터 삭제
merge : 조건에 따라 insert와 update 수행
*/

/*insert
-테이블에 신규 데이터 추가
-기본적으로 insert 한번에 하나의 row를 입력하나,
-입력 구문에 따라 여러개의 rows를 동시에 입력 가능
*/
/*
구문1
insert into 테이블명 (컬럼1,컬럼2,....)
values (값1, 값2,.....)
-한 번 실행 시 row 한개 추가
-컬럼1,컬럼2,...  & 값1, 값2,...는 개수, 순서, 데이터형이 일치해야 함
-컬럼은 생략 가능하나 생략 시 모든 컬럼의 값을 순서대로 입력해야 함
-insert 시 컬럼 위치 변경(컬럼2,컬럼1) 시 값도 변경(값2, 값1)
-not null은 반드시 입력
*/

create table emp(
    emp_no varchar2(30) not null,
    emp_name varchar2(80) not null,
    salary number,
    hire_date date);

--기본키 지정 -> 지정 시 not null + 유일값
alter table emp
add constraints emp_pk primary key(emp_no);

select * from emp;
insert into emp (emp_no, emp_name, salary, hire_date) values(1,'홍길동',1000,sysdate);
insert into emp (emp_no, emp_name) values(2,'김유신');
insert into emp (emp_name, emp_no) values('강감찬', 3);
insert into emp values(4,'세종대왕',1000,sysdate-1);
insert into emp values(5,'신사임당',2000,to_date('2020-06-29 07:30:24','yyyy-mm-dd hh24:mi:ss')); 

/*구문2
insert into 테이블명(컬럼1,컬럼2,...)
select expr1, expr2,....
  from ...
-한 번 실행 시 여러 개의 row 입력 가능 -> select 문이 반환하는 데이터에 따라 좌우됨
-컬럼1,컬럼2,...와 expr1, expr2,...는 개수, 순서, 데이터형이 일치해야 함
-테이블명 다음(컬럼1,컬럼2,...) 부분은 생략 가능, 생략 시 모든 컬럼 값 입력
-not null 속성인 컬럼은 반드시 입력
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


/*구문3(unconditional Multitable insert)
insert all
into 테이블1(컬럼1, 컬럼2,...) values(값1, 값2,...)
into 테이블2(컬럼1, 컬럼2,...) values(값1, 값2,...)
...
select exp1, exp2,...
from...
-한 실행 시 여러 테이블 동시 insert
-컬럼, 값, exp의 개수, 순서, 데이터 형태가 일치해야 함
-오라클 9i부터 추가된 기능
-강사님께서는 실제 사용하는 경우 별로 없다고 하심
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

/*조건4-1(conditional Multitable insert)
구문
insert all
when 조건 1 then
  into 테이블1(컬럼1, 컬럼2,...) values(값1, 값2,...)
when 조건 2 then
  into 테이블2(컬럼1, 컬럼2,...) values(값1, 값2,...)
else into...
select exp1, exp2,...
from...
...
select exp1, exp2,...
from...

조건4-2(conditional Multitable insert)
구문
insert first
when 조건 1 then
  into 테이블1(컬럼1, 컬럼2,...) values(값1, 값2,...)
when 조건 2 then
  into 테이블2(컬럼1, 컬럼2,...) values(값1, 값2,...)
else into...
select exp1, exp2,...
from...
...
select exp1, exp2,...
from...
insert all : when 조건이 맞는 모든 테이블에 insert
insert first : when 쿼리 작성 순서대로 진행하여 조건이 맞는 경우 해당 table에 insert
               다음 조건도 when 첫 쿼리부터 진행
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
when dept_id > 50 then --아니면 else로 나머지 경우의 수 선택 가능, 단 null도 같이 들어옴
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

/*update구문
- 테이블에 저장된 데이터 수정
- 컬럼 값을 수정 조건에 따라 여러 개의 row 처리 가능
- where 절로 조건 설정

구문
update 테이블명
set 컬럼1 = 변경값1
   ,컬럼2 = 변경값2
   ,...
where 조건
-변경하려는 컬럼과 변경값은 데이터 형이 맞아야 하며
-변경값 항목에는 표현식과 서브쿼리도 가능
where 입력 : 조건에 맞는 row만 처리
where 미입력 : 전체 처리
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
--업데이트 확인
select * from emp_info1
where salary not between 10000 and 20000
and instr(emp_name, '(middle)')>0;

/*delete문
- 테이블에 저장된 데이터 삭제
- row단위 삭제
- whrer절 유무에 따라 조건 설정, 미설정 시 row 전체 삭제 => delete + commit = truncate table
구문
delete (from) 테이블명
where 조건
-from 생략 가능
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

/*transaction 처리
테이블 조작 후 commit -> 테이블 저장
테이블 조작 후 rollback -> 테이블 원복
*/

/*merge문
 - insert와 update를 한번에 처리
 - 대상 테이블 조건에 따라 insert or update 수행
 - 일반적으로 테이블의 주요키 값을 체크, 해당 값이 존재 시 update, 아니면 insert

구문
merge into 테이블명
using 참조테이블 ro 서브쿼리
on 조인조건
when mahtched then update set 컬럼1 = 값1, 컬럼2 = 값2,...
when not matched then insert (컬럼1, 컬럼2,...) values(값1, 값2,...);
*/

create table dept_mgr as select * from departments;
alter table dept_mgr add constraints dept_mgr_pk primary key(department_id);

select * from dept_mgr;
merge into dept_mgr a
using (select 280 dept_id, '영업부(merge)' dept_name from dual
       union all
       select 285 dept_id, '경리부(merge)' dept_name from dual
       ) b
on (a.department_id = b.dept_id)
when matched then update set a.department_name = b.dept_name
when not matched then insert (a.department_id, a.department_name) values(b.dept_id, b.dept_name);

merge into dept_mgr a
using (select 280 dept_id, '영업부(merge)2' dept_name from dual
       union all
       select 285 dept_id, '경리부(merge)2' dept_name from dual
       ) b
on (a.department_id = b.dept_id)
when matched then update set a.department_name = b.dept_name
when not matched then insert (a.department_id, a.department_name) values(b.dept_id, b.dept_name);

merge into dept_mgr a
using (select 280 dept_id, '영업부(merge)3' dept_name from dual
       union all
       select 290 dept_id, '경리부(merge)' dept_name from dual
       ) b
on (a.department_id = b.dept_id)
when matched then update set a.department_name = b.dept_name
when not matched then insert (a.department_id, a.department_name) values(b.dept_id, b.dept_name);

/*view
 - 하나 혹은 그 이상의 다른 테이블이나 뷰로 구성된 논리적 객체 (테이블처럼 동작)
 - 뷰 자체에는 데이터가 저장되지 않음(저장되는 뷰도 있으나 우리 수준에선 안알려주심)
 - 단 뷰는 초기 작성한 쿼리대로 동작하여 뷰 조회됨
 - 하나의 뷰가 또 다른 뷰에서 사용 될 수 있음
 
뷰 생성 : create or replace view 뷰이름 as select...;
뷰 수정 : create or replace view 뷰이름 as select...;
뷰 삭제 : drop view 뷰이름;
*/
create or replace view emp_dept_v as
select a.employee_id, a.first_name||' '||a.last_name emp_name
      ,b.department_id, b.department_name
from employees a, departments b
where a.department_id = b.department_id;
select * from emp_dept_v;

grant select on emp_dept_v to hr2;

select * from employees;
--salary 제외하고 컬럼 서택하기
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
