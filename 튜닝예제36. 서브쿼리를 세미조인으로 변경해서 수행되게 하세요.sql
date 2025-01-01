🎯 예제36. 서브쿼리를 세미 조인으로 변경하여 성능 최적화

📝 이론 설명

**세미 조인 (Semi Join)**은 서브쿼리의 데이터를 메인 쿼리에 매칭하는 방식으로, 완전한 조인이 아닌 부분적 조인을 수행하여 성능을 향상시킵니다. 기본적으로 메인 쿼리가 드라이빙되어 시작되며, 해시 조인과 같은 강력한 조인 방식을 사용할 수 있습니다.

📌 세미 조인의 특징

・ 메인 쿼리의 테이블이 드라이빙 테이블로 설정.
・ 서브쿼리와 메인 쿼리 간의 조인 방식을 강제하여 성능 최적화.
・ HASH SEMI JOIN: 대규모 데이터 처리에 적합하며, 가장 많이 사용됨.

⚠️ 세미 조인의 종류

・ nl_sj: NESTED LOOP SEMI 조인.
・ hash_sj: HASH SEMI 조인 (가장 많이 사용).
・ merge_sj: SORT MERGE SEMI 조인.

💻 실습예제1: 해시 세미 조인 적용

✨튜닝전:

select count()
from sales200
where cust_id in (
select /+ no_unnest push_subq */ cust_id
from customers200
where cust_first_name = 'Abel'
);

✨튜닝후:

select count()
from sales200
where cust_id in (
select /+ unnest hash_sj */ cust_id
from customers200
where cust_first_name = 'Abel'
);

📌 설명

unnest: 서브쿼리를 조인으로 변환.
hash_sj: 해시 세미 조인을 강제하여 대량 데이터 처리 최적화.

🤔 문제: EMP와 DEPT를 조인했을때의 실행계획이 해시 세미 조인으로 변경되게하세요.

✨튜닝전:

select ename, sal
from emp
where deptno in (
select /*+ no_unnest no_push_subq */ deptno
from dept
where loc = 'DALLAS'
);

✨튜닝후:

select ename, sal
from emp
where deptno in (
select /*+  적절한 힌트를 주세요 */ deptno
from dept
where loc = 'DALLAS'
);

📌 설명

・ 서브쿼리에서 조건을 메인 쿼리에 매칭하면서 HASH SEMI JOIN 수행.
・ 실행 계획에서 HASH SEMI JOIN이 나타나는지 확인.

🎓 결론

・ 세미 조인은 서브쿼리를 효율적으로 처리할 수 있는 방법으로, 특히 HASH SEMI JOIN이 대량 데이터 처리에 적합합니다.
・ unnest와 hash_sj 힌트를 활용해 서브쿼리를 조인으로 변환하여 성능을 최적화할 수 있습니다.
・ 실행 계획을 확인하여 의도한 최적화 방식이 적용되었는지 확인하는 것이 중요합니다.






