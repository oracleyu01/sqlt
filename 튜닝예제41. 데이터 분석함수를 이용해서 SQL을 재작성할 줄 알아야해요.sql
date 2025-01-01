🎯 예제41. 데이터 분석 함수를 이용하여 SQL 재작성

📝 이론 설명

ROLLUP 함수는 GROUP BY 절에서 계층적 합계를 생성할 때 사용되며, 추가적인 행을 포함해 소계 및 총계를 제공합니다. 이는 기존 SQL 문장을 간단하게 재작성할 수 있어 성능과 가독성을 향상시킵니다.

💻 튜닝전과 튜닝후 비교

✨ 튜닝전:
select decode(no, 1, deptno, 2, null) as deptno, sum(sal)
from emp e,
(select rownum no
from dual
connect by level <= 2) d
group by decode(no, 1, deptno, 2, null)
order by deptno;

✨ 튜닝후:
select deptno, sum(sal)
from emp
group by rollup(deptno);

📌 설명

・ 튜닝전: ROLLUP 대신 DECODE와 CONNECT BY를 사용해 수작업으로 그룹화.
・ 튜닝후: ROLLUP 함수로 그룹화 및 계층적 합계 생성.

🤔 문제: 튜닝후 SQL을 튜닝전으로 변경

✨ 튜닝후:
select job, sum(sal)
from emp
group by rollup(job)
order by job asc;

✨ 튜닝전:




📌 설명

・ 튜닝후 SQL은 ROLLUP 함수를 사용하여 계층적 합계를 생성.
・ 튜닝전 SQL은 ROLLUP 없이 DECODE와 CONNECT BY를 활용해 동일한 결과 생성.

🎓 결론

・ ROLLUP 함수는 계층적 합계와 총계를 간단히 생성할 수 있어 복잡한 SQL을 재작성하는 데 유용합니다.
・ 기존 SQL 문장을 재작성할 때 ROLLUP을 도입하면 성능과 가독성을 동시에 개선할 수 있습니다.
・ 반대로, ROLLUP을 지원하지 않는 환경에서는 DECODE와 CONNECT BY를 조합하여 동일한 결과를 얻을 수 있습니다.






