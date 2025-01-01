🎯 튜닝예제18. INDEX FAST FULL SCAN을 활용한 성능 최적화

📝 이론 설명

INDEX FAST FULL SCAN은 INDEX FULL SCAN보다 빠르게 데이터를 검색할 수 있는 방식으로, 테이블을 전체 스캔하는 TABLE FULL SCAN에 비해 훨씬 적은 I/O 자원을 소모합니다.

⚡ INDEX FAST FULL SCAN의 장점

・ 데이터를 정렬하지 않으므로 처리 속도가 더 빠릅니다.
・ MULTI BLOCK I/O를 사용하여 한 번에 더 많은 데이터를 읽어옵니다.

📖 예: 책의 목차가 50장이 있을 때

・ SINGLE BLOCK I/O는 한 장씩 읽는 방식

・ MULTI BLOCK I/O는 한 번에 10장씩 읽는 방식

💻 실습1: 직업별 토탈월급을 INDEX FAST FULL SCAN으로 출력

@demo 

create index emp_job_sal on emp(job, sal);

➡️ INDEX FULL SCAN 실행계획 

select job, sum(sal) 
   from emp 
  where job is not null group by job;

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

➡️ INDEX FAST FULL SCAN 실행계획

 select /*+ index_ffs(emp emp_job_sal) */ job, sum(sal) 
      from emp 
    where job is not null group by job;

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

🤔 문제1: 부서번호별 토탈월급을 출력하며 INDEX FULL SCAN과 INDEX FAST FULL SCAN의 정렬된 결과 차이를 비교하시오.

@demo create index emp_deptno_sal on emp(deptno, sal);

✨ 튜닝전: INDEX FULL SCAN 

select deptno, sum(sal) 
  from emp 
  where deptno is not null 
  group by deptno;

✨ 튜닝후: INDEX FAST FULL SCAN 


💻 실습2: SALEGB별 토탈 매출액을 출력하며 정렬 확인

@demo drop table mcustsum purge;

create table mcustsum as select rownum custno, '2008' || lpad(ceil(rownum / 100000), 2, '0') salemm, decode(mod(rownum, 12), 1, 'A', 'B') salegb, round(dbms_random.value(1000, 100000), -2) saleamt from dual connect by level <= 1200000;

create index m_salegb_saleamt on mcustsum(salegb, saleamt);

➡️ INDEX FULL SCAN 실행계획 

select /*+ index(m m_salegb_saleamt) */ salegb, sum(saleamt) 
   from mcustsum m 
   where salegb is not null 
   group by salegb;

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

➡️ INDEX FAST FULL SCAN 실행계획 

select /*+ index_ffs(m m_salegb_saleamt) */ salegb, sum(saleamt) 
   from mcustsum m 
   where salegb is not null 
   group by salegb;

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

📌 INDEX FAST FULL SCAN은 데이터를 정렬하지 않기 때문에 결과가 더 빠르게 출력됩니다.

🤔 문제2: INDEX FAST FULL SCAN과 병렬 처리를 활용해 직업별 인원수를 출력하시오.

@demo 

create index emp_job on emp(job);

답: 


📌 PARALLEL_INDEX 힌트를 사용하면 여러 프로세스가 동시에 인덱스를 스캔하여 성능을 더욱 향상시킬 수 있습니다.

🤔 문제3: 아래 쿼리를 INDEX FAST FULL SCAN 및 병렬 처리가 가능하도록 튜닝하시오.

@demo 

create index emp_deptno on emp(deptno);

✨ 튜닝전:

 select deptno, count(*) 
   from emp 
   group by deptno;

✨ 튜닝후: 




🎓 결론

・ INDEX FAST FULL SCAN은 데이터를 정렬하지 않고 MULTI BLOCK I/O를 사용하므로 INDEX FULL SCAN보다 빠릅니다.
・ 병렬 처리를 함께 사용하면 대규모 데이터에서 추가적인 성능 향상을 기대할 수 있습니다.
・ 테이블 데이터에서 NULL 값을 제거하거나 NOT NULL 조건을 설정하면 인덱스 활용을 극대화할 수 있습니다.