--1. JOB테이블에서 JOB_NAME의 정보만 출력되도록 하시오
SELECT JOB_NAME
FROM JOB;
--2. DEPARTMENT테이블의 내용 전체를 출력하는 SELECT문을 작성하시오
SELECT * FROM DEPARTMENT;
--3. EMPLOYEE 테이블에서 이름(EMP_NAME),이메일(EMAIL),전화번호(PHONE),고용일(HIRE_DATE)만 출력하시오
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE
FROM EMPLOYEE;
--4. EMPLOYEE 테이블에서 고용일(HIRE_DATE) 이름(EMP_NAME),월급(SALARY)를 출력하시오
SELECT HIRE_DATE, EMP_NAME, SALARY
FROM EMPLOYEE;
--5. EMPLOYEE 테이블에서 월급(SALARY)이 2,500,000원이상인 사람의 EMP_NAME 과 SAL_LEVEL을 출력하시오 
--    (힌트 : >(크다) , <(작다) 를 이용)
SELECT EMP_NAME, SAL_LEVEL
FROM EMPLOYEE
WHERE SALARY >= 2500000;
--6. EMPLOYEE 테이블에서 월급(SALARY)이 350만원 이상이면서 
--    JOB_CODE가 'J3' 인 사람의 이름(EMP_NAME)과 전화번호(PHONE)를 출력하시오
--    (힌트 : AND(그리고) , OR (또는))
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND JOB_CODE = 'J3';
--7. EMPLOYEE 테이블에서 이름, 연봉, 총수령액(보너스포함), 실수령액(총 수령액-(월급*세금 3%))가 출력되도록 하시오
SELECT EMP_NAME AS 이름, SALARY * 12 AS 연봉, (SALARY + SALARY * NVL(BONUS, 0)) * 12 AS 총수령액, ((SALARY + SALARY * NVL(BONUS, 0)) - (SALARY * 0.03)) * 12 AS 실수령액
FROM EMPLOYEE;
--8. EMPLOYEE 테이블에서 이름, 근무 일수(입사한지 몇일인가)를 출력해보시오. (날짜도 산술연산가능함.)
SELECT EMP_NAME, HIRE_DATE, FLOOR(SYSDATE - HIRE_DATE) || '일' AS 근무일수
FROM EMPLOYEE;
--9. EMPLOYEE 테이블에서 20년 이상 근속자의 이름,월급,보너스율를 출력하시오
SELECT EMP_NAME, SALARY, NVL(BONUS, 0)
FROM EMPLOYEE
WHERE FLOOR(SYSDATE - HIRE_DATE) / 365 >= 20;
--10.EMPLOYEE 테이블에서 고용일이 90/01/01 ~ 01/01/01 인 사원의 전체 내용을 출력하시오
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';
--11.이름에 '이'가 들어가는 사원을 모두 출력하세요.
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%이%';
--12.EMPLOYEE 테이블에서 이름 끝이 연으로 끝나는 사원의 이름을 출력하시오
SELECT EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%연';
--13.EMPLOYEE 테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 출력하시오
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';
--14 EMPLOYEE 테이블에서 메일주소 '_'의 앞이 4자이면서, DEPT_CODE가 D9 또는 D6이고
--고용일이 90/01/01 ~ 00/12/01이면서, 월급이 270만원이상인 사원의 전체 정보를 출력하시오
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE IN('D9', 'D6') AND HIRE_DATE BETWEEN '90/01/01' AND '00/12/01' AND SALARY >= 2700000;
--15. 부서 배치를 받지 않았지만 보너스를 지급하는 직원 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;
--16. 관리자도 없고 부서 배치도 받지 않은 직원 이름 조회
SELECT EMP_NAME
FROM EMPLOYEE 
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;