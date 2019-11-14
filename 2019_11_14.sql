-- 제약조건 활성화 / 비활성화
-- 어떤 제약조건을 활성화(비활성화) 시킬 대상인가?

-- emp fk제약 (dept테이블의 deptno컬럼 참조)
-- FK_EMP_DEPT 비활성화
ALTER TABLE emp DISABLE CONSTRAINT FK_EMP_DEPT;

-- 제약조건에 위배되는 데이터가 들어갈 수 있지 않는지 확인
INSERT INTO emp(empno, ename, deptno)
VALUES (9999,'brown',80);

-- FK_EMP_DEPT 활성화
ALTER TABLE emp ENABLE CONSTRAINT FK_EMP_DEPT;

-- 제약조건에 위배되는 데이터 (소속 부서번호가 80번인 데이터)가
-- 존재하여 제약조건 활성화 불가
DELETE emp
WHERE empno = 9999;

-- FK_EMP_DEPT 활성화
ALTER TABLE emp ENABLE CONSTRAINT FK_EMP_DEPT;
commit;

-- 현재 계정에 존재하는 테이블 목록 view : USER_TABLES
-- 현재 계정에 존재하는 제약조건 view : USER_CONSTRAINTS
-- 현재 계정에 존재하는 제약조건의 컬럼 view : USER_CONS_COLUMNS
SELECT *
FROM user_constraints -- 제약조건
WHERE table_name = 'CYCLE';

--FK_EMP_DEPT
SELECT *
FROM USER_CONS_COLUMNS -- 해당 제약조건의 컬럼
WHERE CONSTRAINT_NAME = 'PK_CYCLE';

-- 테이블에 설정된 제약조건 조회 (VIEW 조인)
-- 테이블명 / 제약조건명 / 컬럼명 / 컬럼 포지션

SELECT a.table_name, a.constraint_name, b.column_name, b.position
FROM user_constraints a, user_cons_columns b
WHERE a.constraint_name = b.constraint_name
AND a.constraint_type = 'P' -- primary key만 조회
ORDER BY a.table_name, b.position;

DESC CUSTOMER;

-- emp테이블과 8가지 컬럼 주석달기
-- EMPNO ENAME JOB MGR HIREDATE SAL COMM DEPTNO

-- 테이블 주석 view : USER_TAB_COMMENTS

SELECT *
FROM user_tab_comments;

-- emp 테이블 주석
COMMENT ON TABLE emp IS '사원';

SELECT *
FROM user_tab_comments
WHERE table_name = 'EMP';

-- emp 테이블의 컬럼 주석
SELECT *
FROM user_col_comments;

-- EMPNO ENAME JOB MGR HIREDATE SAL COMM DEPTNO
COMMENT ON COLUMN emp.empno IS '사원번호';
COMMENT ON COLUMN emp.ename IS '이름';
COMMENT ON COLUMN emp.JOB IS '담당업무';
COMMENT ON COLUMN emp.mgr IS '관리자 사번';
COMMENT ON COLUMN emp.hiredate IS '입사일자';
COMMENT ON COLUMN emp.sal IS '급여';
COMMENT ON COLUMN emp.comm IS '상여';
COMMENT ON COLUMN emp.deptno IS '소속부서정보';

-- 실습 comment1
SELECT a.table_name,a.table_type,a.comments tab_comment,b.COLUMN_NAME, b.comments
FROM user_tab_comments a, user_col_comments b
WHERE a.table_name IN ('CUSTOMER','CYCLE','DAILY','PRODUCT')
AND b.table_name = a.TABLE_NAME;

-- view 생성 (emp테이블에서 sal, comm두개 컬럼을 제외한다)
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

-- INLINE VIEW
SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno 
        FROM emp);

-- VIEW(위 인라인뷰와 동일하다)
SELECT *
FROM v_emp;

-- 조인된 쿼리 결과를 view로 생성 : v_emp_dept
-- emp, dept : 부서명, 사원번호, 사원명, 담당업무, 입사일자

CREATE OR REPLACE VIEW v_emp_dept AS 
SELECT a.dname, b.empno, b.ename, b.job, b.hiredate
FROM dept a, emp b
WHERE a.deptno = b.deptno;

SELECT *
FROM v_emp_dept;

-- VIEW 제거
DROP VIEW v_emp;

-- VIEW를 구성하는 테이블의 데이터를 변경하면 VIEW에도 영향이 간다
-- dept 30 - sales
SELECT *
FROM v_emp_dept;

-- dept테이블의 sales -> market sales
UPDATE dept SET dname = 'MARKET SALES'
WHERE deptno = 30;

rollback;



-- HR계정에게 v_emp_dept view 조회 권한을 준다 : 급여를 감추고 싶을때
GRANT SELECT ON v_emp_dept TO hr;

-- SEQUENCE 생성 (게시글 번호 부여용 시퀀스) : 유일한 값을 생성 
CREATE SEQUENCE seq_post 
INCREMENT BY 1
START WITH 1;


SELECT seq_post.nextval, seq_post.currval
FROM dual;

SELECT seq_post.currval --  방금 실행했던 값
FROM dual;

SELECT *
FROM post -- 테이블이 없어서 실행 X
WHERE reg_id = 'brown' 
and title = '하하하하'
and reg_dt = to_date('2019/11/14 15:40:15', 'YYYY/MM/DD HH24:MI:SS');

SELECT *
FROM post -- 테이블이 없어서 실행 X
WHERE post_id = 1;

-- 시퀀스 복습
-- 시퀀스 : 중복되지 않는 정수 값을 리턴 해주는 객체
-- 1, 2, 3, ...
DESC EMP_TEST;

DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR(15)
    );

CREATE SEQUENCE seq_emp_test;    

INSERT INTO emp_test VALUES (seq_emp_test.nextval, 'brown'); -- (중복되지 않는 값, 'brown')

SELECT *
FROM emp_test;

SELECT seq_emp_test.nextval
FROM dual;

-- INDEX
-- rowid : 테이블 행의 물리적 주소, 해당 주소를 알면 빠르게 테이블에 접근하는것이 가능하다.

SELECT product.*, ROWID
FROM product
WHERE ROWID = 'AAAFNzAAFAAAAHtAAA';

