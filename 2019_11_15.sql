-- emp���̺� empno�÷��� �������� PRIMARY KEY�� ����
-- PRIMARY KEY = UNIQUE + NOT NULL
-- UNIQUE --> �ش� �÷����� UNIQUE INDEX�� �ڵ����� ����
-- index �����ϸ� ������ �ڵ����� �����ϴ�

ALTER TABLE emp ADD CONSTRAINT FK_EMP PRIMARY KEY (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;

SELECT *
FROM TABLE (dbms_xplan.display); -- �ܿ��, �����ؼ� ���

 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    37 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    37 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | FK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7369)
   
-- empno �÷����� �ε����� �����ϴ� ��Ȳ���� 
-- �ٸ� �÷������� �����͸� ��ȸ�ϴ� ���
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'; -- �����ȹ�� �����

SELECT *
FROM TABLE(dbms_xplan.display); -- �����ȹ ��ȸ

--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("JOB"='MANAGER')
   
-- �ε��� ���� �÷��� SELECT ���� ����� ��� 
-- ���̺� ������ �ʿ����.

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7782'; 

SELECT *
FROM TABLE(dbms_xplan.display); 

commit;

-- �÷��� �ߺ��� ������ non-unique �ε��� ���� ��
-- unique index���� �����ȹ ��
-- PRIMARY KEY �������� ���� (unique �ε��� ����)
ALTER TABLE emp DROP CONSTRAINT pk_emp;
CREATE INDEX /*UNIQUE*/ IDX_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7782'; 

SELECT *
FROM TABLE(dbms_xplan.display); 

-- emp ���̺� job �÷����� �ι�° �ε��� ���� (non- unique index)
-- job �÷��� �ٸ� �ο��� job�÷��� �ߺ��� ������ �÷��̴�.
CREATE INDEX idx_emp_02 ON emp (job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'; 

SELECT *
FROM TABLE(dbms_xplan.display); 

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%'; 

SELECT *
FROM TABLE(dbms_xplan.display); 

Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER')

-- emp���̺� job, ename �÷��� �������� non-unique �ε��� ����
CREATE INDEX IDX_emp_03 ON emp (job, ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%'; 

SELECT *
FROM TABLE(dbms_xplan.display); 
Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')
       
-- emp���̺� ename, job �÷����� non-unique �ε��� ����
CREATE INDEX IDX_EMP_04 ON emp (ename,job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C'; 

SELECT *
FROM TABLE(dbms_xplan.display); 

-- HINT�� ����� �����ȹ ����
EXPLAIN PLAN FOR
SELECT /*+ INDEX ( emp idx_emp_03 ) */ * -- HINT�̿�
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C'; 

SELECT *
FROM TABLE(dbms_xplan.display); 

Plan hash value: 4060516099
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX SKIP SCAN           | IDX_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE '%C' AND "ENAME" IS NOT NULL)
       
-- �ǽ� idx1
CREATE TABLE DEPT_TEST AS 
SELECT * FROM DEPT 
WHERE 1 = 1;

CREATE UNIQUE INDEX index_name ON dept_test(deptno);

CREATE INDEX index_name2 ON dept_test(dname);

CREATE INDEX index_name3 ON dept_test(dname, deptno);

-- �ǽ� idx2
DROP INDEX index_name;
DROP INDEX index_name2;
DROP INDEX index_name3;

-- �ǽ� idx3
CREATE TABLE EMP_TEST1 AS
SELECT * FROM EMP
WHERE 1 = 1;

COMMIT;
SELECT *
FROM EMP_TEST1;

ALTER TABLE emp_test1 ADD CONSTRAINT pk_empno PRIMARY KEY (empno);

commit;

CREATE INDEX index_emp_test ON emp_test1 (deptno);
CREATE INDEX index_emp_test1 ON emp_test1 (ename);
CREATE INDEX index_emp_test2 ON emp_test1 (deptno, sal);
CREATE INDEX index_emp_test3 ON emp_test1 (deptno, empno);
COMMIT;

EXPLAIN PLAN FOR
SELECT *
FROM emp_test1
WHERE empno = 7298; 

SELECT *
FROM TABLE(dbms_xplan.display); 

EXPLAIN PLAN FOR
SELECT *
FROM emp_test1
WHERE ename = 'SCOTT'; 

SELECT *
FROM TABLE(dbms_xplan.display); 

EXPLAIN PLAN FOR
SELECT *
FROM emp_test1
WHERE sal BETWEEN 500 and 7000
AND deptno = 20; 

SELECT *
FROM TABLE(dbms_xplan.display); 

EXPLAIN PLAN FOR
SELECT *
FROM emp_test1, dept
WHERE emp_test1.deptno = dept.deptno
AND emp_test1.deptno = 10
AND emp_test1.empno LIKE '78%'; 

SELECT *
FROM TABLE(dbms_xplan.display); 


EXPLAIN PLAN FOR
SELECT B.*
FROM emp_test1 a, emp_test1 b
WHERE a.mgr = b.empno
AND a.deptno = 30; 

SELECT *
FROM TABLE(dbms_xplan.display); 

commit;
