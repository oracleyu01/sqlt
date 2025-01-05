🎯 예제38. NOT IN 연산자를 사용한 서브쿼리문 튜닝


💻 실습1: DALLAS에서 근무하는 사원들의 이름과 월급 출력하세요




💻 실습2: 위 SQL의 실행계획을 HASH SEMI JOIN으로 변경 하세요.




📌 설명

・ hash_sj 힌트를 사용하여 서브쿼리를 HASH SEMI JOIN으로 수행.

🤔 문제1: DEPT 테이블을 해시 테이블로 설정하세요



📌 설명

・ swap_join_inputs(dept)를 사용해 서브쿼리 테이블(DEPT)을 해시 테이블로 설정.

🤔 문제2: DALLAS에서 근무하지 않는 사원들의 이름과 월급 출력하세요




📌 설명

・ hash_aj 힌트를 사용해 NOT IN 연산자를 HASH ANTI JOIN으로 수행.

🤔 문제3: 작은 테이블(DEPT)을 해시 테이블로 설정하여 튜닝하세요.




📌 설명

・ swap_join_inputs(dept)를 사용하여 DEPT 테이블을 해시 테이블로 설정.
・ deptno is not null 조건을 추가하여 NULL 값으로 인해 발생할 수 있는 오류를 방지.

📝 이론 설명

NOT IN 연산자를 사용한 서브쿼리는 ANTI JOIN으로 변환될 수 있으며, 
메인 쿼리의 데이터에서 서브쿼리에 없는 데이터를 찾는 방식입니다. 
성능 최적화를 위해 HASH ANTI JOIN을 사용하는 것이 효율적입니다.

📌 조인 힌트 설명

・ nl_aj: NESTED LOOP ANTI JOIN 수행
・ hash_aj: HASH ANTI JOIN 수행 (가장 많이 사용)
・ merge_aj: SORT MERGE ANTI JOIN 수행

- 💻  다음 수업 바로가기 

-- https://github.com/oracleyu01/sqlt/blob/main/튜닝예제39. in 연산자를  exists 로 변경해서 튜닝할 줄 알아야해요.sql 




