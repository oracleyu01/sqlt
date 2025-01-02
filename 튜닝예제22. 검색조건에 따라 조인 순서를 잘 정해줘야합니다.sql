
🎯 튜닝예제22. 검색 조건에 따른 조인 순서 최적화

📝 이론 설명

SQL 조인에서 검색 조건과 데이터의 특성을 고려하여 조인 순서를 적절히 
설정하면 불필요한 데이터 접근을 줄이고 성능을 크게 향상시킬 수 있습니다.
특히, 특정 조건에 의해 데이터 양이 제한되는 경우 조건이 가장 좁혀진 테이블을
먼저 읽는 것이 중요합니다.

📌 조인 순서 튜닝의 핵심

・ 조인 순서는 검색 조건과 데이터 양에 따라 달라져야 합니다.
・ 조건에 의해 결과가 제한되는 테이블(선택도 높은 테이블)을 먼저 읽는 것이 유리합니다.
・ 효율적인 조인 순서를 힌트(LEADING)를 통해 명시적으로 지정할 수 있습니다.

💻 실습1: 이름이 SCOTT인 사원의 이름과 부서 위치 출력

@demo

select e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno and e.ename = 'SCOTT';

📌 조인 순서 비교

DEPT → EMP: 4번 조인 시도
EMP → DEPT: 1번 조인 시도

➡️ 답: 2번

SCOTT이라는 특정 이름의 데이터를 EMP에서 먼저 읽은 후 DEPT와 조인하면,
불필요한 조인 시도를 줄일 수 있습니다.

💻 실습2: 조인 방법은 NESTED LOOP로, EMP → DEPT 순으로 조정

@demo

select /*+ leading(e d) use_nl(d) */ e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno and e.ename = 'SCOTT';

🤔 문제1: 가장 좋은 조인 순서를 힌트로 설정하시오.

조인 방법은 NESTED LOOP를 유지해야 합니다.

@demo

select e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno
and e.job = 'SALESMAN'
and d.loc = 'CHICAGO';



💻 실습3: 대용량 테이블 생성 환경 구성


select count(*) from sales;
select count(*) from times;

create table sales200 
as
select *
 from sales;

create table times200 
as
select *
 from times;

🤔 문제2: SQL을 적절한 조인 순서 힌트로 튜닝하시오.

조인 방법은 변경하지 않음.

@demo

✨튜닝전:
select /*+ leading(s t) use_nl(t) */ t.calendar_year, sum(amount_sold)
from sales200 s, times200 t
where s.time_id = t.time_id
and t.week_ending_day_id = 1582
group by t.calendar_year;

✨튜닝후:




------------------------------------------------------------------------------------------
| Id  | Operation           | Name     | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |          |      1 |        |      1 |00:00:00.16 |   31134 |
|   1 |  HASH GROUP BY      |          |      1 |      4 |      1 |00:00:00.16 |   31134 |
|   2 |   NESTED LOOPS      |          |      1 |   4386 |   6203 |00:00:00.16 |   31134 |
|*  3 |    TABLE ACCESS FULL| TIMES200 |      1 |      7 |      7 |00:00:00.01 |      54 |
|*  4 |    TABLE ACCESS FULL| SALES200 |      7 |    629 |   6203 |00:00:00.16 |   31080 |
------------------------------------------------------------------------------------------

🎓 결론

・ 검색 조건이 좁혀진 테이블을 먼저 읽으면 성능이 크게 향상됩니다.
・ LEADING 힌트를 사용해 적절한 조인 순서를 지정할 수 있습니다.
・ 대용량 데이터 환경에서는 선택도가 높은 테이블을 우선적으로 처리해야 합니다.
・ 조인 방법(NESTED LOOP, HASH 등)을 유지하면서 순서를 최적화하여 
   성능을 극대화할 수 있습니다.
