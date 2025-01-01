🎯 튜닝예제2. 옵티마이져가 뭔지 알아야해요

📝 이론 설명

⚡ 옵티마이져(Optimizer)란 ?

SQL을 가장 효율적이고 빠르게 수행할 수 있도록 최적의 처리 경로를 선택해주는 
오라클의 핵심 엔진입니다.


🔍 옵티마이져의 처리 단계

1. SQL 입력
2. Query Transformer가 SQL을 수행하기 좋도록 변경할 수 있으면 변경합니다
3. Estimator가 SQL의 비용을 계산합니다
4. Plan Generator가 비용이 가장 적게드는 실행계획을 생성합니다

💻 실습1: Query Transformer의 동작 확인

SELECT ename, sal, job
 FROM emp
 WHERE job IN ('SALESMAN', 'ANALYST');

➡️ 실행계획 확인:

EXPLAIN PLAN FOR
SELECT ename, sal, job
 FROM emp
 WHERE job IN ('SALESMAN', 'ANALYST');

SELECT * FROM table(dbms_xplan.display);

➡️ Query Transformer의 변환 결과:

SELECT ename, sal, job
 FROM emp
 WHERE job = 'ANALYST' OR job = 'SALESMAN';

⚠️ SQL 튜닝시 주의사항

・ 힌트를 아무리 줘도 원하는 실행계획이 안나오는 경우가 있습니다
・ 대부분의 경우 Query Transformer가 SQL을 자동으로 변경했기 때문입니다

💻  통계정보 확인 방법

 SELECT COUNT(*) FROM emp;

 SELECT table_name, num_rows FROM user_tables;

📈 통계정보 수집 방법

➡️ 단일 테이블 통계정보 수집:

 ANALYZE TABLE emp COMPUTE STATISTICS;

➡️ 전체 스키마 통계정보 수집:

  EXEC dbms_stats.gather_schema_stats('C##SCOTT');

💡 통계정보 확인 실습

SELECT table_name, num_rows
  FROM user_tables
  WHERE num_rows IS NOT NULL
  ORDER BY num_rows DESC;

🎓 결론

・ SELECT 문의 처리과정 3가지를 알고
・ 통계정보 수집의 중요성을 이해하면
・ SQL 튜닝시 시간을 많이 절약할 수 있습니다 


