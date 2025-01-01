🎯 튜닝예제7. 암시적 형변환에 주의하세요

📝 이론 설명

암시적 형변환이란 데이터베이스가 다른 데이터 타입을 자동으로 변환하는 과정을 말합니다.
예를 들어, WHERE sal = '3000'과 같이 숫자와 문자열을 비교할 때 발생합니다.

⚡ 문제점 설명

・ 암시적 형변환이 발생하면 FULL TABLE SCAN이 일어납니다
・ 이로 인해 검색 성능이 크게 저하됩니다
・ 인덱스를 제대로 활용할 수 없게 됩니다

💻 실습1: 숫자 데이터의 문자열 비교

➡️ 인덱스 생성:

create index emp_sal on emp(sal);

✨ 튜닝 전:

select ename, sal
from emp
where sal like '30%';

⚡ 실행계획 확인:

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

TO_CHAR("SAL") LIKE '30%' -- 암시적 형변환 발생

✨ 튜닝 후:

create index emp_sal_indx1 on emp(to_char(sal));

⚡ 실행계획 확인:

select * from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));

🤔 문제1. 아래의 환경을 만들고 SQL을 튜닝하시오!

@demo

drop table emp9000;

create table emp9000(
ename varchar2(10),
sal varchar2(10)
);

insert into emp9000 values('scott', '3000');
insert into emp9000 values('smith', '1000');
insert into emp9000 values('allen', '2000');
commit;

create index emp9000_sal on emp9000(sal);

✨ 튜닝 전:

select ename, sal
from emp9000
where sal = 3000;

✨튜닝 후 :






⚠️ 주의사항

・ 가급적 SQL 재작성으로 문제를 해결합니다
・ SQL 재작성이 어려운 경우에만 함수기반 인덱스를 고려합니다
・ 데이터 타입을 설계할 때부터 신중히 고려해야 합니다

🎓 결론

・ 암시적 형변환은 성능 저하의 주요 원인입니다
・ 데이터 타입을 일치시켜 SQL을 작성합니다
・ 불가피한 경우 함수기반 인덱스를 활용합니다
・ 실행계획을 통해 암시적 형변환 발생 여부를 확인합니다

