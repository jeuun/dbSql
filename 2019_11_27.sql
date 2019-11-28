SELECT *
FROM no_emp;

--1. leaf node 찾기
SELECT org_cd, parent_org_cd, no_emp, lv, leaf, rn, gr,
    SUM(no_emp) OVER (PARTITION BY GR ORDER BY rn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) s_emp
FROM
(SELECT a.*, ROWNUM rn, a.lv + ROWNUM gr,
    COUNT(org_cd) OVER (PARTITION BY org_cd) org_cnt
FROM
(SELECT org_cd, parent_org_cd, no_emp, LEVEL LV,CONNECT_BY_ISLEAF leaf
FROM no_emp
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd)a
START WITH leaf = 1
CONNECT BY PRIOR parent_org_cd = org_cd));


-- PL / SQL
-- 할당연산 :=
-- System.out.println("") --> dbms_out.put_line("");
-- Log4j
-- set setveroutput on; -- 출력 기능을 활성화

-- PL/SQL
-- declare : 변수, 상수 선언
-- begin : 로직 실행
-- exception : 예외처리

set serveroutput on;


DECLARE
    -- 변수 선언
    deptno NUMBER(2);
    dname VARCHAR2(14);
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    
    -- SELECT 절의 결과를 변수에 잘 할당 했는지 확인
    dbms_output.put_line('dname : ' || dname || '(' || deptno || ')');
END;
/ -- 마침을 잘 해야한다.


CREATE OR REPLACE PROCEDURE printdept
    IS
    -- 참조 변수 선언(테이블 컬럼타입이 변경되도 PL/SQL 구문을 수정할 필요가 없다)
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = 10;
    
    -- SELECT 절의 결과를 변수에 잘 할당 했는지 확인
    dbms_output.put_line('dname,loc='|| dname ||','||loc);
END;
/

exec printdept;

CREATE OR REPLACE PROCEDURE printdept_p(p_deptno IN dept.deptno%TYPE)
    IS
    -- 참조 변수 선언(테이블 컬럼타입이 변경되도 PL/SQL 구문을 수정할 필요가 없다)
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = p_deptno;
    
    -- SELECT 절의 결과를 변수에 잘 할당 했는지 확인
    dbms_output.put_line('dname,loc='|| dname ||','||loc);
END;
/

exec printdept_p(30);

-- PRO_1

CREATE OR REPLACE PROCEDURE printemp_procedure(p_empno IN emp.empno%TYPE)
    IS
    -- 참조 변수 선언(테이블 컬럼타입이 변경되도 PL/SQL 구문을 수정할 필요가 없다)
    ename emp.ename%TYPE;
    dname dept.dname%TYPE;
BEGIN
  SELECT emp.ename, dept.dname
    INTO ename, dname
    FROM dept, emp
    WHERE empno = p_empno
    AND  dept.deptno = emp.deptno;
    
    -- SELECT 절의 결과를 변수에 잘 할당 했는지 확인
    dbms_output.put_line('ename,dname='|| ename ||','||dname);
END;
/

exec printemp_procedure(7369);

-- PRO_2
select *
from dept_test;

select *
from dept_test;

DROP TABLE DEPT_TEST;

CREATE TABLE DEPT_TEST AS
SELECT *
FROM DEPT;

DELETE dept_test
WHERE deptno > 90;

commit;

CREATE OR REPLACE PROCEDURE registerdept_test(p_empno IN dept_test%TYPE, 
                                        p_dname IN dept_test%TYPE, p_loc IN dept_test%TYPE)
    IS
    -- 참조 변수 선언(테이블 컬럼타입이 변경되도 PL/SQL 구문을 수정할 필요가 없다)

BEGIN
  INSERT 
    INTO dept_test 
    VALUES (P_DEPTNO, P_DNAME, P_LOC);
    
    -- SELECT 절의 결과를 변수에 잘 할당 했는지 확인
    dbms_output.put_line('ename,dname='|| ename ||','||dname);
END;
/
exec registdept_test('99', 'ddit', 'daejoen');