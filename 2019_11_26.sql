SELECT *
FROM emp;

SELECT ename, sal, deptno, RANK() OVER (PARTITION BY deptno ORDER BY sal) rank,
    DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) d_rank,
    ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) rown
FROM emp;

-- �ǽ� ana 1
SELECT empno, ename, sal, deptno, RANK() OVER (ORDER BY sal desc, empno) sal_rank,
    DENSE_RANK() OVER (ORDER BY sal desc, empno) sal_dense_rank,
    ROW_NUMBER() OVER (ORDER BY sal desc) sal_row_number
FROM emp;

-- �ǽ� no_ana 2
-- �μ��� �ο��� ���ϱ�
SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;

SELECT emp.empno, emp.ename, emp.deptno, b.cnt
FROM emp, (SELECT deptno, COUNT(*) cnt
            FROM emp
            GROUP BY deptno) b
WHERE emp.deptno = b.deptno
ORDER BY emp.deptno;

-- �м��Լ��� ���� �μ��� ������(COUNT)
SELECT ename, empno, deptno,
        COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

-- �μ��� ����� �޿� �հ�
-- SUM �м��Լ�
SELECT ename, empno, deptno, sal,
        SUM(sal) OVER (PARTITION BY deptno) sum_sal
FROM emp;

-- ana2
SELECT empno, ename, sal, deptno,
    ROUND(AVG(sal) OVER (PARTITION BY deptno),2) cnt
FROM emp;

-- ana3
SELECT empno, ename, sal, deptno,
    MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;

-- ana4
SELECT empno, ename, sal, deptno, 
 MIN(SAL) OVER (PARTITION BY deptno) min_sal
FROM emp;

-- �μ��� �����ȣ�� ���� �������
-- �μ��� �����ȣ�� ���� �������

SELECT empno, ename, deptno,
        FIRST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) f_emp,
        LAST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) l_emp
FROM emp;

-- LAG (������)
-- ������
-- LEAD (������)
-- �޿��� ���� ������ ���� ������ �ڱ⺸�� �� �ܰ� �޿��� ���� ����� �޿�, 
--                            �ڱ⺸�� �� �ܰ� �޿��� ���� ����� �޿�,

SELECT empno, ename, sal, LAG(sal) OVER (ORDER BY sal) lag_sal
                          ,LEAD(sal) OVER (ORDER BY sal) lead_sal
FROM emp;

-- ana5
SELECT empno, ename, sal, LEAD(sal) OVER (ORDER BY sal desc, hiredate) lead_sal
FROM emp;

-- ana6
SELECT empno, ename, hiredate, job,
                  LAG(sal) OVER (PARTITION BY job ORDER BY sal desc, hiredate) lag_sal   
FROM emp;

-- no_ana3
SELECT sal
FROM emp;

SELECT a.empno, a.ename, a.sal, SUM(b.sal)
FROM (SELECT sal
        FROM emp)a, emp b
WHERE a.sal = b.sal 
group by a.empno, a.ename, a.sal;

SELECT a.*, ROWNUM rn
FROM ;
        
-- WINDOWING
-- UNBOUNDED PRECEDING : ���� ���� �������� �����ϴ� ��� ��
-- CURRENT ROW : ���� ��
-- UNBOUNDED FOLLOWING : ���� ���� �������� �����ϴ� ��� ��
-- N(����) PRECEDING : ���� ���� �������� �����ϴ� N���� ��
-- N(����) FOLLOWING : ���� ���� �������� �����ϴ� N���� ��

SELECT empno, ename, sal,
    sum(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal,
    sum(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,
     sum(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3
FROM emp;

SELECT empno, ename, deptno, sal, 
        SUM(sal)OVER (PARTITION BY deptno ORDER BY sal, empno 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)c_sum
FROM emp;

SELECT empno, ename, deptno, sal,
        SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
        SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum2
FROM emp;

SELECT empno, ename, deptno, sal,
        SUM(sal) OVER (ORDER BY sal RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
        SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) row_sum2
FROM emp;