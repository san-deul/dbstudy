/*
    서브 쿼리
    1.  메인 쿼리에 포함되는 하위 쿼리를 서브쿼리라고 한다.
        (SELECT안에 SELECT를 넣는 식)
    2.  실행순서
            서브쿼리 먼저-> 메인쿼리 추후
    3.  종류
            1) SELECT 절 : 스칼라 서브 쿼리 (결과를 반환함)  ->서브쿼리 결과값이 값일때
            2)   FROM 절 : 인라인 뷰(INLINE VIEW) ※VIEW:TABLE로 생각하길.../ TABLE 대신 들어가는
            3)  WHERE 절 : 서브쿼리
                 (1) 단일 행 서브 쿼리(결과 행이 1행)
                 (2) 다중 행 서브 쿼리(결과 행이 N행)
*/



/*
    단일 행 서브 쿼리
    1. 서브 쿼리의 실행 결과가 1행이다.
    ★2. 단일 행 서브 쿼리인 경우
        1) 함수결과를 반환하는 서브쿼리
        2) PK 또는 UNIQUE 칼럼의 동등 비교 조건을 사용한 서브 쿼리
    3. 단일 행 서브 쿼리 연산자
        =, !=, >, >=, <, <=
*/

-- 1. 사원번호가 1004인 사원의 직책을 가진 사원 조회하기

-- 서브쿼리:사원번호(PK)가 1004인 사원의 직책
-- 서브쿼리와 메인쿼리는 단일행서브쿼리 연산자를 통해 연결

SELECT * 
  FROM EMPLOYEE_T
 WHERE POSITION = (SELECT POSITION
                     FROM EMPLOYEE_T
                    WHERE EMP_NO = 1004);

-- 전체가: 메인쿼리, 괄호친게 서브쿼리.. 서브쿼리가 먼저 실행됨


-- 2. 급여 평균보다 더 큰 급여를 받는 사원 조회하기
-- 
/*
SELECT *
  FROM EMPLOYEE_T
 WHERE SALARY > 급여평균 구하는 서브쿼리; AVG(SALARY) <-요거 안됨
*/

SELECT *
  FROM EMPLOYEE_T
 WHERE SALARY > (SELECT AVG(SALARY)
                   FROM EMPLOYEE_T); -- 단일행 서브쿼리.. 함수의 결과를 반환하니까
           -- 단일행서브쿼리 연산자중 하나를(>) 통해 연결



-- ----------------------------------------------
/*
    다중 행 서브쿼리
    1. 서브 쿼리의 실행 결과가 N행이다.
    2. 다중 행 서브쿼리 연산자
        IN ★, ANY, ALL 등
        
        COLUMN > ANY(1,2,3) : 1보다 크든가 2보다 크든가 3보다 크든가
        COLUMN > MIN(1,2,3) : 보통 이렇게 씀..
*/


-- 1. 부서가 '영업부'인 사원을 조회하시오.
/*
SELECT * 
  FROM EMPLOYEE_T
 WHERE 부서명 = '영업부' < 이렇게 못적음... EMPLOYEE 에 부서명 칼럼 X
*/
/*
SELECT * 
  FROM EMPLOYEE_T
 WHERE DEPART = (영업부의 부서 번호)
*/
/*
SELECT * 
  FROM EMPLOYEE_T
 WHERE DEPART = (SELECT DEPT_NO
                   FROM DEPARTMENT_T
                  WHERE DEPT_NAME = '영업부');
                 -- DEPT_NAME 이 PK,UNIQUE 가 아니라서 다중행..
*/                
SELECT * 
  FROM EMPLOYEE_T
 WHERE DEPART IN(SELECT DEPT_NO
                   FROM DEPARTMENT_T
                  WHERE DEPT_NAME = '영업부');                 
        -- = <단일행연산자 이므로 IN으로 바꿔줘야지         



-- 2. 근무지역이 '서울'인 사원을 조회하시오.\
/*
SELECT *
  FROM EMPLOYEE_T
 WHERE DEPART = (SELECT DEPT_NO
                   FROM DEPARTMENT_T
                  WHERE LOCATION = '서울');  
                  */
