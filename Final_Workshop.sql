--1. 4�� ���̺��� ���Ե� ������ �� ���� ���ϴ� SQL ������ ����� SQL ������ �ۼ��Ͻÿ�. 
SELECT COUNT(*) FROM TB_BOOK;
SELECT COUNT(*) FROM TB_WRITER;
SELECT COUNT(*) FROM TB_PUBLISHER;
SELECT COUNT(*) FROM TB_BOOK_AUTHOR;

--3. �������� 25�� �̻��� å ��ȣ�� �������� ȭ�鿡 ����ϴ� SQL ���� �ۼ��Ͻÿ�.
SELECT BOOK_NO, BOOK_NM
FROM TB_BOOK
WHERE LENGTH(BOOK_NM) >= 25;

--4. �޴��� ��ȣ�� ��019���� �����ϴ� �达 ���� ���� �۰��� �̸������� �������� ��
-- ���� ���� ǥ�õǴ� �۰� �̸��� �繫�� ��ȭ��ȣ, �� ��ȭ��ȣ, �޴��� ��ȭ��ȣ��
-- ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�.
SELECT *
FROM(
SELECT WRITER_NM, OFFICE_TELNO, HOME_TELNO, MOBILE_NO
FROM TB_WRITER
WHERE MOBILE_NO LIKE '019%' AND WRITER_NM LIKE '��%'
ORDER BY 1

)
WHERE ROWNUM = 1;

--5. ���� ���°� ���ű衱�� �ش��ϴ� �۰����� �� �� ������ ����ϴ� SQL ������ �ۼ��Ͻÿ�.
-- (��� ����� ���۰�(��)������ ǥ�õǵ��� �� ��)
SELECT COUNT(DISTINCT(WRITER_NO)) AS "�۰�(��)"
FROM TB_BOOK_AUTHOR
WHERE COMPOSE_TYPE = '�ű�';

--6. 300�� �̻� ��ϵ� ������ ���� ���� �� ��ϵ� ���� ������ ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�.
-- (�������°� ��ϵ��� ���� ���� ������ ��)
SELECT COMPOSE_TYPE, COUNT(*)
FROM TB_BOOK_AUTHOR
WHERE COMPOSE_TYPE IS NOT NULL
GROUP BY COMPOSE_TYPE
HAVING COUNT(*) >= 300;

--7. ���� �ֱٿ� �߰��� �ֽ��� �̸��� ��������, ���ǻ� �̸��� ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�.
SELECT *
FROM(
SELECT BOOK_NM, ISSUE_DATE, PUBLISHER_NM
FROM TB_BOOK
ORDER BY ISSUE_DATE DESC
)
WHERE ROWNUM = 1;

--8. ���� ���� å�� �� �۰� 3���� �̸��� ������ ǥ���ϵ�, ���� �� ������� ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�.
-- ��, ��������(��٣���) �۰��� ���ٰ� �����Ѵ�. (��� ����� ���۰� �̸���, ���� ������ ǥ�õǵ��� �� ��)
SELECT *
FROM(
SELECT WRITER_NM AS "�۰� �̸�", COUNT(*) AS "�� ��"
FROM TB_WRITER JOIN TB_BOOK_AUTHOR USING (WRITER_NO)
GROUP BY WRITER_NM
ORDER BY COUNT(*) DESC
)
WHERE ROWNUM <= 3;

--9. �۰� ���� ���̺��� ��� ������� �׸��� �����Ǿ� �ִ� �� �߰��Ͽ���. ������ ������� ����
-- �� �۰��� ������ ���ǵ����� �����ϰ� ������ ��¥���� �����Ű�� SQL ������ �ۼ��Ͻÿ�.
-- (COMMIT ó���� ��)

--1
UPDATE TB_WRITER W SET REGIST_DATE = (SELECT MIN(ISSUE_DATE)
                                                            FROM TB_BOOK JOIN TB_BOOK_AUTHOR USING (BOOK_NO)
                                                            GROUP BY WRITER_NO
                                                            HAVING W.WRITER_NO = WRITER_NO
                                                        );
COMMIT;                                                      

--2
UPDATE TB_WRITER SET REGIST_DATE = (SELECT MIN(ISSUE_DATE) 
                                                     FROM TB_BOOK 
                                                     WHERE BOOK_NO IN (
                                                          SELECT BOOK_NO 
                                                          FROM TB_BOOK_AUTHOR B
                                                          WHERE B.WRITER_NO = TB_WRITER.WRITER_NO)
                                                    );

