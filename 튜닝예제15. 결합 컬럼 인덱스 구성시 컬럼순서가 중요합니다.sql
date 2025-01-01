🎯 튜닝예제15. 결합 컬럼 인덱스의 최적 컬럼 순서 선정하기

📝 이론 설명

결합 컬럼 인덱스에서 컬럼의 순서는 성능에 결정적인 영향을 미치는 핵심 요소입니다. 
적절한 컬럼 순서 선정은 인덱스 스캔 범위를 최소화하고 검색 성능을 극대화할 수 있습니다.


⚡특히 중요한 두 가지 조건 유형을 이해해야 합니다:

・ 점조건(Point Condition): '=' 또는 'IN' 연산자를 사용하는 조건으로, 특정 값을 정확히 지정합니다
・ 선분조건(Range Condition): 'BETWEEN', 'LIKE' 등을 사용하는 조건으로, 값의 범위를 지정합니다

📌 결합 컬럼 인덱스 설계의 핵심 원칙:

・ 첫 번째 컬럼은 점조건이 있는 컬럼으로 선정
・ 두 번째 컬럼은 선분조건이 있는 컬럼으로 배치
・ 이렇게 구성하면 인덱스 스캔 범위가 최소화되어 성능이 향상됩니다

💻 실습1: 대용량 테이블 환경 구성

drop table mcustsum purge;

create table mcustsum
as
select rownum custno
, '2008' || lpad(ceil(rownum/100000), 2, '0') salemm
, decode(mod(rownum, 12), 1, 'A', 'B') salegb
, round(dbms_random.value(1000,100000), -2) saleamt
from dual
connect by level <= 1200000;

🤔 문제1. 아래의 SQL의 성능을 높이기 위한 결합 컬럼 인덱스를 생성하시오!

select count(*)
from mcustsum t
where salegb = 'A'
and salemm between '200801' and '200812';

답:




🤔 문제2. M_SALEGB_SALEMM 인덱스를 drop하고 salemm + salegb로 결합컬럼 인덱스를 생성하고 아래의 SQL의 Buffer의 갯수를 보시오!

drop index M_SALEGB_SALEMM;

create index m_salemm_salegb on mcustsum(salemm, salegb);

select /*+ index(t m_salemm_salegb)
no_index_ss(t m_salemm_salegb) / count()
from mcustsum t
where salegb = 'A'
and salemm between '200801' and '200812';

설명: no_index_ss(t m_salemm_salegb)는 m_salemm_salegb 인덱스를 skip scan 하지 말라는 의미입니다!

🤔 문제3. 아래의 SQL에 가장 적절한 결합 컬럼 인덱스를 생성하시오!

@demo

튜닝전:
select count(*)
from emp
where deptno between 10 and 30
and job = 'CLERK';

⚠️ 주의사항

・ 결합 컬럼 순서가 잘못되면 인덱스 스캔 범위가 불필요하게 커질 수 있습니다
・ 점조건과 선분조건의 위치를 신중히 고려해야 합니다
・ Skip Scan 힌트 사용 시 주의가 필요합니다
・ 실행계획과 버퍼 사용량을 반드시 비교 확인해야 합니다

🎓 결론

・ 결합 컬럼 인덱스에서 컬럼 순서는 성능을 좌우하는 핵심 요소입니다
・ 점조건을 첫 번째 컬럼으로 사용하면 더 효율적입니다
・ 실제 테스트 결과 적절한 컬럼 순서로 구성된 인덱스가 버퍼 사용량을 크게 줄일 수 있습니다
・ 실행계획을 통해 인덱스 사용 효율성을 반드시 검증해야 합니다.

