--�Լ�
---������
select abs(-7), abs(7), abs(0) from dual; --����
select ceil(7.6), floor(7.6) from dual; --�ø�,����
select exp(5), ln(exp(5)), log(10,1000) from dual; --�����Լ�, �ڿ��α� �Լ�, �α� �Լ�
select mod(17,3), sign(-17), sign(17), sign(0) from dual;--��, ���� ��ȣ
select power(2,3), sqrt(4) from dual; --����, ��Ʈ
select round(3.545,2), round(3.545,1),trunc(3.545,2),trunc(3.545,1) from dual; --Ư�� �Ҽ������� �ݿø�,����
select concat('a','b'), 'a'||'b'||'c' from dual; --���ڿ� ��ġ��
select initcap('aBc'), initcap('ko-changyong'), lower('ko-changyong'), upper('ko-changyong') from dual;--ù���� �빮��, �ҹ��ں�ȯ, �빮�ں�ȯ
select lpad('sql',5,'*'), rpad('sql',5,'*') from dual; -- ���ڰ��� ���� �� Ȥ�� �� �Է� ���� �߰��ϱ�
select ltrim('**sql**','*'), rtrim('**sql**','*') from dual; --Ư�� ���ڿ��� �� Ȥ�� �쿡�� ����
select substr('abcedf',1,2) from dual; --1�� ���� ��ġ���� 2�� ��������
select trim(' ab cd '), ascii('a'), length('a b c ��'), lengthb('a b c ��') from dual; --�¿� �����̽� ����, �ƽ�Ű�ڵ�� ��ȯ, ���ڰ���, ���ڹ���Ʈ
select replace('������','��','��') from dual; --���ڿ� ��ü

--��¥��
select sysdate from dual; --SQL ȯ���� ���� �ð� ��ȸ
select add_months(sysdate,1) from dual; --�� ����, + / - �� �� ����
select months_between(sysdate, '2020-09-01') from dual; --�� ��¥�� �� ���� ���
select last_day(sysdate), next_day(sysdate, '��') from dual; --�Է³�¥�� ���� ��¥ ��ȯ, �Է� ������ ���ƿ��� ��¥ ��ȯ
select round(sysdate, 'DD') from dual; --�ݿø� YYYY, MM, DD, HH24, MI, �̱���(=���� ����, default)
select trunc(sysdate, 'DD') from dual; --���� YYYY, MM, DD, HH24, MI, �̱���(=���� ����, default)

--Quiz
--3.1.1
select initcap('ȫ�浿'), upper('ȫ�浿'), lower('ȫ�浿') from dual;
----���ĺ��� �ƴ϶� ��ҹ��� ������ ��� ����

--3.1.2
select substr('Isthis the real life? Is this just fantasy?', instr('Isthis the real life? Is this just fantasy?', 'fantasy?')) from dual;

--3.1.3
select last_day(sysdate)+1,trunc(add_months(sysdate,1), 'MM'),round(sysdate, 'mm') from dual;

--3.1.4
select * from employees;
select employee_id, hire_date, round(months_between(sysdate, hire_date)) as �ټӿ���
from employees
where employee_id <=110;

--3.1.5
select * from employees;
select phone_number, lpad(replace(phone_number, '.', '-'), 20,' ') as phone_number2 from employees;

--3.1.6
select * from locations;
select street_address,
       substr(street_address,instr(street_address, ' ',1)+1) as street_address2
from locations
where location_id <=2400;

-----------------------------------------------------------------------------------------------------------
--����ȯ �Լ�
select to_number('12345.6779'), to_number('-12.0') from dual; --����-> ������ �� �������� ���ڷ� ��ȯ �Ұ�
select to_char(1234.5678,'999,999.9999'),to_char(1234.5678,'999.9999') from dual; --�ڸ����� �˳���
select to_char(sysdate, 'DDD') from dual; --��¥�� ���ڷ� ��ȯ YYYY,HH,DDD,DD,D,Day, HH24,HH,MI,SS,W,WW
select to_char(sysdate, 'DD') from dual; --��¥�� ���ڷ� ��ȯ
select to_char(sysdate, 'D') from dual; --��¥�� ���ڷ� ��ȯ
select to_char(sysdate, 'Day') from dual; --��¥�� ���ڷ� ��ȯ
select to_date('2020-10-31' ,'YYYY-MM-DD') from dual; --���ڸ� ��¥�� ��ȯ
select to_date('2020-10-31' ,'YYYYMMDD') from dual; --���ڸ� ��¥�� ��ȯ ��, ��¥�� ��ȯ�� ���ڿ��� ������ ���·� ��¥ format�� ����� ��
select nvl('a','b'),nvl(null,'b'), nvl2(null,'b','c'), nvl2('a','b','c') from dual; --nvl�� null�̸� �� ���ڸ�, �ƴϸ� �� ���� ��ȯ�̰�, nvl2�� null�̸� �ι�° ���� �ƴϸ� ������ ���� ��ȯ
select coalesce(null, null, null, 'a', null, 'b') from dual; --null�ƴ� ù��° �� ��ȯ
select nullif(100,100), nullif(100,1000) from dual; --�Է°� �� ���� ������ null �ƴϸ� �� �� ��ȯ
select decode(1,2,3,1,4,5) from dual;

--Quiz
--3.2.1
select to_char(last_day(to_date('2019-08-20','yyyy-mm-dd')),'day') from dual;

