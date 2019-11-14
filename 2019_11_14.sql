-- �������� Ȱ��ȭ / ��Ȱ��ȭ
-- � ���������� Ȱ��ȭ(��Ȱ��ȭ) ��ų ����ΰ�?

-- emp fk���� (dept���̺��� deptno�÷� ����)
-- FK_EMP_DEPT ��Ȱ��ȭ
ALTER TABLE emp DISABLE CONSTRAINT FK_EMP_DEPT;

-- �������ǿ� ����Ǵ� �����Ͱ� �� �� ���� �ʴ��� Ȯ��
INSERT INTO emp(empno, ename, deptno)
VALUES (9999,'brown',80);

-- FK_EMP_DEPT Ȱ��ȭ
ALTER TABLE emp ENABLE CONSTRAINT FK_EMP_DEPT;

-- �������ǿ� ����Ǵ� ������ (�Ҽ� �μ���ȣ�� 80���� ������)��
-- �����Ͽ� �������� Ȱ��ȭ �Ұ�
DELETE emp
WHERE empno = 9999;

-- FK_EMP_DEPT Ȱ��ȭ
ALTER TABLE emp ENABLE CONSTRAINT FK_EMP_DEPT;
commit;

-- ���� ������ �����ϴ� ���̺� ��� view : USER_TABLES
-- ���� ������ �����ϴ� �������� view : USER_CONSTRAINTS
-- ���� ������ �����ϴ� ���������� �÷� view : USER_CONS_COLUMNS
SELECT *
FROM user_constraints -- ��������
WHERE table_name = 'CYCLE';

--FK_EMP_DEPT
SELECT *
FROM USER_CONS_COLUMNS -- �ش� ���������� �÷�
WHERE CONSTRAINT_NAME = 'PK_CYCLE';

-- ���̺� ������ �������� ��ȸ (VIEW ����)
-- ���̺�� / �������Ǹ� / �÷��� / �÷� ������

SELECT a.table_name, a.constraint_name, b.column_name, b.position
FROM user_constraints a, user_cons_columns b
WHERE a.constraint_name = b.constraint_name
AND a.constraint_type = 'P' -- primary key�� ��ȸ
ORDER BY a.table_name, b.position;

DESC CUSTOMER;

-- emp���̺�� 8���� �÷� �ּ��ޱ�
-- EMPNO ENAME JOB MGR HIREDATE SAL COMM DEPTNO

-- ���̺� �ּ� view : USER_TAB_COMMENTS

SELECT *
FROM user_tab_comments;

-- emp ���̺� �ּ�
COMMENT ON TABLE emp IS '���';

SELECT *
FROM user_tab_comments
WHERE table_name = 'EMP';

-- emp ���̺��� �÷� �ּ�
SELECT *
FROM user_col_comments;

-- EMPNO ENAME JOB MGR HIREDATE SAL COMM DEPTNO
COMMENT ON COLUMN emp.empno IS '�����ȣ';
COMMENT ON COLUMN emp.ename IS '�̸�';
COMMENT ON COLUMN emp.JOB IS '������';
COMMENT ON COLUMN emp.mgr IS '������ ���';
COMMENT ON COLUMN emp.hiredate IS '�Ի�����';
COMMENT ON COLUMN emp.sal IS '�޿�';
COMMENT ON COLUMN emp.comm IS '��';
COMMENT ON COLUMN emp.deptno IS '�ҼӺμ�����';

-- �ǽ� comment1
SELECT a.table_name,a.table_type,a.comments tab_comment,b.COLUMN_NAME, b.comments
FROM user_tab_comments a, user_col_comments b
WHERE a.table_name IN ('CUSTOMER','CYCLE','DAILY','PRODUCT')
AND b.table_name = a.TABLE_NAME;

-- view ���� (emp���̺��� sal, comm�ΰ� �÷��� �����Ѵ�)
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

-- INLINE VIEW
SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno 
        FROM emp);

-- VIEW(�� �ζ��κ�� �����ϴ�)
SELECT *
FROM v_emp;

-- ���ε� ���� ����� view�� ���� : v_emp_dept
-- emp, dept : �μ���, �����ȣ, �����, ������, �Ի�����

CREATE OR REPLACE VIEW v_emp_dept AS 
SELECT a.dname, b.empno, b.ename, b.job, b.hiredate
FROM dept a, emp b
WHERE a.deptno = b.deptno;

SELECT *
FROM v_emp_dept;

-- VIEW ����
DROP VIEW v_emp;

-- VIEW�� �����ϴ� ���̺��� �����͸� �����ϸ� VIEW���� ������ ����
-- dept 30 - sales
SELECT *
FROM v_emp_dept;

-- dept���̺��� sales -> market sales
UPDATE dept SET dname = 'MARKET SALES'
WHERE deptno = 30;

rollback;



-- HR�������� v_emp_dept view ��ȸ ������ �ش� : �޿��� ���߰� ������
GRANT SELECT ON v_emp_dept TO hr;

-- SEQUENCE ���� (�Խñ� ��ȣ �ο��� ������) : ������ ���� ���� 
CREATE SEQUENCE seq_post 
INCREMENT BY 1
START WITH 1;


SELECT seq_post.nextval, seq_post.currval
FROM dual;

SELECT seq_post.currval --  ��� �����ߴ� ��
FROM dual;

SELECT *
FROM post -- ���̺��� ��� ���� X
WHERE reg_id = 'brown' 
and title = '��������'
and reg_dt = to_date('2019/11/14 15:40:15', 'YYYY/MM/DD HH24:MI:SS');

SELECT *
FROM post -- ���̺��� ��� ���� X
WHERE post_id = 1;

-- ������ ����
-- ������ : �ߺ����� �ʴ� ���� ���� ���� ���ִ� ��ü
-- 1, 2, 3, ...
DESC EMP_TEST;

DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR(15)
    );

CREATE SEQUENCE seq_emp_test;    

INSERT INTO emp_test VALUES (seq_emp_test.nextval, 'brown'); -- (�ߺ����� �ʴ� ��, 'brown')

SELECT *
FROM emp_test;

SELECT seq_emp_test.nextval
FROM dual;

-- INDEX
-- rowid : ���̺� ���� ������ �ּ�, �ش� �ּҸ� �˸� ������ ���̺� �����ϴ°��� �����ϴ�.

SELECT product.*, ROWID
FROM product
WHERE ROWID = 'AAAFNzAAFAAAAHtAAA';

