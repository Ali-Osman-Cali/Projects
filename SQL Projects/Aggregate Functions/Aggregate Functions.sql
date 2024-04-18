#########################################################################
#########################################################################

-- Performing Aggregation Using SQL Aggregate Functions

#########################################################################
#########################################################################


#############################
-- Task One: Introduction
-- In this task, you will retrieve data from tables in the employees database
#############################

-- 1.1: Retrieve all records in the employees table
SELECT * FROM employees;

-- 1.2: Retrieve all records in the departments table
SELECT * FROM departments;

-- 1.3: Retrieve all records in the dept_emp table
SELECT * FROM dept_emp;

-- 1.4: Retrieve all records in the salaries table
SELECT * FROM salaries;

#############################
-- Task Two: COUNT()
-- In this task, you will learn how to retrieve data from the employees
-- database using the COUNT() function
#############################

-- ##########
-- COUNT()

-- 2.1: How many employees are in the company?
SELECT COUNT(emp_no) AS Number_of_Employees FROM employees;


-- 2.2: Is there any employee without a first name?  

SELECT *  FROM employees
WHERE first_name IS NULL;

-- Alternative Solution
SELECT COUNT(first_name) AS Firstname_Count
FROM employees;


-- 2.3: How many records are in the salaries table
SELECT COUNT(*) FROM salaries;


-- 2.4: How many annual contracts with a value higher than or equal to
-- $100,000 have been registered in the salaries table?
SELECT * FROM salaries;

SELECT COUNT(*) FROM salaries
WHERE salary >= 100000;

-- 2.5: How many times have we paid salaries to employees?
SELECT COUNT(*) AS Salary_Count
FROM salaries;
 

-- Alternative query for the same result as above
SELECT COUNT(from_date)
FROM salaries;
	
#############################
-- Task Three: SELECT DISTINCT & GROUP BY
-- In this task, you will understand the difference between SELECT DISTINCT
-- and GROUP BY to retrieve data from the employees database
#############################

###########
-- SELECT DISTINCT & GROUP BY
-- Select first name from the employees table
SELECT first_name FROM employees;

-- 3.1: Select different names from the employees table
SELECT DISTINCT(first_name) FROM employees;

-- Same result as above
-- Select first name from the employees table and group by first name
SELECT first_name
FROM employees
GROUP BY first_name;

-- 3.2: How many different names can be found in the employees table?
SELECT COUNT(DISTINCT(first_name)) FROM employees;

-- 3.3: How many different first names are in the employees table?
SELECT COUNT(first_name)
FROM employees
GROUP BY first_name;


-- 3.4: How many different first name are in the employees table?
SELECT first_name, COUNT(first_name)
FROM employees
GROUP BY first_name;

-- 3.5: How many different first name are in the employees table
-- and order by first name in descending order?
SELECT first_name, COUNT(first_name)
FROM employees
GROUP BY first_name
ORDER BY first_name DESC;
  
-- 3.6 (Ex.): How many different departments are there in the "employees" database?
SELECT * FROM dept_emp;

SELECT COUNT(DISTINCT dept_no) FROM dept_emp;

-- 3.7: Retrieve a list of how many employees earn over $80,000 and
-- how much they earn. Rename the 2nd column as emps_with_same_salary?

SELECT salary, COUNT(emp_no) AS emps_with_same_salary
FROM salaries
WHERE salary > 80000
GROUP BY salary
ORDER BY salary ASC;


#############################
-- Task Four: HAVING
-- In this task, you will learn how to set conditions on the output of 
-- aggregate functions using the HAVING clause
#############################

###########

-- HAVING

-- 4.1: Retrieve a list of all employees who were employed on and after 1st of January, 2000
SELECT * FROM dept_emp
WHERE from_date >= '2000-01-01';


-- 4.2: Extract a list of names of employees, where the number of employees is more than 15
-- Order by first name.
SELECT first_name, COUNT(first_name) AS Name_Count
FROM employees
GROUP BY first_name
HAVING COUNT(first_name) > 15
ORDER BY first_name;


-- 4.3: Retrieve a list of employee numbers and the average salary.
-- Make sure the you return where the average salary is more than $120,000

-- Select all records from the salaries table
SELECT * FROM salaries;

