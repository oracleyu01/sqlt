🎯 예제45. 데이터 분석 함수를 활용하여 SQL 재작성 (다섯 번째)

📝 이론 설명

데이터 분석 함수는 SQL에서 중복 데이터 접근과 조인을 줄이고 성능을 최적화하는 데 유용합니다. **RANK**와 AVG 함수와 함께 OVER 절을 활용하면, 기존 SQL에서 복잡한 조인이나 중복 SELECT 작업을 단순화하고 실행 성능을 극대화할 수 있습니다.

💻 직업별 1등 월급 사원 출력

✨ 튜닝전:
select e.empno, e.ename, e2.job, e2.max_sal
from emp e,
(
select job, max(sal) as max_sal
from emp
group by job
) e2
where e.job = e2.job
and e.sal = e2.max_sal
order by e.empno;

📌 문제점

・ EMP 테이블을 2번 조회.
・ 조인 작업으로 인해 불필요한 데이터 접근 발생.

✨ 튜닝후:
select empno, ename, job, sal
from (
select empno, ename, job, sal,
rank() over (partition by job order by sal desc) as rnk
from emp
)
where rnk = 1
order by empno;

📌 효과

・ RANK 함수를 사용하여 단일 스캔으로 직업별 1등 데이터를 추출.
・ EMP 테이블을 한 번만 조회하여 성능 최적화.

🤔 문제. 부서 평균 월급보다 많은 사원 출력하는 아래의 SQL을 튜닝하세요.

✨ 튜닝전:
select e.deptno, e.ename, e.sal, v.avgsal
from emp e,
(
select deptno, avg(sal) as avgsal
from emp
group by deptno
) v
where e.deptno = v.deptno
and e.sal > v.avgsal
order by 1 asc;

📌 문제점

・ EMP 테이블을 2번 조회.
・ 조인을 사용하여 불필요한 데이터 접근.
・ 버퍼 사용량: 14개.

✨ 튜닝후:



📌 효과

・ AVG 함수와 OVER 절을 사용하여 부서별 평균 월급 계산.
・ 단일 스캔으로 평균 월급 데이터를 계산하고 필터링.
・ 버퍼 사용량: 7개.

🎓 결론

・ 데이터 분석 함수는 조인 제거와 중복 SELECT 작업 최소화를 통해 성능 최적화를 제공합니다.
・ RANK와 AVG 함수와 함께 OVER 절을 사용하여 단일 스캔으로 복잡한 조건을 처리할 수 있습니다.
・ 실행 계획을 확인하여 튜닝 결과를 검증하고, SQL 성능을 최적화해야 합니다.