-- 실습 join8

SELECT *
FROM countries;

SELECT *
FROM regions;

SELECT *
FROM departments;

SELECT *
FROM locations;

-- 실습 join8
SELECT a.region_id, b.region_name, a.country_name
FROM countries a, regions b
WHERE a.region_id = b.region_id
AND region_name = 'Europe';

-- 실습 join9
SELECT countries.region_id, regions.region_name, countries.country_name, locations.city
FROM countries, regions, locations 
WHERE countries.region_id = regions.region_id
AND locations.country_id = countries.country_id
AND region_name = 'Europe';

-- 실습 join10
SELECT a.region_id, b.region_name, a.country_name, c.city, d.department_name
FROM countries a, regions b, locations c, departments d
WHERE a.region_id = b.region_id
AND c.country_id = a.country_id
AND c.location_id = d.location_id
AND region_name = 'Europe';

-- 실습 join11
SELECT a.region_id, b.region_name, a.country_name, c.city, d.department_name, e.first_name || '' || e.last_name AS NAME
FROM countries a, regions b, locations c, departments d, employees e
WHERE a.region_id = b.region_id
AND c.country_id = a.country_id
AND c.location_id = d.location_id
AND d.department_id = e.department_id
AND region_name = 'Europe';

select *
from employees;

-- 실습 join12
SELECT *
FROM employees;

SELECT *
FROM jobs;

SELECT employees.employee_id, first_name || '' || last_name AS NAME ,jobs.job_id,jobs.job_title
FROM employees, jobs
WHERE employees.job_id = jobs.job_id;

-- 실습 join13
SELECT 
FROM
WHERE