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

--SQL ����-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DDL
create table ���̺��; --��ü ����
drop table ���̺��; --��ü ����
alter table ���̺��; --��ü ����
truncate table ���̺��; --��ü ������ ��ü ����
rename table ���̺�� to ���̺��; -- ��ü �̸� ����
--DML
select * from ���̺�� --���̺� ��ȸ
insert into ���̺�(�÷���1, �÷���2, ,,,) values(������1, ������2,...) --������ �Է�/����
update emp set salary =5000 from where salary in null; --���� ������ ����
delete from emp where salary <=10000; --������ ����
--TCL
commit; --Ŀ��
rollback; -- �ѹ�
--DCL
grant DBA to orauser; --����/�� �Ҵ�
revoke DBA from orauser; ����/�� ȸ��
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*������ Ȯ��*/
desc emp -- ���̺� ���� Ȯ��
select * from emp; -- ���̺� ��� ���ڵ�(��, row) Ȯ��

/*������ ���Ǻ� �˻�*/
select * from emp where salary > 5000 order by salary desc; -- salary 5000�̻����� ������������ ����, 
                                                            --�������� ��� salary desc, first_name; Ȥ�� 2 desc ,3, phone_number desc ;�� ����(��ȣ�� �������� �÷� �������)
select * from employees order by salary desc; -- asc(��������)default, ���� ���� / desc��������

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*modify*/
alter table emp modify col1 number not null; --�÷� ���� ����

--������-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--�⺻������
select 10 + 4 as plus from dual;
select 10 - 4 as minus_ from dual;
select 10 * 4 as multifly from dual;
select 10 / 4 as devide from dual;
select -10 as minus_number from dual;
select +10 as plus_number from dual;
select 10 || 4 as "���ڰ���" from dual;

--�� ������
select * from employees where salary = 24000; -- salary�� 24000�� ���ڵ�
select * from employees where not(salary = 24000); -- salary�� 24000�� �ƴ� ���ڵ�
select * from employees where salary != 24000; -- salary�� 24000�� �ƴ� ���ڵ�
select * from employees where salary <> 24000; -- salary�� 24000�� �ƴ� ���ڵ�
select * from employees where salary > 24000;-- salary�� 24000 �ʰ��� ���ڵ�
select * from employees where salary >= 24000;-- salary�� 24000 �̻��� ���ڵ�
select * from employees where salary < 24000;-- salary�� 24000 �̸��� ���ڵ�
select * from employees where salary <= 24000;-- salary�� 24000 ������ ���ڵ�
select * from employees where salary between 2000 and 24000;-- salary�� 2000�̻� 24000���� ������ ���ڵ�
select * from employees where salary not between 2000 and 24000;-- salary�� 2000�̻� 24000���ϰ� �ƴ� ���ڵ�
select * from employees where salary < 24000 and salary > 2000;-- salary�� 24000�ʰ� & 2000�̸��� ���ڵ�
select * from employees where salary = 24000 or salary < 2000;-- salary�� 24000�̰ų� 2000�̸��� ���ڵ�

--��Ÿ������
select * from employees where commission_pct is null;-- commission_pct�� ����ִ� ���ڵ�
select * from employees where commission_pct is not null;-- commission_pct�� ����ִ� ���� ���ڵ�
select * from employees where job_id like 'SA%'; -- job_id�� SA���ڰ� ���Ե� ���ڵ�
select * from employees where job_id not like 'SA%'; -- job_id�� SA���ڰ� ���ԵǾ� ���� �ʴ� ���ڵ�
select * from employees where job_id in ('AD_PRES','AD_VP'); -- job_id�� AD_PRES or AD_VP�� ���ڵ�(2���̻��� ,�� ������ ����)
select * from employees where job_id not in ('AD_PRES','AD_VP'); -- job_id�� AD_PRES or AD_VP�� �ƴ� ���ڵ�
--case---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--�ܼ��� case
select country_id, country_name,
    case region_id when 1 then '����'
                   when 2 then '�Ƹ޸�ī'
                   when 3 then '�ƽþ�'
                   when 4 then '�ߵ� �� ������ī'
    end as region_name
from countries;
--region_id�� ���ǿ� ���� �����Ͽ� ���ο� �÷��� �����Ͽ� ��ȸ

--�˻��� case
select employee_id, first_name, last_name, salary, job_id,
    case when salary between 1 and 5000 then '����'
         when salary between 5001 and 10000 then '�߰�'
         when salary between 10001 and 15000 then '����'
         else '�ֻ���'
    end salary_rank
from employees;
-- Ư�� �÷��� ���� ���ǿ� �°� �˻��Ͽ� ���ο� �÷��� �����Ͽ� ��ȸ

-- �ǻ��÷�---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--rownum
select first_name, last_name, rownum from employees;
select * from employees where rownum <=100;
/*
���� ���� �� ��ȸ�� �� �ο쿡 ���� rownum �ǻ��÷��� �� ������ ����Ű�� ���� ��ȯ
row1~row100�� ���� 1~100�� ���� ��ȣ �ο���
�ַ� where ������ ���� ����� ��ȯ�Ǵ� �ο� �� ������ �� ���
*/