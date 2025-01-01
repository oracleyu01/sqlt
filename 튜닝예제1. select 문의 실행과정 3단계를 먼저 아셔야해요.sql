🎯 튜닝예제1. select 문의 실행과정 3단계를 먼저 아셔야해요

📝  이론 설명

SELECT ename, sal
FROM emp
WHERE ename = 'SCOTT';

🔍 실행 단계 상세 설명

⚡ 1. 파싱(Parsing):

・ SQL문을 기계어로 변환하는 단계
・ 이 과정에서 실행계획(Execution Plan)이 생성됨
・ 구문 검사와 의미 분석이 수행됨

⚙️ 2. 실행(Execute):

・ 파싱된 SQL문의 실행 계획에 따라
・ 데이터베이스에서 실제 데이터를 찾는 과정

📤 3. 패치(Fetch):

・ 실행 단계에서 찾은 결과를
・ SQL을 요청한 사용자에게 전달하는 단계

💡 이 3단계를 이해하는 것은 SQL 튜닝의 기본이 됩니다.

