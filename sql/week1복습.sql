/*
������ - �������� ���� �ܼ��� ������ ���(fact), ��
      - �ǹ� �ִ� ����(information)�� �Ǳ� ���� ������ ó��(process)���� �ʿ�

Data Base(DB) - �����͸� ü�������� ��� ���� ������ ����

Data Base management System(DBMS) - ������ ���̽��� �����ϴ� ��ǻ�� ���α׷�

Relational DBMS(RDBMS) - ������ ������ ���̽�
                       - �ߺ� �����͸� ������ �������� ȿ������ ���� ���

RDBMS Ư¡
    1. ������ �ߺ� �ּ�ȭ
        - 2���� ������ ���̺��̶�� ��ü�� ������ ����
        - �ߺ� ������ ������ �ּ�ȭ�ϱ� ���� ������ ���ݿ� ���� ���� ���̺� �����Ͽ� ������ ����->������ ���丮�� ��� ����)
        - ���õ� ���� ���̺� �л�� �����͸� ������ ������ ����
    2. ������ ���Ἲ(integrity)
        - DB�� ����� �������� �ϰ���, ��Ȯ��, �ŷڼ� ����
        - �߸��� ������ ������ �Է� ���� �� ���� ��ü, �⺻Ű, Null, ����Ű, �������� ���� ���� ������ ���Ἲ ����
    3. Ʈ������ ó��
        - ���ڼ�(atomicity) - Ʈ������ ���� ���� �۾��� ��� ���������� ó���ǰų�, ��� ó������ �ʴ� all or nothing ���
        - �ϰ���(Consistency) - Ʈ������ �Ŀ��� DB�� �����ʹ� �ϰ��� ���� ����, ex) ������-> ������ / ������ X-> ������
        - ����(isolation) - �ϳ��� Ʈ�������� �Ϸ�� ������ �ٸ� Ʈ�������� ���� ���ϵ��� ����
        - ���Ӽ�(Durability) - ������ Ʈ�������� ���������� DB�� ����
    4. SQL�� �̿��� ������ ó��
        - SQL�� ������ڵ��� ������� �������� ���� ���α׷�
        - ����� RDBMS�� ������ ó���� ���� �ǻ���� ���
        - ����, ����, ����, ���� �۾��� ���� ������ ó�� ����
    5. ������ ����
        - ����ں� ���� ����
        - �⺻������ �ڽ��� ���� �����͸� �����Ͽ� ��� ����

SQL
    ����
        - SQL : Structured Query Language�� ����, ����ȭ��(��������) ���� ���
        - RDBMS�� ������ ó���� ���� ���� ���
        - ������ ���<-> C,java, python���� ���α׷��� ���� ���������� ���
        - SQL ǥ�� ����
    Ư¡
        - ���� ���
        - ������ ó��(��ȸ, �Է�, ����, ����) �Ӹ� �ƴ϶� ������ ���̽� ��ü(���̺�,��,....) ����, ���� �� ���
        - Ư�� ���ǿ� �´� ������ �� ���� ó��(������ ���)
        -Ź���� ������ ���� ó��
    ����
        - DDL(data deifinition Language) ������ ���Ǿ�, DB��ü ���� ���� ����
            - create : ��ü ����
            - drop : ������ ��ü ����
            - alter : ������ ��ü ����
            - truncate table : ���̺� ������ ����
            - rename : ��ü �̸� ����
        - DML(data manipulation Language) ������ ���۾�, ������ ��ȸ �Է� ���� ����
            - select : ���̺� ����� ������ ��ȸ
            - insert : ���̺� �ű� ������ �Է�/����
            - update : ���� ������ ����
            - delete : ������ ����
            - merge : ���ǿ� ���� �Է°� ���� ���� ó��(inser + update)
        - TCL(transaction control Language) Ʈ������ �����, ������ ���� �۾� �߻� ��
            - commit : ������ ����
            - rollback : ������ ���� ���� ���·� ����
            * MYsql, mssql ���� �ڵ� commit���� rollback �Ұ�(������ ó�� �ſ� ����)
        - DCL(data control Language) ������ �����, ���� �Ҵ� �� ȸ��
            - grant
            - revoke
        - Truncate table, drop table, delete
            - Truncate table - �ڵ� commit, rollback �Ұ�
            - drop table - �ڵ� commit, rollback �Ұ�
            - delete - commit & rollback ���� ����
    ��Ÿ
        - ��ҹ��� ����
            - ���̺� �����ʹ� ��ҹ��� ����
            - ����, ���̺��, �÷��� ���� ��ҹ��� ���� ����


RDBMS�� Oracle
    -12C ���� �Ӹ� �³�Ʈ ��Ű��ó ����
    -�ϳ��� CBD(container DB)�� ���� ���� PDB(pluggable DB)�� ����� ���
    -�ϳ��� DB�� ���� ���� DBó�� �
     (create pluggable database hrpdb admin user dba1 identified by password;)
    -�ý��� �ڿ��� CDB, PDB�� �������� ����ϳ� �� PDB�� �����ʹ� �������� �����Ͽ� ���

����ڿ� ��Ű��(schema)
    �����(user)
        - ����Ŭ�� ������ DB�� ����ϴ� ����
        - "create user ����ڸ� identified by �н�����"
    ��Ű��(schema)
        - ����ڿ� ����� ������ DB ��ü�� ����
        - ex) orauser �������� test1 ���̺�� v_test �並 ������� ���
            test1�� v_Test�� orauser�� ��Ű���� ���ϸ�, �� �� ��ü�� �����ڴ� orauser

sys�� system ����(������)
    - ����Ŭ ���� �� �ڵ����� �� ���� ������
    - sys ���� - ����Ŭ�� ��� ���� ����
    - system ���� - ������ �����̳� �����ͺ��̽� ���, ����, ���׷��̵� ���� ����

����(privilege)�� ��(role)
    ���� - �ý��� ���Ѱ� ��ü ����
        �ý��� ����
            - �����ڰ� Ư�� ����ڿ��� Ư�� �۾��� �� �� �ִ� ���� �Ҵ�
            - create user(����� ����), create session(�����ͺ��̽� ���� ����), create table(���̺� ���� ����)
        ��ü ����
            - ��ü �����ڰ� �ٸ� ����ڿ��� �ڽ��� ��ü ���� ���� �Ҵ�
    ��
        - ����� ���ѵ��� ������� �� ex) DBA : �ý��� ���ѵ��� ��Ƴ��� ��
    
    ���� �� �� �Ҵ� �� ȸ��
    grant ���Ѹ�(or�Ѹ�) to �����;
    revoke ���Ѹ�(or�Ѹ�) from �����;
*/
/* ����Ŭ ���� ����
    1. SYSTEM ���� ����
    2. CDB, PDB ����
    3. Tablespace ���� & ����� ���� ����(orauser, tablespace �ɼ� ����)
    4. HR���� unlock �� ����*/


