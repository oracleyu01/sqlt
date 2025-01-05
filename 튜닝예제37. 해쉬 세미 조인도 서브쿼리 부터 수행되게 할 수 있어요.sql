🎯 예제37. 해시 세미 조인을 서브쿼리부터 수행하고 서브쿼리의 테이블을 해시 테이블로 설정


💻 실습예제1: 서브쿼리 테이블을 해시 테이블로 구성

✨튜닝전:


✨튜닝후:



📌 설명

swap_join_inputs(dept)를 사용하여 서브쿼리 테이블(DEPT)을 해시 테이블로 설정.

🤔 문제: CUSTOMERS200을 해시 테이블로 설정

✨튜닝전:


✨튜닝후:


📌 설명

swap_join_inputs(customers200)를 사용하여 CUSTOMERS200을 해시 테이블로 설정.
실행 계획에서 CUSTOMERS200이 메모리 기반 해시 테이블로 처리되는지 확인.

🤔 문제: 작은 테이블을 해시 테이블로 설정

✨튜닝전:

✨튜닝후:


📌 설명

・ swap_join_inputs(sales200)를 사용하여 SALES200을 해시 테이블로 설정.
・ 서브쿼리를 메모리 기반 해시 테이블로 처리하여 성능 최적화.

📝 이론 설명

**해시 세미 조인 (Hash Semi Join)**은 일반적으로 메인 쿼리의 테이블을 해시 테이블로 설정합니다. 
그러나 swap_join_inputs 힌트를 사용하면 서브쿼리의 테이블을 해시 테이블로 구성할 수 있습니다.
이를 통해 서브쿼리 데이터를 메모리 기반으로 처리하여 성능을 최적화할 수 있습니다.

📌 힌트 설명

・ unnest: 서브쿼리를 조인으로 변환.
・ hash_sj: 해시 세미 조인 수행.
・ swap_join_inputs: 서브쿼리 테이블을 해시 테이블로 설정.
・ no_swap_join_inputs: 메인 쿼리 테이블을 해시 테이블로 설정.


 <a href="https://github.com/oracleyu01/sqlt/blob/main/%ED%8A%9C%EB%8B%9D%EC%98%88%EC%A0%9C38.%20not%20in%20%EC%97%B0%EC%82%B0%EC%9E%90%EB%A5%BC%20%EC%82%AC%EC%9A%A9%ED%95%9C%20%EC%84%9C%EB%B8%8C%EC%BF%BC%EB%A6%AC%EB%AC%B8%EC%9D%84%20%ED%8A%9C%EB%8B%9D%ED%95%A0%20%EC%A4%84%20%EC%95%8C%EC%95%84%EC%95%BC%ED%95%B4%EC%9A%94.sql" target="_blank">📘 다음 수업 바로가기</a>


