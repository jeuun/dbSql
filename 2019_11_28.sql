CREATE OR REPLACE PROCEDURE UPDATEdept_test (p_deptno IN dept_test.deptno%TYPE, 
                                        p_dname IN dept_test.dname%TYPE, 
                                        p_loc IN dept_test.loc%TYPE)
    IS
    -- ���� ���� ����(���̺� �÷�Ÿ���� ����ǵ� PL/SQL ������ ������ �ʿ䰡 ����)

BEGIN
    UPDATE dept_test SET dname = p_name, loc = p_loc
    WHERE deptno = p_deptno;
    COMMIT;
    -- SELECT ���� ����� ������ �� �Ҵ� �ߴ��� Ȯ��
    dbms_output.put_line('ename,dname='|| ename ||','||dname);
END;
/
exec UPDATEdept_test('99', 'ddit', 'daejoen');


select *
from dept_test;

-- ROWTYPE : ���̺��� �� ���� �����͸� ���� �� �ִ� ���� Ÿ��
set serveroutput on;
DECLARE
    dept_row dept%ROWTYPE;
BEGIN
    SELECT *
    INTO dept_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(dept_row.deptno || ',' ||dept_row.dname || ',' || dept_row.loc);
END;
/

-- ���պ��� : record
DECLARE
    -- UserVO userVo;
    TYPE dept_row IS RECORD(
        deptno NUMBER(2),
        dname dept.dname%TYPE);
    
    v_row dept_row;
BEGIN
    SELECT deptno, dname
    INTO v_row
    FROM dept
    WHERE deptno = 10;

    dbms_output.put_line(v_row.deptno || ',' || v_row.dname);
END;
/

-- tabletype
DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    
    -- java: Ÿ�� ������ : 
    -- pl/sql : ������ Ÿ��;
    v_dept dept_tab;
    
BEGIN
    SELECT *
    BULK COLLECT INTO v_dept
    FROM dept;
    
    FOR i IN 1 .. v_dept.count LOOP
        dbms_output.put_line(v_dept(i).dname);
    END LOOP;
    
END;
/

select *
from dept;

-- IF
-- ELSE IF --> ELSIF
-- END IF;

DECLARE 
    ind BINARY_INTEGER;
BEGIN
     int := 2;
     
     IF ind = 1 THEN
        dbms_output.put_line(ind);
     ELSIF ind = 2 THEN
        dbms_output.put_line('ELSIF ' || ind);
    ELSE
        dbms_output.put_line('ELSE');
    END IF;
END;
/

-- FOR LOOP : 
-- FOR �ε��� ���� IN ���۰�..���ᰪ LOOP
-- END LOOP;

DECLARE
BEGIN
    FOR i IN 0..5 LOOP
         dbms_ouput.put_line('i : ' || i );
    END LOOP;
END;
/

-- LOOP : ��� ���� �Ǵ� ������ LOOP�ȿ��� ����
-- java : while(true)

DECLARE
    i NUMBER;
BEGIN
    i := 0;
    
    LOOP 
    dbms_output.put_line(i);
    i := i+1;
    -- loop ��� ���࿩�� �Ǵ�
    EXIT WHEN  i >= 5;
    EXIT LOOP;
END;
/

 CREATE TABLE DT
(	DT DATE);

insert into dt
select trunc(sysdate + 10) from dual union all
select trunc(sysdate + 5) from dual union all
select trunc(sysdate) from dual union all
select trunc(sysdate - 5) from dual union all
select trunc(sysdate - 10) from dual union all
select trunc(sysdate - 15) from dual union all
select trunc(sysdate - 20) from dual union all
select trunc(sysdate - 25) from dual;

commit;

-- ���� ��� : 5��

DECLARE
    TYPE dt_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dt dt_tab;
    ind NUMBER;
    sum_bt NUMBER;
    i NUMBER;
BEGIN 
    SELECT *
    BULK COLLECT INTO v_dt
    FROM dt;
    
    i:= v_dt COUNT;
    sum_bt = 0;
    
LOOP
    ind := v_dt(i-1).dt - v_dt(i).dt
    sum_bt := sum_bt + ind
    
    i := i-1
    EXIT WHEN I <=1;
END;
/

-- lead, lag ���� ���� ����, ���� �����͸� ������ �� �ִ�.
SELECT AVG(diff)
FROM
(SELECT dt, LEAD(dt) OVER (ORDER BY dt DESC) diff
FROM dt);

-- �м��Լ��� ������� ���ϴ� ȯ�濡��
SELECT AVG(a.dt - b.dt)
FROM
(SELECT ROWNUM RN, dt
FROM 
    (SELECT dt
    FROM dt
    ORDER BY dt DESC))a,
(SELECT ROWNUM rn, dt
FROM 
    (SELECT dt
    FROM dt
    ORDER BY dt DESC))b
WHERE a.rn = b.rn(+)-1;

-- HALL OF HONOR
SELECT (MAX(dt) - MIN(dt)) / (COUNT(*) - 1)
FROM dt;

DECLARE 
    -- Ŀ�� ����
    CURSOR dept_cursor IS
        SELECT deptno, dname FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    -- Ŀ�� ����
    OPEN dept_cursor;
    LOOP
        FETCH dept_cursor INTO v_deptno, v_dname;
        dbms_output.put_line(v_deptno || ', ' || v_dname);
        EXIT WHEN dept_cursor%NOTFOUND; -- �� �̻� ���� �����Ͱ� ������ ����
    END LOOP;
END;
/

-- FOR LOOP CURSOR ����
DECLARE    
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    FOR rec IN dept_cursor LOOP 
        dbms_output.put_line(rec.deptno || ',' ||rec.dname);
    END LOOP;
END;
/

-- �Ķ���Ͱ� �ִ� ����� Ŀ��
DECLARE
    CURSOR emp_cursor(p_job emp.job%TYPE) IS
        SELECT empno, ename, job
        FROM emp
        WHERE job = p_job;

BEGIN
    FOR emp IN emp_cursor('SALESMAN') LOOP
        dbms_output.put_line(emp.empno || ',' ||emp.ename ||',' ||emp.job);
    END LOOP;
END;
/