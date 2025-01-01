🎯 예제35. push_subq와 no_push_subq 힌트의 짝꿍 힌트

📝 이론 설명

  push_subq  와   no_push_subq  는 서브쿼리의 수행 순서를 제어하는 힌트입니다. 이와 함께 사용되는   unnest  와 no_unnest 힌트는 서브쿼리를 조인으로 변경할지 여부를 제어합니다. 이를 통해 서브쿼리와 메인 쿼리 간의 최적화 전략을 수립할 수 있습니다.

📌 힌트 설명

・ no_unnest: 서브쿼리를 절대 조인으로 변경하지 않고, 독립적으로 서브쿼리로 수행.
・ unnest: 서브쿼리를 풀어서 조인으로 수행.
・ push_subq: 서브쿼리를 먼저 수행.
・ no_push_subq: 메인 쿼리를 먼저 수행.

💻 실습예제1: 서브쿼리부터 수행되게 하기

select /*+ gather_plan_statistics / ename, sal
from emp
where deptno in (
select /+ no_unnest push_subq */ deptno
from dept
where loc = 'NEW YORK'
);

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

📌 설명

・ no_unnest: 서브쿼리를 조인으로 변경하지 않음.
・ push_subq: 서브쿼리를 먼저 수행.


🤔 문제: 아래의 SQL이 메인쿼리부터 수행되게 적절한 힌트를 주시오

select  ename, sal
from emp
where deptno in (
select /+  적절한 힌트를 주세요 */ deptno
from dept
where loc = 'NEW YORK'
);

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

📌 설명

・ no_push_subq: 메인 쿼리를 먼저 수행.
・ no_unnest: 서브쿼리를 조인으로 변경하지 않음.


🤔 문제: SALES200과 CUSTOMERS200 서브쿼리 튜닝

환경 구성:
create table sales200 as select * from sh.sales;
create table customers200 as select * from sh.customers;

✨  튜닝전:

select count()
from sales200
where cust_id in (
select /+ no_unnest no_push_subq */ cust_id
from customers200
where cust_first_name = 'Abel'
);

✨ 튜닝후:

select count()
from sales200
where cust_id in (
select /+ 적절한 힌트를 주세요  */ cust_id
from customers200
where cust_first_name = 'Abel'
);

📌 설명

・ 튜닝 후, 서브쿼리를 먼저 수행하여 성능 개선.
・ 실행 시간이 여전히 길다면, 서브쿼리 대신 세미 조인으로 변경하는 것을 고려.

🎓 결론

・  push_subq 와   no_push_subq  를 사용해 서브쿼리와 메인 쿼리의 수행 순서를 제어할 수 있습니다.
・  no_unnest  와   unnest  를 활용해 서브쿼리를 조인으로 변환할지 여부를 설정할 수 있습니다.
・ 서브쿼리와 조인의 효율성을 비교하고, 상황에 맞는 최적화 방식을 선택해야 합니다.