🎯 튜닝예제28. 대량의 테이블을 조인하는데 HASH 조인을 할 수 없을 경우 SORT MERGE JOIN 활용

📝 이론 설명

SORT MERGE JOIN은 두 테이블을 정렬한 후 병합하여 조인을 수행하는 방식입니다. HASH 조인을 사용할 수 없거나, 조인 결과를 정렬해야 할 때 유용합니다. 정렬 작업으로 인해 추가적인 부담이 있지만, 조인 전에 데이터가 정렬되어 있다면 빠른 조인을 수행할 수 있습니다.

📌 SORT MERGE JOIN이 유용한 경우

・ HASH 조인을 해야 하지만 사용할 수 없는 경우
   
   예: 조인 조건이 = 외의 조건일 때.

・ 조인된 결과를 정렬해야 하는 경우

・ 정렬된 데이터가 필요한 결과에서 효율적.


⚠️ 정렬 부담의 고려

SORT MERGE JOIN은 조인 전에 데이터를 정렬해야 하므로, 테이블 크기에 따라 성능에 영향을 줄 수 있습니다.
검색 조건에 의해 액세스되는 데이터가 적거나, 작은 테이블이 선두로 정렬되면 성능이 향상됩니다.


💻 실습1: EMP와 DEPT를 SORT MERGE JOIN으로 조인

@demo

select /*+       ?           */ e.ename, e.loc, e.deptno
from emp e, dept d
where e.deptno = d.deptno;

📌 설명

・ DEPT 테이블의 deptno를 정렬한 후 EMP와 병합하여 조인을 수행.

・ DEPT 테이블의 부서 번호가 정렬되어 있어 빠르게 스캔 가능.

💻 문제: SALES200과 CUSTOMERS200을 SORT MERGE JOIN으로 튜닝

@demo

✨ 튜닝전:
select /*+ leading(s c) use_nl(c) / count()
from sales200 s, customers200 c
where s.cust_id = c.cust_id
and c.country_id = 52790
and s.time_id between to_date('1999/01/01', 'YYYY/MM/DD')
and to_date('1999/12/31', 'YYYY/MM/DD');

📌 환경 조사

・ SALES200의 전체 건수: 918,843
・ CUSTOMERS200의 전체 건수: 55,500
・ 조건에 따른 SALES200 건수: 247,945
・ 조건에 따른 CUSTOMERS200 건수: 18,520

✨ 튜닝후:
select /*+ 이 자리에 적절한 힌트를 쓰세요 */ count()
from sales200 s, customers200 c
where s.cust_id = c.cust_id
and c.country_id = 52790
and s.time_id between to_date('1999/01/01', 'YYYY/MM/DD')
and to_date('1999/12/31', 'YYYY/MM/DD');

📌 설명

・ CUSTOMERS200을 선두 테이블로 설정하여 정렬된 데이터로 SORT MERGE JOIN 수행.
・ 조건에 의해 데이터가 줄어든 CUSTOMERS200을 먼저 정렬하여 조인 성능 향상.

📌 실행 계획 확인

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

🎓 결론

・ SORT MERGE JOIN은 HASH 조인을 사용할 수 없는 경우 효과적인 대안입니다.
・ 정렬된 데이터가 조인 전 준비되어 있다면 조인 속도를 크게 향상시킬 수 있습니다.
・ 조건에 의해 데이터가 적게 액세스되는 작은 테이블을 선두로 설정하여 효율성을 극대화해야 합니다.
・ 환경 조사를 통해 테이블 크기와 조건을 확인한 후 적합한 조인 방식을 선택해야 합니다.
