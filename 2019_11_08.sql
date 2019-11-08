-- 조인 복습
-- RDBMS의 특성상 데이터 중복을 최대 배제한 설계를 한다.
-- EMP 테이블에는 직원의 정보가 존재, 해당 직원의 소속 부서 정보는 부서번호만 갖고있고, 
-- 부서번호를 통해 dept 테이블과 조인을 통해 해당 부서의 정보를 가져올 수 있다.

-- 직원 번호, 직원 이름, 직원의 소속 부서번호, 부서이름
-- emp, dept
SELECT emp.empno, emp.ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- 부서번호, 부서명, 해당부서의 인원수]
-- COUNT(col) : col값이 존재하면 1, null : 0, 행수가 궁금한것이면 *
SELECT dept.deptno, dept.dname, COUNT(empno) cnt
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY dept.deptno, dept.dname;

-- TOTAL ROW : 14
SELECT COUNT(*), COUNT(EMPNO), COUNT(MGR), COUNT(COMM)
FROM emp;

-- OUTER JOIN : 조인에 실패도 기준이 되는 테이블의 데이터는 조회 결과가 나오도록 하는 조인 형태
-- LEFT OUTER JOIN : JOIN KEYWORD 왼쪽에 위치한 테이블이 조회 기준이 되도록 하는 조인 형태
-- RIGHT OUTER JOIN : JOIN KEYWORD 오른쪽에 위치한 테이블이 조회 기준이 되도록 하는 조인 형태
-- FULL OUTER JOIN : LEFT OUTER JOIN + RIGHT OUTER JOIN - 중복제거

-- 직원 정보와 해당 직원의 관리자 정보
-- 직원번호, 직원이름, 관리자 번호, 관리자 이름
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno);

-- oracle outer join (left, right만 존재 fullouter는 지원하지 않음
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

-- oracle outer 문법에서는 outer 테이블이 되는 모든 컬럼에 (+)를 붙여줘야 outer joing 이 정상적으로 동작한다.
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
AND b.deptno(+) = 10;

-- ANSI RIGHT OUTER
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a RIGHT OUTER JOIN emp b ON (a.mgr = b.empno);

-- 실습 outer join1
SELECT a.buy_date, a.buy_prod, b.prod_id, b.prod_name, a.buy_qty
FROM buyprod a, prod b
WHERE a.buy_prod(+) = b.prod_id
AND a.buy_date(+) = '05/01/25';

-- 실습 outer join2
SELECT TO_DATE('05/01/25','YY/MM/DD') buy_date, a.buy_prod, b.prod_id, b.prod_name, a.buy_qty
FROM buyprod a, prod b
WHERE a.buy_prod(+) = b.prod_id
AND a.buy_date(+) = '05/01/25';

-- 실습 outer join3
SELECT TO_DATE('05/01/25','YY/MM/DD') buy_date, a.buy_prod, b.prod_id, b.prod_name, nvl(buy_qty,'0')
FROM buyprod a, prod b
WHERE a.buy_prod(+) = b.prod_id
AND a.buy_date(+) = '05/01/25';

-- 실습 outer join4
SELECT b.pid, b.pnm, nvl(cid,'1') CID, nvl(day ,'0')DAY, COUNT(CID)CNT
FROM cycle a, product b
WHERE a.pid(+) = b.pid
AND a.cid(+) = '1'
GROUP BY b.pid, b.pnm, CID, DAY
ORDER BY PID;

-- 실습 outer join5
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

-- 실습 crossjoin 1 
SELECT cid, cnm, pid, pnm
FROM customer, product;

-- subquery : main 쿼리에 속하는 부분 쿼리 (하나의 행과, 하나의 컬럼만 조회되는 쿼리이여야 한다.) 
-- 사용되는 위치 : 
-- SELECT - scalar subquery
-- FROM - inline view
-- WHERE - subquery

-- SCALAR subquery
SELECT empno, ename,(SELECT SYSDATE FROM dual) now /*현재날짜*/
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

-- 실습 sub1 평균급여 먼저 찾기 직원보다 높은급여 찾기
SELECT AVG(sal) -- 
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
                FROM emp);
                
-- 실습 sub2          
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
                FROM emp);
-- 실습 sub3
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


