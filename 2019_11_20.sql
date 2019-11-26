-- GROUPING (cube, rollup ���� ���� �÷�)
-- �ش� �÷��� �Ұ� ��꿡 ���� ��� 1 
-- ������ ���� ��� 0
SELECT job, deptno, GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

-- job �÷�
-- case1.GROUPING(job)=1 AND GROUPING(deptno) = 1
--       job --> '�Ѱ�'
-- case else
--       job --> job

-- GROUP AD2
SELECT CASE WHEN GROUPING(job) = 1 AND 
                 GROUPING(deptno) = 1 THEN '�Ѱ�'
            ELSE job
        END job, deptno,
        GROUPING(job), GROUPING(deptno), SUM(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

-- GROUP AD3
SELECT deptno, job, sum(sal) sal
FROM emp
GROUP BY ROLLUP(deptno, job);

-- GROUP AD4

-- GROUP AD5

- CUBE(col, col2)
-- CUBE ���� ������ �÷��� ������ ��� ���տ� ���� ���� �׷����� ����
-- CUBE�� ������ �÷��� ���� ���⼺�� ����(rollup���� ����)
-- GROUP BY (job, deptno)
-- 00 : GROUP BY job, deptno
-- 0X : GROUP BY job
-- X0 : GROUP BY deptno
-- XX : GROUP BY -- ��� �����Ϳ� ���ؼ� ..

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE(job, deptno);

select *
from emp;

-- sub query�� ���� ������Ʈ
drop table emp_test;

-- emp���̺��� �����͸� �����ؼ� ��� �÷��� �̿��Ͽ� emp_test���̺�� ����
CREATE TABLE emp_test AS
SELECT *
FROM emp;

SELECT *
FROM emp_test;

-- emp_test���̺��� dept���̺��� �����ǰ� �ִ� dname�÷�(VARCHAR2(14))�� �߰�
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

-- emp_test���̺��� dname�÷��� dept���̺��� dname�÷� ������ ������Ʈ�ϴ� ���� �ۼ�
UPDATE emp_test SET dname = (SELECT dname
                                FROM dept
                                WHERE dept.deptno = emp_test.deptno);
-- ���� �߰��� ����
WHERE empno IN (7369,7499);

commit;

-- �ǽ� sub_al
ALTER TABLE dept_test ADD (empcnt number);

UPDATE dept_test SET empcnt = (SELECT COUNT(*)
                                FROM emp
                                WHERE deptno = dept_test.deptno);

-- 10 �� �μ��� �μ��� �� ���ϴ� ����
SELECT COUNT(*)
FROM emp
WHERE deptno = 20;

-- �ǽ� sub_a2
SELECT *
FROM dept_test;
INSERT INTO dept_test VALUES (98,'it','daejeon',0);
INSERT INTO dept_test VALUES (99,'it','daejeon',0);

select *
from dept_test;

select *
from emp;

DELETE DEPT_TEST
WHERE not exists (SELECT 'X'
                FROM emp
                WHERE emp.deptno = dept_test.deptno);

DELETE DEPT_TEST
WHERE deptno NOT IN (SELECT deptno
                    FROM emp);
-- �ǽ� sub_a3
UPDATE emp_test a SET sal = sal + 200
WHERE sal <  (select AVG(SAL)
            from emp_test b
            WHERE b.deptno = a.deptno);


SELECT *
FROM emp_test
WHERE SAL < (SELECT AVG(sal)SAL
                FROM emp_test
                GROUP BY deptno);
                
                
