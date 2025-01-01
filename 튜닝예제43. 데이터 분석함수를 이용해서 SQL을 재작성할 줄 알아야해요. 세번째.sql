🎯 예제43. 데이터 분석 함수를 활용하여 SQL 재작성 (세 번째)

📝 이론 설명

데이터 분석 함수는 기존의 스칼라 서브쿼리나 복잡한 SQL 문을 간소화하고, 실행 성능을 극대화할 수 있는 강력한 도구입니다. 특히, OVER 절을 사용하여 누적 합계, 순위 등을 효율적으로 계산할 수 있습니다.

💻 실습예제1: 사원번호, 이름, 월급, 누적치를 출력

✨ 튜닝전:

select empno, ename, sal,
(select sum(sal)
from emp e
where e.empno <= b.empno) sumsal
from emp b
order by empno;

📌 문제점

・ 스칼라 서브쿼리가 EMP 테이블의 행 수만큼 반복 수행.
・ EMP 테이블에 14건이 있으면 서브쿼리가 14번 실행됨.
・ 실행 시 버퍼 사용량: 105개로 비효율적.

✨ 튜닝후:
select empno, ename, sal,
sum(sal) over (order by empno asc) sumsal
from emp;

📌 효과

・ 데이터 분석 함수 **SUM()**과 OVER() 절을 사용하여 단일 스캔으로 누적 합계 계산.
・ 버퍼 사용량: 7개로 대폭 감소.

🤔 문제: 부서별 사원 누적 월급 계산

✨ 튜닝전:
select deptno, empno, ename, sal,
(select sum(sal)
from emp e
where e.empno <= b.empno
and e.deptno = b.deptno) sumsal
from emp b
order by deptno, empno;

📌 문제점

스칼라 서브쿼리가 부서별로 반복 수행되며, EMP 테이블의 행 수와 부서별 조건에 따라 성능이 악화됨.

✨ 튜닝후:




📌 효과

・ PARTITION BY 절을 사용하여 부서별로 그룹화 후 누적 합계 계산.
・ 단일 스캔으로 모든 데이터를 처리하며, 실행 성능이 크게 향상됨.

🎓 결론

・ 스칼라 서브쿼리는 반복 실행으로 인해 성능 저하를 유발할 수 있으므로 데이터 분석 함수로 대체하는 것이 효과적입니다.
・ OVER 절과 **PARTITION BY**를 사용하면 그룹화된 누적 계산을 간단히 수행할 수 있습니다.
・ 실행 계획과 버퍼 사용량을 확인하여 최적화된 SQL 문을 작성해야 합니다.