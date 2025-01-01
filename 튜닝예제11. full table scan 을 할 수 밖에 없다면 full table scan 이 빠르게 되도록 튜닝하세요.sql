🎯 튜닝예제11. FULL TABLE SCAN이 불가피할 때의 성능 최적화 방법

📝 이론 설명

FULL TABLE SCAN이 불가피한 상황이 있습니다. 
이런 경우에는 FULL TABLE SCAN 자체를 최적화하여 성능을 개선할 수 있습니다. 

다음과 같은 상황에서 FULL TABLE SCAN이 발생합니다:

・ WHERE 절이 없거나 인덱스가 없는 컬럼 검색 시
・ 인덱스 생성 시
・ 부정 연산자(!=, ^=, <>) 사용 시
・ 테이블 통계정보 수집 시

💻 실습1: 병렬 처리를 통한 FULL TABLE SCAN 최적화

병렬 처리를 사용하면 여러 프로세서가 동시에 데이터를 읽을 수 있어 성능이 향상됩니다.

➡️ CPU 코어 수 확인:

select *
from v$parameter
where name like '%cpu%';

✨ 병렬 처리 예제:

select /*+ parallel(emp, 4) */ *
from emp;

🤔 문제1. 직업이 SALSMAN이 아닌 사원들의 이름과 월급과 직업을 출력하는데 병렬로 FULL SCAN 할 수 있도록 힌트를 주시오!

답:

select /*+ parallel(emp, 4) */ ename, sal, job
from emp
where job <> 'SALESMAN';


🤔 문제1. 아래의 SQL을 튜닝하시오!

select *
from insurance
where region != 'northeast';





💻 실습2: 병렬 인덱스 생성

인덱스 생성 시에도 병렬 처리를 활용할 수 있습니다.

✨ 일반 인덱스 생성:
create index emp_sal on emp(sal);

✨ 병렬 인덱스 생성:
create index emp_deptno on emp(deptno) parallel 4;

⚠️ 주의사항:

・ 인덱스 생성 후에는 병렬도를 다시 1로 변경해야 합니다

alter index emp_deptno parallel 1;

🤔 문제2. 사원 테이블에 입사일에 인덱스를 생성하는데 병렬도를 6을 주고 생성하시오! 

인덱스를 생성한 이후에 다시 병렬도를 1로 변경하시오!



💻 실습3: 부정 연산자 처리 최적화

가상 컬럼을 활용하여 부정 연산자 검색을 개선할 수 있습니다.

✨ 튜닝 전:

select ename, job
from emp
where job != 'SALESMAN';

✨ 튜닝 후:

alter table emp
add job_condition generated always as
(case when job != 'SALESMAN' then 1 else 0 end);
create index emp_job_condition on emp(job_condition);

select ename, job
from emp
where job_condition = 1;

🤔 문제1. dept 테이블의 통계정보를 수집하는데 병렬도를 4를 주고 수집하시오.

테이블 통계정보가 잘 수집되었는지도 확인하시오!




💻 실습4: 테이블 통계정보 수집 최적화

통계정보 수집도 병렬로 처리하여 성능을 개선할 수 있습니다.

✨ 일반 통계정보 수집:

analyze table emp compute statistics;

✨ 병렬 통계정보 수집:

Begin
dbms_stats.gather_table_stats(
ownname => 'C##SCOTT',
tabname => 'EMP',
cascade => TRUE,
degree => 4
);
end;
/

⚠️ 주의사항

・ 병렬 처리는 시스템 리소스를 많이 사용하므로 적절한 병렬도를 설정해야 합니다
・ 인덱스 생성 후에는 반드시 병렬도를 1로 재설정해야 합니다
・ 통계정보는 주기적으로 수집하여 최신 상태를 유지해야 합니다

🎓 결론

・ FULL TABLE SCAN이 불가피한 경우 병렬 처리를 활용하여 성능을 개선할 수 있습니다
・ 가상 컬럼과 인덱스를 활용하여 부정 연산자 검색을 최적화할 수 있습니다
・ 테이블 통계정보는 옵티마이저가 최적의 실행계획을 생성하는 데 중요한 역할을 합니다
・ 각 상황에 맞는 적절한 튜닝 방법을 선택하여 적용해야 합니다

