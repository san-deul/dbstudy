/*
    DDL
    1. Data Definition Language
    2. 데이터 정의어
    3. 데이터베이스 객체를 다루는 언어이다. ex)테이블
    4. 종류
        1) CREATE     : 생성
        2) ALTER      : 수정
        3) DROP       : 삭제(완전 삭제)
        4) TRUNCATE   : 삭제(내용만 삭제)
*/

/* 스크립트 만들때:테이블 먼저 삭제하고 새로운 테이블 생성 */

-- 테이블 삭제
DROP TABLE CUSTOMER_T;
DROP TABLE BANK_T;


-- 테이블 생성
CREATE TABLE BANK_T(
    BANK_CODE VARCHAR2(20 BYTE) NOT NULL,
    BANK_NAME VARCHAR2 (30 BYTE),
    CONSTRAINT PK_BANK/*제약조건 이름..테이블이름*/ PRIMARY KEY(BANK_CODE/*칼럼..누구한테 줄건지*/)
    -- ▲ BANK_CODE안에 있던 코드를 밑으로 빼냄..
);

CREATE TABLE CUSTOMER_T(
    CUST_NO NUMBER NOT NULL,
    CUST_NAME VARCHAR2(30 BYTE) NOT NULL,
    CUST_PHONE VARCHAR2(30 BYTE) UNIQUE ,--중복없음,
    CUST_AGE NUMBER(3)     CHECK(CUST_AGE >= 0 AND  CUST_AGE <= 120),
                        -- CHECK(CUST_AGE BETWEEN 0 AND 120),
    BANK_CODE VARCHAR2(20 BYTE),
    -- BANK_T 테이블의 BANK_CODE를 참조한다
    -- 외래키는 참조하는 부모키의 타입과 같아야야함
    
    CONSTRAINT PK_CUSTOMER PRIMARY KEY(CUST_NO),
    CONSTRAINT FK_CUSTOMER_BANK FOREIGN KEY(BANK_CODE) REFERENCES BANK_T(BANK_CODE)/*제약조건..테이블이름 두개 다 적어줄것*/
);

SELECT * FROM USER_CONSTRAINTS; --제약조건

/*
    테이블 수정하기
    1. 칼럼 추가하기         : ALTER TABLE 테이블명   ADD   칼럼명 데이터타입 제약조건
    2. 칼럼 정보 수정하기    : ALTER TABLE 테이블명   MODIFY 칼럼명 데이터타입 제약조건
    3. 기존 칼럼 삭제하기    : ALTER TABLE 테이블명   DROP COLUMN 칼럼명
    4. 칼럼 이름 바꾸기      : ALTER TABLE 테이블명   RENAME COLUMN 기존칼럼명 TO 신규칼럼 
    5. 테이블 이름 바꾸기    : ALTER TABLE 테이블명   RENAME TO 신규테이블명
*/


-- 1. BANK_T 에 연락처 칼럼(BANK_TEL)을 추가하시오.
    ALTER TABLE BANK_T ADD BANK_TEL VARCHAR2(15 BYTE); --

-- 2. BANK_T의 은행명(BANK_NAME) VARCHAR2(15 BYTE)로 바꾸고 필수 제약조건을 지정
    ALTER TABLE BANK_T MODIFY BANK_NAME VARCHAR2(15 BYTE) NOT NULL; --

-- 3. CUSTOMER_T의 나이(CUST_AGE) 칼럼을 삭제하시오.
    ALTER TABLE CUSTOMER_T DROP COLUMN CUST_AGE; --

-- 4. CUSTOMER_T의 연락처(CUST_PHONE) 칼럼명을 CUST_TEL로 수정하시오.
    ALTER TABLE CUSTOMER_T RENAME COLUMN CUST_PHONE TO CUST_TEL; --

-- 5. CUSTOMER_T에 등급(GRADE) 칼럼을 추가하시오. 'VIP', 'GOLD', 'SILVER', 'BRONZE' 중 하나의 값을 가지도록 설정하시오.
ALTER TABLE CUSTOMER_T ADD CUST_GRADE VARCHAR2(6 BYTE) CHECK(GRADE IN('VIP','GOLD','SILVER','BRONZE'));
                                                       //  CHECK(GRADE = 'VIP' OR GRADE = 'GOLD' OR GRADE = 'SILVER' OR GRADE = 'BRONZE');
 
-- 6. CUSTOMER_T의 고객명(CUST_NAME) 칼럼의 필수 제약조건을 없애시오. ->NOT NULL을 NULL로 바꿔라
ALTER TABLE CUSTOMER_T MODIFY CUST_NAME VARCHAR2(30 BYTE) NULL; 
//데이터타입은 바꿀 생각이 없으니, 그대로 써줘야함...
//NULL안 쓰면 NOT NULL 이 그대로 적용..수정이니까

-- 7. CUSTOMER_T의 테이블명을 CUST_T로 수정하시오
    ALTER TABLE CUSTOMER_T RENAME TO CUST_T; --
    



/*
    테이블 수정하기 - PK/FK 제약조건
    
    1. PK 관련
        1) PK 추가 : ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 PRIMARY KEY(칼럼명)
        2) PK 삭제 : 
            (1) ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명
            (2) ALTER TABLE 테이블명 DROP PRIMARY KEY
    
    2. FK 관련
        1) 추가      : ALTER TABLE 자식테이블명   ADD        CONSTRAINT 제약조건명 FOREIGN KEY(칼럼명) REFERENCES 부모테이블명(참조할 칼럼명) [옵션]
        2) 삭제      : ALTER TABLE 테이블명       DROP       CONSTRAINT 제약조건명
        3) 비활성화  : ALTER TABLE 테이블명       DISABLE    CONSTRAINT 제약조건명
        4) 활성화    : ALTER TABLE 테이블명       ENABLE     CONSTRAINT 제약조건명
*/



-- FK_CUSTOMER_BANK 제약조건을 비활성화하시오.
ALTER TABLE CUST_T DISABLE CONSTRAINT FK_CUSTOMER_BANK; 
/* 

참조무결성 위배된 데이터
원래는 부모키에 데이터가 없어서 입력을 못하는데
비활성화해서 외래키에 입력가능해짐

*/

-- FK_CUSTOMER_BANK 제약조건을 활성화하시오.
ALTER TABLE CUST_T ENABLE CONSTRAINT FK_CUSTOMER_BANK;
/*
참조무결성 위배되서
오류발생
*/


