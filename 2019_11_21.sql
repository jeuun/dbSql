-- �������� ADVANCED
-- ���� ������ �޿���� 2073.21
SELECT ROUND(AVG(sal),2)
FROM emp;

-- �μ��� ������ �޿� ��� 10 XXXX, 20 YYYY, 30 ZZZZ
SELECT *
FROM 
    (SELECT deptno, ROUND(AVG(sal),2) d_avgsal
    FROM emp
    GROUP BY deptno)
WHERE d_avgsal > (SELECT ROUND(AVG(sal),2)
                    FROM emp);

-- ���� ���� WITH���� �����Ͽ� ������ �����ϰ� ǥ���Ѵ�.
WITH dept_avg_sal AS(
    SELECT deptno, ROUND(AVG(sal),2) d_avgsal
    FROM emp
    GROUP BY deptno)
    
SELECT *
FROM dept_avg_sal
WHERE d_avgsal > (SELECT ROUND(AVG(sal), 2) FROM emp);

-- �޷¸����
-- STEP1. �ش� ����� ���� �����
-- CONNECT BY LEVEL
-- 201911
-- DATE + ���� = ���� ���ϱ� ����

SELECT DECODE(d, 1, a.iw+1, a.iw)iw
            ,MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue
           , MAX(DECODE(d, 4, dt)) wed, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri
           , MAX(DECODE(d, 7, dt)) sat
FROM 
    (SELECT TO_DATE(:YYYYMM,'YYYYMM') + (level-1) dt,
            TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM') + (level-1),'w') w,
            TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM') + (level-1),'d') d
    FROM dual a
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')), 'DD')) a
GROUP BY a.w, DECODE(d, 1, a.iw+1, a.iw)
ORDER BY a.w;

create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;

-- sales ���̺� ����
SELECT NVL(MAX(DECODE(TO_CHAR(DT,'MM'),'01', SUM(sales))),0) jan,
        NVL(MAX(DECODE(TO_CHAR(DT,'MM'),'02', SUM(sales))),0) feb,
        NVL(MAX(DECODE(TO_CHAR(DT,'MM'),'03', SUM(sales))),0) mar,
        NVL(MAX(DECODE(TO_CHAR(DT,'MM'),'04', SUM(sales))),0) apr,
        NVL(MAX(DECODE(TO_CHAR(DT,'MM'),'05', SUM(sales))),0) may,
        NVL(MAX(DECODE(TO_CHAR(DT,'MM'),'06', SUM(sales))),0) june
FROM sales
GROUP BY TO_CHAR(DT,'MM');

SELECT *
FROM sales;

-- ��������
-- START WITH : ������ ���� �κ��� ����
-- CONNECT BY : ������ ���� ������ ����

-- ����� �������� (���� �ֻ��� ������������ ��� ������ Ž��)
-- �ǽ� h1
SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*4, ' ') || dept_h.deptnm
FROM dept_h
START WITH deptcd = 'dept0' -- START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd; -- PRIOR ���� ���� ������(XXȸ��)

create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XXȸ��', '');
insert into dept_h values ('dept0_00', '�����κ�', 'dept0');
insert into dept_h values ('dept0_01', '������ȹ��', 'dept0');
insert into dept_h values ('dept0_02', '�����ý��ۺ�', 'dept0');
insert into dept_h values ('dept0_00_0', '��������', 'dept0_00');
insert into dept_h values ('dept0_01_0', '��ȹ��', 'dept0_01');
insert into dept_h values ('dept0_02_0', '����1��', 'dept0_02');
insert into dept_h values ('dept0_02_1', '����2��', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '��ȹ��Ʈ', 'dept0_01_0');
commit;

-- �ǽ� h2
SELECT LEVEL LV, dept_h.DEPTCD, LPAD(' ', (LEVEL-1)*4, ' ') || deptnm deptnm, P_DEPTCD
FROM dept_h
START WITH deptcd = 'dept0_02' -- START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd; -- PRIOR ���� ���� ������(XXȸ��)
--PRIOR ���� ���� ���� �����͸� ���Ѵ�.

select *
FROM dept_h;

-- ����� ���� ����
-- Ư�� ���κ��� �ڽ��� �θ��带 Ž��(Ʈ�� ��ü Ž���� �ƴϴ�)
-- ���������� �������� ���� �μ��� ��ȸ
-- �������� dept0_00_0

-- �ǽ� h3
-- ������������ �����ϴ� ����� ���� ����
SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR  p_deptcd = deptcd;
-- ������������ ���������� �����ڵ带 �μ��ڵ�� �ϴ� ������

create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;

-- �ǽ� h4 : ����� ����

SELECT * 
FROM h_sum;

SELECT LPAD(' ', 4*(level), ' ') || s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id ;

create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XXȸ��', null, 1);
insert into no_emp values('�����ý��ۺ�', 'XXȸ��', 2);
insert into no_emp values('����1��', '�����ý��ۺ�', 5);
insert into no_emp values('����2��', '�����ý��ۺ�', 10);
insert into no_emp values('������ȹ��', 'XXȸ��', 3);
insert into no_emp values('��ȹ��', '������ȹ��', 7);
insert into no_emp values('��ȹ��Ʈ', '��ȹ��', 4);
insert into no_emp values('�����κ�', 'XXȸ��', 1);
insert into no_emp values('��������', '�����κ�', 7);

commit;

-- �ǽ� h5
SELECT org_cd
FROM no_emp;

SELECT LPAD(' ', 4*(level-1), ' ') ||org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;