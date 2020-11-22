/*
데이터 - 가공되지 않은 단순한 형태의 사실(fact), 값
      - 의미 있는 정보(information)이 되기 위해 임의의 처리(process)과정 필요

Data Base(DB) - 데이터를 체계적으로 모아 놓은 논리접인 집합

Data Base management System(DBMS) - 데이터 베이스를 관리하는 컴퓨터 프로그램

Relational DBMS(RDBMS) - 관계형 데이터 베이스
                       - 중복 데이터를 제거한 데이터의 효율적인 저장 방식

RDBMS 특징
    1. 데이터 중복 최소화
        - 2차원 형태의 테이블이라는 객체에 데이터 저장
        - 중복 데이터 저장을 최소화하기 위해 데이터 성격에 따라 여러 테이블에 분할하여 데이터 저장->데이터 스토리지 비용 절감)
        - 관련된 여러 테이블에 분산된 데이터를 연결해 데이터 추출
    2. 데이터 무결성(integrity)
        - DB에 저장된 데이터의 일관성, 정확성, 신뢰성 보장
        - 잘못된 형태의 데이터 입력 불허 및 각종 객체, 기본키, Null, 참조키, 제약조건 등을 통해 데이터 무결성 보장
    3. 트랜젝션 처리
        - 원자성(atomicity) - 트랜젝션 수행 연산 작업이 모두 정상적으로 처리되거나, 모두 처리되지 않는 all or nothing 방식
        - 일관성(Consistency) - 트랜젝션 후에도 DB의 데이터는 일관된 상태 유지, ex) 정수형-> 정수형 / 정수형 X-> 문자형
        - 고립성(isolation) - 하나의 트랜젝션이 완료될 때까지 다른 트래젝션이 간섭 못하도록 방지
        - 지속성(Durability) - 성공한 트로젝션은 영구적으로 DB에 저장
    4. SQL을 이용한 데이터 처리
        - SQL은 통계학자들이 통계학을 바탕으로 만들어낸 프로그램
        - 사람과 RDBMS간 데이터 처리를 위한 의사소통 언어
        - 조쇠, 변경, 수정, 삭제 작업을 통해 데이터 처리 예정
    5. 데이터 보안
        - 사용자별 권한 관리
        - 기본적으로 자신이 만든 데이터만 접근하여 사용 가능

SQL
    정의
        - SQL : Structured Query Language의 약자, 구조화된(구조적인) 질의 언어
        - RDBMS와 데이터 처리를 위한 소통 언어
        - 집합적 언어<-> C,java, python같은 프로그래밍 언어는 절차지향적 언어
        - SQL 표준 존재
    특징
        - 영어 기반
        - 데이터 처리(조회, 입력, 삭제, 수정) 뿐만 아니라 데이터 베이스 객체(테이블,뷰,....) 생성, 수정 시 사용
        - 특정 조건에 맞는 데이터 한 번에 처리(집합적 언어)
        -탁월한 데이터 가공 처리
    종류
        - DDL(data deifinition Language) 데이터 정의어, DB객체 생성 수정 삭제
            - create : 객체 생성
            - drop : 생성된 객체 삭제
            - alter : 생성된 객체 수정
            - truncate table : 테이블 데이터 삭제
            - rename : 객체 이름 변경
        - DML(data manipulation Language) 데이터 조작어, 데이터 조회 입력 수정 삭제
            - select : 테이블에 저장된 데이터 조회
            - insert : 테이블에 신규 데이터 입력/저장
            - update : 기존 데이터 수정
            - delete : 데이터 삭제
            - merge : 조건에 따라 입력과 수정 동시 처리(inser + update)
        - TCL(transaction control Language) 트렌젝션 제어어, 데이터 변경 작업 발생 시
            - commit : 데이터 저장
            - rollback : 데이터 변경 이전 상태로 돌림
            * MYsql, mssql 등은 자동 commit으로 rollback 불가(데이터 처리 매우 중유)
        - DCL(data control Language) 데이터 제어어, 권할 할당 및 회수
            - grant
            - revoke
        - Truncate table, drop table, delete
            - Truncate table - 자동 commit, rollback 불가
            - drop table - 자동 commit, rollback 불가
            - delete - commit & rollback 선택 가능
    기타
        - 대소문자 구분
            - 테이블 데이터는 대소문자 구분
            - 쿼리, 테이블명, 컬럼명 등은 대소문자 구분 없음


RDBMS중 Oracle
    -12C 이후 머리 태넌트 아키텍처 구조
    -하나의 CBD(container DB)에 여러 개의 PDB(pluggable DB)를 만들어 사용
    -하나의 DB를 여러 개의 DB처럼 운영
     (create pluggable database hrpdb admin user dba1 identified by password;)
    -시스템 자원을 CDB, PDB가 공용으로 사용하나 각 PDB별 데이터는 독립적을 생성하여 사용

사용자와 스키마(schema)
    사용자(user)
        - 오라클에 접속해 DB를 사용하는 계정
        - "create user 사용자명 identified by 패스워드"
    스키마(schema)
        - 사용자와 사용자 소유의 DB 객체의 집합
        - ex) orauser 계정으로 test1 테이블과 v_test 뷰를 만들었을 경우
            test1과 v_Test는 orauser의 스키마에 속하며, 이 두 객체의 소유자는 orauser

sys와 system 계정(관리자)
    - 오라클 새성 시 자동으로 두 계정 생성됨
    - sys 계정 - 오라클의 모든 권한 소유
    - system 계정 - 관리자 계정이나 데이터베이스 백업, 복구, 업그레이드 권한 없음

권한(privilege)과 롤(role)
    권한 - 시스템 권한과 객체 권한
        시스템 권한
            - 관리자가 특정 사용자에게 특정 작업을 할 수 있는 권한 할당
            - create user(사용자 권한), create session(데이터베이스 접속 권한), create table(테이블 생성 권한)
        객체 권한
            - 객체 소유자가 다른 사용자에게 자신의 객체 참조 권한 할당
    롤
        - 비슷한 권한들을 묶어놓은 것 ex) DBA : 시스템 권한들을 모아놓은 롤
    
    권한 및 롤 할당 및 회수
    grant 권한명(or롤명) to 사용자;
    revoke 권한명(or롤명) from 사용자;
*/
/* 오라클 접속 순서
    1. SYSTEM 계정 접속
    2. CDB, PDB 접속
    3. Tablespace 생성 & 사용자 계정 생성(orauser, tablespace 옵션 포함)
    4. HR계정 unlock 후 접속*/


