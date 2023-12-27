/*
    테이블(table)
    1. 관계형 데이터베이스에서 데이터를 저장하는 객체이다.
    2. 표 형식을 가진다.
    3. 행(row)과 열(column)의 집합 형식이다.
*/

/*
    테이블 만들기
    1. 열(column)을 만드는 과정이다.
    2. 테이블 만드는 쿼리문
        CREATE TABLE 테이블이름(
            칼럼이름1 데이터타입 제약조건,
            칼럼이름2 데이터타임 제약조건,
            ...
        );    
*/
/*
    데이터타입
    1. NUMBER(p,s) : 정밀도가 p이고, 스케일이 s인 숫자
        1) 정밀도 p : 전체유효숫자 ex)0123:3, 123:3, 1.2:2
        2) 스케일 s : 소수부의 유효숫자 ex)1.2 p:2 s:1, number(2,1)
        ex)number(2,2) 0.xx ->0은 유효숫자로 인식하지 않음
        보통 p,s는 생략함...
        3) 스케일만 생략하면 정수료 표시하는 숫자
        ex)number(3) ->scale생략된거 
        4) 정밀도와 스케일을 생략하면 정수,실수 모두 표시할 수 있는 숫자
    2. CHAR(size) : 글자수가 최대 size인 고정 문자타입
        1) 고정 문자 : 글자수의 변동이 적은 문자(예시:휴대전화번호, 주민번호 등)
        2) 최대 size : 2000 byte
        //가능한 쓰지말것
    3. VARCHAR2(size) : 글자수가 최대 size인 가변 문자
        1) 가변 문자: 글자수의 변동이 큰 문자(예시: 이름, 주소 등)
        2) 최대 size : 4000 byte
        char(5):'abc' == varchar2(5):'abc' -> false
        char(5):'abc__' / varchar2(5):'abc' <-이런식으로 내부동작
    4. CLOB : VARCHAR2(size)로 처리할 수 없는 큰 문자...4000byte넘어가는거
    5. DATE : 날짜/시간(년,월,일,시,분,초)
    6. TIMESTAMP : 좀 더 정밀한 날짜/시간(년,월,일,시,분,초,마이크로초(백만분의1초))
*/
/*
    제약조건 5가지
    1. NOT NULL : 필수 입력
    2. UNIQUE : 중복 불가
    3. PRIMARY KEY : 기본키 -식별자...찾아올때..주로 번호 ex)주민등록번호,학번,제품번호
    -필수적으로 가지고있으면서 , 다른 기본키값과 중복이 있으면 X
    -not null , unique의 특성을가지고있음
    4. FOREIGN KEY : 외래키
    5. CHECK : 작성한 조건으로 값의 제한
*/

-- 블로그 구현을 위한 블로그 테이블
CREATE TABLE BLOG_T (
    BLOG_NO  NUMBER             NOT NULL PRIMARY KEY,
    TITLE    VARCHAR2(100 BYTE) NOT NULL,
    EDITOR   VARCHAR2(100 BYTE) NOT NULL,
    CONTENTS CLOB               NULL, -- NULL은 생략가능함..
    CREATED  DATE               NOT NULL
);

-- 블로그테이블 삭제
DROP TABLE BLOG_T;