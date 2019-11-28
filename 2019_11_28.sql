CREATE OR REPLACE PROCEDURE UPDATEdept_test (p_deptno IN dept_test.deptno%TYPE, 
                                        p_dname IN dept_test.dname%TYPE, 
                                        p_loc IN dept_test.loc%TYPE)
    IS
    -- 참조 변수 선언(테이블 컬럼타입이 변경되도 PL/SQL 구문을 수정할 필요가 없다)

BEGIN
    UPDATE dept_test SET dname = p_name, loc = p_loc
    WHERE deptno = p_deptno;
    COMMIT;
    -- SELECT 절의 결과를 변수에 잘 할당 했는지 확인
    dbms_output.put_line('ename,dname='|| ename ||','||dname);
END;
/
exec UPDATEdept_test('99', 'ddit', 'daejoen');


select *
from dept_test;

-- ROWTYPE : 테이블의 한 행의 데이터를 담을 수 있는 참조 타입
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

-- 복합변수 : record
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
    
    -- java: 타입 변수명 : 
    -- pl/sql : 변수명 타입;
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
-- FOR 인덱스 변수 IN 시작값..종료값 LOOP
-- END LOOP;

DECLARE
BEGIN
    FOR i IN 0..5 LOOP
         dbms_ouput.put_line('i : ' || i );
    END LOOP;
END;
/

-- LOOP : 계속 실행 판단 로직을 LOOP안에서 제어
-- java : while(true)

DECLARE
    i NUMBER;
BEGIN
    i := 0;
    
    LOOP 
    dbms_output.put_line(i);
    i := i+1;
    -- loop 계속 진행여부 판단
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

-- 간격 평균 : 5일

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

-- lead, lag 현재 행의 이전, 이후 데이터를 가져올 수 있다.
SELECT AVG(diff)
FROM
(SELECT dt, LEAD(dt) OVER (ORDER BY dt DESC) diff
FROM dt);

-- 분석함수를 사용하지 못하는 환경에서
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
    -- 커서 선언
    CURSOR dept_cursor IS
        SELECT deptno, dname FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    -- 커서 열기
    OPEN dept_cursor;
    LOOP
        FETCH dept_cursor INTO v_deptno, v_dname;
        dbms_output.put_line(v_deptno || ', ' || v_dname);
        EXIT WHEN dept_cursor%NOTFOUND; -- 더 이상 읽을 데이터가 없을때 종료
    END LOOP;
END;
/

-- FOR LOOP CURSOR 결합
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

-- 파라미터가 있는 명시적 커서
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