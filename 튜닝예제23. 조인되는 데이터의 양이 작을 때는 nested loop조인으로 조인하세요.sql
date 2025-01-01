🎯 튜닝예제23. 조인되는 데이터의 양이 작을 때는 NESTED LOOP 조인을 사용하세요

📝 이론 설명

조인 시 데이터의 양에 따라 적절한 조인 방식을 선택하는 것이 중요합니다. NESTED LOOP 조인은 조인되는 데이터의 양이 적을 때 적합하며, 연결고리 컬럼에 인덱스가 있을 경우 성능이 크게 향상됩니다. 반면, 데이터 양이 많을 경우에는 HASH 조인이나 SORT MERGE 조인을 사용하는 것이 효율적입니다.

📌 조인 방법 3가지

・ NESTED LOOP JOIN: use_nl 힌트를 사용하며, 데이터 양이 적을 때 유리합니다.
・ HASH JOIN: use_hash 힌트를 사용하며, 데이터 양이 많을 때 효율적입니다.
・ SORT MERGE JOIN: use_merge 힌트를 사용하며, 정렬된 결과가 필요한 경우 유용합니다.

⚠️ NESTED LOOP 조인에서 주의점

・ 조인 연결고리 컬럼에 인덱스가 없을 경우 성능이 크게 저하됩니다.
・ 연결고리 컬럼에 인덱스가 없으면 반드시 인덱스를 생성해야 합니다.

💻 실습1: 연결고리 컬럼에 인덱스가 없을 때 버퍼 사용량 확인

@demo

select /*+ leading(d e) use_nl(e) */ e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno;

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

📌 결과: 35개의 버퍼를 읽어들임.

💻 실습2: 연결고리 컬럼에 인덱스를 생성한 후 버퍼 사용량 확인

@demo

create index emp_deptno on emp(deptno);
create index dept_deptno on dept(deptno);

select /*+ leading(d e) use_nl(e) index(e emp_deptno) */ e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno;

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

📌 결과: 버퍼 사용량이 35개에서 10개로 줄어듬

🤔 문제: 아래 SQL의 조인 순서를 NESTED LOOP 조인으로 고정하고, 연결고리 컬럼에 인덱스를 생성하여 버퍼 사용량을 줄이시오.

✨ 튜닝전: 인덱스 생성 전 버퍼 사용량

select /*+ leading(t s) use_nl(s) */ t.calendar_year, sum(amount_sold)
from sales200 s, times200 t
where s.time_id = t.time_id
and t.week_ending_day_id = 1582
group by t.calendar_year;

✨ 튜닝후: 





🎓 결론

・ 조인되는 데이터의 양이 적을 경우 NESTED LOOP 조인이 효율적입니다.
・ 연결고리 컬럼에 인덱스를 생성하면 성능이 크게 향상됩니다.
・ 힌트를 사용하여 조인 방식을 NESTED LOOP로 고정하고, 인덱스를 통해 불필요한 버퍼 사용을 줄일 수 있습니다.