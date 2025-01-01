🎯 튜닝예제14. 테이블 랜덤 액세스를 줄이기 위한 결합 컬럼 인덱스 활용

📝 이론 설명

결합 컬럼 인덱스(Concatenated Index)는 여러 컬럼을 하나의 인덱스로 구성하는 강력한 튜닝 방법입니다. 
단일 컬럼 인덱스들을 개별적으로 사용할 때 발생하는 테이블 랜덤 액세스를 획기적으로 줄일 수 있습니다. 
단일 컬럼 인덱스를 사용했을 때는 2개의 인덱스를 왔다갔다 하면서 길게 스캔하지만, 
결합 컬럼 인덱스로 구성하면 아주 짧게 스캔하면서 원하는 데이터를 찾을 수 있습니다.

⚡결합 컬럼 인덱스의 주요 장점은:

・ 여러 컬럼을 동시에 검색할 때 인덱스 스캔 범위가 최소화됩니다
・ 테이블 액세스 횟수가 크게 감소합니다
・ 인덱스 자체에 정렬된 데이터를 포함하므로 추가 정렬 작업이 불필요할 수 있습니다
・ 특히 대용량 테이블에서 매우 효과적인 성능 향상을 보여줍니다

💻 실습1: emp 테이블에 deptno와 job에 결합 컬럼 인덱스를 거시오!

@demo
create index emp_deptno_job on emp(deptno, job);

💻 실습2: emp_deptno_job 결합 인덱스의 구조를 확인하시오!

select deptno, job, ROWID
from emp
where deptno >= 0;

💻 실습3: 부서번호가 20번이고 직업이 ANALYST인 사원들의 이름과 월급과 직업과 부서번호를 출력하시오! 

실행계획도 확인해서 버퍼의 갯수도 확인하세요!

select ename, sal, job, deptno
from emp
where deptno = 20 and job = 'ANALYST';
select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

💻 실습4: 아래와 같이 대용량 테이블들을 생성하시오!

drop table mcustsum purge;

create table mcustsum
as
select rownum custno
, '2008' || lpad(ceil(rownum/100000), 2, '0') salemm
, decode(mod(rownum, 12), 1, 'A', 'B') salegb
, round(dbms_random.value(1000,100000), -2) saleamt
from dual
connect by level <= 1200000;

create index m_salegb on mcustsum(salegb);
create index m_salemm on mcustsum(salemm);
create index m_salegb_salemm on mcustsum(salegb,salemm);

💻 실습5: 아래의 SQL의 실행계획을 확인해서 옵티마이져가 어떤 인덱스를 사용했는지 확인하시오!

select /*+ index(t M_SALEGB_SALEMM) / count()
from mcustsum t
where salegb = 'A'
and salemm between '200801' and '200812';

🤔 문제1. 아래의 SQL이 salegb 컬럼의 인덱스를 액세스하도록 힌트를 주고 실행하시오!

select  count()
from mcustsum t
where salegb = 'A'
and salemm between '200801' and '200812';

🤔 문제2. 아래의 SQL이 salemm 컬럼의 인덱스를 액세스하도록 힌트를 주고 실행하시오!

select  count()
from mcustsum t
where salegb = 'A'
and salemm between '200801' and '200812';

⚠️ 주의사항

・ 결합 컬럼 인덱스는 컬럼 순서가 매우 중요합니다
・ WHERE 절의 조건 순서와 인덱스 컬럼 순서를 일치시키면 더 효과적입니다
・ 과도한 결합 컬럼 인덱스는 DML 성능을 저하시킬 수 있습니다
・ 실행계획을 통해 버퍼 사용량을 반드시 확인해야 합니다

🎓 결론

・ 결합 컬럼 인덱스는 테이블 랜덤 액세스를 효과적으로 줄일 수 있습니다
・ 단일 컬럼 인덱스보다 더 나은 성능을 제공할 수 있습니다
・ 특히 대용량 테이블에서 현저한 성능 향상을 보여줍니다
・ 결합 컬럼 인덱스는 버퍼(buffer)의 갯수를 281개만 읽어 가장 효율적인 성능을 보였습니다

