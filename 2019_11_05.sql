-- ��� �Ķ���Ͱ� �־����� �� �ش� �� ���� �ϼ��� ���ϴ� ����
-- 201911 --> 30 / 201912 --> 31

-- �Ѵ� ���� �� �������� ���� = �ϼ�
-- ������ ��¥ ���� ��  --> DD�� ����
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
-- nvl(col1, col1�� null�� ��� ��ü�� ��)
SELECT empno, ename, sal ,comm, nvl(comm, 0) nvl_comm,
    sal + comm,
    sal + nvl(comm, 0),
    nvl(sal + comm, 0)
FROM emp;

-- NVL2(coll, coll�� null�� �ƴ� ��� ǥ���Ǵ� ��, coll�� null�� ��� ǥ�� �Ǵ� ��)
SELECT empno, ename, sal, comm, NVL2(comm, comm, 0) + sal
FROM emp;

-- NULL (expr1,expr2)
-- expr1 == expr2 ������ null
-- else : expr1
SELECT empno, ename, sal, comm, NULLIF(sal,1250)
FROM emp;

-- COALESCE(expr1, expr2, expr3 ...)
-- �Լ� ���� �� null�� �ƴ� ù��° ���� 
SELECT empno, ename, sal, comm, coalesce(comm, sal)
FROM emp;

-- �ǽ� fn4
SELECT empno, ename, mgr, nvl(mgr, 9999),
       nvl2(mgr, mgr, 9999),
       coalesce(mgr,9999)
FROM emp;

SELECT *
FROM users;

-- �ǽ� fn5
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

-- �ǽ� cond1
SELECT empno, ename,
    case
        when deptno = '10' then 'ACCOUNTING'
        when deptno = '20' then 'RESEARCH'
        when deptno = '30' then 'SALES'
        when deptno = '40' then 'OPERATIONS'
        else 'DDIT'
    end DNAME
FROM emp;

-- �ǽ� cond2
SELECT empno, ename, hiredate,
    case
    when MOD(TO_CHAR(hiredate, 'YYYY'),2) = MOD(TO_CHAR(SYSDATE,'YYYY'),2)
        then '�ǰ����� �����'
    else '�ǰ����� ������'
    end CONTACT_TO_DOCTOR  
FROM emp;

-- �� �ؼ��� ¦���ΰ�? Ȧ���ΰ�?
-- 1. �� �س⵵ ���ϱ� (DATE --> TO_CHAR(DATE, FORMAT))
-- 2. ���� �⵵�� ¦������ ���
-- � ���� 2�� ������ �������� �׻� 2���� �۴�
-- 2�� ������� �������� 0,1
-- MOD(���, ������)
SELECT MOD(TO_CHAR(SYSDATE,'YYYY'),2)
FROM DUAL;

-- emp���̺��� �Ի����ڰ� Ȧ�������� ¦�������� Ȯ��
SELECT empno, ename, hiredate,
    case when MOD(TO_CHAR(hiredate,'YYYY'),2) =  MOD(TO_CHAR(SYSDATE,'YYYY'),2)
    then '�ǰ����� ���'
    else '�ǰ����� �� �����'
    end CONTACT_TO_DOCTOR  
FROM emp;

-- �ǽ� cond3
SELECT userid, usernm, alias, reg_dt,
    case when mod(to_char(reg_dt,'yyyy'),2) = mod(to_char(sysdate,'yyyy'),2)
    then '�ǰ����� ����'
    else '�ǰ����� �� �����'
    end CONTACT_TO_DOCTOR
FROM users;

-- �׷��Լ�(AVG, MAX, MIN, SUM, COUNT)
-- ���� �� ���� ���� �޿��� �޴� ����� �޿�
-- ���� �� ���� ���� �޿��� �޴� ����� �޿�
SELECT MAX(sal) max_sal, MIN(sal) min_sal
FROM emp;

--�μ��� ���� ���� �޿��� �޴»���� �޿�
--GROUP BY ���� ������� ���� �÷��� SELECT ���� ����� ��� ����
SELECT deptno, 'test', 1, MAX(sal) max_sal, MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp
GROUP BY deptno;


--�μ��� �ִ� �޿�
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