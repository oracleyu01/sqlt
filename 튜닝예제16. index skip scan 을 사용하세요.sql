🎯 튜닝예제16. INDEX SKIP SCAN을 활용한 성능 최적화

📝 이론 설명

INDEX SKIP SCAN은 결합 컬럼 인덱스를 더 효율적으로 활용할 수 있게 하는 고급 튜닝 기법입니다. 
일반적으로 결합 컬럼 인덱스는 첫 번째 컬럼이 WHERE 절에 있어야만 사용할 수 있지만, INDEX SKIP SCAN을 사용하면 이 제약을 우회할 수 있습니다.

⚡ INDEX SKIP SCAN의 작동 원리

・ 결합 인덱스의 첫 번째 컬럼을 건너뛰면서 검색을 수행합니다
・ 첫 번째 컬럼의 고유 값이 적을수록 더 효과적입니다
・ FULL TABLE SCAN을 피하고 인덱스를 활용할 수 있게 해줍니다

📌 핵심 포인트

・ 결합 컬럼 인덱스의 첫 번째 컬럼이 WHERE 절에 없어도 인덱스 사용 가능
・ INDEX_SS 힌트를 통해 명시적으로 지정 가능
・ 첫 번째 컬럼의 Distinct 값이 적을 때 효과적

💻 실습1: 결합 컬럼 인덱스의 기본 동작 확인

@demo
create index emp_deptno_job on emp(deptno, job);
select ename, job, deptno
from emp
where job = 'MANAGER';

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

설명: 결합 컬럼 인덱스는 deptno+job으로 되어 있는데 select문의 where절에서 검색되는 컬럼은 job만 있으면 인덱스를 사용하지 못하고 full table scan을 하게 됩니다.

💻 실습2: INDEX SKIP SCAN 적용

select /*+ index_ss(emp emp_deptno_job) */ ename, deptno, job
from emp
where job = 'MANAGER';

설명: emp_deptno_job 인덱스에서 부서번호별로 MANAGER를 찾아가며, 불필요한 스캔을 스킵합니다. 이는 FULL TABLE SCAN보다 효율적인 접근 방식입니다.

💻 실습3: 대용량 테이블에서의 INDEX SKIP SCAN

📝 환경 구성
・ 테스트를 위한 대용량 테이블을 생성하고 결합 인덱스를 구성합니다
・ 120만 건의 데이터를 포함하는 MCUSTSUM 테이블을 생성합니다
・ SALEMM과 SALEGB 컬럼에 대한 결합 인덱스를 생성합니다

➡️ 테이블 생성:

drop table mcustsum purge;
create table mcustsum
as
select rownum custno
, '2008' || lpad(ceil(rownum/100000), 2, '0') salemm
, decode(mod(rownum, 12), 1, 'A', 'B') salegb
, round(dbms_random.value(1000,100000), -2) saleamt
from dual
connect by level <= 1200000;

➡️ 인덱스 생성:

create index m_salemm_salegb on mcustsum(salemm,salegb);

✨ 튜닝 전:
select count(*)
from mcustsum t
where salegb = 'A';
select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

⚡ 문제점 분석:
・ INDEX FAST FULL SCAN이 발생했습니다
・ 버퍼를 3,367개나 읽어들이는 비효율이 발생했습니다
・ SALEGB가 결합 인덱스의 두 번째 컬럼이라 INDEX RANGE SCAN을 사용하지 못했습니다
・ 부분범위 처리가 아닌 전체범위 처리가 발생했습니다

✨ 튜닝 후:
select /*+ index_ss(t m_salemm_salegb) / count()
from mcustsum t
where salegb = 'A';
select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

📊 성능 개선 결과

・ 버퍼 읽기가 3,367개에서 302개로 크게 감소했습니다
・ INDEX SKIP SCAN을 통해 효율적인 인덱스 검색이 가능해졌습니다
・ 전체범위 처리에서 부분범위 처리로 개선되었습니다🤔 문제1: emp와 dept 테이블 튜닝

create index emp_job_sal on emp(job, sal);

select ename, job, sal
from emp
where sal = 1250;

🤔 문제1: 직업 종류의 갯수를 확인하세요



🤔 문제2: 부서 번호 종류의 갯수를 확인하세요



⚠️ 주의사항

・ 첫 번째 컬럼의 Distinct 값이 많으면 성능이 저하될 수 있습니다
・ 인덱스 크기가 큰 경우 신중하게 사용해야 합니다
・ 실행계획을 통해 성능 개선 여부를 반드시 확인해야 합니다

🎓 결론

・ INDEX SKIP SCAN은 결합 컬럼 인덱스 활용도를 높이는 강력한 도구입니다
・ 첫 번째 컬럼의 Distinct 값이 적을 때 특히 효과적입니다
・ 버퍼 사용량 감소를 통해 성능 향상을 확인할 수 있습니다
・ SQL 전문가 시험에서도 중요한 개념으로 다뤄집니다