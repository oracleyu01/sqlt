##  SQL 속도가 1000배 빨라진 충격적인 튜닝 비법 50가지 🚀 | 실무 DB 성능 최적화

## 🚀 시작하는 법

## 🔍 당신의 쿼리가 느린 진짜 이유

데이터베이스가 느리다고 무조건 서버 탓을 하시나요?    
인덱스만 추가하면 모든 게 해결될 거라 생각하시나요?  

20년차 DB전문가가 알려주는 진짜 SQL 튜닝 비법을 공개합니다.

### 👥 이런 분들을 위한 강의입니다

- 데이터가 늘어날수록 점점 더 느려지는 쿼리로 고민하시는 분
- 실무에서 바로 적용할 수 있는 실전 튜닝 기법이 필요하신 분
- 대용량 데이터 처리 시 최적화 노하우를 배우고 싶으신 분
- SQL 성능 개선의 체계적인 접근 방법을 알고 싶으신 분

### ✨ 수강 후 이런 것들을 할 수 있습니다

✓ 실행 계획만 보고도 병목 구간을 파악할 수 있습니다  
✓ 상황에 맞는 최적의 인덱스 전략을 수립할 수 있습니다  
✓ 대용량 데이터 처리 시 최적의 쿼리를 작성할 수 있습니다  
✓ 서비스 특성에 맞는 튜닝 포인트를 발견할 수 있습니다

### 👨‍💻 강사 소개

- 20년 넘는 현업 경험과 강의 경력을 보유한 데이터 분석가이자 전문 튜터로서 실무 경험을 교육에 접목 
- 국내 주요 기업들의 데이터베이스 성능 최적화 컨설팅 및 튜닝 자문을 담당하며 기업 데이터 시스템 개선에 기여 
- SQL 실무 지식을 체계적으로 정리한 'SQL200제' 도서의 저자 (정보문화사 출간) 
- 오라클 성능 튜닝 전문기업 엑셈(EXEM)의 오라클 컨설턴트로서 포스코, 삼성전자등 대기업의 데이터베이스 성능 분석 및 튜닝 프로젝트 수행 

단순한 이론이 아닌, 실무에서 바로 적용할 수 있는  
실전 SQL 튜닝의 모든 것을 알려드립니다.

## 수업 자료( ☀️ 2025년  1월 1일 updated)

### 실행계획 이해하기
- 튜닝예제1. select 문의 실행과정 3단계를 먼저 아셔야해요 | 💬[설명그림](링크) | 📄[관련 코드](링크)
- 튜닝예제2. 옵티마이져가 뭔지 알아야해요 | 📄[관련 코드](링크)
- 튜닝예제3. 실행계획의 종류 2가지를 알아야합니다 | 📄[관련 코드](링크)
- 튜닝예제4. where 절에 인덱스 컬럼을 가공하지 마세요 | 📄[관련 코드](링크)
- 튜닝예제5. having 절에 일반 검색조건을 쓰지 마세요 | 📄[관련 코드](링크)

### WHERE절과 인덱스 튜닝
- 튜닝예제6. where에 인덱스 컬럼 가공이 불가피하다면 함수기반 인덱스를 생성하세요 | 📄[관련 코드](링크)
- 튜닝예제7. 암시적 형변환에 주의하세요 | 📄[관련 코드](링크)
- 튜닝예제8. order by를 통한 과도한 정렬작업을 피하세요 | 📄[관련 코드](링크)
- 튜닝예제9. 그룹함수 대신에 인덱스를 사용해서 SQL을 튜닝하세요 | 📄[관련 코드](링크)
- 튜닝예제10. 인덱스를 엑세스 하지 못하는 검색조건을 알아야해요 | 📄[관련 코드](링크)

### 인덱스 스캔과 테이블 스캔
- 튜닝예제11. full table scan을 할 수 밖에 없다면 full table scan이 빠르게 되도록 튜닝하세요 | 📄[관련 코드](링크)
- 튜닝예제12. 인덱스를 탈 수 있도록 힌트를 사용하세요 | 📄[관련 코드](링크)
- 튜닝예제13. 훌륭한 인덱스 2개를 같이 사용하여 시너지 효과를 볼 수 있어요 | 📄[관련 코드](링크)
- 튜닝예제14. 테이블 랜덤 엑세스를 줄이기 위해 결합 컬럼 인덱스를 사용하세요 | 📄[관련 코드](링크)
- 튜닝예제15. 결합 컬럼 인덱스 구성시 컬럼순서가 중요합니다 | 📄[관련 코드](링크)

### 다양한 인덱스 활용
- 튜닝예제16. index skip scan을 사용하세요 | 📄[관련 코드](링크)
- 튜닝예제17. index full scan을 사용하세요 | 📄[관련 코드](링크)
- 튜닝예제18. index fast full scan을 사용하세요 | 📄[관련 코드](링크)
- 튜닝예제19. index bitmap merge scan을 사용하세요 | 📄[관련 코드](링크)
- 튜닝예제20. index unique scan을 사용하세요 | 📄[관련 코드](링크)

