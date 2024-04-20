###############################################################
###############################################################
-- SQL Subqueries
###############################################################
###############################################################


#############################
-- Task One: Getting Started
-- In this task, we will retrieve data from the tables in the
-- employees database
#############################

-- 1.1: Retrieve all the data from tables in the employees database
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM salaries;
SELECT * FROM customers;
SELECT * FROM sales;

#############################
-- Task Two: Subquery in the WHERE clause
-- In this task, we will learn how to use a 
-- subquery in the WHERE clause
#############################

-- 2.1: Retrieve a list of all employees that are not managers

SELECT * FROM employees
WHERE emp_no NOT IN (SELECT emp_no FROM dept_manager);

-- 2.2: Retrieve all columns in the customers table for customers above 60 years old

SELECT * FROM customers
WHERE age > 60;

-- 2.3: Returns the count of customers

SELECT customer_id, COUNT(customer_id) AS customer_count
FROM sales
GROUP BY customer_id
ORDER BY customer_count DESC;

-- 2.4: Retrieve a list of all manager's employees number, first and last names

SELECT emp_no, first_name, last_name
FROM employees
WHERE emp_no IN (SELECT emp_no FROM dept_manager);

-- 2.5: Write a JOIN statement to combine employees and dept_manager tables 

SELECT e.emp_no, e.first_name, e.last_name
FROM employees e
JOIN dept_manager dm
ON e.emp_no=dm.emp_no;

-- 2.6: Retrieve a list of all managers that were 
-- employed between 1st January, 1990 and 1st January, 1995

SELECT * FROM dept_manager WHERE emp_no IN (SELECT emp_no FROM employees 
WHERE hire_date BETWEEN '1990-01-01' AND '1995-01-01');


#############################
-- Task Three: Subquery in the FROM clause
-- In this task, we will learn how to use a 
-- subquery in the FROM clause
#############################

-- 3.1: Retrieve a list of all customers living in the southern region

SELECT * FROM (SELECT * FROM customers
WHERE region = 'South') a;

-- OR

SELECT a.customer_Name, a.age FROM (SELECT * FROM customers
WHERE region = 'South') a;

-- 3.2: Retrieve a list of managers and their department names

SELECT dm.*, d.dept_name
FROM dept_manager dm, (SELECT dept_no, dept_name FROM departments) d;

-- 3.3: Retrieve a list of managers, their first, last, and their department names

SELECT dm.*, e.first_name, e.last_name, d.dept_name
FROM dept_manager dm, employees e, (SELECT dept_no, dept_name FROM departments) d
WHERE dm.dept_no = d.dept_no AND e.emp_no = dm.emp_no;

#############################
-- Task Four: Subquery in the SELECT clause
-- In this task, we will learn how to use a 
-- subquery in the SELECT clause
#############################

-- 4.1: Retrieve the first name, last name and average salary of all employees

SELECT first_name, last_name, (SELECT ROUND(AVG(salary), 2) FROM salaries)
FROM employees;

-- 4.2: Retrieve a list of customer_id, product_id, order_line and the name of the customer

SELECT Order_Line, Customer_ID , Product_ID, (SELECT Customer_Name FROM customers c 
WHERE s.Customer_ID = c.Customer_ID) AS customer_name
FROM sales s
ORDER BY Customer_ID;

#############################
-- Task Five: Subquery Exercises - Part 1
-- In this task, we will try our hands on more 
-- exercises on subqueries
#############################

-- 5.1: Return a list of all employees who are in Customer Service department

SELECT * FROM dept_emp
WHERE dept_no IN (SELECT dept_no FROM departments WHERE dept_name = 'Customer Service');

-- 5.2: Include the employee number, first and last names

SELECT a.emp_no, b.dept_no, a.first_name, a.last_name 
FROM employees a
JOIN
(SELECT * FROM dept_emp
WHERE dept_no IN (SELECT dept_no FROM departments WHERE dept_name = 'Customer Service')) b
ON a.emp_no = b.emp_no
ORDER BY emp_no;

-- 5.3: Retrieve a list of all managers who became managers after 
-- the 1st of January, 1985 and are in the Finance or HR department

SELECT * FROM dept_manager
WHERE from_date > '1985-01-01' AND dept_no IN (SELECT dept_no FROM departments 
WHERE dept_name = 'Finance' OR dept_name = 'Human Resources');

-- 5.4: Retrieve a list of all employees that earn above 120,000
-- and are in the Finance or HR departments

