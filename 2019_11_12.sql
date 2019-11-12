INSERT INTO DEPT
VALUES ('ddit', 99 ,'daejeon');

desc emp;

INSERT INTO emp(ename, job)
VALUES ('brown', null);

SELECT *
FROM emp
WHERE empno = 9999;

rollback;

desc emp;

SELECT *
FROM user_tab_columns
WHERE table_name = 'EMP';

INSERT INTO emp
VALUES (9999,'eun','ranger',null,sysdate,2500,null,40);



-- UPDATE
-- UPDATE 테이블 SET 컬럼 = 값, 컬럼 = 값,...
-- WHERE condition;

UPDATE dept SET dname = '대덕it', loc = 'ym'
WHERE deptno=99;

-- WHERE deptno = 99;
rollback;

-- 고객관리 - 현금영수증 (야구르트 여사님 - 13000, 운영팀, 일반직원, 영업점-650)
-- 주민번호 뒷자리
UPDATE 사용자뒷자리 set 비밀번호=주민번호뒷자리
WHERE 사용자 구분이 = '여사님';
COMMIT;

SELECT *
FROM emp;

-- 사원번호가 9999인 직원을 emp 테이블에서 삭제
DELETE emp
WHERE empno = 9999;

-- 부서테이블을 이용해서 emp 테이블에 입력한 5건의 데이터를 삭제
-- 10,20,30,40,99 --> empno < 100, empno BETWEEN 10 AND 99
DELETE emp
WHERE empno < 100;

SELECT *
FROM emp
WHERE empno < 100;

DELETE emp
WHERE empno BETWEEN 10 AND 99;

DELETE emp
WHERE empno IN (SELECT deptno FROM dept);

commit;

-- DDL : AUTO COMMIT, rollback이 안된다.
-- CREATE
CREATE TABLE ranger_new(
    ranger_no NUMBER,   -- 숫자 타입
    ranger_name VARCHAR2(50),-- 문자 : [VARCHAR2], CHAR
    reg_dt DATE DEFAULT sysdate -- DEFAULT : SYSDATE
);

desc ranger_new;

-- ddl은 rollback이 적용되지 않는다.
rollback;

INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES (1000,'brown');

SELECT *
FROM ranger_new;
COMMIT;

-- 날짜 타입에서 특정 필드 가져오기
-- ex : sysdate에서 년도만 가져오기
SELECT TO_CHAR(sysdate,'YYYY')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt, TO_CHAR(reg_dt,'MM'),
        EXTRACT(MONTH FROM reg_dt) MM,
        EXTRACT(YEAR FROM reg_dt) YEAR,
        EXTRACT(DAY FROM reg_dt) DAY
FROM ranger_new;

-- 제약조건
-- DEPT 모방해서 DEPT_TEST 생성
desc dept_test;
CREATE TABLE dept_test(
    deptno number(2)PRIMARY KEY, -- deptno 컬럼을 식별자로 지정
    dname varchar2(14),          -- 식별자로 지정이 되면 값이 중복이 될 수 없으며 null일수도 없다.
    loc varchar2(13)
);

-- primary key 제약조건 확인
-- 1. deptno컬럼에 null이 들어갈 수 없다.
-- 2. deptno컬럼에 중복된 값이 들어갈 수 없다
INSERT INTO dept_test (deptno, dname, loc)
VALUES (null,'ddit','daejeon');

INSERT INTO dept_test VALUES(1,'ddit','daejoen');
INSERT INTO dept_test VALUES(1,'ddit2','daejoen');

ROLLBACK;

-- 사용자 지정 제약조건명을 부여한 PRIMARY KEY
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_DEPT_TEST PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR(3));

-- TABLE CONSTRAINT
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR(14),
    loc VARCHAR(13),
    
    CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno, dname)
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');

SELECT *
FROM dept_test;
rollback;

-- NOT NULL
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13),
    );
INSERT INTO dept_test VALUES (1,'ddit','daejoen');
INSERT INTO dept_test VALUES (2, null,'daejoen');

-- UNIQUE
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13),
    );
INSERT INTO dept_test VALUES (1,'ddit','daejoen');
INSERT INTO dept_test VALUES (2, 'ddit','daejoen');