--cdb ��������    
show con_name;
select con_id, name from v$pdbs;
select name, cdb from v$database;
show pdbs

--pdb system ��������
show con_name;
create tablespace ora_tb datafile 'C:\app\ChangYong\product\18.0.0\oradata\XE\XEPDB1\ora_tb.dbf'
size 100m autoextend on next 10m maxsize unlimited;

create user orauser identified by chang default tablespace ora_tb;
grant DBA to orauser;

--pdb system ���� Ȥ�� orauser ������ ����(DBA �� �ο�)
alter user hr identified by hr account unlock;

-- ��� �Լ� ����
varchar2(n) --������ ������
number --������ ������
data --��¥�� ������

/*���� ���� ����
����
    - ������ ���Ἲ�� �����ϱ� ���� ����Ŭ DB���� �����ϴ� ��ü
    - Not null, �⺻Ű ��
    
    Null vs Not null
        - �����Ͱ� Must �ԷµǾ�� �ϴ� ���� ����
        - Not null �� ������ �Է��� �ȵǸ� ���� �߻�
    �⺻ Ű(primary Key)
        - ���̺��� �ο� 1���� �����ϰ� �ĺ��� �� �ִ� ���� ����ִ� �÷� -> ���̺� �ϳ��� �ϳ��� �⺻Ű�� ���� ����
        - �ߺ� ���� ����
        - ������ ��+ Not null
        ****** primary key vs Unique
                - primary key, ���ڵ��� �����͸� �ĺ��� �� �ֵ��� �� Ű�� ���� �÷�, �ߺ��� ���ڵ尡 ������ ����, not null + ���� ��
                - unique, null�� ����ϳ� �ߺ� ����, not null + �ߺ����㵵 �����ϳ� ���ڵ带 �ĺ��ϴ� �÷��� �ƴ�
                  atler table emp
                  add constraints emp_name_uk unique(emp_name);
    Check
        -���� �����ϰ�, �ԷµǴ� ���� �ٸ� ��� ����
        -gender varchar2(1) check(gender in ("M", "F") -> M or F �̿ܿ� ���� �ԷµǸ� ����*/


create table emp(
    emp_no varchar2(30) not null,
    emp_name varchar2(80) not null,
    salary number null,
    hire_date date null);
drop table emp;
insert into emp(emp_no, emp_name, salary) values('1��','��â��',5000);
delete from emp where salary <=10000;
--table ������ ���� �ľ�
--select * from table_name; ���̺� ��ü ����
desc emp;
select * from emp;

alter table emp modify emp_name varchar2(100);
alter table emp add emp_name2 varchar2(80);
alter table emp rename column emp_name2 to emp_name3;
alter table emp drop column emp_name3;
alter table emp modify emp_name varchar2(80);
drop table emp;

--primary key ���� 1
create table emp1(
    emp_no varchar2(30) primary key,
    emp_name varchar2(80) not null,
    salary number null,
    hire_date date null);
desc emp1;
--primary key ���� 2
create table emp2(
    emp_no varchar2(30) not null,
    emp_name varchar2(80) not null,
    salary number null,
    hire_date date null,
    primary key(emp_no));
desc emp2;
--primary key ���� 3
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
select 10 || 4 as "���ڰ���" from dual;

select * from employees where commission_pct is null;
select * from employees where commission_pct is not null;
select * from employees where job_id like 'SA%';
select * from employees where job_id not like 'SA%';
select * from employees where job_id in ('AD_PRES','AD_VP');
select * from employees where job_id not in ('AD_PRES','AD_VP');

select country_id, country_name,
    case region_id when 1 then '����'
                   when 2 then '�Ƹ޸�ī'
                   when 3 then '�ƽþ�'
                   when 4 then '�ߵ� �� ������ī'
    end as region_name
from countries;

select employee_id, first_name, last_name, salary, job_id,
    case when salary between 1 and 5000 then '����'
         when salary between 5001 and 10000 then '�߰�'
         when salary between 10001 and 15000 then '����'
         else '�ֻ���'
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