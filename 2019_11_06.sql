-- 그룹함수
-- multi row function : 여러개의 행을 입력으로 하나의 결과 행을 생성
-- SUM, MAX, MIN, AVG, COUNT
-- GROUP BY col | express
-- SELECT 절에는 GROUP BY 절에 기술된 COL, EXPRESS 표기 가능

-- 직원 중 가장 높은 급여 조회
-- 14개의 행이 입력으로 들어가 하나의 결과가 도출
SELECT MAX(sal) max_sal
FROM emp;

-- 부서별로 가장 높은 급여 조회
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
-- emp 테이블에는 dname 컬럼이 없다 --> 부서번호(deptno)밖에 없음
desc emp;

-- emp테이블에 부서 이름을 저장할 수 있는 dname 컬럼 추가
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

-- ansi natural join : 테이블의 컬럼명이 같은 컬럼의 기준으로 JOIN
SELECT DEPTNO, ENAME, DNAME
FROM emp NATURAL JOIN DEPT;

-- ORACLE join
SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno;

SELECT emp.empn, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- SELECT join : 같은 테이블끼리 조인
-- emp 테이블의 mgr 정보를 참고하기 위해서 emp 테이블과 조인을 해야한다
-- a : 직원 정보, b : 관리자
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno)
WHERE a.empno between 7369 AND 7698;

-- oracle
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno
AND a.empno between 7369 AND 7698;

-- non-equijoing (등식 조인이 아닌 경우)
SELECT *
FROM salgrade;

-- 직원의 급여 등급은 ? 
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
