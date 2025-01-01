🎯 예제39. IN 연산자를 EXISTS로 변경하여 성능 최적화

📝 이론 설명

IN 연산자는 메인 쿼리와 서브쿼리 간의 조인을 수행하여 메인 쿼리 데이터를 서브쿼리에 매칭합니다. 하지만, 데이터량이 많은 대규모 테이블에서는 성능이 저하될 수 있습니다. 이 경우, EXISTS를 사용하면 메인 쿼리 데이터가 서브쿼리에 존재하는지 확인 후 바로 멈추므로 성능이 향상됩니다.

📌 IN과 EXISTS의 차이

・ IN: 메인 쿼리의 데이터 전체를 서브쿼리와 비교.
・ EXISTS: 메인 쿼리의 각 행을 서브쿼리에 존재 여부로 검증하며, 조건이 충족되면 바로 종료.
・ EXISTS는 메인 쿼리 데이터가 적을 때 유리.

💻 실습예제1: IN 연산자를 사용한 서브쿼리 분석

문제: 부서 테이블에서 부서번호를 출력하되, 사원 테이블에 존재하는 부서번호만 출력.

select deptno
from dept
where deptno in (
select deptno
from emp
);

📌 문제점

DEPT의 모든 deptno를 EMP와 조인하며, EMP 테이블이 대규모일 경우 비효율적.

✨튜닝 후, EXISTS를 사용:

select deptno
from dept d
where exists (
select deptno
from emp e
where e.deptno = d.deptno
);

📌 설명

・ EXISTS는 메인 쿼리의 각 deptno가 EMP 테이블에 존재하면 즉시 종료.
・ 메인 쿼리 데이터가 적을 경우 효율적.

🤔 문제: CUSTOMERS200과 SALES200 서브쿼리 튜닝

✨튜닝전:
select count(*)
from customers200
where cust_first_name = 'Abel'
and cust_id in (
select cust_id
from sales200
);

✨튜닝후:





📌 설명

・ IN을 EXISTS로 변경하여 메인 쿼리의 cust_id가 서브쿼리에 존재하면 즉시 종료.
・ 메인 쿼리의 조건 cust_first_name = 'Abel'로 데이터 범위를 축소하여 성능 향상.

🎓 결론

・ IN 연산자는 대규모 테이블 조인에서 비효율적일 수 있으며, EXISTS로 변경하면 메인 쿼리 데이터를 효율적으로 확인할 수 있습니다.
・ EXISTS는 조건 충족 시 즉시 종료하므로, 메인 쿼리 데이터가 적거나 서브쿼리 조건이 복잡한 경우 적합합니다.
・ EXISTS와 IN의 효율성 차이를 실행 계획으로 확인하여 적절히 선택하는 것이 중요합니다.
