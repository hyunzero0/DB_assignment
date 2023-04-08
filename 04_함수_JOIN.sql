--1. ������� �̸��� , �̸��� ���̸� ����Ͻÿ�
--		  �̸�	    �̸���		�̸��ϱ���
--	ex) 	ȫ�浿 , hong@kh.or.kr   	  13 
SELECT EMP_NAME AS �̸�, EMAIL AS �̸���, LENGTH(EMAIL) AS �̸��ϱ���
FROM EMPLOYEE;
--3. 60��뿡 �¾ ������� ���, ���ʽ� ���� ����Ͻÿ�. �׶� ���ʽ� ���� null�� ��쿡�� 0 �̶�� ��� �ǰ� ����ÿ�
--	    ������    ���      ���ʽ�
--	ex) ������	    1962	    0.3
--	ex) ������	    1963  	    0
SELECT EMP_NAME AS ������, EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR')) AS ���, NVL(BONUS, 0) AS ���ʽ�
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 1, 2) BETWEEN 60 AND 69;
--4. '010' �ڵ��� ��ȣ�� ���� �ʴ� ����� ���� ����Ͻÿ� (�ڿ� ������ ���� ���̽ÿ�)
--	   �ο�
--	ex) 3��
SELECT COUNT(*) || '��'
FROM EMPLOYEE
WHERE SUBSTR(PHONE, 1, 3) NOT LIKE '010%';
--5. ������� �Ի����� ����Ͻÿ� 
--	��, �Ʒ��� ���� ��µǵ��� ����� ���ÿ�
--	    ������		�Ի���
--	ex) ������		2012�� 12��
--	ex) ������		1997�� 3��
SELECT EMP_NAME AS ������, EXTRACT(YEAR FROM HIRE_DATE) || '�� ' || EXTRACT(MONTH FROM HIRE_DATE) || '��' AS �Ի���
FROM EMPLOYEE;
--6. ������� �ֹι�ȣ�� ��ȸ�Ͻÿ�
--	��, �ֹι�ȣ 9��° �ڸ����� �������� '*' ���ڷ� ä������� �Ͻÿ�
--	ex) ȫ�浿 771120-1******
SELECT EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*')
FROM EMPLOYEE;
--7. ������, �����ڵ�, ����(��) ��ȸ
--  ��, ������ ��57,000,000 ���� ǥ�õǰ� ��
--     ������ ���ʽ�����Ʈ�� ����� 1��ġ �޿���
SELECT EMP_NAME, JOB_CODE, TO_CHAR(((SALARY + SALARY * NVL(BONUS, '0'))  * 12), 'FML999,999,999') AS ����
FROM EMPLOYEE;
--8. �μ��ڵ尡 D5, D9�� ������ �߿��� 2004�⵵�� �Ի��� �����߿� ��ȸ��.
--   ��� ����� �μ��ڵ� �Ի���
SELECT EMP_NO, EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D9') AND EXTRACT(YEAR FROM HIRE_DATE) = '2004';
--9. ������, �Ի���, ���ñ����� �ٹ��ϼ� ��ȸ 
--	* �ָ��� ���� , �Ҽ��� �Ʒ��� ����
SELECT EMP_NAME, HIRE_DATE, FLOOR(SYSDATE - HIRE_DATE) || '��' AS �ٹ��ϼ�
FROM EMPLOYEE;
--11. �������� �Ի��Ϸ� ���� �⵵�� ������, �� �⵵�� �Ի��ο����� ���Ͻÿ�.
--  �Ʒ��� �⵵�� �Ի��� �ο����� ��ȸ�Ͻÿ�. ���������� ��ü�������� ���Ͻÿ�
--  => decode, sum ���
--
--	-------------------------------------------------------------------------
--	 1998��   1999��   2000��   2001��   2002��   2003��   2004��  ��ü������
--	-------------------------------------------------------------------------

-- �ش������� �����ϸ� �ش�row�� ���� �ش�. null�� �ƴ� � ���̶� ����.
-- ���� : count����(Ư���÷��� ����)�� �ϳ� �ְ�, ���ึ��, null�� �ƴ϶�� ++1 ����.
SELECT COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), '1998', '1')) AS "1998��",
            COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), '1999', '1')) AS "1999��",
            COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), '2000', '1')) AS "2000��",
            COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), '2001', '1')) AS "2001��",
            COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), '2002', '1')) AS "2002��",
            COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), '2003', '1')) AS "2003��",
            COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), '2004', '1')) AS "2004��",
            COUNT(*)
