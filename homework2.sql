-- 실습 sub7

SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM cycle, product, customer
WHERE cycle.pid = product.pid
AND cycle.cid= customer.cid 
AND cycle.cid = '1'
AND cycle.pid IN (SELECT pid
                FROM cycle
                WHERE cid ='2');
                
-- 실습 sub9
SELECT *
FROM product;

SELECT *
FROM product
WHERE NOT EXISTS (SELECT pid
                    FROM cycle 
                    WHERE cid = 1
                    AND product.pid = cycle.pid);


SELECT * 
FROM cycle
WHERE cid = 1;