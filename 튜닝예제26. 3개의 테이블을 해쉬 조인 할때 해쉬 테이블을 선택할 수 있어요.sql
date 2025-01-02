🎯 튜닝예제26. 3개의 테이블을 HASH 조인할 때 해시 테이블을 선택하는 방법

📝 이론 설명

HASH 조인을 사용할 때, 작은 테이블을 메모리에 올려 해시 테이블로 구성하는 것이 
성능 최적화의 핵심입니다.

2개의 테이블 조인 시에는 leading 힌트를 사용하여 해시 테이블을 지정할 수 있지만, 
3개 이상의 테이블 조인에서는 추가적인 힌트(swap_join_inputs, no_swap_join_inputs)를 
활용해야 합니다.

📌 HASH 조인의 힌트

・ swap_join_inputs: 메모리로 올라가는 해시 테이블을 지정.
・ no_swap_join_inputs: 디스크에서 읽는 탐색 테이블을 지정.

⚠️ 해시 테이블 선택 시 주의점

・ 상대적으로 크기가 작거나 조건에 의해 데이터 접근량이 적은 테이블을 선택해야 합니다.
・ 적절한 테이블을 메모리에 올림으로써 조인의 효율성을 극대화할 수 있습니다.

💻 실습1: EMP, DEPT, BONUS를 특정 순서로 HASH 조인

@demo

・ 조인 순서: DEPT → EMP → BONUS
・ 조인 방법: HASH 조인

select /*+ leading(d,e,b) use_hash(e) use_hash(b) */ e.ename, d.loc, b.comm2
from emp e, dept d, bonus b
where e.deptno = d.deptno and e.empno = b.empno;

📌 설명

・ DEPT와 EMP 조인 시 DEPT가 해시 테이블.
・ EMP와 BONUS 조인 시 EMP와 DEPT의 조인 결과가 해시 테이블.

💻 실습2: BONUS를 해시 테이블로 구성

@demo

select /*+ leading(d,e,b) use_hash(e) use_hash(b) swap_join_inputs(b) */ e.ename, d.loc, b.comm2
from emp e, dept d, bonus b
where e.deptno = d.deptno and e.empno = b.empno;

📌 설명

・ BONUS를 메모리에 올려 해시 테이블로 사용.

💻 실습3: TIMES200, SALES200, PRODUCTS200 조인 및 환경 구성

@demo

drop table sales200;
drop table times200;
drop table products200;

create table sales200 as select * from sh.sales;
create table times200 as select * from sh.times;
create table products200 as select * from sh.products;

select p.prod_name, t.calendar_year, sum(s.amount_sold)
from sales200 s, times200 t, products200 p
where s.time_id = t.time_id
and s.prod_id = p.prod_id
and t.calendar_year in (2000,2001)
and p.prod_name like 'Deluxe%'
group by p.prod_name, t.calendar_year;

🤔 문제1: 조인 순서와 방법을 특정 순서로 설정

@demo

・ 조인 순서: TIMES200 → SALES200 → PRODUCTS200
・ 조인 방법: HASH 조인

select /*+  이자리에 적절한 힌트를 쓰세요  */
p.prod_name, t.calendar_year, sum(s.amount_sold)
from sales200 s, times200 t, products200 p
where s.time_id = t.time_id
and s.prod_id = p.prod_id
and t.calendar_year in (2000,2001)
and p.prod_name like 'Deluxe%'
group by p.prod_name, t.calendar_year;

📌 설명

・ TIMES200을 해시 테이블로 구성.
・ TIMES200과 SALES200 조인 결과를 PRODUCTS200과 추가 해시 조인.

🤔 문제2: no_swap_join_inputs를 사용해 탐색 테이블 설정

@demo

select /*+ 이 자리에 적절한 힌트를 쓰세요 */
p.prod_name, t.calendar_year, sum(s.amount_sold)
from sales200 s, times200 t, products200 p
where s.time_id = t.time_id
and s.prod_id = p.prod_id
and t.calendar_year in (2000,2001)
and p.prod_name like 'Deluxe%'
group by p.prod_name, t.calendar_year;

📌 결과

PRODUCTS200은 탐색 테이블로, TIMES200과 SALES200의 조인 결과는 해시 테이블로 사용.

🤔 문제3: 조인 순서 최적화를 위한 사전 조사


select count() from sales200; -- 918,843
select count() from times200; -- 1,826
select count(*) from products200; -- 72

select count() from times200 where calendar_year in (2000,2001); -- 731
select count() from products200 where prod_name like 'Deluxe%'; -- 1

📌 결과

TIMES200(731건)과 PRODUCTS200(1건)의 조건으로 조인 순서 최적화.


🎓 결론

・ 3개 이상의 테이블을 HASH 조인할 때, 적절한 힌트와 조인 순서를 설정하여 
   성능을 최적화할 수 있습니다.

・ 작은 테이블 또는 조건으로 데이터 접근량이 적은 테이블을 메모리에 올리는 것이 중요합니다.

・ swap_join_inputs와 no_swap_join_inputs 힌트를 활용해 해시 테이블과 
   탐색 테이블을 명확히 설정할 수 있습니다.
   
・ 사전 조사를 통해 테이블 크기와 조건을 확인하고 적합한 조인 순서를 결정해야 합니다.