FROM EMPLOYEE;
--12. ������, �μ����� ����ϼ���.
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
--   �μ��ڵ尡 D5�̸� �ѹ���, D6�̸� ��ȹ��, D9�̸� �����η� ó���Ͻÿ�.(case ���)
--   ��, �μ��ڵ尡 D5, D6, D9 �� ������ ������ ��ȸ�ϰ�, �μ��ڵ� �������� �������� ������.
SELECT E.*,
        CASE  WHEN DEPT_CODE = 'D5' THEN '�ѹ���'
                 WHEN DEPT_CODE = 'D6' THEN '��ȹ��'
                 WHEN DEPT_CODE = 'D9' THEN '������'
        END
FROM EMPLOYEE E
WHERE DEPT_CODE IN ('D5', 'D6', 'D9')
ORDER BY DEPT_CODE;
--EMPLOYEE ���̺��� ������ J1�� �����ϰ�, ���޺� ����� �� ��ձ޿��� ����ϼ���.
SELECT JOB_CODE, COUNT(*) AS �����, TO_CHAR(FLOOR(AVG(SALARY)), 'FML999,999,999') AS ��ձ޿�
FROM EMPLOYEE
WHERE JOB_CODE != 'J1'
GROUP BY JOB_CODE;
--EMPLOYEE���̺��� ������ J1�� �����ϰ�,  �Ի�⵵�� �ο����� ��ȸ�ؼ�, �Ի�� �������� �������� �����ϼ���.
SELECT EXTRACT(YEAR FROM HIRE_DATE) AS �Ի�⵵, COUNT(*) || '��' AS �ο���
FROM EMPLOYEE
WHERE JOB_CODE != 'J1'
GROUP BY  HIRE_DATE
ORDER BY HIRE_DATE;
--[EMPLOYEE] ���̺��� EMP_NO�� 8��° �ڸ��� 1, 3 �̸� '��', 2, 4 �̸� '��'�� ����� ��ȸ�ϰ�,
SELECT EMP_NAME, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '��', '2', '��', '3', '��', '4', '��') AS ����
FROM EMPLOYEE;
-- ������ �޿��� ���(����ó��), �޿��� �հ�, �ο����� ��ȸ�� �� �ο����� ���������� ���� �Ͻÿ�
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '��', '2', '��', '3', '��', '4', '��') AS ����, FLOOR(AVG(SALARY)) AS �޿����, SUM(SALARY) AS �հ�, COUNT(*) || '��'
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), '1', '��', '2', '��', '3', '��', '4', '��')
ORDER BY COUNT(*) DESC;
--�μ��� ���� �ο����� ���ϼ���.
SELECT DEPT_CODE,  DECODE(SUBSTR(EMP_NO, 8, 1), '1', '��', '2', '��', '3', '��', '4', '��') AS ����, COUNT(*) || '��'
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL
GROUP BY DEPT_CODE,  DECODE(SUBSTR(EMP_NO, 8, 1), '1', '��', '2', '��', '3', '��', '4', '��')
ORDER BY DEPT_CODE;
--�μ��� �ο��� 3���� ���� �μ��� �ο����� ����ϼ���.
SELECT DEPT_CODE, COUNT(*) AS �ο���
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL 
GROUP BY DEPT_CODE
HAVING COUNT(*) > 3; 
--�μ��� ���޺� �ο����� 3���̻��� ������ �μ��ڵ�, �����ڵ�, �ο����� ����ϼ���.
SELECT DEPT_CODE, JOB_CODE, COUNT(*) AS �ο���
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL
GROUP BY DEPT_CODE, JOB_CODE
HAVING COUNT(*) >= 3; 
--�Ŵ����� �����ϴ� ����� 2���̻��� �Ŵ������̵�� �����ϴ� ������� ����ϼ���.
SELECT MANAGER_ID, COUNT(*) || '��' AS �����ϴ»����
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL
GROUP BY MANAGER_ID
HAVING COUNT(*) >= 2;
--�μ���� �������� ����ϼ���. DEPARTMENT, LOCATION ���̺� �̿�.
SELECT DEPT_TITLE AS �μ���, LOCAL_NAME AS ������
FROM DEPARTMENT JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;
--������� �������� ����ϼ���. LOCATION, NATION ���̺�
SELECT LOCAL_NAME AS ������, NATIONAL_NAME AS ������
FROM LOCATION L JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE;
--������� �������� ����ϼ���. LOCATION, NATION ���̺��� �����ϵ� USING�� ����Ұ�.
SELECT LOCAL_NAME AS ������, NATIONAL_NAME AS ������
FROM LOCATION JOIN NATIONAL USING (NATIONAL_CODE);