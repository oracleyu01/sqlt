
▣ 튜닝예제10. 인덱스를 엑세스 하지 못하는 검색조건을 알아야해요

* 문제상황:  

 인덱스는 특정 조건을 만족할 때만 효과적으로 활용됩니다.
 다음과 같은 검색 조건이 포함된 WHERE 절에서는 인덱스를 
 사용할 수 없으며,이는 FULL TABLE SCAN 을 유발하여 성능저하 
 이어집니다.

* 인덱스를 액세스 하지 못하는 조건:

 1. is null 또는 is not null 
 2. like 조건에서 와일드 카드(%) 를 앞에 둘때 
 3. 부정 연산자 사용시 ( !=, <>, ^= )
 4. 인덱스 컬럼을 가공했을때 

#실습1.  ( is null 또는 is not null 튜닝)  커미션이 null 인 사원들의 이름과 커미션
          을 출력하시오 !

@demo
create  index  emp_comm  on  emp(comm);

select  ename, comm
  from  emp
  where  comm  is  null;

select * from  table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

# 실습2.  위의 SQL을 튜닝하시오 !

튜닝후:   

create  index  emp_comm_func  
  on   emp( nvl( comm, -1)  );

 select  ename,  comm
   from  emp
   where  nvl(comm, -1) = -1; 

#문제1. mgr 이 null 인 사원의 이름과 mgr 을 출력하는데  인덱스를 통해서
          엑세스 될 수 있도록 필요한 인덱스를 생성하고 SQL을 작성하시오 !

튜닝후:  create  index  emp_mgr_indx1
             on  emp( nvl(mgr, -1) );

           select   ename, mgr
               from  emp
               where   nvl(mgr, -1) = -1;

#실습3.  ( is null 또는 is not null 튜닝)   아래의 SQL을 튜닝하시오 !

튜닝전 :  select  ename, comm
                from  emp
                where  comm  is  not  null;

튜닝후:   nvl2 함수를 이용해서 다음의 SQL을 먼저 작성해봅니다.

 select  ename, comm, nvl2(comm, 1, null) 
  from   emp;

문법: nvl2(comm, 커미션이 null 아닐때 나올값 ,커미션이 null 일때 나올값) 

create  index  emp_comm_fun2  on   emp( nvl2( comm, 1, null ) );

select  /*+  index(emp  emp_comm_fun2 */  ename, comm
  from  emp
  where  nvl2( comm, 1, null) = 1;

select * from  table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

#문제1.  아래의 SQL을 튜닝하시오 !

튜닝전:  select  ename, mgr
               from  emp
               where   mgr  is  not  null;

튜닝후:  create  index  emp_mgr_notnull  on  emp(nvl2(mgr, 1, null) );

            select  /*+ index( emp emp_mgr_notnull) */   ename, mgr
               from  emp
              where   nvl2( mgr, 1, null ) = 1; 

#실습4.  ( is null 또는 is not null 튜닝)  comm 에 대한 flag 컬럼을 생성합니다.

alter   table  emp
  add   comm_flag  number(10);

update  emp  
   set comm_flag= 1
   where  comm is  not null;

update  emp
  set comm_flag = 0
  where  comm is  null;

create  index emp_comm_flag  on  emp(comm_flag);

select  ename, comm
  from  emp
   where  comm_flag= 1; 

오늘의 마지막 문제.  다음의 환경을 만들고 아래의 SQL을 튜닝하시오 !
major2 가 null 인 학생들의 이름과 전공과 major2 를
조회하거나 major2 가 null 이 아닌 학생들의 이름과 전공과
major2 를 조회하는 2개의 SQL을 튜닝된 SQL로 작성하시오

alter  table   emp20
  add   major2    varchar2(20);

update  emp20
  set  major2 = '전공'
  where  major  in ( '통계데이터과학','통계학');

commit;

2. like 조건에서 와일드 카드(%) 를 앞에 둘때

#실습1. 이름의 첫글자가 S 로 시작하는 사원의 이름과 월급을 출력하시오

@demo
create  index  emp_ename  on  emp(ename);

select  ename, sal
 from  emp
 where  ename  like  'S%';

select * from  table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

-----------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-----------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |           |      1 |        |      2 |00:00:00.01 |       2 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| EMP       |      1 |      2 |      2 |00:00:00.01 |       2 |
|*  2 |   INDEX RANGE SCAN                  | EMP_ENAME |      1 |      2 |      2 |00:00:00.01 |       1 |
-----------------------------------------------------------------------------------------------------------

와일드 카드가 뒤쪽에 있어서 인덱스 스캔을 하고 있습니다.

#실습2. 이름의 끝글자가 T로 끝나는 사원들의 이름과 월급을 출력하시오

select  ename, sal 
 from  emp
 where  ename  like  '%T';

 ------------------------------------------------------------------------------------
| Id  | Operation         | Name | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |      1 |        |      1 |00:00:00.01 |       7 |
|*  1 |  TABLE ACCESS FULL| EMP  |      1 |      1 |      1 |00:00:00.01 |       7 |
------------------------------------------------------------------------------------

와일드 카드가 앞에 있으면 full table scan 을 하게 됩니다.

#실습3.
이름의 끝글자가 T 로 끝나는 사원들의 이름과 월급을 출력하는데
like 연산자 사용하지 말고 substr 과 = 을 사용해서 출력하시오

select  ename, sal  
   from  emp
   where substr(ename,-1,1) = 'T';

------------------------------------------------------------------------------------
| Id  | Operation         | Name | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |      1 |        |      1 |00:00:00.01 |       7 |
|*  1 |  TABLE ACCESS FULL| EMP  |      1 |      1 |      1 |00:00:00.01 |       7 |
------------------------------------------------------------------------------------

#실습4. 아래의 SQL의 검색 속도를 높이기 위해서 함수 기반 인덱스를 생성하시오 !

select  ename, sal  
   from  emp
   where substr(ename,-1,1) = 'T';

답:
create  index  emp_ename_substr
 on  emp( substr(ename,-1,1)) ;

select  ename, sal  
 from  emp
 where substr(ename,-1,1) = 'T';

------------------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name             | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                  |      1 |        |      1 |00:00:00.01 |       2 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| EMP              |      1 |      1 |      1 |00:00:00.01 |       2 |
|*  2 |   INDEX RANGE SCAN                  | EMP_ENAME_SUBSTR |      1 |      1 |      1 |00:00:00.01 |       1 |
------------------------------------------------------------------------------------------------------------------

문제1. 
직업의 끝글자가 MAN 으로 끝나는 사원들의 이름과 직업을 출력하는데
적절한 인덱스도 생성해서 튜닝된 SQL로 작성하시오 !

create  index  emp_job_substr
 on  emp(substr(job,-3,3));

select  ename, job
  from  emp
  where  substr(job,-3,3)='MAN';

  ----------------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name           | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
----------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                |      1 |        |      4 |00:00:00.01 |       2 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| EMP            |      1 |      4 |      4 |00:00:00.01 |       2 |
|*  2 |   INDEX RANGE SCAN                  | EMP_JOB_SUBSTR |      1 |      4 |      4 |00:00:00.01 |       1 |
----------------------------------------------------------------------------------------------------------------


