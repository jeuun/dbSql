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
-- UPDATE ���̺� SET �÷� = ��, �÷� = ��,...
-- WHERE condition;

UPDATE dept SET dname = '���it', loc = 'ym'
WHERE deptno=99;

-- WHERE deptno = 99;
rollback;

-- ������ - ���ݿ����� (�߱���Ʈ ����� - 13000, ���, �Ϲ�����, ������-650)
-- �ֹι�ȣ ���ڸ�
UPDATE ����ڵ��ڸ� set ��й�ȣ=�ֹι�ȣ���ڸ�
WHERE ����� ������ = '�����';
COMMIT;

SELECT *
FROM emp;

-- �����ȣ�� 9999�� ������ emp ���̺��� ����
DELETE emp
WHERE empno = 9999;

-- �μ����̺��� �̿��ؼ� emp ���̺� �Է��� 5���� �����͸� ����
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

-- DDL : AUTO COMMIT, rollback�� �ȵȴ�.
-- CREATE
CREATE TABLE ranger_new(
    ranger_no NUMBER,   -- ���� Ÿ��
    ranger_name VARCHAR2(50),-- ���� : [VARCHAR2], CHAR
    reg_dt DATE DEFAULT sysdate -- DEFAULT : SYSDATE
);

desc ranger_new;

-- ddl�� rollback�� ������� �ʴ´�.
rollback;

INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES (1000,'brown');

SELECT *
FROM ranger_new;
COMMIT;

-- ��¥ Ÿ�Կ��� Ư�� �ʵ� ��������
-- ex : sysdate���� �⵵�� ��������
SELECT TO_CHAR(sysdate,'YYYY')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt, TO_CHAR(reg_dt,'MM'),
        EXTRACT(MONTH FROM reg_dt) MM,
        EXTRACT(YEAR FROM reg_dt) YEAR,
        EXTRACT(DAY FROM reg_dt) DAY
FROM ranger_new;

-- ��������
-- DEPT ����ؼ� DEPT_TEST ����
desc dept_test;
CREATE TABLE dept_test(
    deptno number(2)PRIMARY KEY, -- deptno �÷��� �ĺ��ڷ� ����
    dname varchar2(14),          -- �ĺ��ڷ� ������ �Ǹ� ���� �ߺ��� �� �� ������ null�ϼ��� ����.
    loc varchar2(13)
);

-- primary key �������� Ȯ��
-- 1. deptno�÷��� null�� �� �� ����.
-- 2. deptno�÷��� �ߺ��� ���� �� �� ����
INSERT INTO dept_test (deptno, dname, loc)
VALUES (null,'ddit','daejeon');

INSERT INTO dept_test VALUES(1,'ddit','daejoen');
INSERT INTO dept_test VALUES(1,'ddit2','daejoen');

ROLLBACK;

-- ����� ���� �������Ǹ��� �ο��� PRIMARY KEY
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