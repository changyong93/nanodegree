select abs(-2),abs(3),abs(1.4) from dual;
select ceil(5.4), floor(5.4) from dual;
select exp(1), exp(ln(5)), ln(exp(1)), log(10,1000) from dual;
select mod(17,3), sign(-19), sign(0), sign(19) from dual;
select power(2,3), sqrt(4) from dual;
select round(3.545,2), round(3.545,1), trunc(3.545,1), trunc(3.545,2) from dual;
select concat('a','b'), 'a'||'b'||'c' from dual;
select initcap('aBc'), upper('aBc'), lower('aBc'), initcap('ko-changyong'), initcap('고changyong') from dual;
select * from employees where first_name = 'steven';
select * from employees where first_name = initcap('steven');
select * from employees where upper(first_name) = 'STEVEN';

select lpad('sql',5,'*'),rpad('sql',5,'*') from dual;
select employee_id, phone_number, lpad(phone_number, 20, ' ') phone_number2 from employees;
select ltrim('**sql**','*'), rtrim('**sql**','*') from dual;
select substr('abcdefg',-1) from dual;
select trim(' ab c d '), ascii('a'), length(' a b c'), length('abc'), lengthb('a b 강'), lengthb('a bb 강') from dual;
select replace('산은 산', '산', '물') from dual;
select replace(' A BC D ',' ', ''), trim(' A BC D ') from dual;
select instr('aalaaalllaaa','l',4,2) from dual;
select sysdate from dual;
select add_months(sysdate, -1) from dual;
select sysdate+30 from dual;
select last_day(sysdate) from dual;
select next_day(sysdate, '월') from dual;

select initcap('홍길동') from dual;
select upper('홍길동') from dual;
select lower('홍길동') from dual;

--3.1 과제---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--1
select initcap('홍길동') from dual;
select upper('홍길동') from dual;
select lower('홍길동') from dual;
--2
select substr('Is this thr real life? Is this just fanfasy?',-9) from dual;
select substr('Is this thr real life? Is this just fanfasy?',instr('Is this thr real life? Is this just fanfasy?','f',1,2)) from dual;
--3
select add_months(sysdate,1) from dual;
--4*********************
select employee_id, hire_date, round(months_between(sysdate, hire_date))||'개월' as 근속개월수 from employees where employee_id <=110;
--5
select phone_number, replace(phone_number,'.','-') as phone_number_new from employees;
--6
select location_id, street_address, substr(street_address, instr(street_address, ' ')+1) as street_address2 from locations where location_id <= 2400;
select instr(street_address, ' ')+1 as street_address2 from locations;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select to_number('12345.6789'), to_number(-12.0) from dual;
select to_number('123456.78912'), to_char('123456.78912', '999,999.9999'), to_char('123456.78912', '9,999.9999') from dual;
select to_char(sysdate) d1, to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS') d2 from dual;
select to_char(sysdate, 'dd') d1, to_char(sysdate, 'day') d2, to_char(sysdate, 'ddd') d3 from dual;
select sysdate D1,
       to_char(sysdate, 'W') D2,
       to_char(sysdate, 'WW') D3,
       to_char(to_date('2020-11-23', 'YYYY-MM-DD'), 'W') D4,
       to_char(to_date('2020-11-23', 'YYYY-MM-DD'), 'WW') D5 from dual;
select to_date('2020-11-22 15:20:18', 'YYYY-MM-DD HH24:MI:SS') from dual;
select to_date('2020-11-22', 'YYYY-MM-DD HH24:MI:SS') from dual;
select to_date('20201122', 'YYYY-MM-DD HH24:MI:SS') from dual;
select to_date('20201122', 'YYYYMMDD HH24:MI:SS') from dual;
select to_date('2020-11-22', 'YYYYMMDD HH24:MI:SS') from dual;

select nvl(null, 'a'), nvl(null, 1), nvl(2,3) from dual;
select nvl2(null, 'a', 'b'), nvl2('a', 'b','c') from dual;

select coalesce(null, null, null, 'a', null, 'b') from dual;
select coalesce(null, null, null, null) from dual;
select nullif(100,100), nullif(100,200), nullif(200,100) from dual;
select decode(1,2,3,4,5,1,7,9),
       decode(1,2,3,4,5,6,7,9),
       decode(1,2,3,4,5,6,7)
from dual;

--3.2 과제---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--1--
select to_char(last_day(to_date('2019-08-20', 'YYYY-MM-DD')),'day') from dual;
--2--
select employee_id, first_name, last_name, salary, commission_pct,
       case when commission_pct is null then salary
            else salary + (salary*commission_pct)
       end real_salary
from employees order by 6 desc;

select employee_id, first_name, last_name, salary, commission_pct,
nvl((salary + (salary*commission_pct)), salary) as real_salary from employees order by real_salary desc;
--3--
select employee_id, first_name, last_name, salary, commission_pct,
decode((salary + (salary*commission_pct)), null, salary, (salary + (salary*commission_pct))) as real_salary from employees order by real_salary desc;
--4--
create table day_cal( year number, day number);

declare
count_year number :=1;
begin
    while(count_year<2020)
    loop
        if ((mod(count_year,4)=0) and mod(count_year,100)!=100) or (mod(count_year,400)=0)
        then
            insert into day_cal(year, day) values(1, 366);
            count_year := count_year + 1;
        else
            insert into day_cal(year, day) values(2, 365);
            count_year := count_year + 1;
        end if;
    end loop;
end;

select sum(day)+to_number(to_char(sysdate, 'DDD')) as total_num_of_days from day_cal;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select * from departments;

create or replace function get_dept_name(p_dept_id number)
return varchar2
is
    v_return varchar2(80);
begin
    select department_name into v_return
    from departments where department_id = p_dept_id;
    
    return v_return;
end;

select get_dept_name(10) from dual;

create or replace function IsNumber(p_number varchar2)
  return number
is
  v_return number;
begin
   select to_number(p_number)
   into v_return
   from dual;
   
   return 0;
   exception when others then
   return 1;
end;

select IsNumber('123'), IsNumber('ab3') from dual;

select sum(day)+to_number(to_char(sysdate, 'DDD')) as total_num_of_days,
       round(1000000000000 / (sum(day)+to_number(to_char(sysdate, 'DDD')))) trillions from day_cal;
       
select to_number(to_char(sysdate, 'YYYY')) last_year,
       to_number(to_char(sysdate, 'DDD')) days,
       (to_number(to_char(sysdate, 'YYYY'))-1)*365+to_number(to_char(sysdate, 'DDD')) as days_all,
       round(1000000000000/((to_number(to_char(sysdate, 'YYYY'))-1)*365+to_number(to_char(sysdate, 'DDD')))) trillions
       from dual;
       