-- SELECT :  ��ȸ�� �÷� ���
--           - ��ü �÷� ��ȸ : *
--           - �Ϻ� �÷�: �ش� �÷��� ���� (, ����)
-- FROM : ��ȸ�� ���̺� ���
-- ������ �����ٿ� ����� �ۼ��ص� ��� ����.
-- �� keyword�� �ٿ��� �ۼ�

-- ��� �÷��� ��ȸ
SELECT * FROM prod;

-- Ư�� �÷��� ��ȸ
SELECT prod_id, prod_name
FROM prod;

--1 lprod ���̺��� ��� �÷� ��ȸ

SELECT
    *
FROM lprod;

--2 buyer ���̺��� buyer_id. buyer_name�÷��� ��ȸ�ϴ� ������ �ۼ��ϼ���

SELECT
    buyer_id, buyer_name
FROM buyer;

--3 cart���̺��� ��� �����͸� ��ȸ�ϴ� ������ �ۼ��ϼ���

SELECT
    *
FROM cart;

--4 member���̺��� mem_id, mem-pass, mem_name�÷��� ��ȸ�ϴ� ������ �ۼ��ϼ���

SELECT
    mem_id, mem_pass, mem_name
FROM member;

-- ������ / ��¥���� 
-- date type + ���� : ���ڸ� ���Ѵ�.
-- null�� ������ ������ ����� �׻� null�̴�.

SELECT userid, usernm, reg_dt, 
        reg_dt +5 reg_dt_after5,
        reg_dt -5 as reg_dt_before5
FROM users;

--�ǽ� 2 
-- prod���̺��� prod_id, prod_name �� �÷��� ��ȸ�ϴ� ������ �ۼ��ϼ��� id name���� ��Ī�� ����
SELECT
    prod_id  as id, 
    prod_name as name 
    
FROM prod;

--lprod���̺��� lprod_gu, lprod_nm �� �÷��� ��ȸ�ϴ� ������ �ۼ��ϼ��� gu,nm���� ��Ī�� ����
SELECT 
    lprod_gu as gu,
    lprod_nm as nm
    
FROM lprod;

--buyer���̺���  buyer_id ,buyer_name �� �÷��� ��ȸ�ϴ� ������ �ۼ��ϼ���. ���̾���̵� �̸� ��Ī�� ����
SELECT
    buyer_id as ���̾���̵�, 
    buyer_name as �̸�
    
FROM
    buyer;

-- ���ڿ� ����
-- java + --> sql ||
-- CONCAT(str,str) �Լ�
-- users���̺��� userid, usernm
SELECT userid, usernm, 
       userid || usernm,
       CONCAT(userid,usernm)
FROM users;

-- ���ڿ� ��� (�÷��� ��� �����Ͱ� �ƴ϶� �����ڰ� ���� �Է��� ���ڿ�)
SELECT '����� ���̵� : ' || userid,
        CONCAT('����� ���̵� : ', userid)
FROM users;

-- �ǽ� sel_con1
SELECT *
FROM user_tables;

SELECT
    'SELECT * FROM ' || table_name ||';'
    as QUERY
FROM
    user_tables;
    
-- desc table
-- ���̺� ���ǵ� �÷��� �˰� ���� ��
-- 1. desc
-- 2. select * ....

desc emp;

select *
FROM emp;

--WHERE��, ���� ������
SELECT *
FROM users
WHERE userid = 'brown';

--usernm�� ������ �����͸� ��ȸ�ϴ� ������ �ۼ�

SELECT *
FROM usernm
WHERE usernm = 'sally';