-- 결과값이 2개이므로 단일행이 아니니까 = 으로 연결 불가

--
SELECT *
  FROM EMPLOYEE_T
 WHERE DEPART IN(SELECT DEPT_NO
                   FROM DEPARTMENT_T
                  WHERE LOCATION = '서울');  

  
-- ------------------------------------------------------


-- HR계정으로 접속
/*
    인라인 뷰
    1. FROM 절에 포함되는 서브쿼리이다.
    2. 서브쿼리의 실행 결과를 임시 테이블의 형식으로 FROM절에 두고 사용한다.
     ※ 뷰(VIEW):쿼리문만 가지고있는 가상테이블
    3. SELECT 문의 실행 순서를 조정할 때 사용할 수 있다. 
    
        FROM
        WHERE
        GROUP BY
        HAVIGN
        SELECT
        ORDER BY
*/
  
  
-- 1. 2번째로 입사한 사원을 조회하시오.
-- 1) HIRE_DATE의 오름차순 정렬을 한다. (입사순 정렬) -- 별명A
-- 2) 오름차순 결과에 행 번호(ROWNUM)를 붙인다.       -- 별명B
-- 3) 행 번호가 2인 데이터를 조회한다.

SELECT ROWNUM, A.*
  FROM (SELECT *
          FROM EMPLOYEES
         ORDER BY HIRE_DATE ASC) A;
         
         
-- 정렬한 테이블 A에 행번호 붙이기
-- 정렬 제일먼저 하고 행번호 붙이려고 저렇게 함. 

/*
SELECT ROWNUM, A.*②  
  FROM EMPLOYEES ①
 ORDER BY HIRE_DATE ASC③
*/ 
 SELECT B.*
   FROM (SELECT ROWNUM AS RN, A.*
           FROM (SELECT *
                   FROM EMPLOYEES
                   ORDER BY HIRE_DATE ASC) A) B
  WHERE B.RN = 2;  
  
-- ROWNUM 은 사용에 제약이 있어서, 별칭을 주고 사용하는 게 좋음
  
-- 2. 연봉 TOP 10을 조회하시오
-- 1) 연봉을 내림차순 정렬을 한다 -- 별명 A
-- 2) 결과에 행번호를 붙인다.     -- 별명 B
-- 3) 행번호가 10 이하인 데이터를 조회한다.
SELECT B.*
  FROM(SELECT ROWNUM AS RN, A.*
         FROM (SELECT *
                 FROM EMPLOYEES
                ORDER BY SALARY DESC) A) B
WHERE B.RN BETWEEN 1 AND 10;



-- 3★. 2번째로 입사한 사원을 조회하시오.
-- 1) HIRE_DATE의 오름차순 정렬을 하고 행 번호(ROW_NUMBER 함수)를 붙인다.(한번에) -- 별명A
-- 2) 행 번호가 2인 데이터를 조회한다.

SELECT A.*
  FROM (SELECT ROW_NUMBER() OVER(ORDER BY HIRE_DATE ASC) AS RN, EMPLOYEE_ID, HIRE_DATE
          FROM EMPLOYEES) A
 WHERE A.RN = 2;
 


-- 4. 연봉 TOP 10을 조회하시오
-- 1) 연봉의 내림차순 정렬을 하고 결과에 행번호(ROW_NUMBER)를 붙인다. -- 별명 A
-- 3) 행번호가 1에서 10인 데이터를 조회한다.

SELECT A.* 
  FROM (SELECT ROW_NUMBER() OVER(ORDER BY SALARY DESC) AS RN, EMPLOYEE_ID, LAST_NAME, SALARY
          FROM EMPLOYEES) A
 WHERE A.RN BETWEEN 1 AND 10; 


/*
    스칼라 서브 쿼리
    1. SELECT 절에 포함된 서브 쿼리이다.
    2. 메인 쿼리를 서브쿼리에서 사용할 수 있다.
        1 ) 비상관 쿼리 : 서브 쿼리가 메인 쿼리를 사용하지 않는다.
        2 ) 상관   쿼리 : 서브 쿼리가 메인 쿼리를 사용한다.
*/


