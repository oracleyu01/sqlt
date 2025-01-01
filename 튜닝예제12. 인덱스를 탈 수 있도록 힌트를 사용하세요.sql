🎯 튜닝예제12. 인덱스를 탈 수 있도록 힌트를 사용하세요

📝 이론 설명

인덱스 힌트는 옵티마이저의 실행 계획에 직접적인 영향을 주는 강력한 튜닝 도구입니다. 
때로는 옵티마이저가 최적의 인덱스를 선택하지 못하는 경우가 있는데, 
이때 힌트를 통해 특정 인덱스를 사용하도록 지시할 수 있습니다. 

특히 다음과 같은 상황에서 인덱스 힌트 사용이 효과적입니다:

・ 인덱스가 존재함에도 FULL TABLE SCAN을 선택하는 경우
・ 여러 인덱스 중에서 특정 인덱스를 선호해야 하는 경우
・ WHERE 절에 여러 조건이 AND로 연결되어 있을 때 최적의 인덱스를 지정해야 하는 경우

💻 실습1: 다중 인덱스 상황에서의 실행계획 확인

➡️ 인덱스 생성:

create index emp_deptno on emp(deptno);
create index emp_job on emp(job);

✨ 실행 SQL:

select ename, sal, deptno, job
from emp
where deptno = 20 and job = 'ANALYST';

⚡ 데이터 분포도 확인:
select count() from emp where deptno = 20; -- 5건
select count() from emp where job = 'ANALYST'; -- 2건

✨ 힌트를 사용한 SQL:
select /*+ index(emp emp_job) */ ename, sal, job, deptno
from emp
where job = 'ANALYST' and deptno = 20;

🤔 문제1. 아래의 SQL의 실행계획이 deptno의 인덱스를 사용하도록 힌트를 주시오

select ename, sal, job, deptno
from emp
where job = 'ANALYST' and deptno = 20;

답:



🤔 문제2. insurance 테이블에 아래의 2개의 인덱스를 생성하고 이 2개의 인덱스중 더 좋은 인덱스를 선택하도록 힌트를 주시오!

select 'drop index ' || lower(index_name) || ';'
from user_indexes
where table_name = 'INSURANCE';

drop index insurance_indx1;
drop index ins_age;
drop index ins_bmi;
drop index ins_expenses;

create index insurance_sex on insurance(sex);
create index insurance_age on insurance(age);

select id, age, sex, bmi
from insurance
where sex = 'female' and age = 23;

답:



🤔 문제3. 아래의 SQL의 적절한 힌트를 줘서 좋은 인덱스를 사용하도록 하시오

@demo
create index emp_empno on emp(empno);
create index emp_deptno on emp(deptno);
select empno, ename, job, deptno
from emp
where empno = 7788 and deptno = 20;

답:



⚠️ 주의사항

・ 힌트는 옵티마이저의 판단을 무시하고 강제로 실행계획을 변경하므로 신중하게 사용해야 합니다
・ 데이터의 분포도를 고려하여 적절한 인덱스를 선택해야 합니다
・ 실행계획을 통해 힌트가 제대로 적용되었는지 확인해야 합니다


🎓 결론
・ 인덱스 힌트는 옵티마이저의 판단을 개선할 수 있는 강력한 도구입니다
・ 데이터의 특성과 분포도를 이해하고 적절한 인덱스를 선택해야 합니다
・ 힌트 사용 전후의 실행계획을 비교하여 성능 개선을 확인해야 합니다
・ 무분별한 힌트 사용은 오히려 성능을 저하시킬 수 있으므로 주의가 필요합니다
