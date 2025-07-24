SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

SELECT *
FROM parks_departments;

SELECT dem.first_name, age, gender, sum(salary) over(partition by gender) AS sum_gender
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
 ON dem.employee_id = sal.employee_id; 


SELECT  dem.first_name, dem.last_name, gender, salary,  sal.employee_id,
SUM(salary) over(partition by gender ORDER BY sal.employee_id  ) AS sum_salary
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;

WITH cte_example AS
(
SELECT *,
ROW_NUMBER() over() AS row_numbering,
RANK() OVER( PARTITION BY gender order by age) AS general_rank,
DENSE_RANK() OVER(  order by gender) AS Dens_rank
FROM employee_demographics
)
SELECT *
FROM cte_example;

CREATE PROCEDURE salary_sum()
SELECT*
FROM employee_salary
WHERE salary >= 10000;
SELECT*
FROM employee_salary
WHERE salary >= 50000;

CALL salary_sum();

DELIMITER $$
CREATE PROCEDURE  age_da( first_name_para varchar(50))
BEGIN
SELECT age
FROM employee_demographics
WHERE first_name = first_name_para;
END $$
DELIMITER ;

call age_da("April");

-- creating triggers and events

DELIMITER $$
CREATE TRIGGER employ_data_update
	AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics(employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ;

INSERT INTO employee_salary(employee_id, first_name, last_name)
VALUES (15,"Reishe","Inavola")

/* Events
  Practice*/
  
DELIMITER $$
CREATE EVENT delete_dat
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
	DELETE
    FROM employee_demographics
    WHERE age >= 45;
END $$
DELIMITER ;


SELECT *
FROM employee_demographics;







	

