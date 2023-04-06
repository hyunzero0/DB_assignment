--1. JOB���̺��� JOB_NAME�� ������ ��µǵ��� �Ͻÿ�
SELECT JOB_NAME
FROM JOB;
--2. DEPARTMENT���̺��� ���� ��ü�� ����ϴ� SELECT���� �ۼ��Ͻÿ�
SELECT * FROM DEPARTMENT;
--3. EMPLOYEE ���̺��� �̸�(EMP_NAME),�̸���(EMAIL),��ȭ��ȣ(PHONE),�����(HIRE_DATE)�� ����Ͻÿ�
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE
FROM EMPLOYEE;
--4. EMPLOYEE ���̺��� �����(HIRE_DATE) �̸�(EMP_NAME),����(SALARY)�� ����Ͻÿ�
SELECT HIRE_DATE, EMP_NAME, SALARY
FROM EMPLOYEE;
--5. EMPLOYEE ���̺��� ����(SALARY)�� 2,500,000���̻��� ����� EMP_NAME �� SAL_LEVEL�� ����Ͻÿ� 
--    (��Ʈ : >(ũ��) , <(�۴�) �� �̿�)
SELECT EMP_NAME, SAL_LEVEL
FROM EMPLOYEE
WHERE SALARY >= 2500000;
--6. EMPLOYEE ���̺��� ����(SALARY)�� 350���� �̻��̸鼭 
--    JOB_CODE�� 'J3' �� ����� �̸�(EMP_NAME)�� ��ȭ��ȣ(PHONE)�� ����Ͻÿ�
--    (��Ʈ : AND(�׸���) , OR (�Ǵ�))
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND JOB_CODE = 'J3';
--7. EMPLOYEE ���̺��� �̸�, ����, �Ѽ��ɾ�(���ʽ�����), �Ǽ��ɾ�(�� ���ɾ�-(����*���� 3%))�� ��µǵ��� �Ͻÿ�
SELECT EMP_NAME AS �̸�, SALARY * 12 AS ����, (SALARY + SALARY * NVL(BONUS, 0)) * 12 AS �Ѽ��ɾ�, ((SALARY + SALARY * NVL(BONUS, 0)) - (SALARY * 0.03)) * 12 AS �Ǽ��ɾ�
FROM EMPLOYEE;
--8. EMPLOYEE ���̺��� �̸�, �ٹ� �ϼ�(�Ի����� �����ΰ�)�� ����غ��ÿ�. (��¥�� ������갡����.)
SELECT EMP_NAME, HIRE_DATE, FLOOR(SYSDATE - HIRE_DATE) || '��' AS �ٹ��ϼ�
FROM EMPLOYEE;
--9. EMPLOYEE ���̺��� 20�� �̻� �ټ����� �̸�,����,���ʽ����� ����Ͻÿ�
SELECT EMP_NAME, SALARY, NVL(BONUS, 0)
FROM EMPLOYEE
WHERE FLOOR(SYSDATE - HIRE_DATE) / 365 >= 20;
--10.EMPLOYEE ���̺��� ������� 90/01/01 ~ 01/01/01 �� ����� ��ü ������ ����Ͻÿ�
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';
--11.�̸��� '��'�� ���� ����� ��� ����ϼ���.
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%��%';
--12.EMPLOYEE ���̺��� �̸� ���� ������ ������ ����� �̸��� ����Ͻÿ�
SELECT EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%��';
--13.EMPLOYEE ���̺��� ��ȭ��ȣ ó�� 3�ڸ��� 010�� �ƴ� ����� �̸�, ��ȭ��ȣ�� ����Ͻÿ�
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';
--14 EMPLOYEE ���̺��� �����ּ� '_'�� ���� 4���̸鼭, DEPT_CODE�� D9 �Ǵ� D6�̰�
--������� 90/01/01 ~ 00/12/01�̸鼭, ������ 270�����̻��� ����� ��ü ������ ����Ͻÿ�
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE IN('D9', 'D6') AND HIRE_DATE BETWEEN '90/01/01' AND '00/12/01' AND SALARY >= 2700000;
--15. �μ� ��ġ�� ���� �ʾ����� ���ʽ��� �����ϴ� ���� ��ȸ
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;
--16. �����ڵ� ���� �μ� ��ġ�� ���� ���� ���� �̸� ��ȸ
SELECT EMP_NAME
FROM EMPLOYEE 
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;