-- emp 테이블에는 부서번호(deptno)만 존재
-- emp 테이블에서 부서명을 조회하기 위해서는
-- dept 테이블과 조인을 통해 부서명 조회

-- 조인 문법 
-- ANSI : 테이블 JOIN 테이블2 ON (테이블.COL = 테이블2.COL)
--        emp JOIN dept ON (emp.deptno = dept.deptno)
-- ORACLE : FORM 테이블, 테이블2 WHERE 테이블.col = 테이블2.col
--          FORM emp, dept WHERE emp.deptno = dept.deptno

-- 사원번호, 사원명, 부서번호, 부서명
SELECT empno, ename, dept.deptno, dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

SELECT empno, ename, dept.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- 실습 join0_2
SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE sal > 2500 AND sal <= 5000
ORDER BY deptno;

-- 실습 join0_3
SELECT a.empno, a.ename, a.sal, a.deptno, b.dname
FROM emp a, dept b
WHERE a.deptno = b.deptno
AND sal > 2500
AND empno > 7600;

-- 실습 join0_4
SELECT a.empno, a.ename, a.sal, a.deptno, b.dname
FROM emp a JOIN dept b ON (a.deptno = b.deptno)
WHERE sal > 2500 
AND empno > 7600
AND dname = 'RESEARCH';

SELECT a.empno, a.ename, a.sal, a.deptno, b.dname
FROM emp a, dept b
WHERE a.deptno = b.deptno
AND sal > 2500 
AND empno > 7600
AND dname = 'RESEARCH';

-- 실습 base_tables.sql join1
SELECT b.lprod_gu, b.lprod_nm, a.prod_id, a.prod_name
FROM prod a JOIN lprod b ON (a.prod_lgu = b.lprod_gu);

-- 실습 base_tables.sql join2
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer JOIN prod ON (buyer.BUYER_ID = prod.prod_buyer);

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer, prod
WHERE buyer.BUYER_ID = prod.prod_buyer;

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM cart, prod, member;

-- 실습 base_tables.sql join3
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM cart, prod, member
WHERE member.mem_id = cart.cart_member
AND prod.prod_id = cart.cart_prod;

SELECT a.cid, cnm, pid, day, cnt
FROM customer a, cycle b;

-- 실습 base_tables.sql join4
SELECT a.cid, cnm, pid, day, cnt
FROM customer a, cycle b
WHERE a.cid = b.cid
AND a.cnm = 'brown'
OR a.cnm = 'sally'
ORDER BY cid;

-- 실습 base_tables.sql join5
SELECT a.cid, a.cnm, b.pid, c.pnm, b.day, b.cnt
FROM customer a, cycle b, product c
WHERE a.cid = b.cid
AND b.pid = c.pid
AND (a.cnm = 'brown'
OR a.cnm = 'sally');

-- 실습 base_tables.sql join6
SELECT customer.cid, cnm, cycle.pid, pnm, SUM(CNT) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
AND cycle.pid = product.pid
GROUP BY customer.cid, cnm, cycle.pid, pnm;

-- 실습 base_tables.sql join7
SELECT cycle.pid, pnm, SUM(CNT) cnt
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, pnm
ORDER BY pnm;

