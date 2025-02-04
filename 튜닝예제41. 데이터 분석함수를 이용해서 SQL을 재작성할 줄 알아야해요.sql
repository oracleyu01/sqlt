🎯 예제41. 데이터 분석 함수를 이용하여 SQL 재작성


💻 튜닝전과 튜닝후 비교

✨ 튜닝전:



✨ 튜닝후:



📌 설명

・ 튜닝전: ROLLUP 대신 DECODE와 CONNECT BY를 사용해 수작업으로 그룹화.
・ 튜닝후: ROLLUP 함수로 그룹화 및 계층적 합계 생성.

🤔 문제: 튜닝후 SQL을 튜닝전으로 변경

✨ 튜닝후:




✨ 튜닝전:



  

📌 설명

・ 튜닝후 SQL은 ROLLUP 함수를 사용하여 계층적 합계를 생성.
・ 튜닝전 SQL은 ROLLUP 없이 DECODE와 CONNECT BY를 활용해 동일한 결과 생성.


📝 이론 설명

ROLLUP 함수는 GROUP BY 절에서 계층적 합계를 생성할 때 사용되며, 
추가적인 행을 포함해 소계 및 총계를 제공합니다. 
이는 기존 SQL 문장을 간단하게 재작성할 수 있어 성능과 가독성을 향상시킵니다.


- 💻  다음 수업 바로가기 

-- https://github.com/oracleyu01/sqlt/blob/main/튜닝예제42. 데이터 분석함수를 이용해서 SQL을 재작성할 줄 알아야해요.sql


