🎯 튜닝예제8. ORDER BY를 통한 과도한 정렬작업을 피하세요

📝 이론 설명 - ORDER BY의 문제점

・ ORDER BY 절은 결과 데이터를 정렬하기 위해 추가적인 작업을 수행합니다
・ 대량의 데이터에 대해 ORDER BY를 수행하면 오라클 PGA 메모리에서 정렬작업이 이루어집니다
・ 메모리가 부족할 경우 디스크 I/O로 이어져 성능저하가 발생합니다
・ 정렬이 필요 없는 경우에도 습관적으로 ORDER BY를 사용하는 것은 자원 낭비입니다

💻 실습1: ORDER BY 사용 최소화

➡️ 인덱스 생성:

create index emp_sal on emp(sal);

✨ 튜닝 전:

select ename, sal
from emp
order by sal asc;

➡️ 실행계획 확인:

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));


설명: ORDER BY로 인해 메모리 사용률이 많이 늘어났습니다.

✨ 튜닝 후:

select ename, sal
from emp
where sal >= 0;

🤔 문제1. 아래의 SQL을 튜닝하시오!

✨ 튜닝 전:

select ename, sal
from emp
order by sal desc;

✨ 튜닝 후:





📌 인덱스 스캔 힌트 설명

・ index_asc: 인덱스를 ascending하게 스캔
・ index_desc: 인덱스를 descending하게 스캔
・ 인덱스 스캔을 이용해서 정렬작업을 최소화

📊 인덱스의 데이터를 스캔하는 WHERE 절의 검색조건

・ 숫자: >= 0
・ 문자: > '   '
・ 날짜: < to_date('9999/12/31', 'RRRR/MM/DD')

🤔 문제2. 아래의 SQL을 튜닝하시오!

@demo
create index emp_hiredate on emp(hiredate);

✨ 튜닝 전:

select ename, hiredate
from emp
where job = 'SALESMAN'
order by hiredate desc;

✨ 튜닝 후:






⚠️ 주의사항

・ ORDER BY는 필요한 경우에만 사용해야 합니다
・ 인덱스를 활용한 정렬을 고려합니다
・ 정렬이 필요한 경우 인덱스 힌트를 활용합니다

🎓 결론

・ ORDER BY는 성능에 큰 영향을 미치는 작업입니다
・ 가능한 인덱스를 활용하여 정렬 작업을 최소화합니다
・ 적절한 WHERE 조건과 인덱스 힌트를 사용하여 성능을 개선합니다
・ 불필요한 ORDER BY 사용을 피해야 합니다