* 인덱스를 사용하지 못하는 검색조건

 1. is null 과 is not null
 2. like 검색시 와일드카드가 앞에 나오는 경우
 3. !=, <>, ^=  같지 않다를 검색하는 경우
 4. 인덱스 컬럼을 가공했을때 

 ■ 3. !=, <>, ^=  같지 않다를 검색하는 경우

 #실습1. 
 직업에 인덱스를 생성하고 직업이 SALESMAN 이 아닌 사원들의
 이름과 직업을 출력하시오 !

 @demo
 create index  emp_job  on  emp(job);

 select  ename, job 
   from  emp
   where  job != 'SALESMAN';

   ------------------------------------------------------------------------------------
| Id  | Operation         | Name | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |      1 |        |     10 |00:00:00.01 |       7 |
|*  1 |  TABLE ACCESS FULL| EMP  |      1 |     10 |     10 |00:00:00.01 |       7 |
------------------------------------------------------------------------------------

#실습2. 아래의 SQL을 튜닝하시오 !

select  ename, job 
 from  emp
 where  job != 'SALESMAN';

튜닝후:
select  ename, job 
  from  emp
  where  job  in ('CLEKR','MANAGER','ANALYST','PRESIDENT');

----------------------------------------------------------------------------------------------------------
| Id  | Operation                            | Name    | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
----------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                     |         |      1 |        |      6 |00:00:00.01 |       3 |
|   1 |  INLIST ITERATOR                     |         |      1 |        |      6 |00:00:00.01 |       3 |
|   2 |   TABLE ACCESS BY INDEX ROWID BATCHED| EMP     |      4 |      6 |      6 |00:00:00.01 |       3 |
|*  3 |    INDEX RANGE SCAN                  | EMP_JOB |      4 |      1 |      6 |00:00:00.01 |       2 |
----------------------------------------------------------------------------------------------------------  

# 실습3. 다른 방법으로도 튜닝하세요 !

select  ename, job 
 from  emp
 where  job != 'SALESMAN';

튜닝후:

create  index  emp_job_case
 on emp(case  when job !='SALESMAN' then job  end);

select  ename, job
  from  emp
  where  case  when job !='SALESMAN' then job  end >'  ';

  --------------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name         | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
--------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |              |      1 |        |     10 |00:00:00.01 |       2 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| EMP          |      1 |     10 |     10 |00:00:00.01 |       2 |
|*  2 |   INDEX RANGE SCAN                  | EMP_JOB_CASE |      1 |     10 |     10 |00:00:00.01 |       1 |
--------------------------------------------------------------------------------------------------------------
 

▣ 튜닝예제11. full table scan 을 할 수 밖에 없다면 full table scan 이 빠르게 되도록 튜닝하세요

※ full table scan 을 할 수 밖에 없는 경우 

1. where 절이 아예 없거나 인덱스가 없는 컬럼의 데이터를 검색할때
2. 인덱스를 생성할 때
3. 검색조건이 !=, ^=, <> 로 검색했을때 
4. 테이블 통계정보를 수집할 때

■ 1. where 절이 아예 없거나 인덱스가 없는 컬럼의 데이터를 검색할때

튜닝방법:  병렬 처리(parallel query)

쿼리에 병렬처리를 하게 되면 여러 프로세서들이 동시에 데이터를 
읽을수 있도록 합니다. 

예제:  select /*+ parallel(테이블명, 4) */  *
         from  테이블명; 
    
여기서 4는 병렬 처리의 프로세서수를 의미합니다. 

병렬도를 우리 시스템에서 몇개까지 줄 수 있는지 확인하는 방법

select  *
 from v$parameter
 where  name  like '%cpu%';
 
 cpu_count   20  

#실습1. 
emp 테이블을을 full table scan 하는데 병렬로 full table scan
이 되게 하시오 !
   
select  /*+ parallel(emp, 4)  */  *
  from  emp;

저희가 지금 사용하는 오라클 프로그램이 enterprise edition 이
아니어서 병렬 프로세싱을 못합니다. 

문제1. 직업이 SALSMAN 이 아닌 사원들의 이름과 월급과 직업을 
      출력하는데 병렬로 FULL SCAN 할 수 있도록 힌트를 주시오 !

select  /*+  parallel(emp, 4) */ ename, sal, job
 from  emp
 where  job <> 'SALESMAN';
 
 ※ full table scan을 할 수 밖에 없는 경우 

 1.  where 절이 아예 없거나 인덱스가 없는 컬럼의 데이터를 검색할 때 
 2.  인덱스를 생성할 때 
 3.  검색조건이 !=, ^=, <> 로 검색했을 때 
 4.  테이블의 통계정보를 수집할 때 

■ 2.  인덱스를 생성할 때 

#실습1. 사원 테이블에 월급에 인덱스를 생성하시오 !

create index emp_sal on emp(sal);

#실습2. 인덱스 생성을 빠르게 하기 위해 병렬로 인덱스 생성을 하시오

create index emp_deptno on emp(deptno) parallel  4; 

주의사항 !  인덱스를 생성할 때만 parallel 을 사용하고 이후에
           다시 인덱스의 병렬도를 1로 변경해야합니다. 

select  index_name, degree
 from user_indexes
 where  table_name='EMP';
 
EMP_JOB	        1
EMP_JOB_CASE	1
EMP_DEPTNO	    4

alter  index   emp_deptno   parallel   1; 

select  index_name, degree
 from user_indexes
 where  table_name='EMP';

EMP_JOB	        1
EMP_JOB_CASE	1
EMP_DEPTNO	    1

문제1. 사원 테이블에 입사일에 인덱스를 생성하는데 병렬도를 6을 주고
생성하시오 ! 생성한 이후에 다시 병렬도를 1로 변경하시오 !

create  index  emp_hiredate on  emp(hiredate) parallel 6;

alter  index  emp_hiredate  parallel  1; 

select  index_name, degree
 from user_indexes
 where  table_name='EMP';

 
 ※ full table scan을 할 수 밖에 없는 경우 

 1.  where 절이 아예 없거나 인덱스가 없는 컬럼의 데이터를 검색할 때 
 2.  인덱스를 생성할 때 
 3.  검색조건이 !=, ^=, <> 로 검색했을 때 
 4.  테이블의 통계정보를 수집할 때 

■ 3.  검색조건이 !=, ^=, <> 로 검색했을 때

#실습1. 직업이 SALESMAN 이 아닌 사원들의 이름과 직업을 출력하시오!

@demo
create  index  emp_job  on  emp(job);

select  ename, job 
 from  emp
 where  job  != 'SALESMAN';

 #실습2. 위의 SQL로 검색되는 데이터를 볼 수 있도록 튜닝하시오! 

@demo

alter table  emp
add  job_condition  generated  always as 
(case when job !='SALESMAN' then 1 else 0 end); 

select  * from emp; 

create  index  emp_job_condition
 on  emp(job_condition);

select  ename, job  
 from  emp
 where  job_condition = 1;

 -------------------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                   |      1 |        |     10 |00:00:00.01 |       2 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| EMP               |      1 |     10 |     10 |00:00:00.01 |       2 |
|*  2 |   INDEX RANGE SCAN                  | EMP_JOB_CONDITION |      1 |     10 |     10 |00:00:00.01 |       1 |
-------------------------------------------------------------------------------------------------------------------

문제1. 아래의 SQL을 튜닝하시오 !

select  *
  from  insurance
  where  region !='northeast';

alter table insurance
add  region_condition  generated  always as 
(case when region !='northeast' then 1 else 0 end); 

create  index  insurance_indx1
 on insurance(region_condition);

select  *
 from insurance
 where region_condition = 1;

 --------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name            | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
