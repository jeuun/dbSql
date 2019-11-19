SELECT *
FROM USER_VIEWS;

SELECT *
FROM ALL_VIEWS
WHERE OWNER = 'SEM';

SELECT *
FROM  jeun.V_EMP_DEPT;

-- sem �������� ��ȸ ������ ���� V_EMP_DEPT view �� hr�������� ��ȸ�ϱ�
-- ���ؼ��� ������. view�̸� �������� ����� �ؾ��Ѵ�.
-- �Ź� �������� ����ϱ� �������Ƿ� �ó���� ���� �ٸ� ��Ī�� ����

CREATE SYNONYM V_EMP_DEPT FOR jeun.V_EMP_DEPT;

-- jenu.V_EMP_DEPT --> V_EMP_DEPT
SELECT *
FROM V_EMP_DEPT;

-- �ó�� ����
DROP TABLE ���̺���;
DROP SYNONYM V_EMP_DEPT;

-- hr ���� ��й�ȣ : java
-- hr ���� ��й�ȣ ���� : hr
ALTER USER hr IDENTIFIED BY hr;
-- ALTER USER sem IDENTIFIED BY java; -- ���� ������ �ƴ϶� ����

-- dictionary
-- ���ξ� : USER : ����� ���� ��ü
-- ALL : ����ڰ� ��밡���� ��ü
-- DBA : ������ ������ ��ü ��ü (�Ϲ� ����ڴ� ��� �Ұ�)
-- V$ : �ý��۰� ���õ� view (�Ϲ� ����ڴ� ��� �Ұ�)

SELECT *
FROM ALL_TABLES;

SELECT * 
FROM DBA_TABLES
WHERE OWNER IN ('jeun','HR');

-- ����Ŭ���� ������ SQL�̶�?
-- ���ڰ� �ϳ��� Ʋ���� �ȵ�
-- ���� sql���� ���� ����� ������ ���� DBMS������
-- ���� �ٸ� SQL�� �νĵȴ�.
SELECT /*bilnd_test*/ * from emp;
Select /*bilnd_test*/ * from emp;
Select /*bilnd_test*/ * from emp;

SELECT *
FROM V$SQL
WHERE SQL_TEST LIKE '%bind_test%';
