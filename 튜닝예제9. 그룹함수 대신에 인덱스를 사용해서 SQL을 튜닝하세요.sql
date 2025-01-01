🎯 튜닝예제9. 그룹함수 대신에 인덱스를 사용해서 SQL을 튜닝하세요

📝 이론 설명 - 그룹함수의 문제점

그룹함수는 데이터를 처리하기 위해 정렬작업을 수행하며, 이 과정에서 추가적인 메모리와 CPU 자원을 소모합니다. 

특히 MAX, MIN, COUNT와 같은 함수들은 전체 데이터를 스캔해야 결과를 계산할 수 있어 성능저하를 초래할 수 있습니다.

💻 실습1: MAX 함수의 문제점 분석

✨ 문제가 있는 SQL:

select max(sal) from emp;

⚡ 문제점 설명

・ 모든 데이터를 스캔하여 최대값을 계산합니다
・ 실행계획에서 SORT AGGREGATE가 발생하며 정렬작업을 수행합니다
・ 데이터가 많을수록 성능저하가 심각해집니다

✨ 튜닝 후:

create index emp_sal on emp(sal);
select /*+ index_desc(emp emp_sal) */ sal
from emp
where sal >= 0 and rownum = 1;

⚡ 개선 효과: 버퍼 1개만 읽고 작업이 완료됩니다

🤔 문제1. 아래의 SQL을 튜닝하시오!

✨ 튜닝 전:

select min(hiredate)
from emp;

✨ 튜닝 후:





📌 중요 용어 설명

📖  전체 범위 처리

・ 테이블 전체를 다 읽어야 결과를 볼 수 있는 SQL

 예: select max(sal) from emp;

📖 부분 범위 처리

・ 테이블이나 인덱스의 일부분만 읽어서도 결과를 볼 수 있는 SQL

 예: select /*+ index_desc(emp emp_sal) */ sal from emp where sal >= 0 and rownum = 1;

🤔 문제2. 아래의 SQL을 튜닝하시오!

✨ 튜닝 전:

select ename, sal
from emp
where sal = (select max(sal) from emp);

⚡ 실행계획 확인:

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

✨ 튜닝 후:



⚡ 실행계획 확인:

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

🎓 결론

・ 그룹함수 사용은 전체 테이블 스캔을 유발하여 성능을 저하시킵니다
・ 인덱스를 활용하면 부분범위 처리가 가능하여 성능을 크게 개선할 수 있습니다
・ MAX, MIN 함수는 인덱스와 ROWNUM을 활용하여 효과적으로 대체할 수 있습니다
・ 실행계획을 통해 전체범위 처리가 발생하는지 확인하고 필요한 경우 튜닝이 필요합니다

