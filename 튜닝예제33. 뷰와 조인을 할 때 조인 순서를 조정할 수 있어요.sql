🎯 예제33. 뷰와 조인을 할 때 조인 순서를 조정하기

📝 이론 설명

뷰(View)를 활용한 조인은 SQL 작성 시 직관성을 높이는 동시에 재사용 가능한 데이터 집합을 제공합니다. 그러나 Query Transformer가 뷰를 해체(Merge)할 경우, 뷰의 독립성을 유지하지 못하여 실행 계획에 영향을 미칠 수 있습니다. 힌트를 활용해 뷰의 해체를 방지하고, 조인 순서와 방법을 명확히 지정할 수 있습니다.

📌 힌트 설명

・ no_merge: 뷰를 해체하지 않도록 설정.
・ leading: 조인 순서를 명시적으로 지정.
・ use_nl: NESTED LOOP 조인을 강제.


💻 실습예제1: EMP_DEPT 뷰와 SALGRADE 조인

@demo

create or replace view emp_dept as
select e.ename, e.sal, d.loc, e.deptno
from emp e, dept d
where e.deptno = d.deptno;

select v.ename, v.sal, v.loc, s.grade
from emp_dept v, salgrade s
where v.sal between s.losal and s.hisal;

💻 실습예제2: 뷰 해체 방지

답:  
  

📌 설명

・ no_merge(v) 힌트를 사용해 EMP_DEPT 뷰를 해체하지 않도록 설정.
・ 실행 계획에서 VIEW가 유지되었는지 확인.


💻 실습예제3: 조인 순서와 방법 설정

조인 순서: EMP_DEPT 뷰 → SALGRADE
조인 방법: NESTED LOOP 조인

답:



  

📌 설명

・ EMP_DEPT 뷰를 먼저 조회하고, SALGRADE와 NESTED LOOP 방식으로 조인.
・ no_merge(v)로 뷰 해체 방지, leading(v,s)로 조인 순서 지정.

🤔 문제: EMP_DEPT 뷰 내부 조인 순서와 방법 설정

・ 조인 순서: EMP → DEPT
・ 조인 방법: NESTED LOOP 조인


답: 





📌 설명

・ EMP_DEPT 뷰 내부에서 EMP → DEPT 순으로 NESTED LOOP 조인을 수행하도록 설정.
・ leading(v.e v.d)와 use_nl(v.d)로 EMP와 DEPT 간 조인 순서 및 방식을 명확히 지정.

🎓 결론

・ 뷰를 활용한 조인에서 힌트를 사용해 뷰 해체를 방지하고, 의도한 실행 계획을 유지할 수 있습니다.
・ **no_merge**를 통해 뷰를 독립적으로 유지하고, leading 및 **use_nl**로 조인 순서와 방법을 지정하면 성능을 최적화할 수 있습니다.