--3.2.2
select employee_id, first_name, last_name, salary, commission_pct,
       case when commission_pct is null then salary
            else salary + (salary * commission_pct)
       end real_salary
from employees;

select employee_id, first_name, last_name, salary, commission_pct,
       salary+(salary*nvl(commission_pct,0)) as real_salary
from employees;

--3.2.3
select employee_id, first_name, last_name, salary, commission_pct,
       salary+(salary*decode(commission_pct,null,0,commission_pct)) as real_salary
from employees;

--3.2.4
select  to_date('2020-10-31', 'YYYY-MM-DD')-to_date('0001-01-01','YYYY-MM-DD') from dual;

--------------------------------------------------------------------------------------------------------------
--��������

--groupby��

select to_char(hire_date,'YYYY') hire_year
from employees
group by to_char(hire_date,'YYYY')
order by 1;

--�����Լ�
select min(salary), max(salary), count(*)
from employees;

--groupby + �����Լ� = ��������
select to_char(hire_date,'YYYY') hire_year,
       count(*), min(salary), max(salary)
from employees
group by to_char(hire_date,'YYYY')
order by 1;

--2004�� ����, �޿� ��� 5õ�̻��� �Ի� �⵵�� �μ��� �� �ο����� �޿��Ѿ�, �޿� ���
select * from employees;
select to_char(hire_date,'YYYY') hire_year,
       department_id,
       round(avg(salary)), sum(salary)
from employees
where to_char(hire_date,'YYYY') >=2004
having avg(salary) >=5000
group by to_char(hire_date,'YYYY'), department_id
order by 1,2;

--quiz
--4.1.1
select * from locations;
select country_id,count(*)
from locations
group by country_id;

--4.1.2
select * from employees;
select to_char(hire_date, 'q'),
       count(*)
from employees
group by to_char(hire_date, 'q')
order by 1;

--4.1.3
select job_id, round(avg(salary),0) avg_salary,
       round(avg(salary)/count(*)) avg_salary1
from employees
group by job_id
order by 1;

--4.1.4
select * from covid19;
select to_char(dates, 'MM'), sum(new_cases)
from covid19
where iso_code = 'KOR'
group by to_char(dates, 'MM')
order by 1;

--4.1.5
select to_char(dates, 'YYYY-MM') MONTHS,
       sum(new_cases) Ȯ���ڼ�,
       sum(new_deaths) ����ڼ�,
       decode(sum(new_deaths), 0, 0, round(sum(new_deaths)/sum(new_cases)*100,2)) �����
from covid19
where iso_code = 'KOR'
group by to_char(dates, 'YYYY-MM')
order by 1;

select to_char(dates, 'YYYY-MM') MONTHS,
       sum(new_cases) Ȯ���ڼ�,
       sum(new_deaths) ����ڼ�,
       case when sum(new_deaths) = 0 then 0
            else round(sum(new_deaths)/sum(new_cases)*100,2)
       end �����
from covid19
where iso_code = 'KOR'
group by to_char(dates, 'YYYY-MM')
order by 1;

--4.1.6
select * from covid19;
select country, sum(new_cases) Ȯ����
from covid19
where 1=1
and to_char(dates, 'YYYY-MM') = '2020-10'
and country <> 'World'
having sum(new_cases) is not null
group by country
order by 2 desc;

---------------------------------------------------------------------------------------------------------------
--��������
select job_id
from employees
where 1=1
and salary between 2000 and 5000
--union --������(�ߺ� ����) ��, �ߺ� ���� ������ �߰��Ǿ� ������ �����ɸ�, �������� ������ ��ü
union all --������(�ߺ� ����)
--intersect --������
--minus  --������
select job_id
from employees
where 1=1
and salary between 5001 and 6000
order by job_id;

--4.2.1
--order by�� column ���� �˸��ƽ��� �ۼ��ϰų� �˸��ƽ� ����

--4.2.2
select * from employees;
select to_char(hire_date, 'YYYY') hire_year,
       employee_id, hire_date
from employees
where to_char(hire_date, 'YYYY') = '2001'
union
select to_char(hire_date, 'YYYY') hire_year,
       employee_id, hire_date
from employees
where to_char(hire_date, 'YYYY') = '2003'
order by 1,3;

--4.2.3
select * from employees;
select job_id, sum(salary)
from employees
group by job_id
union
select 'total', sum(salary)
from employees;

--4.2.4
select * from covid19;

select country
from covid19
where 1=1
and to_char(dates, 'YYYY') = '2020'
and to_char(dates, 'MM') < 7
having sum(new_cases)>=10000
group by country, to_char(dates, 'MM')
intersect
select country
from covid19
where 1=1
and to_char(dates, 'YYYY') = '2020'
and to_char(dates, 'MM') >= 7
having sum(new_cases) <=1000
group by country, to_char(dates, 'MM');

select country, sum(new_cases)
from covid19
where country in (select country
    from covid19
    where 1=1
    and to_char(dates, 'YYYY') = '2020'
    and to_char(dates, 'MM') < 7
    having sum(new_cases)>=10000
    group by to_char(dates, 'MM'), country
    intersect
    select country
    from covid19
    where 1=1
    and to_char(dates, 'YYYY') = '2020'
    and to_char(dates, 'MM') >= 7
    having sum(new_cases) <=1000
    group by to_char(dates, 'MM'), country)
group by country;


select country, sum(new_cases)
from covid19
where country in
    (select country
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
    group by to_char(dates, 'MM'), country)
group by country;