--------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                 |      1 |        |     50 |00:00:00.01 |       3 |      4 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| INSURANCE       |      1 |     13 |     50 |00:00:00.01 |       3 |      4 |
|*  2 |   INDEX RANGE SCAN                  | INSURANCE_INDX1 |      1 |      5 |     50 |00:00:00.01 |       2 |      4 |
--------------------------------------------------------------------------------------------------------------------------

 ※ full table scan을 할 수 밖에 없는 경우 

 1.  where 절이 아예 없거나 인덱스가 없는 컬럼의 데이터를 검색할 때 
 2.  인덱스를 생성할 때 
 3.  검색조건이 !=, ^=, <> 로 검색했을 때 
 4.  테이블의 통계정보를 수집할 때 

■ 4.테이블의 통계정보를 수집할 때 

옵티마이져가 최적의 실행계획을 생성하도록 하려면 테이블의 
최신 통계정보를 유지하는것이 중요합니다. 
테이블 통계는 쿼리 성능에 직접적인 영향을 미칩니다. 

예제. emp 테이블의 테이블 통계정보 수집 방법

analyze table  emp  compute  statistics; 

select  table_name, num_rows, last_analyzed
  from  user_tables;

통계정보를 수집할 때는 FULL TABLE SCAN 을 할 수 밖에 없습니다.
그래서 병렬로 테이블 통계정보를 수집하면 됩니다. 

Begin
  dbms_stats.gather_table_stats(
         ownname=>'C##SCOTT',  -- 테이블 소유자
         tabname=> 'EMP',      -- 통계정보 수집 대상 테이블블
         cascade=> TRUE,   -- 테이블의 인덱스까지 통계정보 수집
         degree => 4      -- 병렬도 
  );
end;
/

문제1. dept 테이블의 통계정보를 수집하는데 병렬도를 4를 주고 수집
하시오. 테이블 통계정보가 잘 수집되었는지도 확인하시오 !

Begin
  dbms_stats.gather_table_stats(
         ownname=>'C##SCOTT',  -- 테이블 소유자
         tabname=> 'DEPT',      -- 통계정보 수집 대상 테이블블
         cascade=> TRUE,   -- 테이블의 인덱스까지 통계정보 수집
         degree => 4      -- 병렬도 
  );
end;
/

select  table_name, num_rows, last_analyzed
  from  user_tables
  where table_name='DEPT';

점심시간 문제. 우리반 테이블에서 주소가 '읍' 으로 끝나는 학생들의
이름과 주소를 출력하는 쿼리문을 작성하는데 인덱스를 엑세스 할 수 
있도록 적절한 인덱스도 생성하고 적절한 SQL도 작성하시오 !
실행계획을 보여주시고 검사 받고 식사하러 가시면 됩니다. 

▣ 튜닝예제12. 인덱스를 탈 수 있도록 힌트를 사용하세요.

index 힌트를 이용해서 특정 인덱스를 옵티마이져가 사용하도록 요청을
할 수 있습니다. 

※ 인덱스 힌트를 사용해야하는 경우

1. 인덱스가 있음에도 불구하고 full table scan 을 하는 경우
2. where 절에 검색조건이 여러개가 and 로 연결되어 있을때 
   그중에 하나의 컬럼 인덱스를 선택하고 싶을때 

■ 실습예제1. 다음과 같이 2개의 인덱스를 생성하고 아래의 SQL의 
            실행계획을 확인하시오 !

@demo
create  index  emp_deptno  on  emp(deptno);
create  index  emp_job  on  emp(job);

select  ename, sal, deptno, job 
  from  emp
  where  deptno = 20  and  job='ANALYST';
---------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name    | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
---------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |         |      1 |        |      2 |00:00:00.01 |       2 |
|*  1 |  TABLE ACCESS BY INDEX ROWID BATCHED| EMP     |      1 |      2 |      2 |00:00:00.01 |       2 |
|*  2 |   INDEX RANGE SCAN                  | EMP_JOB |      1 |      2 |      2 |00:00:00.01 |       1 |
---------------------------------------------------------------------------------------------------------

select count(*) from  emp  where deptno = 20;  -- 5건
select count(*) from  emp  where job='ANALYST'; -- 2건

그런데 만약에 emp_job 인덱스를 액세스 하지 않고 emp_deptno 인덱스를
엑세스 했다면 힌트를 통해서 emp_job 인덱스를 사용하라고 명령해야합니다.

select  /*+ index(emp emp_job) */  ename, sal, job, deptno
  from  emp
  where  job='ANALYST'  and  deptno=20;

select * from  table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

---------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name    | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
---------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |         |      1 |        |      2 |00:00:00.01 |       2 |
|*  1 |  TABLE ACCESS BY INDEX ROWID BATCHED| EMP     |      1 |      2 |      2 |00:00:00.01 |       2 |
|*  2 |   INDEX RANGE SCAN                  | EMP_JOB |      1 |      2 |      2 |00:00:00.01 |       1 |
---------------------------------------------------------------------------------------------------------

문제1. 아래의 SQL의 실행계획이 deptno 의 인덱스를 사용하도록 힌트를 주시오

select  ename, sal, job, deptno
  from  emp
  where  job='ANALYST'  and  deptno=20;

답:
select /*+ index(emp emp_deptno) */ ename, sal, job, deptno
  from  emp
  where  job='ANALYST'  and  deptno=20;

  ------------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name       | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |            |      1 |        |      2 |00:00:00.01 |       2 |
|*  1 |  TABLE ACCESS BY INDEX ROWID BATCHED| EMP        |      1 |      2 |      2 |00:00:00.01 |       2 |
|*  2 |   INDEX RANGE SCAN                  | EMP_DEPTNO |      1 |      5 |      5 |00:00:00.01 |       1 |
------------------------------------------------------------------------------------------------------------

문제2. insurance 테이블에 아래의 2개의 인덱스를 생성하고  이 2개의 
      인덱스중 더 좋은 인덱스를 선택하도록 힌트를 주시오 !

select 'drop  index ' || lower(index_name) || ';'
 from user_indexes
 where  table_name='INSURANCE';

drop  index insurance_indx1;
drop  index ins_age;
drop  index ins_bmi;
drop  index ins_expenses;

create  index insurance_sex  on insurance(sex);
create  index insurance_age  on insurance(age);

select id, age, sex, bmi
  from  insurance
  where  sex='female'  and  age=23;

답:
select /*+ index(insurance  insurance_age) */ id, age, sex, bmi
  from  insurance
  where  sex='female'  and  age=23;
------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name          | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |               |      1 |        |     14 |00:00:00.01 |      10 |      4 |
|*  1 |  TABLE ACCESS BY INDEX ROWID BATCHED| INSURANCE     |      1 |     14 |     14 |00:00:00.01 |      10 |      4 |
|*  2 |   INDEX RANGE SCAN                  | INSURANCE_AGE |      1 |     28 |     28 |00:00:00.01 |       2 |      4 |
------------------------------------------------------------------------------------------------------------------------

문제3.  아래의 SQL의 적절한 힌트를 줘서 좋은 인덱스를 사용하도로 하시오

@demo
create  index  emp_empno  on  emp(empno);
create  index  emp_deptno  on  emp(deptno);

select  empno, ename, job, deptno
  from  emp
  where  empno = 7788   and  deptno = 20; 

답: 
select /*+ index(emp emp_empno) */ empno, ename, job, deptno
  from  emp
  where  empno = 7788   and  deptno = 20; 

