🎯 튜닝예제5. HAVING 절에 일반 검색조건을 쓰지 마세요

📝 이론 설명

HAVING 절은 GROUP BY로 그룹화된 결과에 대해 집계함수 조건을 적용하기 위해 사용됩니다.

예: HAVING SUM(sal) > 5000

⚡ 문제점 설명

・ HAVING 절에 일반적인 검색조건(그룹화와 무관한 조건)을 추가하면 불필요한 성능저하가 발생할 수 있습니다
・ 일반적인 검색조건은 WHERE 절에 작성해야 하는데 HAVING 절에 작성하게 되면 FULL TABLE SCAN을 하게 됩니다

💻 실습1: 버퍼 개수 비교

➡️ 인덱스 생성:

create index emp_job on emp(job);

✨ 튜닝 전:

select job, sum(sal)
from emp
group by job
having sum(sal) > 5000 and job = 'SALESMAN';

⚡ 실행계획 확인:

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

✨ 튜닝 후:

select job, sum(sal)
from emp
where job = 'SALESMAN'
group by job
having sum(sal) > 5000;

⚡ 실행계획 확인:

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

🤔 문제1. 아래의 SQL을 튜닝하시오!

@demo
create index emp_deptno on emp(deptno);

✨ 튜닝 전:

select deptno, avg(sal)
from emp
group by deptno
having avg(sal) > 2000 and deptno = 20;

⚡ 실행계획 확인:

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

✨ 튜닝 후:






⚡ 실행계획 확인:

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

⚠️ 주의사항

・ HAVING 절은 오직 GROUP BY의 결과에 대한 집계함수 조건에만 사용해야 합니다
・ 일반 검색조건은 반드시 WHERE 절에 작성해야 성능이 향상됩니다
・ HAVING 절에 일반 조건을 사용하면 불필요한 FULL TABLE SCAN이 발생합니다

🎓 결론

・ HAVING 절은 GROUP BY 결과에 대한 집계함수 조건용으로만 사용합니다
・ 일반 검색조건은 WHERE 절에 작성하여 인덱스를 활용할 수 있게 합니다
・ 실행계획과 버퍼 개수로 튜닝 효과를 확인합니다

