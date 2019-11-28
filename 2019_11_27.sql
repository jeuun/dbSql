SELECT *
FROM no_emp;

--1. leaf node ã��
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
-- �Ҵ翬�� :=
-- System.out.println("") --> dbms_out.put_line("");
-- Log4j
-- set setveroutput on; -- ��� ����� Ȱ��ȭ

-- PL/SQL
-- declare : ����, ��� ����
-- begin : ���� ����
-- exception : ����ó��

set serveroutput on;


DECLARE
    -- ���� ����
    deptno NUMBER(2);
    dname VARCHAR2(14);
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    
    -- SELECT ���� ����� ������ �� �Ҵ� �ߴ��� Ȯ��
    dbms_output.put_line('dname : ' || dname || '(' || deptno || ')');
END;
/ -- ��ħ�� �� �ؾ��Ѵ�.


CREATE OR REPLACE PROCEDURE printdept
    IS
    -- ���� ���� ����(���̺� �÷�Ÿ���� ����ǵ� PL/SQL ������ ������ �ʿ䰡 ����)
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = 10;
    
    -- SELECT ���� ����� ������ �� �Ҵ� �ߴ��� Ȯ��
    dbms_output.put_line('dname,loc='|| dname ||','||loc);
END;
/

exec printdept;

CREATE OR REPLACE PROCEDURE printdept_p(p_deptno IN dept.deptno%TYPE)
    IS
    -- ���� ���� ����(���̺� �÷�Ÿ���� ����ǵ� PL/SQL ������ ������ �ʿ䰡 ����)
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = p_deptno;
    
    -- SELECT ���� ����� ������ �� �Ҵ� �ߴ��� Ȯ��
    dbms_output.put_line('dname,loc='|| dname ||','||loc);
END;
/

exec printdept_p(30);

-- PRO_1

CREATE OR REPLACE PROCEDURE printemp_procedure(p_empno IN emp.empno%TYPE)
    IS
    -- ���� ���� ����(���̺� �÷�Ÿ���� ����ǵ� PL/SQL ������ ������ �ʿ䰡 ����)
    ename emp.ename%TYPE;
    dname dept.dname%TYPE;
BEGIN
  SELECT emp.ename, dept.dname
    INTO ename, dname
    FROM dept, emp
    WHERE empno = p_empno
    AND  dept.deptno = emp.deptno;
    
    -- SELECT ���� ����� ������ �� �Ҵ� �ߴ��� Ȯ��
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
    -- ���� ���� ����(���̺� �÷�Ÿ���� ����ǵ� PL/SQL ������ ������ �ʿ䰡 ����)

BEGIN
  INSERT 
    INTO dept_test 
    VALUES (P_DEPTNO, P_DNAME, P_LOC);
    
    -- SELECT ���� ����� ������ �� �Ҵ� �ߴ��� Ȯ��
    dbms_output.put_line('ename,dname='|| ename ||','||dname);
END;
/
exec registdept_test('99', 'ddit', 'daejoen');