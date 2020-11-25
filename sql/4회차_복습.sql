--group by��
--group by�� ���� �Լ��� �ܵ����� ����� �����ϳ�, �Ϲ������� �� �� ����ؼ� �⺻�� ������ �м�
/* ����
select expr1, expr1,
from...
where...
having ...
group by...
order by...*/

--�����Լ�-- count, max, min, sum, avg
select * from employees;
select count(*) from employees; --row�� ��ȯ
select max(salary) from employees; --�ִ� �޿� ��ȯ
select min(salary) from employees; --�ּ� �޿� ��ȯ
select sum(salary) from employees; --�޿� �Ѿ� ��ȯ
select avg(salary) from employees; --�޿� ��� ��ȯ

--group by��-- select�� group by�� ��Ī�� �����ϰ� ������ �̸��� ���·� ��ȸ �׸��� ���ԵǾ� �־�� ��
select to_char(hire_date, 'YYYY') hire_year
from employees
group by to_char(hire_date, 'YYYY')
order by 1;

--������ �ִ� �޿�, �ּ� �޿� ��ȸ�ϱ�--
select job_id, count(*), max(salary), min(salary)
from employees
group by job_id
order by job_id;

--�Ի� �⵵ �� �μ��� ��� �޿�, �޿� �Ѿ� ��ȸ�ϱ�--
select to_char(hire_date, 'YYYY') hire_year,
       department_id, round(avg(salary)), sum(salary)
from employees
where 1=1
and to_char(hire_date, 'YYYY') >='2004'
group by to_char(hire_date, 'YYYY'), department_id
order by to_char(hire_date, 'YYYY');

--�޿� ����� 5000 �̻�, 2004�� ���� �Ի� �⵵ �� �μ��� ��� �޿�, �޿� �Ѿ� ��ȸ�ϱ�--
select to_char(hire_date, 'YYYY') hire_year,
       department_id, round(avg(salary)), sum(salary)
from employees
where 1=1
and to_char(hire_date, 'YYYY') >=2004
having avg(salary)>=5000
group by to_char(hire_date, 'YYYY'), department_id
order by to_char(hire_date, 'YYYY');

--having���� �̿��Ͽ� ������� 2�̻��� �μ� �� �Ի�⵵�� ��� �޿�, �޿��Ѿ� ���ϱ�
select to_char(hire_date, 'YYYY') hire_year, department_id,
       count(*), round(avg(salary)), sum(salary)
from employees
where 1=1
having count(*) > 1
group by to_char(hire_date, 'YYYY'), department_id
order by to_char(hire_date, 'YYYY');

--distinct���� �̿��Ͽ� �ߺ� ������ ����
select job_id
from employees
group by job_id;

select distinct job_id
from employees;

select distinct to_char(hire_date, 'YYYY') hire_year, department_id
from employees
order by 1,2;

select substr(phone_number,1,3) ,job_id, sum(salary)
from employees
group by substr(phone_number,1,3), job_id
order by 1,2;

--rollup--
select substr(phone_number,1,3) ,job_id, sum(salary)
from employees
group by rollup(substr(phone_number,1,3), job_id)
order by 1,2;

select substr(phone_number,1,3) ,job_id, sum(salary)
from employees
group by cube(substr(phone_number,1,3), job_id)
order by 1,2;

-------------
/*4.1.1 locations ���̺��� �� ���迡 �ִ� ���� �繫�� �ּ� ������ ���� �ֽ��ϴ�.
�� �������� ���� �繫�Ұ� �� ���� �Ǵ��� ã�� ���� �ۼ� */
select * From locations;
select count(*), country_id
from locations
group by country_id;

/*4.1.2 employees ���̺��� �⵵�� ��� ���� �б⺰�� �� ���� ����� �Ի��ߴ��� ���ϴ� ������ �ۼ� */
select * from employees;
select to_char(hire_date, 'q'), count(*)
from employees
group by to_char(hire_date, 'q')
order by to_char(hire_date, 'q');

/*4.1.3 ���� ������ employees ���̺��� job_id���� ��� �޿��� ���� ���ε�, ���⼭ �����
���� ����ϴ� avg_salary1 �̶� ���� �÷��� �߰�(��� = �� �ݾ�/�����*/
select job_id, round(avg(salary),0) avg_salary,
       sum(salary)/count(*) avg_salary1
from employees
group by job_id
order by 1;

/*4.1.4 COVID19 ���̺��� �ѱ�(ISO_CODE ���� KOR)�� ���� �ڷγ� Ȯ���� ���� ��ȸ�ϴ� ���� �ۼ�*/
select * From covid19;

select to_char(dates, 'YYYY-MM'), sum(new_cases)
from covid19
where iso_code='KOR'
group by to_char(dates, 'YYYY-MM')
order by to_char(dates, 'YYYY-MM');

/*4.1.5 COVID19 ���̺��� �ѱ� �����Ϳ� ���� ���� ����� �������� ���� �ۼ� */
select * From covid19;

