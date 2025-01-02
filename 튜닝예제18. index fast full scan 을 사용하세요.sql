

🎯 튜닝예제18. INDEX FAST FULL SCAN을 활용한 성능 최적화

📝 이론 설명

INDEX FAST FULL SCAN은 INDEX FULL SCAN보다 빠르게 데이터를 검색할 수 있는 방식으로, 
테이블을 전체 스캔하는 TABLE FULL SCAN에 비해 훨씬 적은 I/O 자원을 소모합니다.

⚡ INDEX FAST FULL SCAN의 장점

・ 데이터를 정렬하지 않으므로 처리 속도가 더 빠릅니다.
・ MULTI BLOCK I/O를 사용하여 한 번에 더 많은 데이터를 읽어옵니다.

📖 예: 책의 목차가 50장이 있을 때

・ SINGLE BLOCK I/O는 한 장씩 읽는 방식 (index full scan 방식)

・ MULTI BLOCK I/O는 한 번에 10장씩 읽는 방식(index fast full scan 방식식)

💻 실습1: 직업별 토탈월급을 INDEX FAST FULL SCAN으로 출력

@demo 

create index emp_job_sal on emp(job, sal);

➡️ INDEX FULL SCAN 실행계획 

select job, sum(sal) 
   from emp 
   where job is not null 
   group by job;

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

➡️ INDEX FAST FULL SCAN 실행계획

 select /*+ index_ffs(emp emp_job_sal) */ job, sum(sal) 
      from emp 
    where job is not null group by job;

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

출력결과가 직업을 ABCD 순서데로 정렬을 해서 볼 필요가 없다면
INDEX FULL SCAN 보다는 INDEX FAST FULL SCAN 을 하는게 더 성능이 좋습니다.

🤔 문제1: 아래의 SQL을 튜닝하시오 !  

index full scan 이 나오면 index fast full scan 으로 수행되게하시오! 

@demo 
create index emp_deptno_sal on emp(deptno, sal);

✨ 튜닝전: INDEX FULL SCAN 

select deptno, sum(sal) 
  from emp 
  where deptno is not null 
  group by deptno;


select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));


✨ 튜닝후: INDEX FAST FULL SCAN 



💻 실습2. INDEX FAST FULL SCAN과 병렬 처리를 활용해 직업별 인원수를 출력하시오.

index  full scan 보다 index fast full scan 을 했을때의 장점이 
병렬 쿼리 처리를 수행할 수 있습니다. 

@demo 
create index emp_job on emp(job);

답:  select /*+ index_ffs(emp emp_job) 
                parallel_index(emp, emp_job, 4) */ job,  count(*)
        from  emp
        where  job is  not null
        group  by  job;

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

📌 PARALLEL_INDEX 힌트를 사용하면 여러 프로세스가 동시에 인덱스를 
    스캔하여 성능을 더욱 향상시킬 수 있습니다.

 index full scan 은 parallel_index 를 같이 못사용합니다. 

🤔 문제2: 아래 쿼리를 INDEX FAST FULL SCAN 및 병렬 처리가 가능하도록 튜닝하시오.

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