--cdb 계정에서    
show con_name;
select con_id, name from v$pdbs;
select name, cdb from v$database;
show pdbs

--pdb system 계정에서
show con_name;
create tablespace ora_tb datafile 'C:\app\ChangYong\product\18.0.0\oradata\XE\XEPDB1\ora_tb.dbf'
size 100m autoextend on next 10m maxsize unlimited;

create user orauser identified by chang default tablespace ora_tb;
grant DBA to orauser;

--pdb system 계정 혹은 orauser 계저도 가능(DBA 롤 부여)
alter user hr identified by hr account unlock;

-- 사용 함수 고정
varchar2(n) --문자형 데이터
number --숫자형 데이터
data --날짜형 데이터

/*각종 제약 사항
개요
    - 데이터 무결성을 보장하기 위해 오라클 DB에서 제공하는 객체
    - Not null, 기본키 등
    
    Null vs Not null
        - 데이터가 Must 입력되어야 하는 조건 결정
        - Not null 시 데이터 입력이 안되면 오류 발생
    기본 키(primary Key)
        - 테이블에서 로우 1개를 유일하게 식별할 수 있는 값이 들어있는 컬럼 -> 테이블 하나당 하나의 기본키만 생성 가능
        - 중복 값이 없음
        - 유일한 값+ Not null
        ****** primary key vs Unique
                - primary key, 레코드의 데이터를 식별할 수 있도록 한 키를 가진 컬럼, 중복된 레코드가 없도록 제한, not null + 유일 값
                - unique, null은 허용하나 중복 불허, not null + 중복불허도 가능하나 레코드를 식별하는 컬럼은 아님
                  atler table emp
                  add constraints emp_name_uk unique(emp_name);
    Check
        -값을 설정하고, 입력되는 값이 다를 경우 오류
        -gender varchar2(1) check(gender in ("M", "F") -> M or F 이외에 값이 입력되면 오류*/


