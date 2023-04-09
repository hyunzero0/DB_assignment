--문제1
--기술지원부에 속한 사람들의 사람의 이름,부서코드,급여를 출력하시오. 
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_ID FROM DEPARTMENT WHERE DEPT_TITLE = '기술지원부');

--문제2
--기술지원부에 속한 사람들 중 가장 연봉이 높은 사람의 이름,부서코드,급여를 출력하시오
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM (SELECT EMP_NAME, DEPT_CODE, SALARY
            FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
            WHERE DEPT_TITLE = '기술지원부'
            ORDER BY SALARY DESC)
WHERE ROWNUM = 1;

--문제3
--매니저가 있는 사원중에 월급이 전체사원 평균을 넘고 
--사번,이름,매니저 이름, 월급을 구하시오. 
--1. JOIN을 이용하시오
SELECT E.EMP_ID, E.EMP_NAME, M.EMP_NAME AS 매니저이름, E.SALARY
FROM EMPLOYEE E JOIN EMPLOYEE M ON M.EMP_ID = E.MANAGER_ID
WHERE E.SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);

--2. JOIN하지 않고, 스칼라상관쿼리(SELECT)를 이용하기
SELECT E.EMP_ID, E.EMP_NAME, (SELECT M.EMP_NAME FROM EMPLOYEE M WHERE E.MANAGER_ID = M.EMP_ID) AS 매니저이름, E.SALARY
FROM EMPLOYEE E
WHERE E.SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE) AND E.MANAGER_ID IS NOT NULL;

--문제4
--같은 직급의 평균급여보다 같거나 많은 급여를 받는 직원의 이름, 직급코드, 급여, 급여등급 조회
SELECT EMP_NAME, JOB_CODE, SALARY, SAL_LEVEL
FROM EMPLOYEE E
WHERE SALARY >= (SELECT AVG(SALARY) FROM EMPLOYEE WHERE E.JOB_CODE = JOB_CODE);

--문제5
--부서별 평균 급여가 2200000 이상인 부서명, 평균 급여 조회
--단, 평균 급여는 소수점 버림, 부서명이 없는 경우 '인턴'처리
SELECT NVL(DEPT_TITLE, '인턴'), FLOOR(AVG(SALARY))
FROM EMPLOYEE LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
GROUP BY DEPT_TITLE
HAVING AVG(SALARY) >= 2200000;

--문제6
--직급의 연봉 평균보다 적게 받는 여자사원의
--사원명,직급명,부서명,연봉을 이름 오름차순으로 조회하시오
--연봉 계산 => (급여+(급여*보너스))*12    
-- 사원명,직급명,부서명,연봉은 EMPLOYEE 테이블을 통해 출력이 가능함 
SELECT *
FROM (
            SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, (SALARY + SALARY *NVL(BONUS, 0)) *12 AS 연봉
            FROM EMPLOYEE LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
                                    JOIN JOB USING (JOB_CODE)
            WHERE SUBSTR(EMP_NO, 8, 1) = 2
            ORDER BY 1
)
WHERE 연봉 < (SELECT AVG(SALARY) * 12 FROM EMPLOYEE);