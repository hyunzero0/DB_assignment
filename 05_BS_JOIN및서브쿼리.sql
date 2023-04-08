--1. 70��� ��(1970~1979) �� �����̸鼭 ������ ����� �̸��� �ֹι�ȣ, �μ� ��, ���� ��ȸ
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
                         JOIN JOB USING(JOB_CODE)
WHERE EMP_NAME LIKE '��%' AND SUBSTR(EMP_NO, 1, 2) BETWEEN 70 AND 79 AND SUBSTR(EMP_NO, 8, 1) = 2 ;

--2. ���� �� ���� ������ ��� �ڵ�, ��� ��, ����, �μ� ��, ���� �� ��ȸ
SELECT *
FROM(SELECT EMP_NO, EMP_NAME,
                    EXTRACT(YEAR FROM SYSDATE) - (
                    TO_NUMBER(SUBSTR(EMP_NO, 1, 2)) +
                    CASE
                            WHEN SUBSTR(EMP_NO, 8, 1) IN (1, 2) THEN 1900
                            WHEN SUBSTR(EMP_NO, 8, 1) IN (3, 4) THEN 2000
                    END
                    ) AS ����,
                     DEPT_TITLE, JOB_NAME
          FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
                        JOIN JOB USING(JOB_CODE)
            ORDER BY ����)
WHERE ROWNUM = 1;

--3. �̸��� �������� ���� ����� ��� �ڵ�, ��� ��, ���� ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE JOIN JOB USING(JOB_CODE)
WHERE EMP_NAME LIKE '%��%';

--4. �μ��ڵ尡 D5�̰ų� D6�� ����� ��� ��, ���� ��, �μ� �ڵ�, �μ� �� ��ȸ
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
                        JOIN JOB USING(JOB_CODE)
WHERE DEPT_CODE IN ('D5', 'D6')
ORDER BY DEPT_CODE DESC;

--5. ���ʽ��� �޴� ����� ��� ��, �μ� ��, ���� �� ��ȸ
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
                        JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE BONUS IS NOT NULL;

--6. ��� ��, ���� ��, �μ� ��, ���� �� ��ȸ
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
                        LEFT JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
                        JOIN JOB USING (JOB_CODE);
                        
--7. �ѱ��̳� �Ϻ����� �ٹ� ���� ����� ��� ��, �μ� ��, ���� ��, ���� �� ��ȸ
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
                        JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
                        JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_NAME IN ('�ѱ�', '�Ϻ�');

--8. �� ����� ���� �μ����� ���ϴ� ����� �̸� ��ȸ
SELECT E.EMP_NAME, E.DEPT_CODE, E1.EMP_NAME
FROM EMPLOYEE E JOIN EMPLOYEE E1 ON E.DEPT_CODE = E1.DEPT_CODE
WHERE E.EMP_NAME != E1.EMP_NAME
ORDER BY E.EMP_NAME;

--9. ���ʽ��� ���� ���� �ڵ尡 J4�̰ų� J7�� ����� �̸�, ���� ��, �޿� ��ȸ(NVL �̿�)
SELECT EMP_NAME, JOB_NAME, NVL(BONUS, SALARY)
FROM EMPLOYEE JOIN JOB USING(JOB_CODE)
WHERE JOB_CODE IN ('J4', 'J7') AND BONUS IS NULL;

--10. ���ʽ� ������ ������ ���� 5���� ���, �̸�, �μ� ��, ����, �Ի���, ���� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, HIRE_DATE, ROWNUM
FROM (
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, HIRE_DATE, (SALARY + SALARY * NVL(BONUS,0)) *12 AS ����
FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
                        JOIN JOB USING(JOB_CODE)
ORDER BY ���� DESC)
WHERE ROWNUM <= 5;

--11. �μ� �� �޿� �հ谡 ��ü �޿� �� ���� 20%���� ���� �μ��� �μ� ��, �μ� �� �޿� �հ� ��ȸ
--11-1. JOIN�� HAVING ���
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
GROUP BY DEPT_TITLE 
HAVING SUM(SALARY) > (SELECT SUM(SALARY) * 0.2 FROM EMPLOYEE);

--11-2. �ζ��� �� ���
SELECT *
FROM (SELECT DEPT_TITLE, SUM(SALARY) AS �޿�
            FROM DEPARTMENT
                    JOIN EMPLOYEE ON DEPT_CODE = DEPT_ID
            GROUP BY DEPT_TITLE)
WHERE �޿� > (SELECT SUM(SALARY) * 0.2 FROM EMPLOYEE);

--11-3. WITH ���
WITH SAL AS (SELECT DEPT_TITLE, SUM(SALARY) AS �޿�
                    FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
                    GROUP BY DEPT_TITLE)
SELECT * FROM SAL
WHERE �޿� > (SELECT SUM(SALARY) * 0.2 FROM EMPLOYEE);

--12. �μ� ��� �μ� �� �޿� �հ� ��ȸ
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
GROUP BY DEPT_TITLE;