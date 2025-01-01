🎯 튜닝예제31. 선택적 조인을 활용한 조인 성능 향상

📝 이론 설명

선택적 조인은 상호 배타적 관계의 테이블에서 조건에 따라 특정 테이블과만 조인하도록 설정하여 성능을 최적화합니다. 불필요한 조인을 방지함으로써 버퍼 사용량과 실행 시간을 줄이는 데 효과적입니다.

📌 특징

・ 조건에 따라 하나의 테이블만 조인에 참여.
・ DECODE 함수와 **아우터 조인 기호 (+)**를 활용해 구현.
・ 조인의 불필요한 데이터 접근을 제거하여 성능을 향상시킵니다.

💻 환경 구성

@demo

alter table emp add emp_kind varchar2(1) default 1 not null;
update emp set emp_kind = case when mod(empno, 2) = 1 then 1 else 2 end;

create table emp_kind1 as
select empno, ename, sal + 200 as office_sal
from emp where emp_kind = '1';

create table emp_kind2 as
select empno, ename, sal + 200 as sal
from emp where emp_kind = '2';

alter table emp_kind1 add constraint pk_emp_kind1 primary key(empno);
alter table emp_kind2 add constraint pk_emp_kind2 primary key(empno);

alter table emp drop column sal;

select * from emp;
select * from emp_kind1;
select * from emp_kind2;

💻 실습1: EMP, EMP_KIND1, EMP_KIND2 조인

select e.empno, e.ename, k1.office_sal, k2.sal
from emp e, emp_kind1 k1, emp_kind2 k2
where e.empno = k1.empno (+)
and e.empno = k2.empno (+)
and e.empno = 7839;

📌 설명

아우터 조인 (+)은 정규직 또는 비정규직 여부를 모르기 때문에 반드시 필요.

💻 실습2: 실행 계획 확인 및 버퍼 사용량 분석

select /*+ gather_plan_statistics */ e.empno, e.ename, k1.office_sal, k2.sal
from emp e, emp_kind1 k1, emp_kind2 k2
where e.empno = k1.empno (+)
and e.empno = k2.empno (+)
and e.empno = 7839;

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

📌 결과

・ 버퍼 사용량: 10개.
・ 비정규직 테이블과 불필요한 조인이 발생.

💻 실습3: 선택적 조인을 사용한 튜닝

select /*+ gather_plan_statistics */ e.empno, e.ename, k1.office_sal, k2.sal
from emp e, emp_kind1 k1, emp_kind2 k2
where decode(e.emp_kind, 1, e.empno) = k1.empno (+)
and decode(e.emp_kind, 2, e.empno) = k2.empno (+)
and e.empno = 7839;

📌 설명

DECODE 함수로 정규직은 EMP_KIND1과만, 비정규직은 EMP_KIND2와만 조인 수행.

🤔 문제: 부서별 상호 배타적 관계의 조인 수행

@demo

drop table dept_10;
drop table dept_20;
drop table dept_30;

create table dept_10 as
select empno, sal * 0.1 as bonus_10 from emp where deptno = 10;

create table dept_20 as
select empno, sal * 0.2 as bonus_20 from emp where deptno = 20;

create table dept_30 as
select empno, sal * 0.3 as bonus_30 from emp where deptno = 30;

alter table dept_10 add constraint dept_10_pk primary key(empno);
alter table dept_20 add constraint dept_20_pk primary key(empno);
alter table dept_30 add constraint dept_30_pk primary key(empno);

select e.empno, e.ename, d1.bonus_10, d2.bonus_20, d3.bonus_30
from emp e, dept_10 d1, dept_20 d2, dept_30 d3
where e.empno = d1.empno (+)
and e.empno = d2.empno (+)
and e.empno = d3.empno (+)
and e.empno = 7788;

✨ 튜닝 후:





📌 설명

・ DECODE를 사용해 부서별로 상호 배타적 조인 수행.
・ 사원번호 7788은 부서번호 20번이므로 DEPT_20과만 조인.

🎓 결론

・ 선택적 조인은 조건에 따라 특정 테이블과만 조인을 수행하여 성능을 최적화할 수 있습니다.
・ 상호 배타적 관계를 가진 테이블 조인 시, DECODE 함수와 아우터 조인 (+)을 활용하면 불필요한 데이터 접근을 방지할 수 있습니다.
・ 실행 계획을 확인하여 조인 최적화를 적용한 후 버퍼 사용량과 성능 차이를 분석하는 것이 중요합니다.

