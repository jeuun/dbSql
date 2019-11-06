-- �׷��Լ�
-- multi row function : �������� ���� �Է����� �ϳ��� ��� ���� ����
-- SUM, MAX, MIN, AVG, COUNT
-- GROUP BY col | express
-- SELECT ������ GROUP BY ���� ����� COL, EXPRESS ǥ�� ����

-- ���� �� ���� ���� �޿� ��ȸ
-- 14���� ���� �Է����� �� �ϳ��� ����� ����
SELECT MAX(sal) max_sal
FROM emp;

-- �μ����� ���� ���� �޿� ��ȸ
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

-- grp3
SELECT DECODE(deptno,'10','ACCOUNTING','20','RESEARCH','30','SALES')DNAME,
       MAX(sal) max_sal, MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       COUNT(*) count_all
FROM emp
GROUP BY DECODE(deptno,'10','ACCOUNTING','20','RESEARCH','30','SALES')
ORDER BY max_sal desc;

-- grp4
SELECT TO_CHAR(hiredate, 'YYYYMM') HIRE_YYYYMM, COUNT(*) CNT
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

-- grp5
SELECT TO_CHAR(hiredate,'YYYY') HIRE_YYYY, COUNT(TO_CHAR(hiredate,'YYYY')) CNT
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYY')
ORDER BY TO_CHAR(hiredate,'YYYY');

-- grp6
SELECT COUNT(deptno) CNT
FROM dept;

-- JOIN
-- emp ���̺��� dname �÷��� ���� --> �μ���ȣ(deptno)�ۿ� ����
desc emp;

-- emp���̺� �μ� �̸��� ������ �� �ִ� dname �÷� �߰�
ALTER TABLE emp ADD (dname VARCHAR(14));

SELECT *
FROM emp;

UPDATE emp SET dname = 'ACCOUNTING' WHERE DEPTNO = 10;
UPDATE emp SET dname = 'RESEARCH' WHERE DEPTNO = 20;
UPDATE emp SET dname = 'SALES' WHERE DEPTNO = 30;
COMMIT;

SELECT dname, MAX(sal) max_sal
FROM emp
GROUP BY dname;

ALTER TABLE emp DROP COLUMN DNAME;

SELECT*
FROM emp;

-- ansi natural join : ���̺��� �÷����� ���� �÷��� �������� JOIN
SELECT DEPTNO, ENAME, DNAME
FROM emp NATURAL JOIN DEPT;

-- ORACLE join
SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno;

SELECT emp.empn, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- SELECT join : ���� ���̺��� ����
-- emp ���̺��� mgr ������ �����ϱ� ���ؼ� emp ���̺�� ������ �ؾ��Ѵ�
-- a : ���� ����, b : ������
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno)
WHERE a.empno between 7369 AND 7698;

-- oracle
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno
AND a.empno between 7369 AND 7698;

-- non-equijoing (��� ������ �ƴ� ���)
SELECT *
FROM salgrade;

-- ������ �޿� ����� ? 
SELECT *
FROM emp;

SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp JOIN salgrade ON (emp.sal BETWEEN salgrade.losal AND salgrade.hisal);

SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;

-- join0
SELECT a.empno, a.ename, b.deptno, b.dname
FROM emp a, dept b
WHERE a.deptno = b.deptno
ORDER BY deptno asc;

-- join0_1
SELECT a.empno, a.ename, b.deptno, b.dname
FROM emp a, dept b
WHERE a.deptno = b.deptno
and (b.deptno= 10 OR b.deptno= 30);

SELECT a.empno, a.ename, b.deptno, b.dname
FROM emp a, dept b
WHERE a.deptno = b.deptno
and (b.deptno= 10 OR b.deptno= 30);
