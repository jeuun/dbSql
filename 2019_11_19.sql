-- EMP_TEST 테이블 제거
DROP TABLE EMP_TEST;

-- MULTIPLE INSERT를 위한 테스트 테이블 생성
-- EMPNO, ENAME 두개의 컬럼을 갖는 EMP_TEST, EMP_TEST2 테이블을 
-- EMP 테이블로 부터 생성한다. (CTAS)
-- 데이터는 복제하지 않는다.

CREATE TABLE emp_test AS
SELECT empno, ename
FROM emp
WHERE 1=2;

CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp
WHERE 1=2;

-- INSERT ALL
-- 하나의 INSERT SQL문장으로 여러 테이블에 데이터를 입력
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT 1, 'brown' FROM dual UNION ALL
SELECT 2, 'sally' FROM dual;

-- INSERT 데이터 확인
SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

-- INSERT ALL 컬럼 정의
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
    ELSE -- 조건을 통과하지 못할 때만 실행
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

-- INSERT FIRST
-- 조건에 만족하는 첫번째 INSERT 구문만 실행
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

-- MERGE :  조건에 만족하는 데이터가 있으면 UPDATE
--          조건에 만족하는 데이터가 없으면 INSERT
ROLLBACK;

-- empno가 7369인 데이터를 EMP테이블로 부터 EMP_TEST테이블에 복사(INSERT)
INSERT INTO emp_test 
SELECT EMPNO, ENAME
FROM EMP
WHERE EMPNO = 7369;

SELECT *
FROM EMP_TEST;

-- emp 테이블의 데이터중 emp_test 테이블의 empno와 같은 값을 갖는 데이터가 있을 경우
-- emp_test.ename = ename || 'merge' 값으로 update
-- 데이터가 없을 경우에는 emp_test테이블에 insert
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
    
-- 다른 테이블을 통하지 않고 테이블 자체의 데이터 존재 유무로 merge하는 경우
rollback;

-- empno = 1, ename = 'brown'
-- empno가 같은 값이 있으면 ename을 'brown'으로 update
-- empno가 같은 값이 없으면 신규 insert

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

-- 위 쿼리를 ROLL UP 형태로 변경
SELECT deptno, sum(sal) SAL
FROM emp
group by rollup(deptno);
    

-- roll up
-- group by의 서브 그룹을 생성
-- GROUP BY ROLLUP({COL,})
-- 컬럼을 오른쪽에서부터 제거해가면서 나온 서브 그룹을 
-- GROUP BY 하여 UNION 한 것과 동일
-- EX : GROUP BY ROLL UP(JOB, DEPTNO)
--      GROUP BY job, deptno,
--      UNION
--      GROUP BY job
--      UNION
--      GROUP BY --> 총계 (모든 행에 대해 그룹함수 적용)

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
-- GROUPING SETS의 나열된 항목이 하나의 서브그룹으로 GROUP BY 절에 이용된다.

-- GROUP BY col1
-- UNION ALL
-- GROUP BY col2

-- emp 테이블을 이용하여 부서별 급여합과 담당 업무(job)별 급여합을 구하시오 

-- 부서번호,job,급여합계
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