SELECT emp_no, salary FROM salaries
WHERE salary > 120000 AND emp_no IN (SELECT emp_no FROM departments 
WHERE dept_name = 'Finance' OR dept_name = 'Human Resources');

-- Alternative Solution

SELECT emp_no, salary FROM salaries
WHERE salary > 120000
AND emp_no IN (SELECT emp_no FROM dept_emp
				WHERE dept_no IN ('d002','d003'));

-- 5.5: Retrieve the average salary of these employees

SELECT emp_no, ROUND(AVG(salary), 2) AS avg_salary FROM salaries
WHERE salary > 120000 AND emp_no IN (SELECT emp_no FROM departments 
WHERE dept_name = 'Finance' OR dept_name = 'Human Resources')
GROUP BY emp_no
ORDER BY avg_salary;

#############################
-- Task Six: Subquery Exercises - Part Two
-- In this task, we will try our hands on more 
-- exercises on subqueries
#############################

-- 6.1: Return a list of all employees number, first and last name.
-- Also, return the average salary of all the employees and average salary
-- of each employee

SELECT e.emp_no, e.first_name, e.last_name, 
(SELECT ROUND(AVG(salary), 2) FROM salaries) avg_salary
FROM employees e
JOIN (SELECT emp_no, ROUND(AVG(salary), 2) AS emp_avg_salary
FROM salaries
GROUP BY emp_no
ORDER BY emp_no) s
ON e.emp_no = s.emp_no
ORDER BY e.emp_no;

-- 6.2: Find the difference between an employee's average salary
-- and the average salary of all employees

SELECT e.emp_no, e.first_name, e.last_name, a.emp_avg_salary,
(SELECT ROUND(AVG(salary), 2) FROM salaries ) avg_salary, 
a.emp_avg_salary - (SELECT ROUND(AVG(salary), 2) FROM salaries ) AS salary_diff
FROM employees e
JOIN (SELECT emp_no, ROUND(AVG(salary), 2) AS emp_avg_salary
FROM salaries
GROUP BY emp_no
ORDER BY emp_no) a
ON e.emp_no = a.emp_no
ORDER BY e.emp_no;

-- 6.3: Find the difference between the maximum salary of employees
-- in the Finance or HR department and the maximum salary of all employees

SELECT e.emp_no, e.first_name, e.last_name, a.emp_max_salary,
(SELECT MAX(salary) max_salary FROM salaries) AS max_salary, 
(SELECT MAX(salary) max_salary FROM salaries) - a.emp_max_salary AS salary_diff
FROM employees e
JOIN (SELECT s.emp_no, MAX(salary) AS emp_max_salary
				   FROM salaries s
				   GROUP BY s.emp_no
				   ORDER BY s.emp_no) a
ON e.emp_no = a.emp_no
WHERE e.emp_no IN (SELECT emp_no FROM dept_emp WHERE dept_no IN ('d002', 'd003'))
ORDER BY emp_no;

#############################
-- Task Seven: Subquery Exercises - Part Three
-- In this task, we will try our hands on more 
-- exercises on subqueries
#############################

-- 7.1: Retrieve the salary that occured most
SELECT salary, COUNT(*)
FROM salaries
GROUP BY salary
ORDER BY COUNT(*) DESC, salary DESC
LIMIT 1;


-- 7.2: Find the average salary excluding the highest and
-- the lowest salaries
SELECT ROUND(AVG(salary), 2) avg_salary
FROM salaries
WHERE salary NOT IN ( (SELECT MIN(salary) FROM salaries),
(SELECT MAX(salary) FROM salaries));


-- 7.3: Retrieve a list of customers id, name that have
-- bought the most from the store
SELECT c.customer_id, c.customer_name, a.cust_count
FROM customers c,
(SELECT customer_id, COUNT(*) AS cust_count
FROM sales
GROUP BY customer_id
ORDER BY cust_count DESC) AS a
WHERE c.customer_id = a.customer_id
ORDER BY cust_count DESC;
	 
     
-- 7.4: Retrieve a list of the customer name and segment
-- of those customers that bought the most from the store and
-- had the highest total sales

SELECT c.customer_id, c.customer_name, c.segment, a.cust_count, a.total_sales
FROM customers c,
(SELECT customer_id, COUNT(*) AS cust_count, ROUND(SUM(sales), 2) AS total_sales
FROM sales
GROUP BY customer_id
ORDER BY total_sales DESC, cust_count DESC) AS a
WHERE c.customer_id = a.customer_id
ORDER BY a.total_sales DESC, a.cust_count DESC;




