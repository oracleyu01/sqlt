🎯 튜닝예제30. 3개 이상의 테이블을 조인할 때 조인 방법을 다양하게 조절하기

📝 이론 설명

3개 이상의 테이블을 조인할 때, 조인 순서와 조인 방법을 적절히 설정하면 성능을 크게 향상시킬 수 있습니다. 각 조인 방법은 특정 조건에서 효과적이며, 실행 계획의 테이블 위치에 따라 역할이 다릅니다.

📌 조인 방법별 테이블 역할

⚡ NESTED LOOP JOIN

・ 위쪽 테이블: 드라이빙 테이블
・ 아래쪽 테이블: 드리븐 테이블

⚡ HASH JOIN

・ 위쪽 테이블: 해시 테이블
・ 아래쪽 테이블: 프로브 테이블

⚡ SORT MERGE JOIN

・ 위쪽 테이블: 선행 테이블
・ 아래쪽 테이블: 후행 테이블

⚠️ 조인 최적화의 핵심

・ 작은 테이블을 선두로 배치하여 조인 효율성을 높입니다.
・ 대량 데이터 조인 시, 조건에 맞는 조인 방법을 선택합니다.

💻 실습1: EMP, DEPT, SALGRADE를 조인하여 다양한 조인 방법 설정

@demo

select /*+ leading(e,d,s) use_hash(d) use_nl(s) */ e.ename, d.loc, s.grade
from emp e, dept d, salgrade s
where e.deptno = d.deptno
and e.sal between s.losal and s.hisal;

📌 설명

・ EMP와 DEPT는 HASH 조인 수행.
・ EMP와 SALGRADE는 NESTED LOOP 조인 수행.

🤔 문제1: SALGRADE → EMP → DEPT 순서로 조인하고 조인 방법 조정

@demo

select /*+ 이 자리에 적절한 힌트를 쓰세요  */ e.ename, d.loc, s.grade
from emp e, dept d, salgrade s
where e.deptno = d.deptno
and e.sal between s.losal and s.hisal;

📌 설명

・ SALGRADE와 EMP는 SORT MERGE 조인 수행.
・ EMP와 DEPT는 NESTED LOOP 조인 수행.

🤔 문제2: 부서 위치가 DALLAS인 데이터만 출력하며 실전 튜닝

@demo

⚡ 조인 순서: DEPT → EMP → SALGRADE
⚡ 조인 방법: NESTED LOOP 조인

select /*+ 이 자리에 적절한 힌트를 쓰세요  */ e.ename, d.loc, s.grade
from emp e, dept d, salgrade s
where e.deptno = d.deptno
and e.sal between s.losal and s.hisal
and d.loc = 'DALLAS';

📌 설명

・ 조건에 의해 데이터가 적게 액세스되는 DEPT를 선두로 설정.
・ 모든 조인을 NESTED LOOP 방식으로 수행.

🤔 문제3: DEPT와 EMP 조인 후 결과가 5만 건일 경우 SALGRADE와 MERGE 조인 수행

@demo

⚡ 조인 순서: DEPT → EMP → SALGRADE
⚡ 조인 방법: NESTED LOOP 조인, SORT MERGE 조인

select /*+ 이 자리에 적절한 힌트를 쓰세요   */ e.ename, d.loc, s.grade
from emp e, dept d, salgrade s
where e.deptno = d.deptno
and e.sal between s.losal and s.hisal
and d.loc = 'DALLAS';

📌 설명

DEPT와 EMP는 NESTED LOOP 조인 수행.
EMP와 SALGRADE는 SORT MERGE 조인 수행.

🤔 문제4: SALGRADE(10만 건), EMP(12건), DEPT 조인 설정

@demo

⚡ 조인 순서: SALGRADE → EMP → DEPT
⚡ 조인 방법: SORT MERGE 조인, NESTED LOOP 조인

select /*+ 이 자리에 적절한 힌트를 쓰세요  */ e.ename, d.loc, s.grade
from emp e, dept d, salgrade s
where e.deptno = d.deptno
and e.sal between s.losal and s.hisal;

📌 설명

・ SALGRADE와 EMP는 SORT MERGE 조인 수행.
・ EMP와 DEPT는 NESTED LOOP 조인 수행.
📌 실행 계획 확인

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

🎓 결론

・ 3개 이상의 테이블을 조인할 때, 조인 순서와 방법을 적절히 설정하여 성능을 최적화할 수 있습니다.
・ 작은 테이블이나 조건에 의해 액세스되는 데이터가 적은 테이블을 선두로 배치합니다.
・ HASH, SORT MERGE, NESTED LOOP 조인을 상황에 맞게 조합하여 최적의 실행 계획을 수립해야 합니다.






