###############################################################
###############################################################
-- Window Functions for Analytics
###############################################################
###############################################################

#############################
-- Task One: Getting Started
-- Let's get started with the project
-- by retrieving all the data in the projectdb database
#############################

-- 1.1: Retrieve all the data in the projectdb database
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM regions;
SELECT * FROM customers;
SELECT * FROM sales;

#############################
-- Task Two: Window Functions - Refresher
-- In this task, we will refresh our understanding
-- of using window functions in SQL
#############################

-- 2.1: Retrieve a list of employee_id, first_name, hire_date, 
-- and department of all employees ordered by the hire date
SELECT employee_id, first_name, department, hire_date,
ROW_NUMBER() OVER (ORDER BY hire_date) AS Row_N
FROM employees;

-- 2.2: Retrieve the employee_id, first_name, 
-- hire_date of employees for different departments
SELECT employee_id, first_name, department, hire_date,
ROW_NUMBER() OVER ( PARTITION BY department
ORDER BY hire_date) AS Row_N
FROM employees;

#############################
-- Task Three: Ranking
-- In this task, we will learn how to rank the
-- rows of a result set
#############################

-- 3.1: Recall the use of ROW_NUMBER()
SELECT first_name, email, department, salary,
ROW_NUMBER() OVER(PARTITION BY department
				  ORDER BY salary DESC)
FROM employees;

-- 3.2: Let's use the RANK() function
SELECT first_name, email, department, salary,
RANK() OVER(PARTITION BY department
				  ORDER BY salary DESC) Rank_N
FROM employees;

-- 3.3: Retrieve the hire_date. Return details of
-- employees hired on or before 31st Dec, 2005 and are in
-- First Aid, Movies and Computers departments 
SELECT first_name, email, department, salary, hire_Date,
RANK() OVER(PARTITION BY department
			ORDER BY salary DESC)
FROM employees
WHERE hire_date <= '2005-12-31' AND department IN ('First Aid', 'Movies', 'Computers');

-- This returns how many employees are in each department
SELECT department, COUNT(*) dept_count
FROM employees
GROUP BY department
ORDER BY dept_count DESC;

-- 3.4: Return the fifth ranked salary for each department
SELECT * FROM (
SELECT first_name, email, department, salary,
RANK() OVER(PARTITION BY department
			ORDER BY salary DESC) AS rank_n
FROM employees) a
WHERE rank_n=5;


-- Create a common table expression to retrieve the customer_id, 
-- and how many times the customer has purchased from the mall 
SELECT * FROM sales;

WITH purchase_count AS (
    SELECT `Customer ID`, COUNT(`Customer ID`) AS purchase_number
    FROM sales
    GROUP BY `Customer ID`
)
SELECT `Customer ID`, purchase_number
FROM purchase_count
ORDER BY purchase_number DESC;

-- 3.5: Understand the difference between ROW_NUMBER, RANK, DENSE_RANK

SELECT 'sales.Customer ID', sales.Quantity,
ROW_NUMBER() OVER (ORDER BY sales.Quantity DESC) AS Row_N,
RANK() OVER (ORDER BY sales.Quantity DESC) AS Rank_N,
DENSE_RANK() OVER (ORDER BY sales.Quantity DESC) AS Dense_Rank_N
FROM sales
ORDER BY sales.Quantity DESC;

#############################
-- Task Four: Paging: NTILE()
-- In this task, we will learn how break/page
-- the result set into groups
#############################

-- 4.1: Group the employees table into five groups
-- based on the order of their salaries
SELECT first_name, last_name, department, salary,
NTILE(5) OVER(ORDER BY salary)
FROM employees;

-- 4.2: Group the employees table into five groups for 
-- each department based on the order of their salaries
SELECT first_name, email, department, salary,
NTILE(5) OVER(PARTITION BY department
			  ORDER BY salary DESC)
FROM employees;

-- Create a CTE that returns details of an employee
-- and group the employees into five groups
-- based on the order of their salaries
WITH salary_ranks AS (
SELECT first_name, email, department, salary,
NTILE(5) OVER (ORDER BY salary DESC) AS rank_of_salary
FROM employees
)
SELECT first_name, email, department, salary, rank_of_salary
FROM salary_ranks
ORDER BY salary DESC;

-- 4.3: Find the average salary for each group of employees
WITH salary_ranks AS (
    SELECT first_name, email, department, salary,
    NTILE(5) OVER (ORDER BY salary DESC) AS rank_of_salary
    FROM employees
)
SELECT rank_of_salary, ROUND(AVG(salary), 2) AS avg_salary
FROM salary_ranks
GROUP BY rank_of_salary
ORDER BY rank_of_salary;


#############################
-- Task Five: Aggregate Window Functions - Part One
-- In this task, we will learn how to use
-- aggregate window functions in SQL
#############################

-- 5.1: This returns how many employees are in each department
SELECT department, COUNT(*) AS dept_count
FROM employees
GROUP BY department
ORDER BY department;

-- 5.2: Retrieve the first names, department and 
-- number of employees working in that department
SELECT first_name, department, 
(SELECT COUNT(*) AS dept_count FROM employees e1 WHERE e1.department = e2.department)
FROM employees e2
GROUP BY department, first_name
ORDER BY department;

-- Shorter alternative for the code above
SELECT first_name, department,
COUNT(*) OVER(PARTITION BY department ORDER BY department ASC) AS dept_count
FROM employees;


-- 5.3: Total Salary for all employees
SELECT COUNT(*) AS total_employees,
       SUM(salary) AS total_salary