-----------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-----------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |           |      1 |        |      1 |00:00:00.01 |       2 |
|*  1 |  TABLE ACCESS BY INDEX ROWID BATCHED| EMP       |      1 |      1 |      1 |00:00:00.01 |       2 |
|*  2 |   INDEX RANGE SCAN                  | EMP_EMPNO |      1 |      1 |      1 |00:00:00.01 |       1 |
-----------------------------------------------------------------------------------------------------------


▣ 튜닝예제13. 훌륭한 인덱스 2개를 같이 사용하여 시너지 효과를 볼 수 있어요

select  col1, col2, col3
  from  tab1
  where  col1 ='ABC'  and col2='123';

col1 의 인덱스도 선택도가 좋은 인덱스이고 col2 의 인덱스로 선택도가 
좋은 인덱스 입니다. 이럴때는 2개의 인덱스를 같이 사용해서 시너지 효과를
보면 됩니다.  

두개의 인덱스를 같이 스캔해서 테이블을 엑세스 하면 "테이블 랜덤 엑세스"
를 현격히 줄일 수 있게 됩니다. 

#실습1.  아래의 환경을 만들고 아래의 2개의 인덱스를 모두 활용하는
        idex merge scan 을 하시오 !

@demo
create  index  emp_deptno  on  emp(deptno);
create  index  emp_job  on emp(job);

select  /*+ and_equal(emp emp_deptno emp_job) */  ename, job, deptno 
 from  emp
 where deptno = 30 and job='SALESMAN';

 ----------------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
----------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |      1 |        |      4 |00:00:00.01 |       5 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |      1 |      4 |      4 |00:00:00.01 |       5 |
|   2 |   AND-EQUAL                 |            |      1 |        |      4 |00:00:00.01 |       4 |
|*  3 |    INDEX RANGE SCAN         | EMP_JOB    |      1 |      4 |      4 |00:00:00.01 |       3 |
|*  4 |    INDEX RANGE SCAN         | EMP_DEPTNO |      1 |      6 |      4 |00:00:00.01 |       1 |
----------------------------------------------------------------------------------------------------
 
두개중에 하나의 인덱스만 사용하지 않고고 두개의 인덱스를 같이 사용해서
테이블 액세스를 줄여 검색 성능을 높였습니다. 

문제1. 아래의 2개의 인덱스를 insurance 테이블에 생성하고 2개의 인덱스를
      같이 사용하도록 아래의 SQL의 힌트를 주시오 !

select 'drop  index ' || lower(index_name) || ';'
 from user_indexes
 where  table_name='INSURANCE';

drop  index insurance_sex;
drop  index insurance_age;

create  index  insurance_sex  on  insurance(sex);
create  index  insurance_smoker  on  insurance(smoker);

select  id, age, sex, smoker 
 from insurance
 where  sex='male'  and smoker='yes';

답:
select /*+ and_equal(i insurance_sex insurance_smoker) */
        id, age, sex, smoker 
 from insurance  i
 where  sex='male'  and smoker='yes';

----------------------------------------------------------------------------------------------------------
| Id  | Operation                   | Name             | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
----------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |                  |      1 |        |     50 |00:00:00.01 |     112 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| INSURANCE        |      1 |    137 |     50 |00:00:00.01 |     112 |
|   2 |   AND-EQUAL                 |                  |      1 |        |     50 |00:00:00.01 |     108 |
|*  3 |    INDEX RANGE SCAN         | INSURANCE_SMOKER |      1 |    274 |     86 |00:00:00.01 |      70 |
|*  4 |    INDEX RANGE SCAN         | INSURANCE_SEX    |      1 |    669 |     79 |00:00:00.01 |      38 |
----------------------------------------------------------------------------------------------------------

▣ 튜닝예제14. 테이블 랜덤 엑세스를 줄이기 위해 결합 컬럼 인덱스를 사용하세요

그림 설명 :  https://cafe.daum.net/oracleoracle/SphB/514

select  col1, col2, col3
  from  tab1
  where  col1 ='ABC'  and col2='123';

단일 컬럼 인덱스를 사용했을때는 2개의 인덱스를 왔다갔다 하면서 길게 스캔했습니다.
결합 컬럼 인덱스로 구성하게 되면 아주 짧게 스캔하면서 원하는 데이터를 찾을 수 있습니다.

#실습1. emp 테이블에 deptno 와 job 에 결합 컬럼 인덱스를 거시오 !

@demo
create  index  emp_deptno_job  on  emp(deptno, job);

#실습2. emp_deptno_job 결합 인덱스의 구조를 확인하시오 !

select  deptno, job, ROWID 
  from  emp
  where deptno >= 0;

#실습3. 부서번호가 20번이고 직업이 ANALYST 인 사원들의 이름과 월급과 
       직업과 부서번호를 출력하시오 ! 실행계획도 확인해서 버퍼의 갯수도
       확인하세요 !

select  ename, sal, job, deptno
 from  emp
 where  deptno = 20  and job='ANALYST';
 
select * from  table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

----------------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name           | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
----------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                |      1 |        |      2 |00:00:00.01 |       2 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| EMP            |      1 |      2 |      2 |00:00:00.01 |       2 |
|*  2 |   INDEX RANGE SCAN                  | EMP_DEPTNO_JOB |      1 |      2 |      2 |00:00:00.01 |       1 |
----------------------------------------------------------------------------------------------------------------

# 실습4. 아래와 같이 대용량 테이블 들을 생성하시오 !

drop  table  mcustsum purge;

create table mcustsum
as
select rownum custno
     , '2008' || lpad(ceil(rownum/100000), 2, '0') salemm
     , decode(mod(rownum, 12), 1, 'A', 'B') salegb
     , round(dbms_random.value(1000,100000), -2) saleamt
from   dual
connect by level <= 1200000 ;

create  index  m_salegb  on  mcustsum(salegb);
create  index  m_salemm  on  mcustsum(salemm);
create  index  m_salegb_salemm  on  mcustsum(salegb,salemm);

#실습5. 아래의 SQL의 실행계획을 확인해서 옵티이져가 어떤 인덱스
       를 사용했는지 확인하시오 !

select  /*+ index(t M_SALEGB_SALEMM) */ count(*)
  from  mcustsum  t 
  where  salegb ='A'
  and salemm  between '200801'  and  '200812';

-----------------------------------------------------------------------------------------------
| Id  | Operation         | Name            | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |                 |      1 |        |      1 |00:00:00.01 |     281 |
|   1 |  SORT AGGREGATE   |                 |      1 |      1 |      1 |00:00:00.01 |     281 |
|*  2 |   INDEX RANGE SCAN| M_SALEGB_SALEMM |      1 |    100K|    100K|00:00:00.01 |     281 |
-----------------------------------------------------------------------------------------------

#실습6. 아래의 SQL 이 salegb 컬럼의 인덱스를를 액세스 하도록 힌트를 
      주고 실행하시오 !

select count(*)
  from  mcustsum  t 
  where  salegb ='A'
  and salemm  between '200801'  and  '200812';

답:

select /*+ index(t M_SALEGB)  */ count(*)
  from  mcustsum  t 
  where  salegb ='A'
  and salemm  between '200801'  and  '200812';
--------------------------------------------------------------------------------------------------------------------
| Id  | Operation                            | Name     | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
--------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                     |          |      1 |        |      1 |00:00:00.04 |    4013 |    188 |
|   1 |  SORT AGGREGATE                      |          |      1 |      1 |      1 |00:00:00.04 |    4013 |    188 |
|*  2 |   TABLE ACCESS BY INDEX ROWID BATCHED| MCUSTSUM |      1 |    600K|    100K|00:00:00.04 |    4013 |    188 |
|*  3 |    INDEX RANGE SCAN                  | M_SALEGB |      1 |    600K|    100K|00:00:00.02 |     184 |    188 |
--------------------------------------------------------------------------------------------------------------------

