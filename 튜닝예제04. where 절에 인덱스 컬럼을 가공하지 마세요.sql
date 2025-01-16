🎯 튜닝예제4. WHERE 절에서 인덱스 컬럼을 가공하지 마세요

📝 이론 설명
인덱스 컬럼의 가공은 성능에 크게 영향을 미치는 중요한 튜닝 포인트입니다. 
WHERE 절에서 인덱스 컬럼에 함수나 연산을 적용하면, 옵티마이져는 해당 인덱스를 효과적으로 활용할 수 없게 됩니다.

⚡ 인덱스 활용의 기본 원칙

・ 인덱스는 컬럼의 원본 값을 기준으로 정렬되어 저장됩니다
・ 컬럼에 어떠한 가공(함수, 연산)을 적용하면 인덱스를 사용할 수 없습니다
・ 가공이 필요한 경우, 가능한 한 상수 쪽을 변환하는 것이 좋습니다

💻 실습1: 급여 검색 성능 개선

➡️ 먼저 인덱스 생성:
create index emp_sal on emp(sal);

✨튜닝 전:
select ename, sal
from emp
where sal * 12 = 36000;

✨튜닝 후:
select ename, sal
from emp
where sal = 36000 / 12;

📊 실습2: 문자열 함수 사용 개선

인덱스 생성:
create index emp_job on emp(job);

✨튜닝 전:
select ename, sal, job
from emp
where substr(job, 1, 5) = 'SALES';

✨튜닝 후:
select ename, sal, job
from emp
where job like 'SALES%';

🤔문제. 다음의 튜닝전 SQL 을 튜닝하세요.

➡️ 인덱스 생성:
create index emp_ename on emp(ename);
create index emp_sal on emp(sal);

✨ 튜닝 전:
select ename, sal, job
from emp
where ename || sal = 'SCOTT3000';

✨튜닝 후:




⚠️ 주의사항

・ 함수나 연산을 사용할 때는 항상 인덱스 사용 가능 여부를 고려해야 합니다
・ WHERE 절의 조건식에서는 가능한 한 인덱스 컬럼을 있는 그대로 사용합니다
・ 필요한 변환이나 연산은 상수 쪽에서 수행하는 것이 좋습니다
・ LIKE 연산자 사용 시 와일드카드(%)를 뒤에 붙이면 인덱스를 활용할 수 있습니다

💡 최적화 포인트

・ 컬럼에 함수 적용 → 상수에 함수 적용
・ 컬럼에 산술 연산 → 상수에 산술 연산
・ 문자열 가공 함수 → LIKE 연산자 활용
・ 문자열 연결 연산 → 개별 조건으로 분리

🎓 결론

・ WHERE 절에서 인덱스 컬럼을 가공하면 인덱스를 사용할 수 없습니다
・ 가공이 필요한 경우, 상수 쪽을 변환하여 인덱스를 활용할 수 있게 합니다
・ 실행계획과 버퍼 개수를 확인하여 튜닝 효과를 검증해야 합니다
・ 적절한 인덱스 활용은 SQL 성능 향상의 핵심입니다 