### 조인 튜닝의 기초
- 튜닝예제21. 조인문장을 튜닝할 때 조인 순서 튜닝이 중요합니다 | 📄[관련 코드](링크)
- 튜닝예제22. 검색조건에 따라 조인 순서를 잘 정해줘야합니다 | 📄[관련 코드](링크)
- 튜닝예제23. 조인되는 데이터의 양이 작을 때는 nested loop조인으로 조인하세요 | 📄[관련 코드](링크)
- 튜닝예제24. 3개 이상의 테이블을 nested loop조인으로 조인할 때 힌트 사용법을 알아야 해요 | 📄[관련 코드](링크)
- 튜닝예제25. 대량의 데이터를 조인할 때는 해쉬조인을 사용하세요 | 📄[관련 코드](링크)

### 고급 조인 튜닝
- 튜닝예제26. 3개의 테이블을 해쉬 조인 할때 해쉬 테이블을 선택할 수 있어요 | 📄[관련 코드](링크)
- 튜닝예제27. 해쉬조인이 안되는 연산자가 있어요 | 📄[관련 코드](링크)
- 튜닝예제28. 대량의 테이블을 조인하는데 해쉬조인을 할 수 없다면 sort merge join을 하세요 | 📄[관련 코드](링크)
- 튜닝예제29. 아우터 조인은 이렇게 튜닝해야합니다 | 📄[관련 코드](링크)
- 튜닝예제30. 3개 이상의 테이블을 조인할 때 조인 방법을 다양하게 조절할 줄 알아야해요 | 📄[관련 코드](링크)

### 특수 조인과 뷰 튜닝
- 튜닝예제31. 선택적 조인을 하면서 조인의 성능을 높일 수 있어요 | 📄[관련 코드](링크)
- 튜닝예제32. 인라인 뷰와 조인할 때는 인라인 뷰가 해체 되지 않게 하세요 | 📄[관련 코드](링크)
- 튜닝예제33. 뷰와 조인을 할 때 조인 순서를 조정할 수 있어요 | 📄[관련 코드](링크)
- 튜닝예제34. 조인의 성능을 높이고 싶다면 MVIEW 생성을 고려하세요 | 📄[관련 코드](링크)
- 튜닝예제35. 서브쿼리문에서 서브쿼리의 데이터가 작으면 서브쿼리부터 수행되게 해야해요 | 📄[관련 코드](링크)

### 서브쿼리 튜닝
- 튜닝예제36. push_subq와 no_push_subq와의 짝꿍힌트를 알아야 해요 | 📄[관련 코드](링크)
- 튜닝예제37. 서브쿼리를 세미조인으로 변경해서 수행되게 하세요 | 📄[관련 코드](링크)
- 튜닝예제38. 해쉬 세미 조인도 서브쿼리 부터 수행되게 할 수 있어요 | 📄[관련 코드](링크)
- 튜닝예제39. not in 연산자를 사용한 서브쿼리문을 튜닝할 줄 알아야해요 | 📄[관련 코드](링크)
- 튜닝예제40. in 연산자를 exists로 변경해서 튜닝할 줄 알아야해요 | 📄[관련 코드](링크)

### 분석 함수와 SQL 재작성
- 튜닝예제41. minus를 not exists 문으로 변경해서 튜닝하세요 | 📄[관련 코드](링크)
- 튜닝예제42. 데이터 분석함수를 이용해서 SQL을 재작성할 줄 알아야해요(첫번째) | 📄[관련 코드](링크)
- 튜닝예제43. 데이터 분석함수를 이용해서 SQL을 재작성할 줄 알아야해요(두번째) | 📄[관련 코드](링크)
- 튜닝예제44. 데이터 분석함수를 이용해서 SQL을 재작성할 줄 알아야해요(세번째) | 📄[관련 코드](링크)
- 튜닝예제45. 데이터 분석함수를 이용해서 SQL을 재작성할 줄 알아야해요(네번째) | 📄[관련 코드](링크)

### 고급 SQL 튜닝
- 튜닝예제46. 데이터 분석함수를 이용해서 SQL을 재작성할 줄 알아야해요(다섯번째) | 📄[관련 코드](링크)
- 튜닝예제47. update 문의 튜닝방법을 잘알아야해요 | 📄[관련 코드](링크)
- 튜닝예제48. 파티션 테이블이 뭔지 알아야해요 | 📄[관련 코드](링크)
- 튜닝예제49. 리스트 파티션이 뭔지 알아야해요 | 📄[관련 코드](링크)
- 튜닝예제50. 해쉬 파티션이 뭔지 알아야해요 | 📄[관련 코드](링크)

## 강의 안내

위의 수업 내용은 강남 아이티윌 교육센터에서 수강하실 수 있습니다.

### 👨‍🏫 강사
**강남 아이티윌 교육센터 유연수 강사**

### 🏆 수강생 실적
- 수료생 추천 1위! 
- 누적 수강생 2천명 돌파!
- 비전공자, 입문자도 가능한 데이터 분석 전문가 과정!

### 📞 문의하기
- **전화 문의:** 02-6255-8002
- **카카오톡 문의:** [아이티윌 상담 페이지](https://www.itwill.co.kr/cmn/sym/mnu/mpm/1061100/htmlMenuView.do)

### ⚡ SQL 관련 온라인 강좌 추천

Offline 수업을 수강하시기 어려우시다면 온라인 강의를 추천합니다. 


### **초보자도 쉽게 배우는 SQL200제**

<a href="https://www.inflearn.com/course/%EB%8D%B0%EC%9D%B4%ED%84%B0-%EB%B6%84%EC%84%9D%EA%B0%80-%EC%8B%A4%EB%AC%B4-sql">
    <img src="SQL200.png" alt="SQL200" style="width:300px;">
</a>



&nbsp;

