-- 테이블에서 데이터 조회
/*
    SELECT 컬럼 || express(문자열상수) [AS] 별칭
    FROM 데이터를 조회할 테이블(VIEW)
    WHERE 조건 (condition)
*/

DESC user_tables;
SELECT table_name, 
'SELECT * FROM' || table_name || ';' AS select_query
FROM user_tables
WHERE TABLE_NAME != 'EMP';
-- 전체건수-1

-- 숫자비교 연산
-- 부서번호가 30번 보다 크거나 같은 부서에 속한 직원 조회
SELECT *
FROM emp
WHERE deptno >= 30;

-- 부서번호가 30번보다 작은 부서에 속한 직원 조회
SELECT *
FROM emp
WHERE deptno < 30;

-- 입사일자가 1982년 1월 1일 이후인 직원 조회
SELECT *
FROM emp
--WHERE hiredate < '82/01/01';
WHERE hiredate >= TO_DATE('1982/01/01','YYYY/MM/DD');

-- col BETWEEN X AND Y 연산
-- 컬럼의 값이 x보다 크거나 같고, Y보다 작거나 같은 데이터
-- 급여(sal)가 1000보다 크거나 같고, 2000보다 작거나 같은 데이터를 조회
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

-- 위의 BETWEEN AND 연산자는 아래의 <=, >= 조합과 같다
SELECT *
FROM emp
WHERE sal >= 1000 
AND sal <= 2000
AND deptno = 30;

-- where1
SELECT ename,hiredate
FROM emp
WHERE hiredate
    BETWEEN TO_DATE('1982/01/01','YYYY/MM/DD')
    AND TO_DATE('1983/01/01','YYYY/MM/DD');
    
-- where2
SELECT ename,hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01','YYYY/MM/DD')
       AND hiredate <= TO_DATE('1983/01/01','YYYY/MM/DD');