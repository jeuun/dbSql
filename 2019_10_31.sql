-- ���̺��� ������ ��ȸ
/*
    SELECT �÷� || express(���ڿ����) [AS] ��Ī
    FROM �����͸� ��ȸ�� ���̺�(VIEW)
    WHERE ���� (condition)
*/

DESC user_tables;
SELECT table_name, 
'SELECT * FROM' || table_name || ';' AS select_query
FROM user_tables
WHERE TABLE_NAME != 'EMP';
-- ��ü�Ǽ�-1

-- ���ں� ����
-- �μ���ȣ�� 30�� ���� ũ�ų� ���� �μ��� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno >= 30;

-- �μ���ȣ�� 30������ ���� �μ��� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno < 30;

-- �Ի����ڰ� 1982�� 1�� 1�� ������ ���� ��ȸ
SELECT *
FROM emp
--WHERE hiredate < '82/01/01';
WHERE hiredate >= TO_DATE('1982/01/01','YYYY/MM/DD');

-- col BETWEEN X AND Y ����
-- �÷��� ���� x���� ũ�ų� ����, Y���� �۰ų� ���� ������
-- �޿�(sal)�� 1000���� ũ�ų� ����, 2000���� �۰ų� ���� �����͸� ��ȸ
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

-- ���� BETWEEN AND �����ڴ� �Ʒ��� <=, >= ���հ� ����
SELECT *
FROM emp
WHERE sal >= 1000 
AND sal <= 2000
AND deptno = 30;

-- where1
SELECT ename,hiredate
FROM emp
WHERE hiredate
    BETWEEN TO_DATE('1982/01/01','YYYY/MM/DD')
    AND TO_DATE('1983/01/01','YYYY/MM/DD');
    
-- where2
SELECT ename,hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01','YYYY/MM/DD')
       AND hiredate <= TO_DATE('1983/01/01','YYYY/MM/DD');
       
-- IN ������
-- COL IN (values...)
-- �μ���ȣ�� 10 Ȥ�� 20�� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno in (10, 20);

-- IN �����ڴ� OR �����ڷ� ǥ���� �� �ִ�.
SELECT *
FROM emp
WHERE deptno = 10
    OR deptno = 20;

-- where3
SELECT userid as "���̵�", usernm as "�̸�", alias AS "����"  
FROM users
WHERE userid in ('brown','cony','sally');

-- COL LIKE 'S%'
-- COL�� ���� �빮�� s�� �����ϴ� ��� ��
-- COL LIKE 'S____'
-- COL�� ���� �빮�� S�� �����ϰ� �̾ 4���� ���ڿ��� �����ϴ� ��

-- emp ���̺��� �����̸��� S�� �����ϴ� ��� ���� ��ȸ
SELECT *
FROM emp
WHERE ename LIKE 'S%';

SELECT *
FROM emp
WHERE ename LIKE 'S____';

-- �ǽ� where4
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '��__';

-- �ǽ� where5
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%��%'; -- ���ڿ��ȿ� �̷� �����ϴ� ������ 
WHERE mem_name LIKE '��%'; -- mem_name�� ù �ܾ �̷� �����ϴ� ������  

-- NULL ��
-- colc IS NULL
-- EMP ���̺��� MGR ������ ���� ���(NULL) ��ȸ
SELECT *
FROM emp
WHERE mgr IS NULL;
-- WHERE MGR != null;   -- null �񱳰� �����Ѵ�

-- �Ҽ� �μ��� 10���� �ƴ� ������
SELECT *
FROM emp
WHERE deptno != '10';

-- �ǽ� where6
SELECT *
FROM emp
WHERE COMM IS NOT NULL;

-- AND/OR
-- ������(mgr) ����� 7698 �̰� �޿��� 1000�̻� �� ���
SELECT *
FROM emp
WHERE mgr = 7698
AND sal >= 1000;

-- emp ���̺��� ������(mgr) ����� 7698 �̰ų� �޿�(sal)�� 1000 �̻��� ���� ��ȸ
SELECT *
FROM emp
WHERE mgr = 7698
OR sal >= 1000;

-- emp ���̺��� ������(mgr) ����� 7698�� �ƴϰ�, 7839�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN (7698,7639);   -- NOT IN --> AND

-- ���� ������ AND/OR �����ڷ� ��ȯ
SELECT *
FROM emp
WHERE mgr != 7698
AND mgr != 7639;

-- IN, NOT IN �������� NULL ó��
-- emp ���̺��� ������(emp) ����� 7698, 7939 �Ǵ� null�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN (7698,7639,NULL); -- IN �����ڿ��� ������� NULL�� ���� ��� �ǵ����� �ʴ� ������ �Ѵ�.

SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839)
AND mgr IS NOT NULL;

-- �ǽ� where7
SELECT *
FROM emp
WHERE job = 'SALESMAN'     -- ���ڿ� �߿�
AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');

-- �ǽ� where8 
SELECT *
FROM emp
WHERE DEPTNO != 10
AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');

-- �ǽ� where9
SELECT *
FROM emp
WHERE DEPTNO NOT IN (10)
AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');

-- �ǽ� where10
SELECT *
FROM emp
WHERE DEPTNO NOT IN 10
AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');

-- �ǽ� where11
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');

-- where12
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR EMPNO LIKE '78%';