#실습7. 아래의 SQL 이 salemm 컬럼의 인덱스를를 액세스 하도록 힌트를 
       주고 실행하시오 !

select count(*)
  from  mcustsum  t 
  where  salegb ='A'
  and salemm  between '200801'  and  '200812';

답:
select /*+ index(t  m_salemm) */ count(*)
  from  mcustsum  t 
  where  salegb ='A'
  and salemm  between '200801'  and  '200812';

  --------------------------------------------------------------------------------------------------------------------
| Id  | Operation                            | Name     | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
--------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                     |          |      1 |        |      1 |00:00:00.26 |    6839 |   3015 |
|   1 |  SORT AGGREGATE                      |          |      1 |      1 |      1 |00:00:00.26 |    6839 |   3015 |
|*  2 |   TABLE ACCESS BY INDEX ROWID BATCHED| MCUSTSUM |      1 |    600K|    100K|00:00:00.26 |    6839 |   3015 |
|*  3 |    INDEX RANGE SCAN                  | M_SALEMM |      1 |   1200K|   1200K|00:00:00.15 |    3010 |   3015 |
--------------------------------------------------------------------------------------------------------------------

정리:  단일 컬럼 인덱스를 탔을때 보다 결합 컬럼 인덱스를 탔을 때 더 좋은 성능을 보였습니다.
      결합 컬럼 인덱스는 버퍼(buffer)의 갯수를 281개만 읽었습니다. 

▣ 튜닝예제15. 결합 컬럼 인덱스 구성시 컬럼순서가 중요합니다   

관련그림 : https://cafe.daum.net/oracleoracle/SphB/516

col + col2 결합 컬럼 인덱스가 col2 + col1 결합 컬럼 인덱스 보다
인덱스를 짧게 스캔하면서 원하는 결과를 검색하고 있습니다.
그래서 결합 컬럼 인덱스 생성시 컬럼 순서가 아주 중요합니다. 

select  *
  from  tab1
  where  col1 ='A'  
    and  col2 between  '111'  and  '113';

1. 점조건  :   = 이나 in 을 사용하면 점조건
2. 선분조건 :  between..and 나 like 를 사용하면 선분조건 입니다.

결합 컬럼 인덱스를 구성할때는 결합 컬럼 인덱스의 첫번째 컬럼을 
점조건이 있는 컬럼으로 구성하고 두번째 컬럼은 선분조건으로 구성하는게
성능이 좋습니다. 

create  index  tab1_col1_col2  on  tab1(col1, col2);
create  index  tab1_col2_col1  on  tab1(col2, col1);

#실습1. 아래의 환경을 구성하시오 !

drop  table mcustsum  purge;

create table mcustsum
as
select rownum custno
     , '2008' || lpad(ceil(rownum/100000), 2, '0') salemm
     , decode(mod(rownum, 12), 1, 'A', 'B') salegb
     , round(dbms_random.value(1000,100000), -2) saleamt
from   dual
connect by level <= 1200000 ;

문제1. 아래의 SQL의 성능을 높이기 위한 결합 컬럼 인덱스를 생성하시오

select count(*)
  from  mcustsum  t 
  where  salegb='A'
  and  salemm  between  '200801'  and  '200812';

  -----------------------------------------------------------------------------------------
| Id  | Operation          | Name     | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-----------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |          |      1 |        |      1 |00:00:00.03 |    3835 |
|   1 |  SORT AGGREGATE    |          |      1 |      1 |      1 |00:00:00.03 |    3835 |
|*  2 |   TABLE ACCESS FULL| MCUSTSUM |      1 |    100K|    100K|00:00:00.03 |    3835 |
-----------------------------------------------------------------------------------------

답:  
create  index m_salegb_salemm  on  mcustsum(salegb,salemm);

select /*+ index(t m_salegb_salemm) */ count(*)
  from  mcustsum  t 
  where  salegb='A'
  and  salemm  between  '200801'  and  '200812';
--------------------------------------------------------------------------------------------------------
| Id  | Operation         | Name            | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
--------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |                 |      1 |        |      1 |00:00:00.02 |     281 |    282 |
|   1 |  SORT AGGREGATE   |                 |      1 |      1 |      1 |00:00:00.02 |     281 |    282 |
|*  2 |   INDEX RANGE SCAN| M_SALEGB_SALEMM |      1 |    600K|    100K|00:00:00.02 |     281 |    282 |
--------------------------------------------------------------------------------------------------------

문제2. M_SALEGB_SALEMM 인덱스를 drop 하고 salemm + salegb 로
      결합컬럼 인덱스를 생성하고 아래의 SQL의 Buffer 의 갯수를 보시오 !

drop  index  M_SALEGB_SALEMM;

create  index  m_salemm_salegb  on  mcustsum(salemm, salegb);

select  /*+ index(t m_salemm_salegb) 
            no_index_ss(t m_salemm_salegb) */ count(*)
  from  mcustsum  t 
  where  salegb='A'
  and  salemm  between  '200801'  and  '200812';

설명: no_index_ss(t m_salemm_salegb) 는 m_salemm_salegb 인덱스를
     skip scan 하지 말아라 !

--------------------------------------------------------------------------------------------------------
| Id  | Operation         | Name            | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
--------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |                 |      1 |        |      1 |00:00:00.13 |    3090 |   2736 |
|   1 |  SORT AGGREGATE   |                 |      1 |      1 |      1 |00:00:00.13 |    3090 |   2736 |
|*  2 |   INDEX RANGE SCAN| M_SALEMM_SALEGB |      1 |    600K|    100K|00:00:00.13 |    3090 |   2736 |
--------------------------------------------------------------------------------------------------------

오늘의 마지막 문제. 아래의 SQL 에 가장 적절한 결합 컬럼 인덱스를 생성하시오

@demo
튜닝전:  
select  count(*)
    from  emp
    where  deptno  between 10  and  30
    and  job='CLERK';

튜닝후: 

🎯 튜닝예제16. INDEX SKIP SCAN을 활용한 성능 최적화

📝 이론 설명

INDEX SKIP SCAN은 결합 컬럼 인덱스를 더 효율적으로 활용할 수 있게 하는 
고급 튜닝 기법입니다. 

일반적으로 결합 컬럼 인덱스는 결합 컬럼 인덱스의 첫 번째 컬럼이 
WHERE 절에 있어야만 사용할 수 있지만, 
INDEX SKIP SCAN을 사용하면 이 제약을 우회할 수 있습니다.

그림 설명

⚡ INDEX SKIP SCAN의 작동 원리

・ 결합 인덱스의 첫 번째 컬럼을 건너뛰면서 검색을 수행합니다
・ 결합 인덱스의 첫 번째 컬럼의 고유 값이 적을수록 더 효과적입니다
・ FULL TABLE SCAN을 피하고 인덱스를 활용할 수 있게 해줍니다

📌 핵심 포인트

・ 결합 컬럼 인덱스의 첫 번째 컬럼이 WHERE 절에 없어도 인덱스 사용 가능
・ INDEX_SS 힌트를 통해 명시적으로 지정 가능
・ 첫 번째 컬럼의 Distinct 값이 적을 때 효과적

💻 실습1: 결합 컬럼 인덱스의 기본 동작 확인

