🎯 예제34. 조인의 성능을 높이기 위해 MVIEW 생성 고려

📝 이론 설명

Materialized View (MVIEW) 는 데이터를 저장하는 뷰로, 대량의 데이터 조인 결과를 저장하여 성능을 최적화합니다. 일반 뷰는 데이터가 저장되지 않아 매번 조인 작업을 수행해야 하지만, MVIEW는 데이터가 저장되어 반복 조회 시 성능이 향상됩니다.

📌 MVIEW의 장점

・ 대량 데이터 조인 결과를 저장하여 조회 성능 개선.
・ Query Rewrite 기능을 사용해 SQL을 자동으로 MVIEW 데이터로 매핑.
・ 정기적인 동기화 옵션을 제공 (Immediate Build, Refresh on Demand).

💻 실습예제1: 일반 뷰 생성

create view emp_dept2 as
select d.loc, sum(e.sal) as sumsal
from emp e, dept d
where e.deptno = d.deptno
group by d.loc;

select * from emp_dept2;

📌 설명

일반 뷰는 데이터를 저장하지 않으므로 매번 조인을 수행.


💻 실습예제2: MVIEW 생성

create materialized view emp_dept3 as
select d.loc, sum(e.sal) as sumsal
from emp e, dept d
where e.deptno = d.deptno
group by d.loc;

select * from emp_dept3;

📌 설명

・ MVIEW는 데이터를 저장하여 반복 조회 시 빠른 성능 제공.
・ 데이터 저장을 통해 매번 조인 작업을 반복하지 않음.


💻 실습예제3: DALLAS 사원 데이터를 위한 MVIEW 생성

create materialized view emp_dept_salgrade as
select e.ename, e.sal, d.loc, s.grade
from emp e, dept d, salgrade s
where e.deptno = d.deptno
and e.sal between s.losal and s.hisal
and d.loc = 'DALLAS';

select * from emp_dept_salgrade;

📌 설명

・ MVIEW를 사용해 DALLAS 사원 데이터를 저장.
・ 일반 뷰를 사용하면 매번 21개의 버퍼를 읽어야 하지만, MVIEW는 3개만 읽음.

💻 실습예제4: Query Rewrite 활용

drop view emp_dept_salgrade2;

select /*+ rewrite */ e.ename, e.sal, d.loc, s.grade
from emp e, dept d, salgrade s
where e.deptno = d.deptno
and e.sal between s.losal and s.hisal
and d.loc = 'DALLAS';

📌 설명

・ rewrite 힌트를 사용하면 테이블 대신 MVIEW 데이터를 사용.
・ MVIEW 데이터로 매핑하여 조인 작업을 생략.
