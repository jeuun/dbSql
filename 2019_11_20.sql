-- GROUPING (cube, rollup 절의 사용된 컬럼)
-- 해당 컬럼이 소계 계산에 사용된 경우 1 
-- 사용되지 않은 경우 0
SELECT job, deptno, GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

-- job 컬럼
-- case1.GROUPING(job)=1 AND GROUPING(deptno) = 1
--       job --> '총계'
-- case else
--       job --> job

-- GROUP AD2
SELECT CASE WHEN GROUPING(job) = 1 AND 
                 GROUPING(deptno) = 1 THEN '총계'
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
-- CUBE 절에 나열된 컬럼의 가능한 모든 조합에 대해 서브 그룹으로 생성
-- CUBE에 나열된 컬럼에 대해 방향성은 없다(rollup과의 차이)
-- GROUP BY (job, deptno)
-- 00 : GROUP BY job, deptno
-- 0X : GROUP BY job
-- X0 : GROUP BY deptno
-- XX : GROUP BY -- 모든 데이터에 대해서 ..

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE(job, deptno);

select *
from emp;

-- sub query를 통한 업데이트
drop table emp_test;

-- emp테이블의 데이터를 포함해서 모든 컬럼을 이용하여 emp_test테이블로 생성
CREATE TABLE emp_test AS
SELECT *
FROM emp;

SELECT *
FROM emp_test;

-- emp_test테이블의 dept테이블에서 관리되고 있는 dname컬럼(VARCHAR2(14))을 추가
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

-- emp_test테이블의 dname컬럼을 dept테이블의 dname컬럼 값으로 업데이트하는 쿼리 작성
UPDATE emp_test SET dname = (SELECT dname
                                FROM dept
                                WHERE dept.deptno = emp_test.deptno);
-- 조건 추가도 가능
WHERE empno IN (7369,7499);

commit;

-- 실습 sub_al
ALTER TABLE dept_test ADD (empcnt number);

UPDATE dept_test SET empcnt = (SELECT COUNT(*)
                                FROM emp
                                WHERE deptno = dept_test.deptno);

-- 10 번 부서의 부서원 수 구하는 쿼리
SELECT COUNT(*)
FROM emp
WHERE deptno = 20;

-- 실습 sub_a2
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
-- 실습 sub_a3
UPDATE emp_test a SET sal = sal + 200
WHERE sal <  (select AVG(SAL)
            from emp_test b
            WHERE b.deptno = a.deptno);


SELECT *
FROM emp_test
WHERE SAL < (SELECT AVG(sal)SAL
                FROM emp_test
                GROUP BY deptno);
                
                
