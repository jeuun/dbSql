-- EMP_TEST ���̺� ����
DROP TABLE EMP_TEST;

-- MULTIPLE INSERT�� ���� �׽�Ʈ ���̺� ����
-- EMPNO, ENAME �ΰ��� �÷��� ���� EMP_TEST, EMP_TEST2 ���̺��� 
-- EMP ���̺�� ���� �����Ѵ�. (CTAS)
-- �����ʹ� �������� �ʴ´�.

CREATE TABLE emp_test AS
SELECT empno, ename
FROM emp
WHERE 1=2;

CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp
WHERE 1=2;

-- INSERT ALL
-- �ϳ��� INSERT SQL�������� ���� ���̺� �����͸� �Է�
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT 1, 'brown' FROM dual UNION ALL
SELECT 2, 'sally' FROM dual;

-- INSERT ������ Ȯ��
SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

-- INSERT ALL �÷� ����
ROLLBACK;

INSERT ALL 
    INTO emp_test (empno) VALUES (empno)
    INTO emp_test2 VALUES (empno, ename)
SELECT 1 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test;

-- multiple insert (conditional insert)
ROLLBACK;
INSERT ALL 
    WHEN empno < 10 THEN
        INTO emp_test (empno) VALUES (empno)
    ELSE -- ������ ������� ���� ���� ����
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

-- INSERT FIRST
-- ���ǿ� �����ϴ� ù��° INSERT ������ ����
INSERT FIRST
    WHEN empno > 10 THEN
        INTO emp_test (empno) VALUES (empno)
    WHEN empno > 5 THEN
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

-- MERGE :  ���ǿ� �����ϴ� �����Ͱ� ������ UPDATE
--          ���ǿ� �����ϴ� �����Ͱ� ������ INSERT
ROLLBACK;

-- empno�� 7369�� �����͸� EMP���̺�� ���� EMP_TEST���̺� ����(INSERT)
INSERT INTO emp_test 
SELECT EMPNO, ENAME
FROM EMP
WHERE EMPNO = 7369;

SELECT *
FROM EMP_TEST;

-- emp ���̺��� �������� emp_test ���̺��� empno�� ���� ���� ���� �����Ͱ� ���� ���
-- emp_test.ename = ename || 'merge' ������ update
-- �����Ͱ� ���� ��쿡�� emp_test���̺� insert
ALTER TABLE emp_test MODIFY (ename VARCHAR(20));

MERGE INTO emp_test
USING (SELECT empno, ename
        FROM 
 ON (emp.empno = emp_test.empno
 AND emp.empno IN (7369, 7499))
WHEN MATCHED THEN
    UPDATE SET ename = emp.ename || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES (emp.empno, emp.ename);
    
-- �ٸ� ���̺��� ������ �ʰ� ���̺� ��ü�� ������ ���� ������ merge�ϴ� ���
rollback;

-- empno = 1, ename = 'brown'
-- empno�� ���� ���� ������ ename�� 'brown'���� update
-- empno�� ���� ���� ������ �ű� insert

SELECT *
FROM emp_test;

MERGE INTO emp_test
USING dual
 ON (emp_test.empno = 1)
 WHEN MATCHED THEN 
    UPDATE set ename = 'brown' || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES (1,'brown');
    
SELECT 'X'
FROM emp_test
WHERE empno=1;

UPDATE emp_test set ename = 'brown' || '_merge'
WHERE empno = 1;

INSERT INTO emp_test VALUES(1,'brown');

-- GROUP AD1
SELECT *
FROM EMP;

SELECT null, sum(sal) SAL
FROM emp
order BY deptno;

SELECT NULL,SUM(SAL) SAL
FROM EMP;

-- �� ������ ROLL UP ���·� ����
SELECT deptno, sum(sal) SAL
FROM emp
group by rollup(deptno);
    

-- roll up
-- group by�� ���� �׷��� ����
-- GROUP BY ROLLUP({COL,})
-- �÷��� �����ʿ������� �����ذ��鼭 ���� ���� �׷��� 
-- GROUP BY �Ͽ� UNION �� �Ͱ� ����
-- EX : GROUP BY ROLL UP(JOB, DEPTNO)
--      GROUP BY job, deptno,
--      UNION
--      GROUP BY job
--      UNION
--      GROUP BY --> �Ѱ� (��� �࿡ ���� �׷��Լ� ����)

SELECT deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP(deptno);

SELECT deptno, sum(sal) sal
FROM emp
GROUP BY deptno
    UNION 
    SELECT NULL,SUM(SAL) SAL
    FROM EMP;
    
-- GROUPING SETS (col1,col2...)
-- GROUPING SETS�� ������ �׸��� �ϳ��� ����׷����� GROUP BY ���� �̿�ȴ�.

-- GROUP BY col1
-- UNION ALL
-- GROUP BY col2

-- emp ���̺��� �̿��Ͽ� �μ��� �޿��հ� ��� ����(job)�� �޿����� ���Ͻÿ� 

-- �μ���ȣ,job,�޿��հ�
SELECT deptno, null job, SUM(sal)
FROM emp
GROUP BY deptno

UNION ALL

SELECT null, job, SUM(sal)
FROM emp
GROUP BY job;

SELECT deptno, job, sum(sal)
FROM emp
GROUP BY GROUPING SETS(deptno, job,(deptno, job);

SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno;