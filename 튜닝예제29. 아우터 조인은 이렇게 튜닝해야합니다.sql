🎯 튜닝예제29. 아우터 조인을 활용한 성능 최적화

📝 이론 설명

아우터 조인은 한쪽 테이블에 데이터가 없는 경우에도 해당 데이터를 포함해 결과를 반환합니다. 아우터 조인은 조인 순서와 방법을 적절히 설정하지 않으면 성능에 영향을 줄 수 있으므로, 최적의 실행 계획을 수립하는 것이 중요합니다.

📌 조인 문법

⚡ 오라클 조인 문법

    1. Equi Join
    2. Non-Equi Join
    3. Outer Join
    4. Self Join

⚡ 1999 ANSI 조인 문법

   1.ON 절을 사용한 조인
   2.USING 절을 사용한 조인
   3.NATURAL 조인
   4.LEFT/RIGHT/FULL 아우터 조인
   5.CROSS 조인

📌 조인 방법

  1. NESTED LOOP JOIN
  2. HASH JOIN
  3. SORT MERGE JOIN


💻 실습1: 이름과 부서 위치를 조인하여 BOSTON도 출력

@demo

select e.ename, d.loc
from emp e, dept d
where e.deptno (+) = d.deptno;

📌 설명

아우터 조인 기호 (+)는 데이터가 없는 쪽에 추가하여 결과에 포함되도록 설정합니다.

💻 실습2: 데이터를 추가한 후 아우터 조인 결과 확인

@demo

insert into emp(empno, ename, sal, deptno) values(1123, 'JONES', 3000, 70);
commit;

select e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno (+);

💻 실습3: 조인 순서를 DEPT → EMP로 설정하고 HASH 조인 수행

@demo

select /*+ leading(d e) use_hash(e) */ e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno (+);

📌 설명

・ DEPT가 작은 테이블이므로 드라이빙 테이블로 설정.
・ 하지만 아우터 조인 기호 때문에 순서가 고정되므로 swap_join_inputs를 사용해 순서 조정.

💻 해쉬 조인 튜닝: 조인 순서와 방법을 수정

@demo

select /*+ leading(d e) use_hash(e) swap_join_inputs(d) */ e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno (+);

📌 설명

swap_join_inputs를 사용하여 해시 테이블을 DEPT로 설정.

🤔 문제1: SALES200과 TIMES200의 조인에서 아우터 조인 순서를 조정하고 HASH 조인 수행

✨ 튜닝전:
select t.calendar_year, sum(s.amount_sold)
from sales200 s, times200 t
where s.time_id = t.time_id (+)
and t.week_ending_day_id (+) = 1581
group by t.calendar_year;

✨ 튜닝후:
select /*+ 이 자리에 적절한 힌트를 쓰세요  */ t.calendar_year, sum(s.amount_sold)
from sales200 s, times200 t
where s.time_id = t.time_id (+)
and t.week_ending_day_id (+) = 1581
group by t.calendar_year;

📌 설명

TIMES200을 해시 테이블로 설정하여 조인 순서 최적화.

🤔 문제2: EMP, DEPT, SALGRADE를 NESTED LOOP 조인으로 최적화하세요. 

@demo

drop table salgrade;
create table salgrade (grade number(10), losal number(10), hisal number(10));

insert into salgrade values(1,700,1200);
insert into salgrade values(2,1201,1400);
insert into salgrade values(3,1401,2000);
insert into salgrade values(4,2001,3000);
insert into salgrade values(5,3001,9999);
commit;

select /*+ 이 자리에 적절한 힌트를 쓰세요 */ e.ename, d.loc, s.grade
from emp e, dept d, salgrade s
where e.deptno = d.deptno
and e.sal between s.losal and s.hisal
and s.grade in (3, 4)
and d.loc = 'DALLAS';

📌 설명

NESTED LOOP 조인을 수행하며 조건에 따라 데이터 액세스를 줄임.

🎓 결론

・ 아우터 조인에서 조인 순서는 아우터 조인 기호에 의해 고정되지만, swap_join_inputs를 사용해 조정 가능합니다.
・ HASH 조인, SORT MERGE 조인 등 적합한 조인 방법을 상황에 맞게 선택해야 합니다.
・ NESTED LOOP 조인은 데이터 양이 적거나 인덱스가 있을 때 효과적입니다.
・ 환경에 맞는 조인 순서를 설정하여 성능을 극대화할 수 있습니다.