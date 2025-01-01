🎯 튜닝예제21. 조인 순서 튜닝의 중요성과 적용 방법

📝 이론 설명

SQL 조인 튜닝은 조인 순서와 방법을 최적화하여 성능을 개선하는 데 중점을 둡니다. 조인 순서를 적절히 설정하면 불필요한 데이터 접근을 줄이고 처리 속도를 크게 향상시킬 수 있습니다. 또한, 조인 방법을 데이터의 양과 특성에 맞게 선택하는 것도 중요합니다.

📌 조인 튜닝에서 알아야 할 두 가지 요소


⚡조인 방법 (3가지)

・ Nested Loop Join: 데이터 양이 적을 때 적합한 조인 방법.
・ Hash Join: 데이터 양이 많을 때 적합하며 해시 테이블을 이용하여 처리.
・ Sort Merge Join: 데이터 양이 많고 정렬된 결과가 필요할 때 적합.

⚡조인 순서

・ ORDERED 힌트: FROM 절의 테이블 순서대로 조인.
・ LEADING 힌트: 힌트 안에 명시한 테이블 순서대로 조인.

💻 실습1: EMP와 DEPT 테이블 조인하여 이름과 부서 위치 출력

@demo

select e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno;

📌 관련 설명

EMP → DEPT 순으로 조인: 14번 조인 시도
DEPT → EMP 순으로 조인: 4번 조인 시도

💻 실습2: LEADING 힌트를 사용하여 조인 순서 변경 및 버퍼 사용량 비교

@demo

EMP → DEPT 순으로 조인 (버퍼: 105개)

select /*+ leading(e d) use_nl(d) */ e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno;

DEPT → EMP 순으로 조인 (버퍼: 35개)

select /*+ leading(d e) use_nl(e) */ e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno;

📌 결과

조인 순서를 DEPT → EMP로 변경하면 버퍼 사용량이 105개에서 35개로 감소.

🤔 문제: 아래 SQL의 조인 순서를 변경하여 성능을 튜닝하시오!

✨ 튜닝전:
select /*+ leading(e s) use_nl(s) */ e.ename, e.sal, s.grade
from emp e, salgrade s
where e.sal between s.losal and s.hisal;

✨ 튜닝후:



🎓 결론

・ 조인 순서를 적절히 조정하면 버퍼 사용량을 줄이고 성능을 향상시킬 수 있습니다.
・ LEADING 힌트를 사용하여 특정 조인 순서를 지정할 수 있습니다.
・ 데이터 양과 쿼리 특성에 따라 적합한 조인 방법(Nested Loop, Hash, Sort Merge)을 선택해야 합니다.
・ 효율적인 조인 튜닝은 대규모 데이터 처리에서 중요한 역할을 합니다.





