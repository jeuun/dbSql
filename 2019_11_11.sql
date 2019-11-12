--서브쿼리 실습 3
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
FROM emp
WHERE ename = 'SMITH'
OR ename = 'WARD');

--ANY : 만족하는 것이 하나라도 있는가
-- ANY : set중에 만족하는게 하나라도 있으면 참으로(크기비교)
-- SMITH, WARD 두사람의 급여보다 적은 급여를 받는 직원 정보 조회
SELECT *
FROM emp
WHERE sal < ANY(SELECT sal
FROM emp
WHERE ename IN ('SMITH', 'WARD'));

--ALL : 전부 만족하는가
--SMITH와 WARD보다 급여가 높은 직원 조회
--SMITH보다도 급여가 높고 WARD보다도 급여가 높은사람(AND)
SELECT *
FROM emp
WHERE sal > all(SELECT sal --800, 1250 --> 1250보다를 높은 급여를 받는사람
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));
                
--DISTINCT : 중복 제거
--어떤 직원의 관리자 역할을 하지 않는 직원 정보 조회
--NOT IN 에서는 NULL값이 존재할 경우 조회가 되지않는다.
--따라서 조건문에 조치를 취해야 한다.

--관리자의 직원정보
--1.관리자인 사람만 조회
--  . mgr 컬럼에 값이 나오는 직원
SELECT mgr
FROM emp;

--어떤 직원의 관리자 역할을 하는 직원 정보 조회
SELECT *
FROM emp
WHERE empno IN (7839,7782,7698,7902,7566,7788);

SELECT *
FROM emp
WHERE empno IN (SELECT mgr
                FROM emp);

--관리자 역할을 하지 않는 평 사원 정보 조회
--단 NOT IN연산자 사용시 SET에 NULL이 포함될 경우 정상적으로 동작하지 않는다
--NULL처리 함수나 WHERE절을 통해 NULL값을 처리한 이후 사용
SELECT *
FROM emp      --7839,7782,7698,7902,7566,7788 다음6개의 사번에 포함되지 않는 직원        
WHERE empno NOT IN (SELECT NVL(mgr, -9999)
                    FROM emp);

--pair wise
--사번 7499, 7782인 직원의 관리자, 부서번호 조회
--7698	30
--7839	10
--직원중에 관리자와 부서번호가 (7698, 30) 이거나, (7839, 10)인 사람
--mgr, deptno 컬럼을 [동시]에 만족 시키는 직원 정보 조회
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));

SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE empno IN (7499, 7782))
AND deptno IN(SELECT deptno
              FROM emp
              WHERE empno IN (7499, 7782));
              
-- SCALAR SUBQUERY : SELECT 절에 등장하는 서브 쿼리 (단 값이 하나의 행, 하나의 컬럼)
-- 직원의 소속 부서명을 JOIN 을 사용하지 않고 조회
SELECT empno, ename, deptno, (SELECT dname
                                FROM dept
                                WHERE deptno = emp.deptno) dname
FROM emp;

SELECT dname
FROM dept
WHERE deptno = 20;

-- 실습 sub4
SELECT *
FROM dept;
INSERT INTO dept VALUES (99,'ddit','daejoen');
commit;

SELECT *
FROM dept
WHERE deptno IN (SELECT deptno
                    FROM dept
                    WHERE deptno >= 40);
                    
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT  deptno
                        FROM emp);
SELECT  deptno
FROM emp;

-- 실습 sub5
SELECT pid
FROM cycle
WHERE cid = '1'; --  cid=1인 고객이 애음하는 제품코드(pid)

SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                    FROM cycle
                    WHERE cid = '1');

-- 실습 sub6
SELECT *
FROM cycle
WHERE cid = '2';

SELECT *
FROM cycle
WHERE cid = 1 
AND pid IN (SELECT pid
            FROM cycle
            WHERE cid = '2');

-- 실습 sub7            
SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT *
FROM cycle
WHERE cid ='2';

SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM cycle, product, customer
WHERE cycle.pid = product.pid
AND cycle.cid= customer.cid 
AND cycle.cid = '1'
AND cycle.pid IN (SELECT pid
                FROM cycle
                WHERE cid ='2');

-- EXISTS MAIN 쿼리의 컬럼을 사용해서 SUBQUERY에 만족하는 조건이 있는지 체크
-- 만족하는 값이 하나라도 존재하면 더 이상 진행하지 않고 멈추기 때문에 성능면에서 유리

-- MGR가 존재하는 직원 조회
SELECT *
FROM emp a
WHERE EXISTS(SELECT 'X'
                FROM emp
                WHERE empno = a.mgr);

-- MGR가 존재하지 않는 직원 조회
SELECT *
FROM emp a
WHERE NOT EXISTS(SELECT 'X'
                FROM emp
                WHERE empno = a.mgr);

-- 실습 sub8               
SELECT *
FROM emp
WHERE mgr IS NOT NULL; 

-- 부서에 소속된 직원이 있는 부서 정보 조회
SELECT * 
FROM dept
WHERE deptno IN(10,20,30);

SELECT *
FROM dept
WHERE NOT EXISTS(SELECT *
                    FROM emp
                    WHERE deptno = dept.deptno);
-- 실습 sub9


--집합연산
--UNION : 합집합, 중복을 제거
--        DBMS에서는 중복을 제거하기위해 데이터를 정렬
--        (대량의 데이터에 대해 정렬시 부하)
--UNION ALL : UNION과 같은개념
--            중복을 제거하지 않고, 위 아래 집합을 결합 => 중복가능
--            위아래 집합에 중복되는 데이터가 없다는 것을 확신하면
--            UNION 연산자보다 성능면에서 유리
--사번이 7566 또는 7698인 사원 조회 (사번, 이름)

SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION 
--사번이 7369, 7499인 사원 조회 (사번, 이름)
SELECT empno, ename
FROM EMP
WHERE empno = 7566 OR empno = 7698;
--WHERE empno =7369 OR empno=7499;


--UNION ALL(중복 허용, 위 아래 집합을 합치기만 한다)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION ALL
--사번이 7369, 7499인 사원 조회 (사번, 이름)
SELECT empno, ename
FROM EMP
WHERE empno = 7566 OR empno = 7698;
--WHERE empno =7369 OR empno=7499;



--INTERSECT(교집합 :위 아래 집합간 공통 데이터)
SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7369) 

INTERSECT

SELECT empno, ename
FROM EMP
WHERE empno IN(7566, 7698, 7499);


--MINUS(차집합 :위 집합에서 아래 집합을 제거)
--순서가 존재
SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7369) 

MINUS

SELECT empno, ename
FROM EMP
WHERE empno IN(7566, 7698, 7499);

SELECT empno, ename
FROM EMP
WHERE empno IN(7566, 7698, 7499)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698, 7369) ;


SELECT 1 n, 'x' m
FROM dual


union 

SELECT 2, 'y'
FROM dual;


SELECT *
FROM USER_CONSTRAINTS
WHERE OWNER = 'SEM'
AND TABLE_NAME IN ('PROD', 'LPROD')
AND CONSTRAINT_TYPE IN ('P', 'R');