-- 1. (비상관)부서번호가 50인 부서에 근무하는 사원의 사원번호, 사원명, 부서명 조회하시오.
-- 연습용이라서 스칼라 가져온 거지, JOIN으로 풀어도되는 거임

SELECT EMPLOYEE_ID
     , LAST_NAME
     , (SELECT DEPARTMENT_NAME
          FROM DEPARTMENTS
         WHERE DEPARTMENT_ID = 50)  -- 단일행 서브쿼리...DEPARTMENT_ID가 PK라서
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 50;



-- 2. (상관) 부서번호가 50인 부서에 근무하는 사원의 사원번호, 사원명, 부서명 조회하시오.
SELECT E.EMPLOYEE_ID
     , E.LAST_NAME
     , (SELECT D.DEPARTMENT_NAME 
          FROM DEPARTMENTS D
         WHERE D.DEPARTENT_ID = E.DEPARTMNET_ID  -- E.DEPARTMENT_ID< 서브쿼리에서 메인쿼리거 가져다쓰는 상관성...?
           AND D.DEPARTEMT_ID = 50)              -- 외부조인
  FROM EMPLOYEES E;


-- 3. 부서번호, 부서명, 사원수를 조회하시오.
SELECT D.DEPARTMENT_ID
     , D.DEPARTMENT_NAME
     , (SELECT COUNT(*)
          FROM EMPLOYEES E
         WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID ) AS 사원수
  FROM DEPARTMENTS D;

-- GD 계정으로 접속
/*
    CREATE문 과 서브쿼리
    1. 서브 쿼리 결과를 새로운 테이블로 만들 수 있다.
    2. 테이블을 복사하는 용도로도 사용할 수 있다.
    3. 형식
        CREATE TABLE 테이블명 (칼럼1, 칼럼2, ...)
        AS (SELECT 칼럼1, 칼럼2, ...)
*/

-- 1. 사원번호, 사원명, 급여, 부서번호를 조회하고 결과를 새 테이블로 생성
    CREATE TABLE EMPLOYEE_T2 ( EMP_NO, NAME, SALARY, DEPART)
    AS (SELECT EMP_NO, NAME, SALARY, DEPART
          FROM EMPLOYEE_T);
    -- ※ ->PK값은 복사되지 않음


-- 2. 부서 테이블의 구조만 복사하여 새 테이블을 생성하시오.
CREATE TABLE DEPARTMENT_T2 (DEPT_NO, DEPT_NAME, LOCATION)
AS (SELECT DEPT_NO, DEPT_NAME, LOCATION
      FROM DEPARTMENT_T
     WHERE 1 = 2); -- 언제나 FALSE인 조건... 만족하는 데이터가 없어서 구조만 복사됨


/*
    INSERT문과 서브 쿼리
    1. 서브 쿼리의 결과를 INSERT 할 수 있다.
    2. 한번에 여러 행을 INSERT 할 수 있다.
    3. 형식 
        INSERT INTO 테이블명(칼럼1, 칼럼2,...) (SELECT 칼럼1, 칼럼2, ...)
*/

-- 1. 지역이 '대구'인 부서 정보를 DEPARTMENT_T2 테이블에 삽입하시오.

INSERT INTO DEPARTMENT_T2(DEPT_NO, DEPT_NAME, LOCATION) 
(SELECT DEPT_NO, DEPT_NAME, LOCATION
   FROM DEPARTMENT_T
  WHERE LOCATION='대구');

COMMIT;




-- 2. 직급이 '과장'인 사원 정보를 '과장명단' 테이블로 생성하시오.

CREATE TABLE 과장명단(EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY )
    AS (SELECT EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY 
          FROM EMPLOYEE_T
          WHERE 1=2);

INSERT INTO 과장명단(EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY)
(SELECT EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY
   FROM EMPLOYEE_T
  WHERE POSITION = '과장');

COMMIT;







