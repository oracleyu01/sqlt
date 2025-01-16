🎯 튜닝예제6. WHERE 절에서 인덱스 컬럼 가공이 불가피하다면 함수기반 인덱스를 생성하세요

📝 이론 설명

함수 기반 인덱스란 인덱스를 생성할 때 컬럼값에 함수를 적용하여, 가공된 값을 인덱스에 저장하는 기법입니다. 
이를 통해 가공된 값을 사용하는 SQL에서도 인덱스를 활용할 수 있습니다.

💻 실습1: jack 검색 예제

➡️ 데이터 준비:

insert into emp(empno, ename, sal) values(1111, '  jack  ', 3000);

create index emp_ename on emp(ename);

select ename, sal
from emp
where ename like '%jack%';

⚡ 실행계획 확인:

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

와일드 카드(%)가 앞에 있으면 full table scan 하게 됩니다.

💻 실습2: TRIM 함수를 활용한 검색

양쪽 공백을 제거해서 비교 검색하는 방법입니다:

select ename, sal
from emp
where trim(ename) = 'jack';

📌 TRIM 함수의 종류

・ rtrim(컬럼명) : 오른쪽 공백을 제거
・ ltrim(컬럼명) : 왼쪽 공백을 제거
・ trim(컬럼명) : 양쪽 공백을 제거

💡 SQL 튜닝의 중요성

・ Oracle DB 기준으로 1초가 넘어가는 SQL은 무조건 튜닝 대상
・ MySQL DB 기준으로는 3초 넘어가는 SQL 무조건 튜닝 대상
・ 오라클의 경우 힌트로 SQL 튜닝이 가능하지만, 다른 DB는 힌트가 없거나 잘 작동하지 않아 SQL 재작성으로 튜닝
・ SQL 튜닝 기술자가 부족하여 주로 경력자들이 담당, 신입의 경우 이 기술을 알면 좋은 대우를 받음
・ 회사들은 아직도 9i, 10g, 11g, 12c, 21c, 23A 등 다양한 버전을 사용하여 SQL튜닝 기술은 필수

💻 실습3: 함수기반 인덱스 생성

✨ 튜닝 전:

select ename, sal
from emp
where trim(ename) = 'jack';

✨ 튜닝 후:

drop index emp_ename_func;

create index emp_ename_func on emp(trim(ename));

select ename, sal
from emp
where trim(ename) = 'jack';

📊 적용 가능한 함수

・ 문자열 함수: trim, substr, upper, lower
・ 수학 함수: round, floor, ceil
・ 변환 함수: to_char, to_date

🤔 문제1. 아래와 같이 데이터를 구성하고 이름이 대문자 smith 이던 소문자 smith 이든 Smith 이든 상관없이 모두 검색되게하시오! 이름이 SMITH 인 사원의 이름과 월급을 조회하시오!

@demo
insert into emp(empno, ename, sal) values(9381, 'smith', 3400);
insert into emp(empno, ename, sal) values(9382, 'Smith', 3400);
insert into emp(empno, ename, sal) values(9381, 'SMith', 3400);
commit;

✨ 답:



🤔 문제2. 사원 테이블에 ename에 인덱스를 다음과 같이 생성하고 이름의 smith인 사원의 이름과 월급을 출력하는데 아래의 SQL을 튜닝하시오!

create index emp_ename on emp(ename);

✨ 튜닝 전:

select ename, sal
from emp
where lower(ename) = 'smith';

✨ 튜닝 후:



🤔 문제3. 아래의 SQL을 튜닝하시오! 함수기반 인덱스 생성으로 튜닝하세요

@demo
create index emp_hiredate on emp(hiredate);

✨ 튜닝 전:

select ename, hiredate
from emp
where to_char(hiredate, 'RRRR') = '1980';

✨ 튜닝 후:




🤔 문제4. 아래의 SQL을 튜닝하시오! SQL 재작성으로 튜닝하세요!

@demo
create index emp_hiredate on emp(hiredate);

✨ 튜닝 전:

select ename, hiredate
from emp
where to_char(hiredate, 'RRRR') = '1980';

✨ 튜닝 후:





⚠️ 주의사항

・ 인덱스 생성은 DML 작업의 성능 저하를 초래할 수 있습니다
・ SQL 재작성을 먼저 시도하고, 안되면 인덱스 생성을 고려하세요

🎓 결론

・ 함수기반 인덱스는 컬럼 가공이 불가피한 경우의 효과적인 대안입니다
・ SQL 재작성이 가능한 경우 이를 우선적으로 고려해야 합니다
・ 인덱스 생성은 DML 작업에 영향을 주므로 신중하게 결정해야 합니다

