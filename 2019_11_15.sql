-- emp테이블에 empno컬럼을 기준으로 PRIMARY KEY를 생성
-- PRIMARY KEY = UNIQUE + NOT NULL
-- UNIQUE --> 해당 컬럼으로 UNIQUE INDEX를 자동으로 생성
-- index 생성하면 정렬이 자동으로 가능하다

ALTER TABLE emp ADD CONSTRAINT FK_EMP PRIMARY KEY (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;

SELECT *
FROM TABLE (dbms_xplan.display); -- 외우기, 복사해서 사용

 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    37 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    37 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | FK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7369)
   
-- empno 컬럼으로 인덱스가 존재하는 상황에서 
-- 다른 컬럼값으로 데이터를 조회하는 경우
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'; -- 실행계획을 만든다

SELECT *
FROM TABLE(dbms_xplan.display); -- 실행계획 조회

--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("JOB"='MANAGER')
   
-- 인덱스 구성 컬럼만 SELECT 절에 기술한 경우 
-- 테이블 접근이 필요없다.

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7782'; 

SELECT *
FROM TABLE(dbms_xplan.display); 

commit;

-- 컬럼에 중복이 가능한 non-unique 인덱스 생성 후
-- unique index와의 실행계획 비교
-- PRIMARY KEY 제약조건 삭제 (unique 인덱스 삭제)
ALTER TABLE emp DROP CONSTRAINT pk_emp;
CREATE INDEX /*UNIQUE*/ IDX_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7782'; 

SELECT *
FROM TABLE(dbms_xplan.display); 

-- emp 테이블에 job 컬럼으로 두번째 인덱스 생성 (non- unique index)
-- job 컬럼은 다른 로우의 job컬럼과 중복이 가능한 컬럼이다.
CREATE INDEX idx_emp_02 ON emp (job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'; 

SELECT *
FROM TABLE(dbms_xplan.display); 

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%'; 

SELECT *
FROM TABLE(dbms_xplan.display); 

Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER')

-- emp테이블에 job, ename 컬럼을 기준으로 non-unique 인덱스 생성
CREATE INDEX IDX_emp_03 ON emp (job, ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%'; 

SELECT *
FROM TABLE(dbms_xplan.display); 
Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')
       
-- emp테이블에 ename, job 컬럼으로 non-unique 인덱스 생성
CREATE INDEX IDX_EMP_04 ON emp (ename,job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C'; 

SELECT *
FROM TABLE(dbms_xplan.display); 

-- HINT를 사용한 실행계획 제어
EXPLAIN PLAN FOR
SELECT /*+ INDEX ( emp idx_emp_03 ) */ * -- HINT이용
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C'; 

SELECT *
FROM TABLE(dbms_xplan.display); 

Plan hash value: 4060516099
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX SKIP SCAN           | IDX_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE '%C' AND "ENAME" IS NOT NULL)
       
-- 실습 idx1
CREATE TABLE DEPT_TEST AS 
SELECT * FROM DEPT 
WHERE 1 = 1;

CREATE UNIQUE INDEX index_name ON dept_test(deptno);

CREATE INDEX index_name2 ON dept_test(dname);

CREATE INDEX index_name3 ON dept_test(dname, deptno);

-- 실습 idx2
DROP INDEX index_name;
DROP INDEX index_name2;
DROP INDEX index_name3;

-- 실습 idx3
CREATE TABLE EMP_TEST1 AS
SELECT * FROM EMP
WHERE 1 = 1;

COMMIT;
SELECT *
FROM EMP_TEST1;

ALTER TABLE emp_test1 ADD CONSTRAINT pk_empno PRIMARY KEY (empno);

commit;

CREATE INDEX index_emp_test ON emp_test1 (deptno);
CREATE INDEX index_emp_test1 ON emp_test1 (ename);
CREATE INDEX index_emp_test2 ON emp_test1 (deptno, sal);
CREATE INDEX index_emp_test3 ON emp_test1 (deptno, empno);
COMMIT;

EXPLAIN PLAN FOR
SELECT *
FROM emp_test1
WHERE empno = 7298; 

SELECT *
FROM TABLE(dbms_xplan.display); 

EXPLAIN PLAN FOR
SELECT *
FROM emp_test1
WHERE ename = 'SCOTT'; 

SELECT *
FROM TABLE(dbms_xplan.display); 

EXPLAIN PLAN FOR
SELECT *
FROM emp_test1
WHERE sal BETWEEN 500 and 7000
AND deptno = 20; 

SELECT *
FROM TABLE(dbms_xplan.display); 

EXPLAIN PLAN FOR
SELECT *
FROM emp_test1, dept
WHERE emp_test1.deptno = dept.deptno
AND emp_test1.deptno = 10
AND emp_test1.empno LIKE '78%'; 

SELECT *
FROM TABLE(dbms_xplan.display); 


EXPLAIN PLAN FOR
SELECT B.*
FROM emp_test1 a, emp_test1 b
WHERE a.mgr = b.empno
AND a.deptno = 30; 

SELECT *
FROM TABLE(dbms_xplan.display); 

commit;
