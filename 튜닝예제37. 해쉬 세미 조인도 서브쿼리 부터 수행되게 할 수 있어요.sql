🎯 예제37. 해시 세미 조인을 서브쿼리부터 수행하고 서브쿼리의 테이블을 해시 테이블로 설정

📝 이론 설명

**해시 세미 조인 (Hash Semi Join)**은 일반적으로 메인 쿼리의 테이블을 해시 테이블로 설정합니다. 그러나 swap_join_inputs 힌트를 사용하면 서브쿼리의 테이블을 해시 테이블로 구성할 수 있습니다. 이를 통해 서브쿼리 데이터를 메모리 기반으로 처리하여 성능을 최적화할 수 있습니다.

📌 힌트 설명

・ unnest: 서브쿼리를 조인으로 변환.
・ hash_sj: 해시 세미 조인 수행.
・ swap_join_inputs: 서브쿼리 테이블을 해시 테이블로 설정.
・ no_swap_join_inputs: 메인 쿼리 테이블을 해시 테이블로 설정.

💻 실습예제1: 서브쿼리 테이블을 해시 테이블로 구성

✨튜닝전:

select ename, sal
from emp
where deptno in (
select deptno
from dept
where loc = 'DALLAS'
);

✨튜닝후:

select ename, sal
from emp
where deptno in (
select /*+ unnest hash_sj swap_join_inputs(dept) */ deptno
from dept
where loc = 'DALLAS'
);

📌 설명

swap_join_inputs(dept)를 사용하여 서브쿼리 테이블(DEPT)을 해시 테이블로 설정.

🤔 문제: CUSTOMERS200을 해시 테이블로 설정

✨튜닝전:
select count()
from sales200
where cust_id in (
select /+ unnest hash_sj no_swap_join_inputs(customers200) */ cust_id
from customers200
where cust_first_name = 'Abel'
);

✨튜닝후:
select count()
from sales200
where cust_id in (
select /+ 적절한 힌트를 주세요  */ cust_id
from customers200
where cust_first_name = 'Abel'
);

📌 설명

swap_join_inputs(customers200)를 사용하여 CUSTOMERS200을 해시 테이블로 설정.
실행 계획에서 CUSTOMERS200이 메모리 기반 해시 테이블로 처리되는지 확인.

🤔 문제: 작은 테이블을 해시 테이블로 설정

✨튜닝전:

select count()
from customers200
where cust_id in (
select /+ no_unnest push_subq */ cust_id
from sales200
where amount_sold between 1 and 10000
);

✨튜닝후:

select count()
from customers200
where cust_id in (
select /+ 적절한 힌트를 주세요  */ cust_id
from sales200
where amount_sold between 1 and 10000
);

📌 설명

・ swap_join_inputs(sales200)를 사용하여 SALES200을 해시 테이블로 설정.
・ 서브쿼리를 메모리 기반 해시 테이블로 처리하여 성능 최적화.

🎓 결론

・ swap_join_inputs를 사용하여 서브쿼리의 테이블을 해시 테이블로 구성하면 성능을 크게 향상시킬 수 있습니다.
・ 서브쿼리와 메인 쿼리의 수행 순서를 적절히 조정하여 실행 계획을 최적화해야 합니다.
・ 해시 세미 조인은 대규모 데이터 처리에서 특히 유용하며, 서브쿼리 데이터를 효율적으로 메모리에서 처리합니다.