@demo
create index emp_deptno_job on emp(deptno, job);
select ename, job, deptno
from emp
where job = 'MANAGER';

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

설명: 결합 컬럼 인덱스는 deptno+job으로 되어 있는데 select문의 where절에서 검색되는 컬럼은 job만 있으면 인덱스를 사용하지 못하고 full table scan을 하게 됩니다.

💻 실습2: INDEX SKIP SCAN 적용

select /*+ index_ss(emp emp_deptno_job) */ ename, deptno, job
from emp
where job = 'MANAGER';

설명: emp_deptno_job 인덱스에서 부서번호별로 MANAGER를 찾아가며, 불필요한 스캔을 스킵합니다. 이는 FULL TABLE SCAN보다 효율적인 접근 방식입니다.

💻 실습3: 대용량 테이블에서의 INDEX SKIP SCAN

📝 환경 구성
・ 테스트를 위한 대용량 테이블을 생성하고 결합 인덱스를 구성합니다
・ 120만 건의 데이터를 포함하는 MCUSTSUM 테이블을 생성합니다
・ SALEMM과 SALEGB 컬럼에 대한 결합 인덱스를 생성합니다

➡️ 테이블 생성:

drop table mcustsum purge;

create table mcustsum
as
select rownum custno
, '2008' || lpad(ceil(rownum/100000), 2, '0') salemm
, decode(mod(rownum, 12), 1, 'A', 'B') salegb
, round(dbms_random.value(1000,100000), -2) saleamt
from dual
connect by level <= 1200000;

➡️ 인덱스 생성:

create index m_salemm_salegb on mcustsum(salemm,salegb);

✨ 튜닝 전:

select count(*)
from mcustsum t
where salegb = 'A';

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

⚡ 문제점 분석:
・ INDEX FAST FULL SCAN이 발생했습니다
・ 버퍼를 3,367개나 읽어들이는 비효율이 발생했습니다
・ SALEGB가 결합 인덱스의 두 번째 컬럼이라 INDEX RANGE SCAN을 사용하지 못했습니다
・ 부분범위 처리가 아닌 전체범위 처리가 발생했습니다

✨ 튜닝 후:

select /*+ index_ss(t m_salemm_salegb) */ count(*)
from mcustsum t
where salegb = 'A';

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

📊 성능 개선 결과

・ 버퍼 읽기가 3,367개에서 302개로 크게 감소했습니다
・ INDEX SKIP SCAN을 통해 효율적인 인덱스 검색이 가능해졌습니다
・ 전체범위 처리에서 부분범위 처리로 개선되었습니다

🤔 문제1: 다음과 같이 결합 컬럼 인덱스를 생성하고 튜닝전 SQL을 튜닝후로 개선하시오 !

@demo
create index emp_job_sal on emp(job, sal);

튜닝전: 
select ename, job, sal
from emp
where sal = 1250;

------------------------------------------------------------------------------------
| Id  | Operation         | Name | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |      1 |        |      2 |00:00:00.01 |       7 |
|*  1 |  TABLE ACCESS FULL| EMP  |      1 |      2 |      2 |00:00:00.01 |       7 |
------------------------------------------------------------------------------------

튜닝후: 





⚠️ 주의사항

・ 첫 번째 컬럼의 Distinct 값이 많으면 성능이 저하될 수 있습니다
・ 인덱스 크기가 큰 경우 신중하게 사용해야 합니다
・ 실행계획을 통해 성능 개선 여부를 반드시 확인해야 합니다

🎓 결론

・ INDEX SKIP SCAN은 결합 컬럼 인덱스 활용도를 높이는 강력한 도구입니다
・ 첫 번째 컬럼의 Distinct 값이 적을 때 특히 효과적입니다
・ 버퍼 사용량 감소를 통해 성능 향상을 확인할 수 있습니다

🎯 튜닝예제17. INDEX FULL SCAN을 활용한 성능 최적화

📝 이론 설명

INDEX FULL SCAN은 인덱스의 전체 구조를 순차적으로 스캔하는 방법으로, 
특히 대용량 테이블에서 집계(COUNT, SUM 등) 연산을 수행할 때 매우 효과적입니다. 
TABLE FULL SCAN에 비해 더 적은 버퍼를 사용하며, 인덱스가 정렬되어 있다는 특성 때문에 
추가적인 정렬 작업 없이도 정렬된 결과를 얻을 수 있습니다.

⚡ INDEX FULL SCAN의 장점

・ 테이블 전체를 읽는 것보다 더 적은 I/O로 원하는 결과를 얻을 수 있습니다
・ 인덱스는 이미 정렬되어 있어 추가 정렬 작업이 필요 없습니다
・ GROUP BY나 집계 함수 실행 시 특히 효율적입니다

💻 실습1: 기본 INDEX FULL SCAN 확인

@demo
create index emp_job on emp(job);

select job, count(*)
from emp
group by job;

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

-------------------------------------------------------------------------------------
| Id  | Operation          | Name | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |      |      1 |        |      5 |00:00:00.01 |       7 |
|   1 |  HASH GROUP BY     |      |      1 |     14 |      5 |00:00:00.01 |       7 |
|   2 |   TABLE ACCESS FULL| EMP  |      1 |     14 |     14 |00:00:00.01 |       7 |
-------------------------------------------------------------------------------------

📌 FULL TABLE SCAN 시 버퍼 7개를 읽어들였습니다

위의 SQL의 결과는 굳이 TABLE FULL SCAN 을 하지 않고 인덱스를 스캔해서도
충분히 얻을 수 있는 결과입니다. 

select job, rowid
 from  emp
 where job > '  ';

ANALYST  	AAAYhhAAHAAAUUsAAJ
ANALYST	    AAAYhhAAHAAAUUsAAL
CLERK	    AAAYhhAAHAAAUUsAAH
CLERK	    AAAYhhAAHAAAUUsAAK
CLERK	    AAAYhhAAHAAAUUsAAM
CLERK	    AAAYhhAAHAAAUUsAAN
MANAGER	    AAAYhhAAHAAAUUsAAB
MANAGER	    AAAYhhAAHAAAUUsAAC
MANAGER	    AAAYhhAAHAAAUUsAAD
PRESIDENT	AAAYhhAAHAAAUUsAAA
SALESMAN	AAAYhhAAHAAAUUsAAE
SALESMAN	AAAYhhAAHAAAUUsAAF
SALESMAN	AAAYhhAAHAAAUUsAAG
SALESMAN	AAAYhhAAHAAAUUsAAI

💻 실습2: NOT NULL 제약 조건을 통한 최적화

table full scan 을 하지 않고 index full scan 을 하려면
emp 테이블에 job 에 not null 제약을 걸어줘야합니다. 

index full scan 이 되려면 해당 인덱스 컬럼에 null 없다는것을 
보장해줘야합니다. 

alter table emp
 modify job constraint emp_job_nn not null;

select table_name, constraint_name
from user_constraints
where table_name = 'EMP';

select job, count(*)
from emp
group by job;

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

📌 버퍼의 갯수가 7개에서 1개로 줄어들었습니다

🤔 문제1: 아래의 SQL의 검색 속도를 높이시오!

@demo
create index emp_deptno on emp(deptno);

✨튜닝전:
select deptno, count(*)
from emp
group by deptno;

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

-------------------------------------------------------------------------------------
| Id  | Operation          | Name | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |      |      1 |        |      3 |00:00:00.01 |       7 |
|   1 |  HASH GROUP BY     |      |      1 |     14 |      3 |00:00:00.01 |       7 |
|   2 |   TABLE ACCESS FULL| EMP  |      1 |     14 |     14 |00:00:00.01 |       7 |
-------------------------------------------------------------------------------------

