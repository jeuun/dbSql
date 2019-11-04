-- ���� 
-- WHERE
-- ������
-- �� : =, !=, <>, >=, >, <=, <
-- BETWEEN start AND end
-- IN(set)
-- LIKE 'S%' (% :  �ټ��� ���ڿ��� ��Ī, _: ��Ȯ�� �� ���� ��Ī)
-- IS NULL ( != NULL ) 
-- AND, OR, NOT

-- emp ���̺��� �Ի����ڰ� 1981�� 6�� 1�Ϻ��� 1986�� 12�� 31�� ���̿� �ִ� ���� ���� ��ȸ
-- BETWEEN AND
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('1981/06/01','YYYY/MM/DD')
                AND TO_DATE ('1986/12/31','YYYY/MM/DD');
-- >=, <=
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD')
AND hiredate <= TO_DATE ('1986/12/31','YYYY/MM/DD');

-- emp ���̺��� ������(mgr)�� �ִ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- where12
SELECT *
FROM emp
WHERE job = 'SALESMAN'
    OR empno LIKE '78%';

-- where13
-- empno�� ���� 4�ڸ����� ���
-- empno : 78, 780, 789 (7800~7899,780~789,78)
desc emp;
SELECT *
FROM emp
WHERE job = 'SALESMAN'
    OR empno = 78
    OR empno BETWEEN 7800 AND 7899
    OR empno BETWEEN 780 AND 789;
    
-- �ǽ� where14
SELECT *
FROM emp
WHERE job ='SALESMAN' 
    OR (empno LIKE '78%'
    AND hiredate > TO_DATE('1981/06/01','YYYY/MM/DD'));
    
SELECT *
FROM emp;

-- order by �÷��� | ��Ī | �÷��ε��� [ASC | DESC]
-- order by ������ WHERE�� ������ ���
-- WHERE ���� ���� ��� FROM�� ������ ���
-- ename �������� �������� ����
SELECT *
FROM emp
ORDER BY ename ASC;

-- ASC : default
-- ASC�� �Ⱥٿ��� �� ������ ������
SELECT *
FROM emp
ORDER BY ename; -- ASC

SELECT *
FROM emp
ORDER BY ename desc;

-- job�� �������� �������� ����, ���� job�� ���� ���
-- ���(empno)���� �ø����� ����
-- SALESMAN - PRESIDENT - MANAGER - CLERK - ANALYST
SELECT *
FROM emp
ORDER BY job DESC, empno asc;

-- ��Ī���� �����ϱ�
-- ��� ��ȣ(empno), �����(ename), ����(sal * 12) as year_sal
-- year_sal ��Ī���� �������� ����
SELECT empno,ename, sal, sal * 12 as year_sal
FROM emp
ORDER BY year_sal;

-- SELECT �� �÷� ���� �ε����� ����
SELECT empno, ename, sal, sal * 12 as year_sal
FROM emp
ORDER BY 4;

-- �ǽ� oderby1
SELECT *
FROM dept
ORDER BY dname;

SELECT *
FROM dept
ORDER BY loc desc;

-- �ǽ� orderby2
SELECT *
FROM emp
WHERE comm IS NOT NULL
ORDER BY comm desc, empno;

-- �ǽ� orderby3
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, mgr desc;

-- �ǽ� order4
SELECT *
FROM emp
WHERE deptno = 10 OR deptno = 30
     AND sal > 1500
ORDER BY ename desc;

SELECT ROWNUM, empno, ename
FROM emp
ORDER BY sal;

-- emp ���̺��� ���(empno), �̸�(ename)�� �޿� �������� �������� �����ϰ� 
-- ���ĵ� ��������� ROWNUM
SELECT empno, ename, sal, ROWNUM
FROM emp
ORDER BY sal;

SELECT a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a;

-- �ǽ� row1
SELECT a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a
WHERE ROWNUM <= 10;

-- �ǽ� row2
SELECT *
FROM 
    (SELECT ROWNUM rn, a.*
    FROM
    (SELECT empno, ename, sal 
    FROM emp
    ORDER BY sal) a )20;
    
    -- FUNTION
    -- DUAL ���̺� ��ȸ
    SELECT * 
    FROM DUAL;
    
    SELECT 'HELLO WORLD'
    FROM emp;
    
    -- ���ڿ� ��ҹ��� ���� �Լ�
    -- LOWER, UPPER, INITCAP
    SELECT LOWER('Hello World'), UPPER('Hello World')
    ,INITCAP('hello world')
    FROM emp
    WHERE job = 'SALESMAN';
    
    -- FUNTION�� WHERE�������� ��밡��
    SELECT *
    FROM emp
    WHERE ename = UPPER ('smith');

    SELECT *
    FROM emp
    WHERE LOWER (ename) = 'smith';
    
    -- ������ SQL ĥ������
    -- 1. �º��� �������� ���ƶ�
    -- �º� (INDEX�� �÷�)�� �����ϰ� �Ǹ� INDEX�� ���������� ������� ����
    -- Funtion Based Index -> FBI
    
    -- CONCAT : ���ڿ� ���� - �� ���� ���ڿ��� �����ϴ� �Լ�
    -- SUBSTR : ���ڿ��� �κ� ���ڿ� (java : String.substring)
    -- LENGTH : ���ڿ��� ����
    -- INSTR : ���ڿ��� Ư�� ���ڿ��� �����ϴ� ù��° �ε���
    -- LPAD : ���ڿ��� Ư�� ���ڿ��� ����
    SELECT CONCAT(CONCAT('HELLO',','), 'WORLD') CONCAT,
        SUBSTR('HELLO, WORLD', 0, 5) substr,
        SUBSTR('HELLO, WORLD', 1, 5)  substr1,
        LENGTH('HELLO, WORLD')length,
        INSTR('HELLO, WORLD','O') instr,
        -- INSTR(���ڿ�, ã�� ���ڿ�, ���ڿ��� Ư�� ��ġ ���� ǥ��)
        INSTR('HELLO,WORLD','O',6) instr, 
    -- LPAD(���ڿ�, ��ü ���ڿ�����, ���ڿ��� ��ü ���ڿ� ���̿� ��ġ�� ���� ��� �߰��� ����); 
        LPAD('HELLO,WORLD',15,'*') lpad,
        LPAD('HELLO,WORLD',15) lpad,
        LPAD('HELLO,WORLD',15,' ') lpad,
        LPAD('HELLO,WORLD',15,'*') rpad
    FROM dual;
