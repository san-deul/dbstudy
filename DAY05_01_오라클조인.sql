/* 오라클 조인 */

/* 내부조인 */
-- 1. 사원번호, 사원명, 부서번호, 부서명을 조회하시오.
SELECT E.EMP_NO, E.NAME, E.DEPART, D.DEPT_NAME
  FROM DEPARTMENT_T D , EMPLOYEE_T E
 WHERE D.DEPT_NO = E.DEPART;
    
    
-- 2. 부서별 평균연봉을 조회하시오. 부서명과 평균연봉을 조회하시오.
SELECT D.DEPT_NAME, AVG(E.SALARY)
  FROM DEPARTMENT_T D , EMPLOYEE_T E
 WHERE D.DEPT_NO = E.DEPART
 GROUP BY D.DEPT_NAME;
 

 /*
    외부 조인(OUTER JOIN)
*/
  
-- 1. 모든 사원들의 사원번호, 사원명, 부서명을 조회하시오.
SELECT E.EMP_NO, E.NAME, D.DEPT_NAME
  FROM DEPARTMENT_T D , EMPLOYEE_T E
 WHERE D.DEPT_NO(+) = E.DEPART; -- 오른쪽 조인은 왼쪽에 (+) 추가하기


-- 2. 부서별 사원수를 조회하시오. 부서명, 사원수를 조회하시오. 사원이 없으면 0으로 조회하시오.
SELECT D.DEPT_NAME, COUNT(E.EMP_NO) -- COUNT(*) 는 전체칼럼이니까 데이터가 하나만 있어도 구해짐...
  FROM DEPARTMENT_T D , EMPLOYEE_T E
  WHERE D.DEPT_NO = E.DEPART(+) --왼쪽 조인은 오른쪽에 (+) 추가하기
 GROUP BY D.DEPT_NAME; 
 
 
 
-- HR 계정으로 접속
-- 내부조인

-- 1. 사원번호, 사원명, 부서명을 조회하시오.
SELECT E.EMPLOYEE_ID, E.LAST_NAME, D.DEPARTMENT_NAME
  FROM DEPARTMENTS D , EMPLOYEES E
 WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID;
-- -> 106 명, 부서없는 사람(NULL)이 조회안됨
    
    
-- 2. 부서번호, 부서명, 지역명을 조회하시오.
SELECT D.DEPARTMENT_ID, D.DEPARTMENT_NAME, L.STREET_ADDRESS
  FROM LOCATIONS L , DEPARTMENTS D 
 WHERE L.LOCATION_ID = D.LOCATION_ID;


-- 3. 사원번호, 사원명, 직업, 직업별 최대연봉, 연봉을 조회하시오.
SELECT E.EMPLOYEE_ID, E.LAST_NAME, E.JOB_ID, J.MAX_SALARY, E.SALARY
  FROM JOBS J , EMPLOYEES E
 WHERE J.JOB_ID = E.JOB_ID;
    
-- 외부조인
-- 4. 사원번호, 사원명, 부서명을 조회하시오. 부서가 없으면 '부서없음' 으로 조회하시오.
SELECT E.EMPLOYEE_ID, E.LAST_NAME, NVL(D.DEPARTMENT_NAME, '부서없음')
  FROM DEPARTMENTS D , EMPLOYEES E
 WHERE D.DEPARTMENT_ID(+) = E.DEPARTMENT_ID;
-- ->부서없는 사람까지 조회되게


-- 5. 부서별 평균급여를 조회하시오. 부서명, 평균급여를 조회하시오.근무중인 사원이 없으면 평균급여를 0으로 조회하시오.
SELECT D.DEPARTMENT_NAME, NVL(AVG(E.SALARY), 0)
  FROM DEPARTMENTS D , EMPLOYEES E
 WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID(+)
 GROUP BY D.DEPARTMENT_ID, D.DEPARTMENT_NAME;
-- ※ 종속관계는 그중 대표를 가지고 그룹핑하는 게 좋음
 

 
-- 3개 이상 테이블 조인하기

-- 6. 사원번호, 사원명,   부서번호, 부서명,   지역번호, 지역명을 조회하시오.
SELECT E.EMPLOYEE_ID , E.LAST_NAME, D.DEPARTMENT_ID, D.DEPARTMENT_NAME, L.LOCATION_ID, L.STREET_ADDRESS
  FROM DEPARTMENTS D , EMPLOYEES E , LOCATIONS L
 WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID 
   AND D.LOCATION_ID = L.LOCATION_ID;
    
-- 6.부서랑 지역 먼저... 그 후에 사원
SELECT E.EMPLOYEE_ID , E.LAST_NAME, D.DEPARTMENT_ID, D.DEPARTMENT_NAME, L.LOCATION_ID, L.STREET_ADDRESS
  FROM LOCATIONS L , DEPARTMENTS D , EMPLOYEES E
 WHERE L.LOCATION_ID = D.LOCATION_ID 
   AND D.DEPARTMENT_ID = E.DEPARTMENT_ID;
    

-- 7. 국가명, 도시명, 부서명을 조회하시오.
SELECT C.COUNTRY_NAME, L.CITY, D.DEPARTMENT_NAME
  FROM COUNTRIES C , LOCATIONS L , DEPARTMENTS D
 WHERE C.COUNTRY_ID = L.COUNTRY_ID 
   AND L.LOCATION_ID = D.LOCATION_ID;


-- 셀프 조인( 하나의 테이블에 일대다 관계를 가지는 칼럼들이 존재하는 경우)
-- 8. 사원번호, 사원명, 매니저번호, 매니저명을 조회하시오.

-- 사원테이블   : EMPLOYEES E ->사원번호, 사원명
-- 매니저테이블 : EMPLOYEES M -> 매니저번호, 매니저명
-- 같은 테이블 안이라도 별명을 다르게 주면 서로 다른 테이블처럼 생각하면됨

-- 관계
-- 1명의 매니저가 N명의             사원을 관리한다.
-- 1                                 N
-- 
-- 매니저테이블 : EMPLOYEES M         사원테이블   : EMPLOYEES E
-- PK           : EMPLOYEE_ID         FK           : MANAGER_ID


SELECT E.EMPLOYEE_ID  AS 사원번호
     , E.LAST_NAME    AS 사원명
     , E.MANAGER_ID   AS 매니저번호
     , M.LAST_NAME    AS 매니저명
  FROM EMPLOYEES M , EMPLOYEES E
 WHERE M.EMPLOYEE_ID = E.MANAGER_ID;


-- 9. 같은 부서내에서 나보다 급여를 더 많이 받는 사원을 조회하시오.
-- 관계
-- 나는 여러 사원과 관계를 맺는다.
-- 나(EMPLOYEES ME)                  너님들(EMPLOYEES YOU)
--같은 부서의 사원만 조인하기 위해 부서 번호로 조인조건을 생성함

SELECT ME.EMPLOYEE_ID AS 사원번호
     , ME.LAST_NAME   AS 사원명
     , ME.SALARY      AS 급여
     , YOU.EMPLOYEE_ID   AS 너사원번호
     , YOU.LAST_NAME  AS 너사원명
     , YOU.SALARY     AS 너급여
  FROM EMPLOYEES ME , EMPLOYEES YOU
 WHERE ME.DEPARTMENT_ID = YOU.DEPARTMENT_ID
   AND ME.SALARY < YOU.SALARY;





    
    
    
    