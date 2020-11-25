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
select distinct * from emp; -- �ߺ� ������ ����
select distinct * from employees where mod(employee_id, 2) = 0; --employee_id�� ¦�� ��ȣ�� ���
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

--like + in regexp_like(column��, '����1|����2|����3,...' , match parameter(�ɼ�)
select * from employees where regexp_like(job_id, 'PRES|AD', 'i'); 
/* match parameter
    i : ��ҹ��� �������� ��Ī
    c : ��ҹ��� �����Ͽ� ��Ī
    n : ���� ��('.')�� ���ϵ�ī�忡���� '�ϳ��� ���ڿ� ����'�̶� ���ε�, �̰� ��ħǥ�� ���ҷ� �ϰ� �ϰڴٴ�, �� ���� ���ڿ� ��ġ
        ���� ����Ʈ���� ���๮�ڰ� �ƴ϶� ���ϵ�ī�忡�� ������ �ǹ̷� ���
    m : ��Ƽ�ö��� ��� �Ķ����, '��� ���ڿ�(�÷���)'�� �� ���� �ƴ϶� ���� ���� ���� �� ����� �� �ִ� �ɼ�
        m�Ķ���͸� ������ ����Ŭ�� ��'^'�� ������ ���������� $�� �������� �����ϰ� ����
    x : whitespace ���ڰ� ����(���� ����Ʈ�� ���� ����)
        *whitepsace -> ����, �� ����, ĳ�������� �� �񽺹����� �͵� ��� ����
https://jhnyang.tistory.com/292 ������ ����*/

--���� �Լ�
count() ���� ��ȯ
max() �ִ� ��ȯ
min() �ּڰ� ��ȯ
sum() �հ� ��ȯ
avg() ��� ��ȯ
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

--select case �� �÷� ��ü ��ȸ(*)�� �ϰ� ���� ���
select p.*,
    case when salary between 1 and 5000 then '����'
         when salary between 5001 and 10000 then '�߰�'
         when salary between 10001 and 15000 then '����'
         else '�ֻ���'
    end salary_rank
from employees p;
--employees�� �˸��ƽ� p�� �����س��� p�� all�� �˻��ϸ� ��




-- �ǻ��÷�---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--rownum
select first_name, last_name, rownum from employees;
select * from employees where rownum <=20;
/*
���� ���� �� ��ȸ�� �� �ο쿡 ���� rownum �ǻ��÷��� �� ������ ����Ű�� ���� ��ȯ
row1~row100�� ���� 1~100�� ���� ��ȣ �ο���
�ַ� where ������ ���� ����� ��ȯ�Ǵ� �ο� �� ������ �� ���

��, �������� ������ ������ �����ϴ� �Լ��� �ϱ� �Լ��� ����
*/
select * from employees limit 20;


------------------------------------------------------------------------------------------------------------------------------------------------------------
--������
select abs(10) from dual; -- ���밪 ***************
select ceil(9.5) from dual; -- �ø�
select floor(9.5) from dual; -- ����
select exp(9.5) from dual; -- �����Լ�
select ln(9.5) from dual; -- �ڿ��α� �Լ�
select log(10, 1000) from dual; --�α� �Լ�

--������
select mod(100,3) from dual; --������ ***************
select power(2,3) from dual; --2^3��
select round(11.03,2) from dual; --�Ҽ�n �ڸ����� �ݿø� ***************
select sign(1) from dual; -- n>0 ->1 / n<0, ->-1, n = 0 ->0 qksghks
select sqrt(4) from dual; -- ������
select trunc(3.542,2) from dual; --�Ҽ� n�ڸ����� ���� ***************

--������
select concat('A','B') from dual; -- = 'A'||'B'�� ����, �� ���ڿ� �ΰ���
select initcap('SQL') from dual; --���ڿ� �� ù ���ĺ� �빮��, ������ �ҹ���
select lower('Sql') from dual; -- �ҹ���ȭ ***************
select upper('Sql') from dual; -- �빮��ȭ ***************
select lpad('Sql', 5, '*') from dual; -- (expr1, n ,expr2), n-expr1 �ڸ�����ŭ expr1�� ���ʿ� expr2�� ä�� ��ȯ
select rpad('Sql', 5, '*') from dual; -- (expr1, n ,expr2), n-expr1 �ڸ�����ŭ expr1�� �����ʿ� expr2�� ä�� ��ȯ
select ltrim('**sql**','*') from dual; -- (expr1,expr2) expr1�� ���ʿ��� expr2�� ������ ���·� ��ȯ
select rtrim('**sql**','*') from dual; -- (expr1,expr2) expr1�� �������� expr2�� ������ ���·� ��ȯ
select substr('abcde',3,2) from dual;-- (chr,n,p) chr�� n°���� p����ŭ ���, n�� �������� +1����, �������� -1
select trim(' abc def ') from dual;-- ���� ���� ������ ������ ���·� ���
select ascii('a') from dual;--�ƽ�Ű�ڵ�(ASCII)�� ���
select lengthb('abc') from dual; --������ ����Ʈ�� ���
select replace('abc', 'b', 'd') from dual; --(chr, search_str, rep_str) chr���� search_str�� ã�� rep_str�� ��ȯ
select instr('ababab','a',1,3) from dual; --(chr1, chr2, n1, n2) chr1���� chr2ã�µ�, ���ڿ��� n1��ġ���� n2��°�� chr2 ã��, n1������ 1, n2 ������ 1

--��¥��
select sysdate from dual; --����ð� ��¥ ��ȯ ��, ���� ȯ�漳������ �����ؾ� �ð��� ������, �̴� ȯ�漳������ �ٸ��Ƿ� �ش� ����� ���� ��Ÿ�� ��� �ٸ� �Լ� ����
select add_months(sysdate, 1) from dual; --(date,n) date�� n������ ���� ��¥�� ��ȯ
--**add_date�� �׳� sysdate + n�Ϸ� 
select months_between(sysdate+60, sysdate) from dual; -- date1�� date2 ���� ������ ��ȯ, date1 > date2�� ��� �ݴ�� ����
select last_day(sysdate) from dual; --date�� ���� ���� ������ ���� ��ȯ
select next_day(sysdate, '������') from dual;--(date, expr) date��¥ �������� expr�� ����� ��¥ ��ȯ
select round(sysdate, 'HH24') from dual; --YYYY,HH,HH24,MI,DD �� ���� �� ������ DD HH 12�ð� ���� HH24 24�ð� ����

--����ȯ
select to_number('213') from dual; -- ������ to ������
select to_char(12345, '99,999') from dual; -- �������� format�� �°� ���������� ����, �� ���� ���°� ���ں��� ���� ��
select to_char(12345, '9999,999') from dual; -- 9 ��� 1�� �����ϳ� ���� ũ�Ⱑ �� Ŀ���ϹǷ� 9�� �ϴ°� ����
select to_char(1234.5, '99,99.9') from dual; -- ������ ,(�ĸ�) / .(�Ҽ���)�� �̿� ����
select to_char(sysdate, 'YYYY-MM-DD- HH24:MI:SS') from dual; --��¥�� date�� date_format�� �°� ���������� ����
select to_char(sysdate, 'YYYY') from dual; -- ����ǥ�� : YYYY, YYYY, YY, YY
select to_char(sysdate, 'MONTH') from dual; -- �� ǥ�� : MONTH, MON
select to_char(sysdate, 'MM') from dual; -- �� ǥ��(1~12)
select to_char(sysdate, 'D') from dual; -- �������� ǥ��, 1(�Ͽ���)~7(�����)
select to_char(sysdate, 'DAY') from dual; -- �������� ���Ϸ� ǥ��(DAY)
select to_char(sysdate, 'DD') from dual; -- ���� ǥ��(01~31)
select to_char(sysdate, 'DDD') from dual; -- ���� ǥ��(001~365)
select to_char(sysdate, 'DL') from dual; -- ��,��,��,���� ǥ��
select to_char(sysdate, 'HH') from dual; -- �ð� ǥ�� HH(=HH12) 1~12�ð� / HH24 1~24 �ð�
select to_char(sysdate, 'MI') from dual; --�� ǥ��
select to_char(sysdate, 'SS') from dual; --�� ǥ��
select to_char(sysdate, 'WW') from dual; --�� ǥ��(1~53����)
select to_char(sysdate, 'W') from dual; -- �ش� ���� ���������� ǥ��(1~5(?))
select to_date('2020-06-05 23:52:01','YYYY-MM-DD HH24:MI:SS') from dual; --������ char�� date_format�� �°� ��¥������ ����

--Null ó�� �Լ�
select NVL(Null, 'A') from dual; -- (expr1, expr2) expr1�� Null�̸� expr2 ���
select NVL2(Null, 'A', 'B') from dual; -- (expr1, expr2, expr3) expr1�� Null�̸� expr3, �ƴϸ� expr2
select coalesce(null, null, 'b', null) from dual; --(expr1,expr2,...,exprn) expr1->exprn ������� �����ϸ� null�� �ƴ� �� ���
select nullif('a','b') from dual; --(expr1, expr2) expr1�� expr2�� ������ null, �ƴϸ� expr1

--��Ÿ �Լ�
select decode('a2', 'a1', 1, 'a2', 2, 3) from dual;--(expr, val1, result1,....,valn, resultn, default_value)
                                                   --expr�� val1���� valn���� ������� ��Ī�Ͽ� ������ ���� result_k�� ��ȯ, �ϳ��� ������ default_value ���
