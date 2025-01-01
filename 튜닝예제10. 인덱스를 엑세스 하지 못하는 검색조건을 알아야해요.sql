🎯 튜닝예제10. 인덱스를 액세스하지 못하는 검색조건을 알아야해요

📝 이론 설명

인덱스는 특정 조건을 만족할 때만 효과적으로 활용됩니다. 
일부 WHERE 절 조건에서는 인덱스를 사용할 수 없어 FULL TABLE SCAN이 발생하며, 이는 성능저하로 이어집니다.

⚡ 인덱스를 액세스하지 못하는 조건

・ IS NULL 또는 IS NOT NULL 조건
・ LIKE 조건에서 와일드카드(%)를 앞에 사용
・ 부정 연산자 사용 시 (!=, <>, ^=)
・ 인덱스 컬럼을 가공했을 때

💻 실습1: IS NULL 조건 처리

➡️ 인덱스 생성:

create index emp_comm on emp(comm);

✨ 튜닝 전:

select ename, comm
from emp
where comm is null;

✨ 튜닝 후:

create index emp_comm_func on emp(nvl(comm, -1));

select ename, comm
from emp
where nvl(comm, -1) = -1;

🤔 문제1. MGR이 NULL인 사원의 이름과 MGR 을 출력하는데 튜닝후 SQL로 작성 하세요.

✨ 튜닝 후:



💻 실습2: IS NOT NULL 조건 처리

✨ 튜닝 전:

select ename, comm
from emp
where comm is not null;

✨ 튜닝 후:

create index emp_comm_fun2 on emp(nvl2(comm, 1, null));

select /*+ index(emp emp_comm_fun2) */ ename, comm
from emp
where nvl2(comm, 1, null) = 1;

💻 실습3: LIKE 조건에서의 와일드카드 사용

✨ 올바른 사용:

select ename, sal
from emp
where ename like 'S%';

✨ 문제가 되는 사용:

select ename, sal
from emp
where ename like '%T';

✨ 개선된 방법:

create index emp_ename_substr on emp(substr(ename, -1, 1));

select ename, sal
from emp
where substr(ename, -1, 1) = 'T';

🤔 문제2. 직업(JOB) 의 끝글자가 MAN 으로 끝나는 사원의 이름과 직업을 출력하세요




💻 실습4: 부정 연산자(!=, <>, ^=) 처리

✨ 튜닝 전:

select ename, job
from emp
where job != 'SALESMAN';

✨ 튜닝 후(방법 1):

select ename, job
from emp
where job in ('CLERK', 'MANAGER', 'ANALYST', 'PRESIDENT');

✨ 튜닝 후(방법 2):

create index emp_job_case
on emp(case when job != 'SALESMAN' then job end);

select ename, job
from emp
where case when job != 'SALESMAN' then job end > ' ';

⚠️ 주의사항

・ 인덱스를 사용할 수 없는 조건은 가능한 다른 방식으로 변환해야 합니다
・ 함수기반 인덱스나 CASE 문을 활용하여 인덱스 사용이 가능하도록 만듭니다
・ 실행계획을 통해 인덱스 사용 여부를 반드시 확인해야 합니다

🎓 결론

・ 인덱스를 사용할 수 없는 조건들을 정확히 이해해야 합니다
・ 적절한 대체 방법을 사용하여 인덱스를 활용할 수 있도록 합니다
・ 실행계획을 통해 튜닝 효과를 검증합니다
・ 함수기반 인덱스와 CASE 문은 효과적인 대안이 될 수 있습니다
