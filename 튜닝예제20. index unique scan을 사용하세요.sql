🎯 튜닝예제20. INDEX UNIQUE SCAN을 활용한 성능 최적화

📝 이론 설명

INDEX UNIQUE SCAN은 UNIQUE 인덱스를 사용하여 특정 레코드를 고유하게 식별하는 방식으로, NON-UNIQUE 인덱스보다 검색 성능이 우수합니다. UNIQUE 인덱스는 특정 컬럼 값이 반드시 고유해야 하며, 이를 통해 데이터의 무결성을 보장할 뿐 아니라 검색 속도를 크게 향상시킵니다.

📌 특징 및 장점

・ 컬럼 값이 고유하므로 특정 값을 정확히 조회할 때 성능이 뛰어납니다.
・ 데이터 중복을 방지하며 데이터 무결성을 유지합니다.
・ 특정 조건(SQL)의 검색 효율을 극대화할 수 있습니다.

⚡ UNIQUE 인덱스를 생성하는 방법

・ 수동 생성: 사용자가 명시적으로 UNIQUE 인덱스를 생성.
・ 자동 생성: PRIMARY KEY 또는 UNIQUE 제약 조건을 정의하면 UNIQUE 인덱스가 자동으로 생성.

💻 실습1: UNIQUE 인덱스 생성 및 확인

@demo

⚡수동 생성:
create unique index emp_ename_un on emp(ename);

⚡자동 생성:
alter table emp
add constraint emp_empno_pk primary key(empno);

select index_name, uniqueness
from user_indexes
where table_name = 'EMP';

■ 실습예제1. 월급에는 NON-UNIQUE 인덱스를 생성하고 다음과 같이 SQL을 실행하면 오라클은 ename에 걸린 UNIQUE 인덱스와 sal에 걸린 NON-UNIQUE 인덱스 중 어떤 인덱스를 선택할까?

create index emp_sal on emp(sal);

select empno, ename, sal
from emp
where ename = 'SCOTT' and sal = 3000;

📌 만약 값이 중복되지 않았다면 NON-UNIQUE 인덱스보다는 UNIQUE 인덱스를 생성하는 것이 성능 향상을 위해 바람직합니다.

🤔 문제: 아래의 SQL의 검색 속도를 높이기 위한 가장 좋은 인덱스를 생성하시오!

SELECT *
from emp20
where email = 'oracleyu23@gmail.com';

답:





🎓 결론

・ UNIQUE 인덱스는 NON-UNIQUE 인덱스보다 검색 성능이 뛰어나며, 데이터 중복을 방지합니다.
・ PRIMARY KEY 또는 UNIQUE 제약 조건을 통해 UNIQUE 인덱스를 자동으로 생성할 수 있습니다.
・ 값이 고유한 컬럼에는 UNIQUE 인덱스를 적용하여 성능을 극대화하고 데이터 무결성을 유지하는 것이 바람직합니다.