-- Solution to 4.3
SELECT emp_no, AVG(salary) AS Avg_Salary
FROM salaries
GROUP BY emp_no
HAVING AVG(salary) > 120000
ORDER BY emp_no;

-- 4.4: Extract a list of all names that have encountered less than 200
-- times. Let the data refer to people hired after 1st of January, 1999
SELECT emp_no, first_name, hire_date, COUNT(first_name) AS name_count
FROM employees
WHERE hire_date > '1999-01-01'
GROUP BY emp_no
HAVING COUNT(first_name) < 200
ORDER BY first_name;

-- 4.5: Select the employees numbers of all individuals who have signed 
-- more than 1 contract after the 1st of January, 2000

-- Retrieve all records from dept_emp
SELECT * FROM dept_emp;

-- Solution to 4.5
SELECT emp_no, COUNT(from_date)
FROM dept_emp
WHERE from_date > '2000-01-01'
GROUP BY emp_no
HAVING COUNT(from_date) > 1
ORDER BY emp_no;


#############################
-- Task Five: SUM
-- In this task, you will learn how to retrieve data from the employees
-- database using the SUM() function
#############################

###########
-- SUM()

-- 5.1: Retrieve the total amount the company has paid in salary?
SELECT SUM(salary) AS Total_Paid_Salaries FROM salaries;
    
-- 5.2:  What is the total amount of money spent on salaries for all 
-- contracts before the 1st of January, 2000?
SELECT SUM(salary) AS Paid_Before_2000 FROM salaries
WHERE from_date <= '2000-01-01';

-- 5.3: What is the total amount of money spent on salaries for all 
-- contracts starting after the 1st of January, 1997?
SELECT SUM(salary) AS Paid_After_1997 FROM salaries
WHERE from_date >= '1997-01-01';


#############################
-- Task Six: MIN() and MAX()
-- In this task, you will learn how to retrieve data from the employees
-- database using the MIN() and MAX() function
#############################

###########
-- MIN() and MAX()

-- 6.1: What is the highest salary paid by the company?
SELECT MAX(salary) FROM salaries;


-- 6.2: What is the lowest salary paid by the company?
SELECT MIN(salary) FROM salaries;


    
-- 6.3: What is the lowest employee number in the database?
SELECT MIN(emp_no) FROM employees;

-- 6.4: What is the highest employee number in the database?
SELECT MAX(emp_no) FROM employees;



#############################
-- Task Seven: AVG()
-- In this task, you will learn how to retrieve data from the employees
-- database using the AVG() function
#############################

###########
-- AVG()

-- 7.1: How much has the company paid on average to employees?
SELECT AVG(salary) FROM salaries;

-- 7.2: What is the average annual salary paid to employees who started
-- after the 1st of January, 1997
SELECT AVG(salary) FROM salaries
WHERE from_date >= '1997-01-01';


#############################
-- Task Eight: ROUND()
-- In this task, you will learn how to tidy up the result set from an 
-- aggregate function using ROUND(). In addition, you will perform some arithmetic
-- operations by combining different aggregate function
#############################

###########
-- ROUND()

-- 8.1: Round the average salary to the nearest whole number
   SELECT ROUND(AVG(salary)) FROM salaries;


-- 8.2: Round the average salary to a precision of cents.
   SELECT ROUND(AVG(salary), 2) FROM salaries;


-- 8.3: Round the average amount of money spent on salaries for all
-- contracts that started after the 1st of January, 1997 to a precision of cents
   SELECT ROUND(AVG(salary), 2) FROM salaries
   WHERE from_date >= '1997-01-01';


-- 8.4:Find the range for salary to a precision of cents
SELECT ROUND(MAX(salary)-MIN(SALARY), 2) AS Salary_Range
FROM salaries;

-- 8.4:Find the mid- range for salary to a precision of cents
SELECT ROUND((MAX(salary)-MIN(SALARY))/2, 2) AS Salary_Range
FROM salaries;

-- 8.4:Find the range for salary after the 1st of January, 2000 to a precision of cents
SELECT ROUND(MAX(salary)-MIN(SALARY), 2) AS Salary_Range
FROM salaries
WHERE from_date >= '2000-01-01';


