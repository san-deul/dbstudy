/*
    샘플 테이블
*/
CREATE TABLE SAMPLE_T(
    NAME VARCHAR2(20 BYTE),
    KOR  NUMBER(3),
    ENG  NUMBER(3),
    MATH NUMBER(3)
);

INSERT INTO SAMPLE_T(NAME, KOR, ENG, MATH) VALUES('A', 100, 100, NULL);
INSERT INTO SAMPLE_T(NAME, KOR, ENG, MATH) VALUES('B', 100, NULL, 100);
INSERT INTO SAMPLE_T(NAME, KOR, ENG, MATH) VALUES('C', NULL, 100, 100);

COMMIT;


-- SAMPLE_T의 전체 데이터 조회하기
SELECT *
  FROM SAMPLE_T;
  

-- SAMPLE_T의 전체 데이터와 점수 합계 조회하기  
SELECT NAME, KOR, ENG, MATH
     , (KOR + ENG + MATH) AS TOTAL  -- NULL 이 포함된 연산 결과는 NULL이다.
  FROM SAMPLE_T;
  
/*
    NULL 처리 함수
    1. NVL(EXPR, VALUE IF EXPR IS NULL)
    2. NVL2(EXPR, VALUE IF EXPR IS NOT NULL, VALUE IF EXPR IS NULL)
*/  

SELECT NAME
     , NVL(KOR, 0) AS 국어
     , NVL(ENG, 0) AS 영어
     , NVL(MATH, 0) AS 수학
     , NVL(KOR, 0) + NVL(ENG, 0) + NVL(MATH, 0) AS 합계
  FROM SAMPLE_T;
  
  
-- HR계정으로 접속한뒤 문제풀이
-- 사원들의 PAY를 조회하시오
-- PAY = SALARY+COMMISSION
-- COMMISSION = SALARY * COMMISSION_PCT

  
SELECT EMPLOYEE_ID, LAST_NAME, FIRST_NAME, SALARY, COMMISSION_PCT
     , NVL2(COMMISSION_PCT, SALARY + SALARY * COMMISSION_PCT, SALARY) AS PAY
FROM EMPLOYEES;

//SALARY * (1+COMMI...) <이렇게 해두됨

  
  