FROM employees;

-- 5.4: Total Salary for each department
SELECT first_name, department, hire_date, salary,
SUM(salary) OVER(PARTITION BY department) AS dept_total_salary
FROM employees;

-- 5.5: Total Salary for each department and
-- order by the hire date. Call the new column running_total
SELECT first_name, hire_date, department, salary,
COUNT(*) OVER(ORDER BY hire_date) AS running_total
FROM employees;

#############################
-- Task Six: Aggregate Window Functions - Part Two
-- In this task, we will learn how to use
-- aggregate window functions in SQL
#############################

-- Retrieve the different region ids
SELECT DISTINCT region_id
FROM employees;

-- 6.1: Retrieve the first names, department and 
-- number of employees working in that department and region
SELECT * FROM employees;

SELECT first_name, department,region_id,
COUNT(*) OVER(PARTITION BY department) AS dept_count,
COUNT(*) OVER(PARTITION BY region_id) AS region_count
FROM employees;


-- 6.2: Retrieve the first names, department and 
-- number of employees working in that department and in region 2
SELECT first_name, department, region_id,
COUNT(*) OVER(PARTITION BY department) AS dept_count
FROM employees
WHERE region_id = 2;

-- 6.3: Create a common table expression to retrieve the customer_id, 
-- ship_mode, and how many times the customer has purchased from the mall
SELECT * FROM sales;

WITH purchase_count AS (
    SELECT `Customer ID`, `Ship Mode`, COUNT(Sales) AS purchase_number
    FROM sales
    GROUP BY `Customer ID`, `Ship Mode`
)
SELECT `Customer ID`, `Ship Mode`, purchase_number
FROM purchase_count
ORDER BY purchase_number DESC;

-- 6.4: Calculate the cumulative sum of customers purchase
-- for the different ship mode
WITH purchase_count AS (
SELECT `Customer ID`, `Ship Mode`, COUNT(Sales) AS purchase
FROM sales
GROUP BY `Customer ID`, `Ship Mode`
)
SELECT `Customer ID`, `Ship Mode`, purchase,
SUM(purchase) OVER(PARTITION BY `Ship Mode` ORDER BY `Customer ID` ASC) AS customer_total_purchase
FROM purchase_count;


#############################
-- Task Seven: Window Frames - Part One
-- In this task, we will learn how to
-- order data in window frames in the result set
#############################

-- 7.1: Calculate the running total of salary
SELECT first_name, last_name, salary
FROM employees
ORDER BY hire_date;

-- Retrieve the first_name, hire_date, salary
-- of all employees ordered by the hire date
SELECT first_name, hire_date, salary
FROM employees
ORDER BY hire_date;

-- The solution for the above
SELECT first_name, hire_date, salary,
SUM(salary) OVER(ORDER BY hire_date
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM employees;

-- 7.2: Add the current row and previous row
SELECT first_name, hire_date, salary,
SUM(salary) OVER(ORDER BY hire_date
ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS running_total
FROM employees;

-- 7.3: Find the running average
SELECT first_name, hire_date, salary,
AVG(salary) OVER(ORDER BY hire_date
ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS running_average
FROM employees;


-- Add the current row and 3 previous row
SELECT first_name, hire_date, salary,
SUM(salary) OVER(ORDER BY hire_date 
				 ROWS BETWEEN
				 3 PRECEDING AND CURRENT ROW) AS running_total
FROM employees;

#############################
-- Task Eight: Window Frames - Part Two
-- In this task, we will learn how to
-- order data in window frames in the result set
#############################

-- 8.1: Review of the FIRST_VALUE() function
SELECT department, division,
FIRST_VALUE(department) OVER(ORDER BY department ASC) first_department
FROM departments;

-- 8.2: Retrieve the last department in the departments table
SELECT department, division,
FIRST_VALUE(department) OVER(ORDER BY department ASC) first_department,
LAST_VALUE(department) OVER(ORDER BY department ASC RANGE BETWEEN
UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_department
FROM departments;

-- Create a common table expression to retrieve the product_id, 
-- ship_mode, and quantity has purchased from the mall
SELECT * FROM sales;

WITH purchase_count AS (
    SELECT `Product ID`, `Ship Mode`, SUM(Quantity) AS total_quantity
    FROM sales
    GROUP BY `Product ID`, `Ship Mode`
)
SELECT `Product ID`, `Ship Mode`, total_quantity
FROM purchase_count
ORDER BY total_quantity DESC;

#############################
-- Task Nine:ROLLUP() & CUBE()
-- In this task, we will learn how  
-- ROLLUP and CUBE clauses work in SQL
#############################

-- 9.1: Find the sum of the quantity for different ship modes

SELECT 'Ship Mode', SUM(quantity) 
FROM sales
GROUP BY 'Ship Mode';

-- 9.2: Find the sum of the quantity for different categories
SELECT category, SUM(quantity) 
FROM sales
GROUP BY category;

-- 9.3: Find the sum of the quantity for different subcategories
SELECT 'Sub-Category', SUM(quantity) 
FROM sales
GROUP BY 'Sub-Category';


-- 9.4: Use the ROLLUP clause
SELECT `Ship Mode`, category, `Sub-Category`
FROM sales
GROUP BY `Ship Mode`, category, `Sub-Category` WITH ROLLUP;

-- 9.5: Use the UNION clause
SELECT `Ship Mode`, category, `Sub-Category` FROM sales
UNION SELECT `Ship Mode`, category, `Sub-Category`
FROM sales;








