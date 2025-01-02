🎯 튜닝예제25. 대량의 데이터를 조인할 때는 HASH 조인을 사용하세요

📝 이론 설명

HASH 조인은 대량의 데이터를 처리할 때 매우 효율적인 조인 방식입니다. 
HASH 알고리즘을 사용하여 테이블 데이터를 메모리에 올리고, 
메모리 내에서 조인을 수행함으로써 디스크 I/O를 최소화합니다. 
특히, 데이터 양이 많고 조인 연결고리 컬럼에 인덱스가 없을 경우 적합합니다.

📌 HASH 조인의 특징

・ 메모리 기반 조인으로 디스크 I/O를 최소화하여 성능을 향상시킵니다.
・ 작은 테이블(드라이빙 테이블)을 메모리에 올려 해시 테이블로 구성 후, 
   큰 테이블과 매칭합니다.
・ ROWID는 디스크 상의 데이터 물리적 주소를 나타내지만, 
   메모리에 올라온 데이터는 HASH 값을 사용합니다.
・ 대규모 데이터 처리에 적합하며, 회사의 데이터 환경이 대용량으로 전환됨에 따라 
   중요성이 커졌습니다.

⚠️ HASH 조인의 주의점

・ 조인 순서를 올바르게 설정해야 합니다(작은 테이블을 먼저 메모리에 올립니다).
・ 버퍼 사용량이 아닌 **A-Time(실제 수행시간)**을 기준으로 성능을 평가해야 합니다.

💻 실습1: EMP와 DEPT를 HASH 조인하여 이름과 부서위치 출력

@demo

select /*+ leading(d e) use_hash(e) */ e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno;

📌 설명

작은 테이블(DEPT)을 먼저 메모리에 올려 EMP와 HASH 조인을 수행.

💻 실습2: EMP가 HASH 테이블이 되도록 조정

@demo

select /*+ leading(e d) use_hash(d) */ e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno;

📌 설명

EMP를 해시 테이블로 설정하여 조인 순서 및 메모리 사용 최적화.

🤔 문제1: 아래 SQL을 HASH 조인으로 튜닝하시오.

✨ 튜닝전:

select /*+ leading(s t) use_hash(t) */ t.calendar_year, sum(amount_sold)
from sales200 s, times200 t
where s.time_id = t.time_id
and t.week_ending_day_id = 1582
group by t.calendar_year;

✨ 튜닝후:





📌 결과

작은 테이블(times200)을 메모리에 올려 해시 테이블로 구성하여 성능 개선.

🤔 문제2: 아래 SQL을 튜닝하시오.

drop index times200_time_id;
drop index sales200_time_id;

✨ 튜닝전:

select /*+ leading(s t) use_hash(t) / count()
from sales200 s, times200 t
where s.time_id = t.time_id;

✨ 튜닝후:





📌 결과

작은 테이블(times200)을 메모리에 올려 HASH 테이블로 구성하여 처리 시간이 개선됨.

💻 실습3: EMP, DEPT, BONUS를 HASH 조인하여 이름, 부서위치, comm2 출력

@demo

조인 순서: EMP → DEPT → BONUS
조인 방법: HASH 조인

select /*+ leading(e d b) use_hash(d) use_hash(b) */ e.ename, d.loc, b.comm2
from emp e, dept d, bonus b
where e.deptno = d.deptno and e.empno = b.empno;

📌 설명

EMP와 DEPT가 해시 조인을 수행하며, EMP가 해시 테이블로 구성됩니다.
EMP와 DEPT 조인 결과가 메모리에 올라가 BONUS와 추가 해시 조인을 수행합니다.


🤔 문제3: 위 SQL을 아래 순서와 방법으로 조정하시오.

조인 순서: DEPT → EMP → BONUS
조인 방법: HASH 조인

select /*+  이 자리에 힌트를 쓰세요  */ e.ename, d.loc, b.comm2
from emp e, dept d, bonus b
where e.deptno = d.deptno and e.empno = b.empno;


🎓 결론

・ HASH 조인은 대량의 데이터를 처리하는 데 매우 효율적이며, 
   메모리를 활용해 디스크 I/O를 줄입니다.
・ 작은 테이블을 메모리에 올려 해시 테이블로 구성하면 성능이 크게 향상됩니다.
・ 조인의 효율성은 수행시간(A-Time)과 메모리 사용량을 기준으로 평가해야 합니다.
・ NESTED LOOP 조인, HASH 조인 등 상황에 맞는 조인 방식을 사용하여 
   SQL 성능을 최적화할 수 있습니다.
