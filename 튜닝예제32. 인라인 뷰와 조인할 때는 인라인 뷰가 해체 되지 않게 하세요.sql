🎯 예제32. 인라인 뷰와 조인할 때는 인라인 뷰가 해체되지 않게 설정

📝 이론 설명

인라인 뷰는 SQL 내부에서 임시적으로 생성된 결과 집합입니다. 조인을 수행할 때 Query Transformer가 인라인 뷰를 해체(Merge)하면 의도한 최적화 방식이 변경될 수 있습니다. 특정 경우, 인라인 뷰를 해체하지 않도록 설정하여 성능을 최적화할 수 있습니다.

📌 힌트 설명

・ no_merge: 인라인 뷰나 뷰를 해체하지 않도록 설정합니다.
・ merge: 인라인 뷰나 뷰를 해체하여 최적화에 활용합니다.

⚠️ Query Transformer의 동작

인라인 뷰가 해체되면 독립적인 결과 집합이 사라지고, 조인의 순서와 방식이 변경될 수 있습니다.
실행 계획에 VIEW가 표시되면 인라인 뷰가 유지된 것입니다.

💻 실습: 인라인 뷰와 SALGRADE 조인

@demo

select v.ename, v.loc, s.grade
from salgrade s, (
select e.ename, e.sal, d.loc
from emp e, dept d
where e.deptno = d.deptno
) v
where v.sal between s.losal and s.hisal;

📌 문제점

・ 실행 계획에서 VIEW가 보이지 않으면 인라인 뷰가 해체된 것입니다.

・ SQL은 다음과 같이 변경되어 실행됩니다:

select e.ename, d.loc, s.grade  
from emp e, dept d, salgrade s  
where e.deptno = d.deptno  
and e.sal between s.losal and s.hisal;

💻 해결: 인라인 뷰 해체 방지

select /*+ no_merge(v) / v.ename, v.loc, s.grade
from salgrade s, (
select /+ no_merge */ e.ename, e.sal, d.loc
from emp e, dept d
where e.deptno = d.deptno
) v
where v.sal between s.losal and s.hisal;

📌 설명

・ no_merge 힌트를 사용하여 인라인 뷰를 독립된 결과 집합으로 유지.
・ 실행 계획에서 VIEW가 표시되어야 함.

🤔 문제: 아래 SQL의 인라인 뷰가 해체되지 않도록 설정

select v.ename, v.sal, v.grade, d.loc
from dept d, (
select e.ename, e.sal, s.grade, e.deptno
from emp e, salgrade s
where e.sal between s.losal and s.hisal
) v
where v.deptno = d.deptno;

💻 해결

select /*+ 적절한 힌트를 쓰세요 / v.ename, v.sal, v.grade, d.loc
from dept d, (
select /+ 적절한 힌트를 쓰세요  */ e.ename, e.sal, s.grade, e.deptno
from emp e, salgrade s
where e.sal between s.losal and s.hisal
) v
where v.deptno = d.deptno;

📌 설명

・ 인라인 뷰 v에 no_merge 힌트를 적용하여 독립된 결과 집합 유지.
・ 실행 계획에서 VIEW가 유지되었는지 확인.

🎓 결론

・ 인라인 뷰를 유지하기 위해 no_merge 힌트를 사용하여 Query Transformer의 해체를 방지합니다.
・ 실행 계획에서 VIEW가 표시되면 인라인 뷰가 유지된 것을 확인할 수 있습니다.
・ 인라인 뷰를 해체하지 않는 설정은 조인 순서와 방식을 제어하는 데 유용합니다.






