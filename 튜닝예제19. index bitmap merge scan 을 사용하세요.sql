🎯 튜닝예제19. INDEX BITMAP MERGE SCAN을 활용한 성능 최적화

📝 이론 설명

INDEX BITMAP MERGE SCAN은 여러 B-Tree 인덱스를 Bitmap 형태로 변환하여 크기를 축소한 후 병합하는 방식입니다. 기존 INDEX MERGE SCAN은 각 인덱스를 병합하여 테이블 접근 횟수를 줄이지만, INDEX BITMAP MERGE SCAN은 병합 전 인덱스를 Bitmap으로 변환해 더 작은 크기로 처리합니다. 이는 테이블의 데이터 양이 많고 여러 조건이 결합된 쿼리에서 효율적으로 작동합니다.

⭐INDEX BITMAP MERGE SCAN은 특히 다음과 같은 경우에 유용합니다:

・ 저장 공간 최적화: Bitmap은 B-Tree 인덱스보다 훨씬 적은 공간을 사용합니다.
・ 성능 향상: Bitmap으로 변환된 인덱스는 크기가 작아져, 디스크 I/O와 메모리 사용량이 줄어듭니다.
・ 복합 조건 처리: WHERE 절에 여러 조건이 결합된 경우 효과적입니다.

⚡ INDEX BITMAP MERGE SCAN의 장점

・ 인덱스를 Bitmap으로 변환해 크기를 축소하여 스캔 속도 향상
・ 여러 인덱스를 병합하여 테이블 접근을 최소화
・ Bitmap 인덱스는 결합, 교집합, 차집합 등 논리 연산을 효율적으로 수행

📖 예: 목차 10장을 1장으로 요약해 스캔

💻 실습1: INDEX MERGE SCAN 확인

@demo

create index emp_job on emp(job);
create index emp_deptno on emp(deptno);

➡️ INDEX MERGE SCAN 실행계획

select /*+ and_equal(emp emp_job emp_deptno) */ empno, ename, job, deptno
from emp
where deptno = 30 and job = 'SALESMAN';

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

📌 버퍼 읽기 수: 5개

💻 실습2: INDEX BITMAP MERGE SCAN으로 최적화

@demo

➡️ INDEX BITMAP MERGE SCAN 실행계획

select /*+ index_combine(emp) */ empno, ename, job, deptno
from emp
where deptno = 30 and job = 'SALESMAN';

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

📌 Bitmap 병합을 통해 성능이 향상되었습니다.

🤔 문제1: 새로운 환경 구성 후 아래의 SQL을 튜닝하세요.

@demo

drop table mcustsum purge;

create table mcustsum as
select rownum custno,
'2008' || lpad(ceil(rownum / 100000), 2, '0') salemm,
decode(mod(rownum, 12), 1, 'A', 'B') salegb,
round(dbms_random.value(1000, 100000), -2) saleamt
from dual
connect by level <= 1200000;

create index m_indx1 on mcustsum(custno);
create index m_indx2 on mcustsum(salemm);
create index m_indx3 on mcustsum(salegb);

➡️ 튜닝전: INDEX MERGE SCAN

select /*+ and_equal(t m_indx2 m_indx3) / count()
from mcustsum t
where salegb = 'A'
and salemm = '200801';

📌 버퍼 읽기 수: 17245개





🎓 결론

・ INDEX BITMAP MERGE SCAN은 인덱스를 Bitmap으로 변환해 크기를 줄이고 효율적으로 병합합니다.
・ 테이블 접근 최소화 및 스캔 속도 향상을 통해 자원을 절약할 수 있습니다.
・ Bitmap은 저장 공간 최적화와 함께 복합 조건의 논리 연산 처리에 효과적입니다.
・ 대규모 데이터 환경에서 인덱스 활용을 극대화하여 성능을 크게 개선할 수 있습니다.

