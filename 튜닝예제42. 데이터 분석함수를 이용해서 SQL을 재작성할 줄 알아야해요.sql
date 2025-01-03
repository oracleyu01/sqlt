🎯 예제42. 데이터 분석 함수를 활용하여 SQL 재작성 (두 번째)

📝 이론 설명

GROUPING SETS는 GROUP BY 절에서 여러 그룹화 조합을 생성할 수 있는 강력한 데이터 분석 함수입니다. 기존 SQL에서 UNION ALL을 사용하여 여러 그룹화 결과를 결합하는 작업을 하나의 SQL로 단순화하고 성능을 향상시킬 수 있습니다.

💻 튜닝전과 튜닝후 비교

✨ 튜닝전:
select job, deptno, null as mgr, sum(sal)
from emp
group by job, deptno
union all
select null as job, deptno, mgr, sum(sal)
from emp
group by deptno, mgr;

📌 설명

・ 첫 번째 SELECT: 직업별 부서번호별 총 월급.
・ 두 번째 SELECT: 부서번호별 매니저별 총 월급.
・ EMP 테이블을 2번 조회하여 비효율적.

✨ 튜닝후:
select job, deptno, mgr, sum(sal)
from emp
group by grouping sets((job, deptno), (deptno, mgr));

📌 설명

・ GROUPING SETS를 사용하여 하나의 SELECT 문으로 동일한 결과 생성.
・ EMP 테이블을 단 1번만 조회하여 성능 향상.

🤔 문제: 튜닝전 SQL을 재작성

✨ 튜닝전:
select job, deptno, null as mgr, sum(sal)
from emp
group by job, deptno
union all
select null as job, deptno, mgr, sum(sal)
from emp
group by deptno, mgr
union all
select to_char(null) as job, to_number(null) as deptno, to_number(null) as mgr, sum(sal)
from emp;

📌 설명

・ 첫 번째 SELECT: 직업별 부서번호별 총 월급.
・ 두 번째 SELECT: 부서번호별 매니저별 총 월급.
・ 세 번째 SELECT: 전체 총 월급.
・ EMP 테이블을 3번 조회하여 비효율적.

✨ 튜닝후:





📌 설명

・ GROUPING SETS를 사용하여 하나의 SELECT 문으로 동일한 결과 생성.
・ EMP 테이블을 단 1번만 조회하여 성능을 극대화.

🎓 결론

・ GROUPING SETS를 활용하면 여러 그룹화 조합을 하나의 SQL 문으로 처리하여 성능을 개선할 수 있습니다.
・ 기존의 UNION ALL을 사용하여 데이터를 결합하는 방식은 비효율적이며, 이를 GROUPING SETS로 대체하는 것이 바람직합니다.
・ 실행 계획을 확인하여 EMP 테이블이 단일 조회로 처리되는지 검증해야 합니다.






