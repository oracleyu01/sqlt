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


