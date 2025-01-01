🎯 예제40. MINUS를 NOT EXISTS로 변경하여 성능 최적화

📝 이론 설명

MINUS 연산자는 두 테이블 간의 차집합을 구하며, 결과를 정렬합니다. 대량의 데이터를 다룰 때 정렬 작업은 성능 저하의 원인이 될 수 있습니다. **NOT EXISTS**는 정렬 작업 없이 조건에 부합하는 데이터를 바로 필터링하여 더 나은 성능을 제공합니다.

📌 집합 연산자 종류

・ UNION ALL: 중복을 허용한 합집합.
・ UNION: 중복을 제거한 합집합.
・ INTERSECT: 교집합.
・ MINUS: 차집합(정렬 발생).

💻 실습예제1: DEPT 테이블에만 존재하는 부서번호 출력

✨튜닝전:
select deptno
from dept
minus
select deptno
from emp;

✨튜닝후:
select deptno
from dept d
where not exists (
select deptno
from emp e
where e.deptno = d.deptno
);

📌 설명

・ NOT EXISTS를 사용하여 EMP 테이블에 존재하지 않는 DEPT의 부서번호를 필터링.
・ 정렬 없이 바로 결과를 반환하여 성능 최적화.

🤔  문제: TELECOM_TABLE에만 존재하는 TELECOM 출력

✨튜닝전:
select telecom
from telecom_table
minus
select telecom
from emp19;

✨튜닝후:
select telecom
from telecom_table t
where not exists (
select telecom
from emp19 e
where e.telecom = t.telecom
);

📌 설명

・ TELECOM_TABLE에서 EMP19에 존재하지 않는 TELECOM 데이터를 필터링.
・ 정렬 작업을 제거하여 성능 향상.

🎓 결론

・ MINUS는 정렬 작업으로 인해 대량 데이터에서 성능 저하를 유발할 수 있습니다.
・ NOT EXISTS는 정렬 작업을 제거하고 바로 조건에 따라 데이터를 필터링하여 성능을 향상시킵니다.
・ 실행 계획을 확인하여 정렬 작업이 제거되었는지 확인하고 최적화된 쿼리를 사용해야 합니다.