create table emp(
    emp_no varchar2(30) not null,
    emp_name varchar2(80) not null,
    salary number null,
    hire_date date null);
drop table emp;
insert into emp(emp_no, emp_name, salary) values('1번','고창용',5000);
delete from emp where salary <=10000;
--table 데이터 구조 파악
--select * from table_name; 테이블 전체 보기
desc emp;
select * from emp;

alter table emp modify emp_name varchar2(100);
alter table emp add emp_name2 varchar2(80);
alter table emp rename column emp_name2 to emp_name3;
alter table emp drop column emp_name3;
alter table emp modify emp_name varchar2(80);
drop table emp;

--primary key 생성 1
create table emp1(
    emp_no varchar2(30) primary key,
    emp_name varchar2(80) not null,
    salary number null,
    hire_date date null);
desc emp1;
--primary key 생성 2
create table emp2(
    emp_no varchar2(30) not null,
    emp_name varchar2(80) not null,
    salary number null,
    hire_date date null,
    primary key(emp_no));
desc emp2;
--primary key 생성 3
create table emp3(
    emp_no varchar2(30) not null,
    emp_name varchar2(80) not null,
    salary number null,
    hire_date date null);

alter table emp3
add constraints emp3_pk primary key(emp_no);

create table dept_test(
    dmpt_no number not null,
    dept_name varchar2(50) not null,
    dept_desc varchar2(100) null,
    create_date date null);
    
alter table dept_test
add constraints dept_test_pk primary key(dmpt_no);

drop table dept_test;

create table country_test(
    country_id number not null,
    country_name varchar2(100) not null);

alter table country_test
add constraints country_test_pk primary key(country_id);

desc country_test;
alter table country_test add region_id number null;
alter table country_test modify region_id number not null;
drop table country_test;

select * from employees;
desc employees;
select * from employees where salary not between 2400 and 20000;
select * from employees where salary between 2400 and 3000;

select * from employees where first_name = 'David' and salary >= 6000;
select * from departments where department_id = 80;
select * from locations where location_id = 2500;

select 10 + 4 as plus from dual;
select 10 - 4 as minus_ from dual;
select 10 * 4 as multifly from dual;
select 10 / 4 as devide from dual;
select -10 as minus_number from dual;
select +10 as plus_number from dual;
select 10 || 4 as "문자결합" from dual;

select * from employees where commission_pct is null;
select * from employees where commission_pct is not null;
select * from employees where job_id like 'SA%';
select * from employees where job_id not like 'SA%';
select * from employees where job_id in ('AD_PRES','AD_VP');
select * from employees where job_id not in ('AD_PRES','AD_VP');

select country_id, country_name,
    case region_id when 1 then '유럽'
                   when 2 then '아메리카'
                   when 3 then '아시아'
                   when 4 then '중동 및 아프리카'
    end as region_name
from countries;

select employee_id, first_name, last_name, salary, job_id,
    case when salary between 1 and 5000 then '낮음'
         when salary between 5001 and 10000 then '중간'
         when salary between 10001 and 15000 then '높음'
         else '최상위'
    end salary_rank
from employees;

select first_name, last_name, rownum from employees;
select * from employees where rownum <=100;

select * from employees where manager_id is null;

select salary, commission_pct,
    case  when commission_pct is null then salary
    else salary + (salary * commission_pct)
    end as total_salary
from employees;
 
select employee_id, first_name, last_name from employees where rownum<1;

select * from locations where city like 'S%' order by city desc;

select postal_code || ' - ' || street_address || ' - ' || city || ' - ' || state_province || ' - ' || country_id from locations where country_id = 'CH';
select postal_code || ' - ' || street_address || ' - ' || city || ' - ' || state_province || ' - ' || country_id from locations where country_id = 'UK' and postal_code is not null;

update locations set postal_code = '99999' where postal_code is null;
select postal_code || ' - ' || street_address || ' - ' || city || ' - ' || state_province || ' - ' || country_id from locations where country_id = 'UK' and postal_code is not null;
rollback;