-- ���� ����
-- RDBMS�� Ư���� ������ �ߺ��� �ִ� ������ ���踦 �Ѵ�.
-- EMP ���̺����� ������ ������ ����, �ش� ������ �Ҽ� �μ� ������ �μ���ȣ�� �����ְ�, 
-- �μ���ȣ�� ���� dept ���̺��� ������ ���� �ش� �μ��� ������ ������ �� �ִ�.

-- ���� ��ȣ, ���� �̸�, ������ �Ҽ� �μ���ȣ, �μ��̸�
-- emp, dept
SELECT emp.empno, emp.ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- �μ���ȣ, �μ���, �ش�μ��� �ο���]
-- COUNT(col) : col���� �����ϸ� 1, null : 0, ����� �ñ��Ѱ��̸� *
SELECT dept.deptno, dept.dname, COUNT(empno) cnt
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY dept.deptno, dept.dname;

-- TOTAL ROW : 14
SELECT COUNT(*), COUNT(EMPNO), COUNT(MGR), COUNT(COMM)
FROM emp;

-- OUTER JOIN : ���ο� ���е� ������ �Ǵ� ���̺��� �����ʹ� ��ȸ ����� �������� �ϴ� ���� ����
-- LEFT OUTER JOIN : JOIN KEYWORD ���ʿ� ��ġ�� ���̺��� ��ȸ ������ �ǵ��� �ϴ� ���� ����
-- RIGHT OUTER JOIN : JOIN KEYWORD �����ʿ� ��ġ�� ���̺��� ��ȸ ������ �ǵ��� �ϴ� ���� ����
-- FULL OUTER JOIN : LEFT OUTER JOIN + RIGHT OUTER JOIN - �ߺ�����

-- ���� ������ �ش� ������ ������ ����
-- ������ȣ, �����̸�, ������ ��ȣ, ������ �̸�
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno);

-- oracle outer join (left, right�� ���� fullouter�� �������� ����
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+);

-- ANSI LEFT OUTER
SELECT a.empno, a.ename, a.mgr, a.ename
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, a.ename
FROM emp a LEFT OUTER JOIN emp b 
ON a.mgr = b.empno
WHERE b.empno = 10;

-- oracle outer ���������� outer ���̺��� �Ǵ� ��� �÷��� (+)�� �ٿ���� outer joing �� ���������� �����Ѵ�.
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
AND b.deptno(+) = 10;

-- ANSI RIGHT OUTER
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a RIGHT OUTER JOIN emp b ON (a.mgr = b.empno);

-- �ǽ� outer join1
SELECT a.buy_date, a.buy_prod, b.prod_id, b.prod_name, a.buy_qty
FROM buyprod a, prod b
WHERE a.buy_prod(+) = b.prod_id
AND a.buy_date(+) = '05/01/25';

-- �ǽ� outer join2
SELECT TO_DATE('05/01/25','YY/MM/DD') buy_date, a.buy_prod, b.prod_id, b.prod_name, a.buy_qty
FROM buyprod a, prod b
WHERE a.buy_prod(+) = b.prod_id
AND a.buy_date(+) = '05/01/25';

-- �ǽ� outer join3
SELECT TO_DATE('05/01/25','YY/MM/DD') buy_date, a.buy_prod, b.prod_id, b.prod_name, nvl(buy_qty,'0')
FROM buyprod a, prod b
WHERE a.buy_prod(+) = b.prod_id
AND a.buy_date(+) = '05/01/25';

-- �ǽ� outer join4
SELECT b.pid, b.pnm, nvl(cid,'1') CID, nvl(day ,'0')DAY, COUNT(CID)CNT
FROM cycle a, product b
WHERE a.pid(+) = b.pid
AND a.cid(+) = '1'
GROUP BY b.pid, b.pnm, CID, DAY
ORDER BY PID;

-- �ǽ� outer join5
(SELECT b.pid, b.pnm, nvl(cid,'1') CID, nvl(day ,'0')DAY, COUNT(CID)CNT
FROM cycle a, product b customer c
WHERE a.pid(+) = b.pid
AND a.cid(+) = '1'
GROUP BY b.pid, b.pnm, nvl(cid,'1'), nvl(day ,'0')
ORDER BY PID);

select *
from customer;

SELECT a.pid, a.pnm, a.cid, b.cnm,a.day, a.cnt
FROM (SELECT b.pid, b.pnm, nvl(cid,'1') CID, nvl(day ,'0')DAY, COUNT(CID)CNT
FROM cycle a, product b 
WHERE a.pid(+) = b.pid
AND a.cid(+) = '1'
GROUP BY b.pid, b.pnm, nvl(cid,'1'), nvl(day ,'0')
ORDER BY PID) a, customer b
WHERE a.cid = b.cid
ORDER BY pid desc;

-- �ǽ� crossjoin 1 
SELECT cid, cnm, pid, pnm
FROM customer, product;

-- subquery : main ������ ���ϴ� �κ� ���� (�ϳ��� ���, �ϳ��� �÷��� ��ȸ�Ǵ� �����̿��� �Ѵ�.) 
-- ���Ǵ� ��ġ : 
-- SELECT - scalar subquery
-- FROM - inline view
-- WHERE - subquery

-- SCALAR subquery
SELECT empno, ename,(SELECT SYSDATE FROM dual) now /*���糯¥*/
FROM emp;

SELECT deptno 
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = (SELECT deptno 
                FROM emp
                WHERE ename = 'SMITH');
                
SELECT *
FROM emp
WHERE deptno = 20;

-- �ǽ� sub1 ��ձ޿� ���� ã�� �������� �����޿� ã��
SELECT AVG(sal) -- 
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
                FROM emp);
                
-- �ǽ� sub2          
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
                FROM emp);
-- �ǽ� sub3
SELECT *
FROM emp
WHERE ename = 'SMITH'
OR ename = 'WARD';

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH'
                OR ename = 'WARD');