SELECT * FROM TB_WRITER ORDER BY WRITER_NO;

--10. ���� �������� ���� ���̺��� ������ �������� ���� ���� �����ϰ� �ִ�. �����δ� �������� ����
-- �����Ϸ��� �Ѵ�. ���õ� ���뿡 �°� ��TB_BOOK_ TRANSLATOR�� ���̺��� �����ϴ� SQL ������ �ۼ��Ͻÿ�. 
-- (Primary Key ���� ���� �̸��� ��PK_BOOK_TRANSLATOR���� �ϰ�, Reference ���� ���� �̸���
-- ��FK_BOOK_TRANSLATOR_01��, ��FK_BOOK_TRANSLATOR_02���� �� ��)
CREATE TABLE TB_BOOK_TRANSLATOR (
        BOOK_NO VARCHAR2(10) CONSTRAINT FK_BOOK_TRANSLATOR_01 REFERENCES TB_BOOK(BOOK_NO),
        WRITER_NO VARCHAR2(10) CONSTRAINT FK_BOOK_TRANSLATOR_02 REFERENCES TB_WRITER(WRITER_NO),
        TRANS_LANG VARCHAR2(60),
        CONSTRAINT PK_BOOK_TRANSLATOR PRIMARY KEY(BOOK_NO, WRITER_NO)
);

--11. ���� ���� ����(compose_type)�� '�ű�', '����', '����', '����'�� �ش��ϴ� �����ʹ�
-- ���� ���� ���� ���̺����� ���� ���� ���� ���̺�(TB_BOOK_ TRANSLATOR)�� �ű�� SQL ������ �ۼ��Ͻÿ�.
-- ��, ��TRANS_LANG�� �÷��� NULL ���·� �ε��� �Ѵ�. (�̵��� �����ʹ� ���̻� TB_BOOK_AUTHOR ���̺��� ���� ���� �ʵ��� ������ ��)
INSERT INTO TB_BOOK_TRANSLATOR(BOOK_NO, WRITER_NO)
(SELECT BOOK_NO, WRITER_NO
FROM TB_BOOK_AUTHOR
WHERE COMPOSE_TYPE IN ('�ű�', '����', '����', '����'));

DELETE FROM TB_BOOK_AUTHOR WHERE COMPOSE_TYPE IN ('�ű�', '����', '����', '����');

--12. 2007�⵵�� ���ǵ� ������ �̸��� ������(����)�� ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�.
SELECT BOOK_NM, WRITER_NM
FROM TB_BOOK_TRANSLATOR JOIN TB_BOOK USING (BOOK_NO)
                                        JOIN TB_WRITER USING (WRITER_NO)
WHERE EXTRACT(YEAR FROM ISSUE_DATE) = 2007
ORDER BY WRITER_NM DESC;

--13. 12�� ����� Ȱ���Ͽ� ��� ���������� �������� ������ �� ������ �ϴ� �並 �����ϴ� SQL������ �ۼ��Ͻÿ�.
--(�� �̸��� ��VW_BOOK_TRANSLATOR���� �ϰ� ������, ������, �������� ǥ�õǵ��� �� ��)
GRANT CREATE VIEW TO BS;

CREATE VIEW VW_BOOK_TRANSLATOR
AS SELECT BOOK_NM, WRITER_NM, ISSUE_DATE
FROM TB_BOOK_TRANSLATOR JOIN TB_BOOK USING (BOOK_NO)
                                        JOIN TB_WRITER USING (WRITER_NO)
WHERE EXTRACT(YEAR FROM ISSUE_DATE) = 2007 WITH CHECK OPTION;

SELECT * FROM VW_BOOK_TRANSLATOR;

--14. ���ο� ���ǻ�(�� ���ǻ�)�� �ŷ� ����� �ΰ� �Ǿ���. ���õ� ���� ������ �Է��ϴ� SQL ������ �ۼ��Ͻÿ�.(COMMIT ó���� ��)
INSERT INTO TB_PUBLISHER VALUES ('�� ���ǻ�', '02-6710-3737', DEFAULT);

--15. ��������(��٣���) �۰��� �̸��� ã������ �Ѵ�. �̸��� �������� ���ڸ� ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�.
SELECT WRITER_NM, COUNT(*)
FROM TB_WRITER
GROUP BY WRITER_NM
HAVING COUNT(*) >= 2;

