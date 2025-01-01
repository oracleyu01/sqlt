🎯 튜닝예제13. 다중 인덱스를 활용한 시너지 효과 극대화하기

📝 이론 설명

데이터베이스 튜닝에서 여러 개의 우수한 인덱스를 동시에 활용하는 것은 매우 강력한 성능 최적화 방법입니다. 
특히 두 개의 인덱스가 각각 높은 선택도(Selectivity)를 가지고 있을 때, 이들을 결합하여 사용하면 놀라운 시너지 효과를 얻을 수 있습니다.

인덱스 병합(Index Merge)을 통해 얻을 수 있는 주요 이점:

・ 테이블 랜덤 액세스 횟수를 크게 줄일 수 있습니다
・ 각 인덱스의 장점을 동시에 활용할 수 있습니다
・ 더 정확한 결과 집합을 빠르게 얻을 수 있습니다

💻 실습1: 다중 인덱스 활용

➡️ 인덱스 생성:

create index emp_deptno on emp(deptno);
create index emp_job on emp(job);

✨ 두 인덱스를 동시에 활용하는 SQL:

select /*+ and_equal(emp emp_deptno emp_job) */ ename, job, deptno
from emp
where deptno = 30 and job = 'SALESMAN';

⚡ 실행 결과 분석:

・ AND-EQUAL 연산을 통해 두 인덱스를 동시에 활용
・ 각 인덱스의 RANGE SCAN이 독립적으로 수행
・ 최종적으로 테이블 액세스 횟수가 감소

🤔 문제1. 아래의 2개의 인덱스를 insurance 테이블에 생성하고 2개의 인덱스를 같이 사용하도록 아래의 SQL의 힌트를 주시오!

select 'drop index ' || lower(index_name) || ';'
from user_indexes
where table_name = 'INSURANCE';

drop index insurance_sex;
drop index insurance_age;
create index insurance_sex on insurance(sex);
create index insurance_smoker on insurance(smoker);

select id, age, sex, smoker
from insurance
where sex = 'male' and smoker = 'yes';

답:





⚠️ 주의사항

・ 인덱스 병합은 각 인덱스의 선택도가 좋을 때만 효과적입니다
・ 과도한 인덱스 병합은 오히려 성능을 저하시킬 수 있습니다
・ 실행계획을 통해 인덱스 병합이 제대로 작동하는지 확인해야 합니다

🎓 결론

・ 다중 인덱스 활용은 강력한 성능 최적화 방법입니다
・ AND-EQUAL 힌트를 통해 인덱스 병합을 유도할 수 있습니다
・ 실행계획 분석을 통해 효과를 검증해야 합니다
・ 선택도가 좋은 인덱스들의 조합이 중요합니다