튜닝후:




🤔 문제2: 직업, 직업별 토탈월급을 출력하는데 TABLE FULL SCAN이 아닌 
          INDEX FULL SCAN이 될 수 있도록 인덱스도 걸고 SQL도 작성하시오!

답:

@demo





⚠️ 주의사항

・ INDEX FULL SCAN을 위해서는 NULL 값 처리가 중요합니다
・ NOT NULL 제약 조건이나 WHERE 절에서 IS NOT NULL 조건을 사용해야 합니다
・ 복합 인덱스 사용 시 첫 번째 컬럼의 NULL 여부가 중요합니다

🎓 결론

・ INDEX FULL SCAN은 대용량 테이블의 집계 작업에서 매우 효과적입니다
・ 정렬된 결과가 필요할 때 추가 정렬 작업 없이 결과를 얻을 수 있습니다
・ NULL 값 처리를 제대로 하면 성능을 크게 향상시킬 수 있습니다
・ ORDER BY 없이도 인덱스 순서대로 결과가 정렬되어 출력됩니다



🎯 튜닝예제18. INDEX FAST FULL SCAN을 활용한 성능 최적화

📝 이론 설명

INDEX FAST FULL SCAN은 INDEX FULL SCAN보다 빠르게 데이터를 검색할 수 있는 방식으로, 
테이블을 전체 스캔하는 TABLE FULL SCAN에 비해 훨씬 적은 I/O 자원을 소모합니다.

⚡ INDEX FAST FULL SCAN의 장점

・ 데이터를 정렬하지 않으므로 처리 속도가 더 빠릅니다.
・ MULTI BLOCK I/O를 사용하여 한 번에 더 많은 데이터를 읽어옵니다.

📖 예: 책의 목차가 50장이 있을 때

・ SINGLE BLOCK I/O는 한 장씩 읽는 방식 (index full scan 방식)

・ MULTI BLOCK I/O는 한 번에 10장씩 읽는 방식(index fast full scan 방식식)

💻 실습1: 직업별 토탈월급을 INDEX FAST FULL SCAN으로 출력

@demo 

create index emp_job_sal on emp(job, sal);

➡️ INDEX FULL SCAN 실행계획 

select job, sum(sal) 
   from emp 
   where job is not null 
   group by job;

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

➡️ INDEX FAST FULL SCAN 실행계획

 select /*+ index_ffs(emp emp_job_sal) */ job, sum(sal) 
      from emp 
    where job is not null group by job;

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

출력결과가 직업을 ABCD 순서데로 정렬을 해서 볼 필요가 없다면
INDEX FULL SCAN 보다는 INDEX FAST FULL SCAN 을 하는게 더 성능이 좋습니다.

🤔 문제1: 아래의 SQL을 튜닝하시오 !  

index full scan 이 나오면 index fast full scan 으로 수행되게하시오! 

@demo 
create index emp_deptno_sal on emp(deptno, sal);

✨ 튜닝전: INDEX FULL SCAN 

select deptno, sum(sal) 
  from emp 
  where deptno is not null 
  group by deptno;


select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));


✨ 튜닝후: INDEX FAST FULL SCAN 



💻 실습2. INDEX FAST FULL SCAN과 병렬 처리를 활용해 직업별 인원수를 출력하시오.

index  full scan 보다 index fast full scan 을 했을때의 장점이 
병렬 쿼리 처리를 수행할 수 있습니다. 

@demo 
create index emp_job on emp(job);

답:  select /*+ index_ffs(emp emp_job) 
                parallel_index(emp, emp_job, 4) */ job,  count(*)
        from  emp
        where  job is  not null
        group  by  job;

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

📌 PARALLEL_INDEX 힌트를 사용하면 여러 프로세스가 동시에 인덱스를 
    스캔하여 성능을 더욱 향상시킬 수 있습니다.

 index full scan 은 parallel_index 를 같이 못사용합니다. 

🤔 문제2: 아래 쿼리를 INDEX FAST FULL SCAN 및 병렬 처리가 가능하도록 튜닝하시오.

@demo 

create index emp_deptno on emp(deptno);

✨ 튜닝전:

 select deptno, count(*) 
   from emp 
   group by deptno;

✨ 튜닝후: 




🎓 결론

・ INDEX FAST FULL SCAN은 데이터를 정렬하지 않고 MULTI BLOCK I/O를 사용하므로 INDEX FULL SCAN보다 빠릅니다.
・ 병렬 처리를 함께 사용하면 대규모 데이터에서 추가적인 성능 향상을 기대할 수 있습니다.
・ 테이블 데이터에서 NULL 값을 제거하거나 NOT NULL 조건을 설정하면 인덱스 활용을 극대화할 수 있습니다.

🎯 튜닝예제19. INDEX BITMAP MERGE SCAN을 활용한 성능 최적화

📝 이론 설명

INDEX BITMAP MERGE SCAN은 여러 B-Tree 인덱스를 Bitmap 형태로 
변환하여 크기를 축소한 후 병합하는 방식입니다. 

기존 INDEX MERGE SCAN은 각 인덱스를 병합하여 테이블 접근 횟수를 줄이지만,
INDEX BITMAP MERGE SCAN은 병합 전 인덱스를 Bitmap으로 변환해
더 작은 크기로 처리합니다. 이는 테이블의 데이터 양이 많고
여러 조건이 결합된 쿼리에서 효율적으로 작동합니다.

⭐INDEX BITMAP MERGE SCAN은 특히 다음과 같은 경우에 유용합니다:

・ 저장 공간 최적화: Bitmap은 B-Tree 인덱스보다 훨씬 적은 공간을 사용합니다.
・ 성능 향상: Bitmap으로 변환된 인덱스는 크기가 작아져, 디스크 I/O와 메모리 사용량이 줄어듭니다.
・ 복합 조건 처리: WHERE 절에 여러 조건이 결합된 경우 효과적입니다.


📖 예: 목차 10장을 1장으로 요약해 스캔

💻 실습1: index merge scan 과 index bitmap merge scan 의 차이를 확인

➡️ INDEX MERGE SCAN 확인

@demo

create index emp_job on emp(job);
create index emp_deptno on emp(deptno);

➡️ INDEX MERGE SCAN 실행계획

select /*+ and_equal(emp emp_job emp_deptno) */ empno, ename, job, deptno
from emp
where deptno = 30 and job = 'SALESMAN';

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));
----------------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
----------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |      1 |        |      4 |00:00:00.01 |       5 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |      1 |      4 |      4 |00:00:00.01 |       5 |
|   2 |   AND-EQUAL                 |            |      1 |        |      4 |00:00:00.01 |       4 |
|*  3 |    INDEX RANGE SCAN         | EMP_JOB    |      1 |      4 |      4 |00:00:00.01 |       3 |
|*  4 |    INDEX RANGE SCAN         | EMP_DEPTNO |      1 |      6 |      4 |00:00:00.01 |       1 |
----------------------------------------------------------------------------------------------------

📌 버퍼 읽기 수: 5개

💻 실습2: INDEX BITMAP MERGE SCAN으로 최적화

@demo

➡️ INDEX BITMAP MERGE SCAN 실행계획

