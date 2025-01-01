🎯 튜닝예제24. 3개 이상의 테이블을 NESTED LOOP 조인으로 조인할 때 힌트 사용법

📝 이론 설명

3개 이상의 테이블을 조인할 때, 조인의 순서와 방법은 성능에 큰 영향을 미칩니다. 특히 NESTED LOOP 조인은 조인되는 데이터의 양이 작고 연결고리 컬럼에 인덱스가 있을 경우 효율적입니다. 적절한 힌트를 사용해 조인 순서와 방법을 명시하면 성능을 크게 향상시킬 수 있습니다.

📌 조인 방법 3가지

・ NESTED LOOP JOIN: use_nl 힌트를 사용하며, 조인되는 데이터의 양이 작고 연결고리 컬럼에 인덱스가 있을 때 유리합니다.

・ HASH JOIN: use_hash 힌트를 사용하며, 데이터 양이 많고 연결고리 컬럼에 인덱스가 없거나 효과적이지 않을 때 적합합니다.
                   인덱스 효과가 어려운 경우: 너무 많은 데이터를 검색할 때.

・ SORT MERGE JOIN: use_merge 힌트를 사용하며, 데이터 양이 많고 정렬된 결과가 필요하거나, 연결고리 컬럼에 인덱스 효과가 없을 때 유리합니다.

⚠️ NESTED LOOP 조인에서 주의점

・ 연결고리 컬럼에 인덱스가 있어야 성능이 향상됩니다.
・ 인덱스가 없을 경우 반드시 생성해야 합니다.

💻 실습1: EMP, DEPT, SALGRADE를 조인하여 이름, 월급, 부서위치, 급여등급 출력

@demo

select e.ename, e.sal, d.loc, s.grade
from emp e, dept d, salgrade s
where e.deptno = d.deptno and e.sal between s.losal and s.hisal;

💻 실습2: 조인 순서 및 방법 조정

@demo

조인 순서: DEPT → EMP → SALGRADE
조인 방법: NESTED LOOP 조인(NL JOIN)

select /*+ leading(d e s) use_nl(e) use_nl(s) */ e.ename, e.sal, d.loc, s.grade
from emp e, dept d, salgrade s
where e.deptno = d.deptno and e.sal between s.losal and s.hisal;

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

🤔 문제1: 조인 순서 및 방법을 SALGRADE → EMP → DEPT로 변경하시오

@demo



💻 실습3: 조인의 성능을 높이기 위해 연결고리 컬럼에 인덱스 생성

@demo

create index emp_deptno on emp(deptno);
create index dept_deptno on dept(deptno);

select /*+ leading(s e d) use_nl(e) use_nl(d) */ e.ename, e.sal, d.loc, s.grade
from emp e, dept d, salgrade s
where e.deptno = d.deptno and e.sal between s.losal and s.hisal;

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

📌 결과:

SALGRADE → EMP(NESTED LOOP) → DEPT(NESTED LOOP).
연결고리 컬럼에 인덱스를 추가한 후 성능 향상.

🤔 문제2: BONUS 테이블 생성하고 emp와 dept 와 bonus 를 조인해서 이름과 부서위치와 comm2 를 출력하세요

@demo

drop table bonus;

create table bonus as
select empno, sal * 1.2 as comm2
from emp;

답:


🤔 문제3: 위의 결과에서 SCOTT의 데이터만 출력하세요

답:


🤔 문제4: 아래의 SQL의 EMP → DEPT → BONUS로 조인 순서 및 방법 설정하세요. 

@demo

조인 순서: EMP → DEPT → BONUS
조인 방법: NESTED LOOP 조인(NL JOIN)

select /*+ 이 자리에 힌트를 쓰세요 */  e.ename, d.loc, b.comm2
from emp e, dept d, bonus b
where e.deptno = d.deptno and e.empno = b.empno;

🎓 결론

・ 3개 이상의 테이블을 조인할 때는 조인 순서와 방법을 힌트로 명시하여 성능을 최적화할 수 있습니다.
・ 연결고리 컬럼에 인덱스를 생성하면 NESTED LOOP 조인의 성능이 크게 향상됩니다.
・ 조인 순서를 적절히 설정하면 불필요한 데이터 접근을 줄이고 효율적인 실행 계획을 수립할 수 있습니다.






