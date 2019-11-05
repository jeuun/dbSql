-- 년월 파라미터가 주어졌을 때 해당 년 월의 일수를 구하는 문제
-- 201911 --> 30 / 201912 --> 31

-- 한달 더한 후 원래값을 빼면 = 일수
-- 마지막 날짜 구한 후  --> DD만 추출
SELECT :yyyymm as param, TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),'DD') dt
FROM DUAL;

desc emp;

explain plan for
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT empno, ename, sal, TO_CHAR(sal, '999,999.99') sal_fmt
FROM emp;

-- function null
-- nvl(col1, col1이 null일 경우 대체할 값)
SELECT empno, ename, sal ,comm, nvl(comm, 0) nvl_comm,
    sal + comm,
    sal + nvl(comm, 0),
    nvl(sal + comm, 0)
FROM emp;

-- NVL2(coll, coll이 null이 아닐 경우 표현되는 값, coll이 null일 경우 표현 되는 값)
SELECT empno, ename, sal, comm, NVL2(comm, comm, 0) + sal
FROM emp;

-- NULL (expr1,expr2)
-- expr1 == expr2 같으면 null
-- else : expr1
SELECT empno, ename, sal, comm, NULLIF(sal,1250)
FROM emp;

-- COALESCE(expr1, expr2, expr3 ...)
-- 함수 인자 중 null이 아닌 첫번째 인자 
SELECT empno, ename, sal, comm, coalesce(comm, sal)
FROM emp;

-- 실습 fn4
SELECT empno, ename, mgr, nvl(mgr, 9999),
       nvl2(mgr, mgr, 9999),
       coalesce(mgr,9999)
FROM emp;

SELECT *
FROM users;

-- 실습 fn5
SELECT  userid, usernm, reg_dt, nvl(reg_dt,to_date(sysdate))
FROM users;

-- condition
SELECT empno, ename, job, sal,
    case
        when job = 'SALESMAN' then sal * 1.05
        when job = 'MANAGER' then sal * 1.10
        when job = 'PRESIDENT' then sal * 1.20
        else sal 
    end case_sal
FROM emp;

-- decode(col, search1, return1, search2, return2..... defult)
SELECT empno, ename, job, sal,
    DECODE(job, 'SALESMAN', sal*1.05, 'MANAGER', sal*1.10, 'PRESIDENT', sal*1.20, sal) decode_sal
FROM emp;

-- 실습 cond1
SELECT empno, ename,
    case
        when deptno = '10' then 'ACCOUNTING'
        when deptno = '20' then 'RESEARCH'
        when deptno = '30' then 'SALES'
        when deptno = '40' then 'OPERATIONS'
        else 'DDIT'
    end DNAME
FROM emp;

-- 실습 cond2
SELECT empno, ename, hiredate,
    case
    when MOD(TO_CHAR(hiredate, 'YYYY'),2) = MOD(TO_CHAR(SYSDATE,'YYYY'),2)
        then '건강검진 대상자'
    else '건강검진 비대상자'
    end CONTACT_TO_DOCTOR  
FROM emp;

-- 올 해수는 짝수인가? 홀수인가?
-- 1. 올 해년도 구하기 (DATE --> TO_CHAR(DATE, FORMAT))
-- 2. 올해 년도가 짝수인지 계산
-- 어떤 수를 2로 나누면 나머지는 항상 2보다 작다
-- 2로 나눌경우 나머지는 0,1
-- MOD(대상, 나눌값)
SELECT MOD(TO_CHAR(SYSDATE,'YYYY'),2)
FROM DUAL;

-- emp테이블에서 입사일자가 홀수년인지 짝수년인지 확인
SELECT empno, ename, hiredate,
    case when MOD(TO_CHAR(hiredate,'YYYY'),2) =  MOD(TO_CHAR(SYSDATE,'YYYY'),2)
    then '건강검진 대상'
    else '건강검진 비 대상자'
    end CONTACT_TO_DOCTOR  
FROM emp;

-- 실습 cond3
SELECT userid, usernm, alias, reg_dt,
    case when mod(to_char(reg_dt,'yyyy'),2) = mod(to_char(sysdate,'yyyy'),2)
    then '건강검진 대상사'
    else '건강검진 비 대상자'
    end CONTACT_TO_DOCTOR
FROM users;

-- 그룹함수(AVG, MAX, MIN, SUM, COUNT)
-- 직원 중 가장 높은 급여를 받는 사람의 급여
-- 직원 중 가장 낮은 급여를 받는 사람의 급여
SELECT MAX(sal) max_sal, MIN(sal) min_sal
FROM emp;

--부서별 가장 높은 급여를 받는사람의 급여
--GROUP BY 절에 기술되지 않은 컬럼이 SELECT 절에 기술될 경우 에러
SELECT deptno, 'test', 1, MAX(sal) max_sal, MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp
GROUP BY deptno;


--부서별 최대 급여
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) > 3000;

--grp1
SELECT MAX(sal) max_sal, MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       COUNT(*) count_all
FROM emp;

--grp1
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       COUNT(*) count_all
FROM emp
GROUP BY deptno;