select /*+ index_combine(emp) */ empno, ename, job, deptno
from emp
where deptno = 30 and job = 'SALESMAN';

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));
------------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name       | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |            |      1 |        |      4 |00:00:00.01 |       3 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| EMP        |      1 |      4 |      4 |00:00:00.01 |       3 |
|   2 |   BITMAP CONVERSION TO ROWIDS       |            |      1 |        |      4 |00:00:00.01 |       2 |
|   3 |    BITMAP AND                       |            |      1 |        |      1 |00:00:00.01 |       2 |
|   4 |     BITMAP CONVERSION FROM ROWIDS   |            |      1 |        |      1 |00:00:00.01 |       1 |
|*  5 |      INDEX RANGE SCAN               | EMP_DEPTNO |      1 |        |      6 |00:00:00.01 |       1 |
|   6 |     BITMAP CONVERSION FROM ROWIDS   |            |      1 |        |      1 |00:00:00.01 |       1 |
|*  7 |      INDEX RANGE SCAN               | EMP_JOB    |      1 |        |      4 |00:00:00.01 |       1 |
------------------------------------------------------------------------------------------------------------

📌 Bitmap 병합을 통해 성능이 향상되었습니다.

🤔 문제1: 새로운 환경 구성 후 아래의 SQL을 튜닝하세요.

drop table mcustsum purge;

create table mcustsum as
select rownum custno,
'2008' || lpad(ceil(rownum / 100000), 2, '0') salemm,
decode(mod(rownum, 12), 1, 'A', 'B') salegb,
round(dbms_random.value(1000, 100000), -2) saleamt
from dual
connect by level <= 1200000;

create index m_indx2 on mcustsum(salemm);
create index m_indx3 on mcustsum(salegb);

➡️ 튜닝전: INDEX MERGE SCAN

select /*+ and_equal(t m_indx2 m_indx3) */ count(*)
from mcustsum t
where salegb = 'A'
and salemm = '200801';
-------------------------------------------------------------------------------------------------
| Id  | Operation          | Name    | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
-------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |         |      1 |        |      1 |00:00:00.04 |   17239 |    269 |
|   1 |  SORT AGGREGATE    |         |      1 |      1 |      1 |00:00:00.04 |   17239 |    269 |
|*  2 |   AND-EQUAL        |         |      1 |        |   8334 |00:00:00.04 |   17239 |    269 |
|*  3 |    INDEX RANGE SCAN| M_INDX2 |      1 |    100K|  16667 |00:00:00.03 |     553 |    252 |
|*  4 |    INDEX RANGE SCAN| M_INDX3 |      1 |    600K|   8335 |00:00:00.01 |   16686 |     17 |
-------------------------------------------------------------------------------------------------
📌 버퍼 읽기 수: 17239개

➡️ 튜닝후:      




---------------------------------------------------------------------------------------------------------------
| Id  | Operation                        | Name    | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
---------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                 |         |      1 |        |      1 |00:00:00.01 |     274 |      3 |
|   1 |  SORT AGGREGATE                  |         |      1 |      1 |      1 |00:00:00.01 |     274 |      3 |
|   2 |   BITMAP CONVERSION COUNT        |         |      1 |  50000 |      1 |00:00:00.01 |     274 |      3 |
|   3 |    BITMAP AND                    |         |      1 |        |      1 |00:00:00.01 |     274 |      3 |
|   4 |     BITMAP CONVERSION FROM ROWIDS|         |      1 |        |      1 |00:00:00.01 |     253 |      0 |
|*  5 |      INDEX RANGE SCAN            | M_INDX2 |      1 |        |    100K|00:00:00.01 |     253 |      0 |
|   6 |     BITMAP CONVERSION FROM ROWIDS|         |      1 |        |      1 |00:00:00.01 |      21 |      3 |
|*  7 |      INDEX RANGE SCAN            | M_INDX3 |      1 |        |  10109 |00:00:00.01 |      21 |      3 |
---------------------------------------------------------------------------------------------------------------


🎓 결론

・ INDEX BITMAP MERGE SCAN은 인덱스를 Bitmap으로 변환해 크기를 줄이고 효율적으로 병합합니다.
・ 테이블 접근 최소화 및 스캔 속도 향상을 통해 자원을 절약할 수 있습니다.
・ Bitmap은 저장 공간 최적화와 함께 복합 조건의 논리 연산 처리에 효과적입니다.
・ 대규모 데이터 환경에서 인덱스 활용을 극대화하여 성능을 크게 개선할 수 있습니다.

🎯 튜닝예제20. INDEX UNIQUE SCAN을 활용한 성능 최적화

📝 이론 설명

INDEX UNIQUE SCAN은 UNIQUE 인덱스를 사용하여 특정 레코드를 고유하게 
식별하는 방식으로, NON-UNIQUE 인덱스보다 검색 성능이 우수합니다.
UNIQUE 인덱스는 특정 컬럼 값이 반드시 고유해야 하며, 
이를 통해 데이터의 무결성을 보장할 뿐 아니라 검색 속도를 크게 향상시킵니다.

📌 특징 및 장점

・ 컬럼 값이 고유하므로 특정 값을 정확히 조회할 때 성능이 뛰어납니다.
・ 데이터 중복을 방지하며 데이터 무결성을 유지합니다.
・ 특정 조건(SQL)의 검색 효율을 극대화할 수 있습니다.

⚡ UNIQUE 인덱스를 생성하는 방법

・ 수동 생성: 사용자가 명시적으로 UNIQUE 인덱스를 생성.
・ 자동 생성: PRIMARY KEY 또는 UNIQUE 제약 조건을 정의하면 
             UNIQUE 인덱스가 자동으로 생성.

💻 실습1: UNIQUE 인덱스 생성 및 확인

@demo

⚡수동 생성:
create unique index emp_ename_un on emp(ename);

⚡자동 생성:
alter table emp
add constraint emp_empno_pk primary key(empno);

select index_name, uniqueness
from user_indexes
where table_name = 'EMP';

■ 실습예제1. 월급에 NON-UNIQUE 인덱스를 생성하고 다음과 같이 
            SQL을 실행하면 오라클은 ename에 걸린 UNIQUE 인덱스와 sal에 걸린
            NON-UNIQUE 인덱스 중 어떤 인덱스를 선택할까?

create index emp_sal on emp(sal);

select empno, ename, sal
from emp
where ename = 'SCOTT' and sal = 3000;

------------------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |      1 |        |      1 |00:00:00.01 |       2 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP          |      1 |      1 |      1 |00:00:00.01 |       2 |
|*  2 |   INDEX UNIQUE SCAN         | EMP_ENAME_UN |      1 |      1 |      1 |00:00:00.01 |       1 |
------------------------------------------------------------------------------------------------------

📌 만약 값이 중복되지 않았다면 NON-UNIQUE 인덱스보다는 
    UNIQUE 인덱스를 생성하는 것이 성능 향상을 위해 바람직합니다.

🤔 문제: 아래의 SQL의 검색 속도를 높이기 위한 가장 좋은 인덱스를 생성하시오!

SELECT *
from emp20
where email = 'oracleyu23@gmail.com';

답:


🎓 결론

・ UNIQUE 인덱스는 NON-UNIQUE 인덱스보다 검색 성능이 뛰어나며, 
   인덱스를 생성한 이후에 입력될 데이터에 대해 데이터 중복을 방지합니다.

・ PRIMARY KEY 또는 UNIQUE 제약 조건을 통해 UNIQUE 인덱스를 자동으로 
   생성할 수 있습니다.

・ 값이 고유한 컬럼에는 UNIQUE 인덱스를 적용하여 성능을 극대화하고 
   데이터 무결성을 유지하는 것이 바람직합니다.

