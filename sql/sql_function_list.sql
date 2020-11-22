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

--SQL 종류-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DDL
create table 테이블명; --객체 생성
drop table 테이블명; --객체 삭제
alter table 테이블명; --객체 수정
truncate table 테이블명; --객체 데이터 전체 삭제
rename table 테이블명 to 테이블명; -- 객체 이름 변경
--DML
select * from 테이블명 --테이블 조회
insert into 테이블(컬럼명1, 컬럼명2, ,,,) values(데이터1, 데이터2,...) --데이터 입력/저장
update emp set salary =5000 from where salary in null; --기존 데이터 수정
delete from emp where salary <=10000; --데이터 삭제
--TCL
commit; --커밋
rollback; -- 롤백
--DCL
grant DBA to orauser; --권한/롤 할당
revoke DBA from orauser; 권할/롤 회수
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*데이터 확인*/
desc emp -- 테이블 구조 확인
select * from emp; -- 테이블 모든 레코드(행, row) 확인

/*데이터 조건별 검색*/
select * from emp where salary > 5000 order by salary desc; -- salary 5000이상으로 내림차순으로 정리, 
                                                            --여러개일 경우 salary desc, first_name; 혹은 2 desc ,3, phone_number desc ;도 가능(번호는 좌측부터 컬럼 순서대로)
select * from employees order by salary desc; -- asc(오름차순)default, 생략 가능 / desc내림차순

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*modify*/
alter table emp modify col1 number not null; --컬럼 정보 수정

--연산자-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--기본연산자
select 10 + 4 as plus from dual;
select 10 - 4 as minus_ from dual;
select 10 * 4 as multifly from dual;
select 10 / 4 as devide from dual;
select -10 as minus_number from dual;
select +10 as plus_number from dual;
select 10 || 4 as "문자결합" from dual;

--비교 연산자
select * from employees where salary = 24000; -- salary가 24000인 레코드
select * from employees where not(salary = 24000); -- salary가 24000이 아닌 레코드
select * from employees where salary != 24000; -- salary가 24000이 아닌 레코드
select * from employees where salary <> 24000; -- salary가 24000이 아닌 레코드
select * from employees where salary > 24000;-- salary가 24000 초과인 레코드
select * from employees where salary >= 24000;-- salary가 24000 이상인 레코드
select * from employees where salary < 24000;-- salary가 24000 미만인 레코드
select * from employees where salary <= 24000;-- salary가 24000 이하인 레코드
select * from employees where salary between 2000 and 24000;-- salary가 2000이상 24000이하 사이인 레코드
select * from employees where salary not between 2000 and 24000;-- salary가 2000이상 24000이하가 아닌 레코드
select * from employees where salary < 24000 and salary > 2000;-- salary가 24000초과 & 2000미만인 레코드
select * from employees where salary = 24000 or salary < 2000;-- salary가 24000이거나 2000미만인 레코드

--기타연산자
select * from employees where commission_pct is null;-- commission_pct가 비어있는 레코드
select * from employees where commission_pct is not null;-- commission_pct가 비어있는 않은 레코드
select * from employees where job_id like 'SA%'; -- job_id에 SA문자가 포함된 레코드
select * from employees where job_id not like 'SA%'; -- job_id에 SA문자가 포함되어 있지 않는 레코드
select * from employees where job_id in ('AD_PRES','AD_VP'); -- job_id에 AD_PRES or AD_VP인 레코드(2개이상은 ,로 여러개 가능)
select * from employees where job_id not in ('AD_PRES','AD_VP'); -- job_id에 AD_PRES or AD_VP가 아닌 레코드
--case---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--단순형 case
select country_id, country_name,
    case region_id when 1 then '유럽'
                   when 2 then '아메리카'
                   when 3 then '아시아'
                   when 4 then '중동 및 아프리카'
    end as region_name
from countries;
--region_id를 조건에 따라 구분하여 새로운 컬럼에 저장하여 조회

--검색형 case
select employee_id, first_name, last_name, salary, job_id,
    case when salary between 1 and 5000 then '낮음'
         when salary between 5001 and 10000 then '중간'
         when salary between 10001 and 15000 then '높음'
         else '최상위'
    end salary_rank
from employees;
-- 특정 컬럼의 값을 조건에 맞게 검색하여 새로운 컬럼에 저장하여 조회

-- 의사컬럼---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--rownum
select first_name, last_name, rownum from employees;
select * from employees where rownum <=100;
/*
쿼리 수행 후 조회된 각 로우에 대해 rownum 의사컬럼은 그 순서를 가리키는 수를 반환
row1~row100이 각각 1~100과 같이 번호 부여됨
주로 where 절에서 쿼리 결과로 반환되는 로우 수 제어할 떄 사용
*/