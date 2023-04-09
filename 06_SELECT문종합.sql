--����1
--��������ο� ���� ������� ����� �̸�,�μ��ڵ�,�޿��� ����Ͻÿ�. 
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_ID FROM DEPARTMENT WHERE DEPT_TITLE = '���������');

--����2
--��������ο� ���� ����� �� ���� ������ ���� ����� �̸�,�μ��ڵ�,�޿��� ����Ͻÿ�
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM (SELECT EMP_NAME, DEPT_CODE, SALARY
            FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
            WHERE DEPT_TITLE = '���������'
            ORDER BY SALARY DESC)
WHERE ROWNUM = 1;

--����3
--�Ŵ����� �ִ� ����߿� ������ ��ü��� ����� �Ѱ� 
--���,�̸�,�Ŵ��� �̸�, ������ ���Ͻÿ�. 
--1. JOIN�� �̿��Ͻÿ�
SELECT E.EMP_ID, E.EMP_NAME, M.EMP_NAME AS �Ŵ����̸�, E.SALARY
FROM EMPLOYEE E JOIN EMPLOYEE M ON M.EMP_ID = E.MANAGER_ID
WHERE E.SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);

--2. JOIN���� �ʰ�, ��Į��������(SELECT)�� �̿��ϱ�
SELECT E.EMP_ID, E.EMP_NAME, (SELECT M.EMP_NAME FROM EMPLOYEE M WHERE E.MANAGER_ID = M.EMP_ID) AS �Ŵ����̸�, E.SALARY
FROM EMPLOYEE E
WHERE E.SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE) AND E.MANAGER_ID IS NOT NULL;

--����4
--���� ������ ��ձ޿����� ���ų� ���� �޿��� �޴� ������ �̸�, �����ڵ�, �޿�, �޿���� ��ȸ
SELECT EMP_NAME, JOB_CODE, SALARY, SAL_LEVEL
FROM EMPLOYEE E
WHERE SALARY >= (SELECT AVG(SALARY) FROM EMPLOYEE WHERE E.JOB_CODE = JOB_CODE);

--����5
--�μ��� ��� �޿��� 2200000 �̻��� �μ���, ��� �޿� ��ȸ
--��, ��� �޿��� �Ҽ��� ����, �μ����� ���� ��� '����'ó��
SELECT NVL(DEPT_TITLE, '����'), FLOOR(AVG(SALARY))
FROM EMPLOYEE LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
GROUP BY DEPT_TITLE
HAVING AVG(SALARY) >= 2200000;

--����6
--������ ���� ��պ��� ���� �޴� ���ڻ����
--�����,���޸�,�μ���,������ �̸� ������������ ��ȸ�Ͻÿ�
--���� ��� => (�޿�+(�޿�*���ʽ�))*12    
-- �����,���޸�,�μ���,������ EMPLOYEE ���̺��� ���� ����� ������ 
SELECT *
FROM (
            SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, (SALARY + SALARY *NVL(BONUS, 0)) *12 AS ����
            FROM EMPLOYEE LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
                                    JOIN JOB USING (JOB_CODE)
            WHERE SUBSTR(EMP_NO, 8, 1) = 2
            ORDER BY 1
)
WHERE ���� < (SELECT AVG(SALARY) * 12 FROM EMPLOYEE);