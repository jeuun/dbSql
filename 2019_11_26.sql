SELECT *
FROM emp;

SELECT ename, sal, deptno, RANK() OVER (PARTITION BY deptno ORDER BY sal) rank,
    DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) d_rank,
    ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) rown
FROM emp;

-- 실습 ana 1
SELECT empno, ename, sal, deptno, RANK() OVER (ORDER BY sal desc, empno) sal_rank,
    DENSE_RANK() OVER (ORDER BY sal desc, empno) sal_dense_rank,
    ROW_NUMBER() OVER (ORDER BY sal desc) sal_row_number
FROM emp;

-- 실습 no_ana 2
-- 부서별 인원수 구하기
SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;

SELECT emp.empno, emp.ename, emp.deptno, b.cnt
FROM emp, (SELECT deptno, COUNT(*) cnt
            FROM emp
            GROUP BY deptno) b
WHERE emp.deptno = b.deptno
ORDER BY emp.deptno;

-- 분석함수를 통한 부서별 직원수(COUNT)
SELECT ename, empno, deptno,
        COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

-- 부서별 사원의 급여 합계
-- SUM 분석함수
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

-- 부서별 사원번호가 가능 빠른사람
-- 부서별 사원번호가 가능 느린사람

SELECT empno, ename, deptno,
        FIRST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) f_emp,
        LAST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) l_emp
FROM emp;

-- LAG (이전행)
-- 현재행
-- LEAD (다음행)
-- 급여가 높은 순으로 정렬 했을때 자기보다 한 단계 급여가 낮은 사람의 급여, 
--                            자기보다 한 단계 급여가 높은 사람의 급여,

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
-- UNBOUNDED PRECEDING : 현재 행을 기준으로 선행하는 모든 행
-- CURRENT ROW : 현재 행
-- UNBOUNDED FOLLOWING : 현재 행을 기준으로 후행하는 모든 행
-- N(정수) PRECEDING : 현재 행을 기준으로 선행하는 N개의 행
-- N(정수) FOLLOWING : 현재 행을 기준으로 후행하는 N개의 행

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