--16. ������ ���� ���� �� ���� ����(compose_type)�� ������ �����͵��� ���� �ʰ� �����Ѵ�.
--�ش� �÷��� NULL�� ��� '����'���� �����ϴ� SQL ������ �ۼ��Ͻÿ�.(COMMIT ó���� ��)
UPDATE TB_BOOK_AUTHOR SET COMPOSE_TYPE = '����' WHERE COMPOSE_TYPE IS NULL;
COMMIT;

--17. �������� �۰� ������ �����Ϸ��� �Ѵ�. �繫���� �����̰�, �繫�� ��ȭ ��ȣ ������ 3�ڸ��� �۰���
--�̸��� �繫�� ��ȭ ��ȣ�� ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�.
SELECT WRITER_NM, OFFICE_TELNO
FROM TB_WRITER
WHERE OFFICE_TELNO LIKE '02-___-%';

--18. 2006�� 1�� �������� ��ϵ� �� 31�� �̻� �� �۰� �̸��� �̸������� ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�.
SELECT WRITER_NM
FROM TB_WRITER
WHERE FLOOR(MONTHS_BETWEEN('06/01/01', REGIST_DATE)) >= 31 * 12
ORDER BY WRITER_NM;

--19. ���� ��� �ٽñ� �α⸦ ��� �ִ� 'Ȳ�ݰ���' ���ǻ縦 ���� ��ȹ���� ������ �Ѵ�. 'Ȳ�ݰ���' ���ǻ翡��
--������ ���� �� ��� ������ 10�� �̸��� �������� ����, ������¸� ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�.
--��� ������ 5�� �̸��� ������ ���߰��ֹ��ʿ䡯��, �������� ���ҷ��������� ǥ���ϰ�, 
--��������� ���� ��, ������ ������ ǥ�õǵ��� �Ѵ�. 
SELECT BOOK_NM AS ������, PRICE AS ����,
        CASE
                WHEN STOCK_QTY < 5 THEN '�߰��ֹ��ʿ�'
                WHEN STOCK_QTY < 10 THEN '�ҷ�����'
        END AS �������
FROM TB_BOOK
WHERE STOCK_QTY < 10 AND PUBLISHER_NM = 'Ȳ�ݰ���'
ORDER BY STOCK_QTY DESC, BOOK_NM;

--20. '��ŸƮ��' ���� �۰��� ���ڸ� ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�. (��� ����� ����������,�����ڡ�,�����ڡ��� ǥ���� ��)
SELECT BOOK_NM AS ������, WRITER_NM AS ����,
(SELECT WRITER_NM
FROM TB_BOOK_TRANSLATOR JOIN TB_WRITER USING (WRITER_NO)
                                        JOIN TB_BOOK USING (BOOK_NO)
WHERE BOOK_NM = '��ŸƮ��') AS ����
FROM TB_BOOK JOIN TB_BOOK_AUTHOR USING (BOOK_NO)
                    JOIN TB_WRITER USING (WRITER_NO)
WHERE BOOK_NM = '��ŸƮ��'
UNION
SELECT BOOK_NM, WRITER_NM, WRITER_NM
FROM TB_BOOK JOIN TB_BOOK_TRANSLATOR USING (BOOK_NO)
                    JOIN TB_WRITER USING (WRITER_NO)
WHERE BOOK_NM = '��ŸƮ��';

--21. ���� �������� ���� �����Ϸκ��� �� 30���� ����ǰ�, ��� ������ 90�� �̻��� ������ ����
--������, �������, ���� ����, 20% ���� ������ ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�.
--(��� ����� ����������, �����������, ������(Org)��, ������(New)���� ǥ���� ��.
--��� ������ ���� ��, ���� ������ ���� ��, ������ ������ ǥ�õǵ��� �� ��)
SELECT *
FROM(
SELECT BOOK_NM AS ������, STOCK_QTY AS "��� ����", PRICE AS "����(Org)", PRICE * 0.8 AS "����(New)"
FROM TB_BOOK
WHERE STOCK_QTY >= 90 AND MONTHS_BETWEEN(SYSDATE, ISSUE_DATE) >= 30 * 12
)
ORDER BY "��� ����" DESC, "����(New)" DESC, ������;