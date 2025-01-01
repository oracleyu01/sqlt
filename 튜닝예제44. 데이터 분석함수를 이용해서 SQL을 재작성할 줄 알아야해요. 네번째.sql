🎯 예제44. 데이터 분석 함수를 활용하여 SQL 재작성 (네 번째)

📝 이론 설명

LAG와 LEAD 함수는 데이터 분석 함수로, 특정 행에서 이전 행 또는 다음 행의 데이터를 참조할 수 있습니다. 이러한 함수는 기존 SQL에서 복잡한 JOIN이나 ROWNUM을 사용한 연산을 제거하여 성능을 개선합니다.

💻 실습예제1: 이전 행의 값을 참조 (LAG 함수)

✨ 튜닝전:
select a.deptno, a.empno, a.ename, a.sal, b.sal
from (
select rownum no1, deptno, empno, ename, sal
from (
select deptno, empno, ename, sal
from emp
order by deptno, sal
)
) a,
(
select rownum + 1 no2, deptno, empno, ename, sal
from (
select deptno, empno, ename, sal
from emp
order by deptno, sal
)
) b
where a.no1 = b.no2 (+)
order by no1;

📌 문제점

・ EMP 테이블을 두 번 조회.
・ ROWNUM과 복잡한 JOIN을 사용하여 불필요한 계산 발생.
・ 버퍼 사용량: 14개로 비효율적.

✨ 튜닝후:
select deptno, empno, sal,
lag(sal, 1) over (order by deptno, sal) as sal_lag
from emp;

📌 효과

・ LAG 함수를 사용하여 단일 스캔으로 이전 행의 데이터를 참조.
・ 버퍼 사용량: 7개로 대폭 감소.

🤔 문제: 다음 행의 값을 참조 (LEAD 함수)

✨ 튜닝전:
select a.deptno, a.empno, a.ename, a.sal, b.sal
from (
select rownum no1, deptno, empno, ename, sal
from (
select deptno, empno, ename, sal
from emp
order by deptno, sal
)
) a,
(
select rownum - 1 no2, deptno, empno, ename, sal
from (
select deptno, empno, ename, sal
from emp
order by deptno, sal
)
) b
where a.no1 = b.no2 (+)
order by no1;

📌 문제점

・ EMP 테이블을 두 번 조회.
・ ROWNUM과 복잡한 JOIN을 사용하여 불필요한 계산 발생.

✨ 튜닝후:




📌 효과

LEAD 함수를 사용하여 단일 스캔으로 다음 행의 데이터를 참조.

🎓 결론

・ LAG와 LEAD 함수는 특정 행의 이전 또는 다음 행 데이터를 참조해야 할 때 강력한 도구입니다.
・ 기존의 JOIN 및 ROWNUM 기반 SQL을 간소화하여 성능을 개선할 수 있습니다.
・ 실행 계획과 버퍼 사용량을 확인하여 데이터 분석 함수의 효과를 검증하는 것이 중요합니다.