select to_char(dates, 'YYYY-MM') MONTHS,
       sum(new_cases) Ȯ���ڼ�,
       sum(new_deaths) ����ڼ�,
       decode(sum(new_cases), 0 , 0, round(sum(new_deaths)/sum(new_cases)*100,2)) �����
from covid19
where 1=1
and iso_code='KOR'
group by to_char(dates, 'YYYY-MM')
order by 1;

/*4.1.6 COVID19 ���̺��� 2020�� 10���� ���� ���� Ȯ���ڰ� ���� ������ 5�� ������ � �����ϱ�� */
select * from covid19;

select country, nvl(sum(new_cases),0)
from covid19
where 1=1
and country <>'World'
and to_char(dates,'YYYY-MM') ='2020-10'
group by country
order by 2 desc;

select country , nvl(sum(new_cases),0)
from covid19
where 1=1
and dates between to_date('20201001', 'YYYYMMDD')
              and to_date('20201031', 'YYYYMMDD')
and country != 'World'
group by country
order by 2 desc;

------------------------------------------------------------------------------------------
--union

select job_id
from employees
where 1=1
and salary between 2000 and 5000
minus
select job_id
from employees
where 1=1
and salary between 5001 and 6000
order by 1;

select job_id, salary
from employees
where 1=1
and salary between 2000 and 5000
union
select job_id, salary
from employees
where 1=1
and salary between 5001 and 6000
order by 1;

/*4.2.1 ���� ������ �����ϸ� ������ �߻��ϴµ� �� ������?*/
-- ù select ���� job_id�� alias�� jobs�� �����Ƿ� order by�� job_id�� �ƴ� job�� �ؾ� ��
select job_id jobs
from employees
where department_id = 60
union
select job_id
from employees
where department_id = 90
order by job_id;

/*4.2.2 ���� �����ڸ� ����� employees ���̺��� 2001�� 2003�⿡ �Ի��� ����� �����ȣ�� �Ի����ڸ� ��ȸ�ϴ� ���� �ۼ�*/
select * from employees;

select employee_id, hire_date
from employees
where to_char(hire_date,'YYYY') = '2001'
union all
select employee_id, hire_date
from employees
where to_char(hire_date,'YYYY') = '2003';
order by 2;

/*4.2.3 employees ���̺��� job_id ���� �޿�(salary)�� �հ踦 ���ϰ�, �������� ��ü �޿� �հ踦 ���ϴ�
������ union �����ڸ� ����� �ۼ�*/
select * from employees;

select job_id, sum(salary)
from employees
group by job_id
union
select '�հ�', sum(salary)
from employees
order by 1;

/*4.2.4 covid19 ���̺��� 2020�� ���ݱ�(1��~6��)���� ���� Ȯ���ڰ� 10000�� �̻��̾��µ�,
�Ĺݱ�(7��~10��) ���� ���� Ȯ���ڰ� 1000�� ���Ϸ� ������ ���� �ִ� ������ ���ϴ� ������ �ۼ�(hint : intersect)*/
select * from covid19;
select to_char(dates, 'YYYY-Q') from covid19;

select country
from covid19
where 1=1
and to_char(dates, 'YYYY') = '2020'
and to_char(dates, 'MM') < 7
having sum(new_cases) >=10000
group by to_char(dates, 'MM'), country
intersect
select country
from covid19
where 1=1
and to_char(dates, 'YYYY') = '2020'
and to_char(dates, 'MM') >= 7
having sum(new_cases) <=1000
group by to_char(dates, 'MM'), country
order by 1;

select country
from covid19
where 1=1
and dates between to_Date('20200101','YYYYMMDD') and
                  to_date('20200630','YYYYMMDD')
group by to_char(dates,'YYYY-MM'), country
having nvl(sum(new_cases),0)>=10000
intersect
select country
from covid19
where 1=1
and dates between to_Date('20200701','YYYYMMDD') and
                  to_date('20201231','YYYYMMDD')
group by to_char(dates,'YYYY-MM'), country
having nvl(sum(new_cases),0)<=1000;

--���ʽ� ���� : Department_name ���� num_data �÷����� ���ϴ� ���� �ƴ϶� ���� ����� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
create table GROUPBYMULTIPLY (
department_name VARCHAR2(100),
num_data NUMBER
);

insert into groupbymultiply values ('dept1', 10);
insert into groupbymultiply values ('dept1', 20);
insert into groupbymultiply values ('dept1', 30);
insert into groupbymultiply values ('dept2', 5);
insert into groupbymultiply values ('dept2', 7);
insert into groupbymultiply values ('dept2', 40);
insert into groupbymultiply values ('dept3', 69);
insert into groupbymultiply values ('dept3', 71);
insert into groupbymultiply values ('dept3', 12);
commit;

SELECT *
FROM groupbymultiply;

SELECT department_name,
SUM(num_data), 
FROM groupbymultiply
GROUP BY department_name
ORDER BY 1 ;

select department_name, round(exp(sum(ln(num_data))))
from groupbymultiply
GROUP BY department_name
order by 1;