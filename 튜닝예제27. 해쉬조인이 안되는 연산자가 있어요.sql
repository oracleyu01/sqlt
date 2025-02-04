🎯 튜닝예제27. 해쉬 조인이 안되는 연산자와 대안

📝 이론 설명

HASH 조인은 조인 연결고리 조건이 반드시 = 조건일 때만 사용할 수 있습니다. BETWEEN ... AND, !=, 또는 기타 범위 조건이 사용되면 HASH 조인을 수행할 수 없으며, 대신 다른 조인 방식(예: SORT MERGE JOIN)을 고려해야 합니다.

📌 HASH 조인의 조건

・ 조인 연결고리는 반드시 = 조건이어야 합니다.
・ 범위 조건이나 부등호 연산자는 HASH 조인을 사용할 수 없습니다.
・ 조인 연결고리 조건에 따라 적합한 대체 조인 방법을 선택해야 합니다.

⚠️ 대안 조인 방법

・ SORT MERGE JOIN: 범위 조건이 있는 경우 효율적으로 사용 가능.
・ NESTED LOOP JOIN: 데이터 양이 적을 때 적합하지만, 대량 데이터에서는 성능 저하 가능.

💻 실습1: EMP와 SALGRADE를 조인하여 이름, 월급, 급여등급 출력하는데 조인방법이 해쉬 조인되게 힌트를 주시오

@demo




  

📌 설명

HASH 조인이 불가능: 연결고리가 BETWEEN ... AND 조건으로 인해 HASH 조인을 사용할 수 없습니다.

💻 실습2: 대안으로 SORT MERGE JOIN 수행

@demo





  
📌 설명

・  SORT MERGE JOIN을 사용하여 범위 조건 조인 수행.
・  SORT MERGE JOIN은 데이터 양이 많을 때도 효율적입니다.

📌 실행 계획 확인

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

🎓 결론

・ HASH 조인은 연결고리 조건이 반드시 **=**이어야 하며, 범위 조건에서는 사용할 수 없습니다.
・ 범위 조건 조인을 수행할 때는 SORT MERGE JOIN이 효과적인 대안입니다.
・ 데이터 양과 조건에 따라 적합한 조인 방식을 선택해야 최적의 성능을 얻을 수 있습니다.
