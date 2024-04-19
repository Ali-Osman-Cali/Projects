###############################################################
###############################################################
-- Introduction to Window Functions
###############################################################
###############################################################

#############################
-- Task One: Getting Started
-- In this task, we will get started with the project
-- by retrieving all the data in the project-db database
#############################

-- 1.1: Retrieve all the data in the project-db database
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM regions;
SELECT * FROM customers;
SELECT * FROM sales;

#############################
-- Task Two: ROW_NUMBER() - Part One
-- In this task, we will learn the ROW_NUMBER() 
-- and OVER() to assign numbers to each row
#############################

-- 2.1: Assign numbers to each row of the departments table
SELECT *, ROW_NUMBER() OVER() AS Row_N
FROM departments
ORDER BY Row_N;

-- 2.2: Assign numbers to each row of 
-- the department for the Entertainment division
SELECT *, ROW_NUMBER() OVER() AS Row_N
FROM departments
WHERE division = 'Entertainment'
ORDER BY Row_N ASC;

#############################
-- Task Three: ROW_NUMBER() - Part Two
-- In this task, we will continue to learn how to 
-- assign numbers to each row using ROW_NUMBER() and OVER()
#############################

-- 3.1: Retrieve all the data from the employees table
SELECT * FROM employees;

-- Order by inside OVER()
-- 3.2: Retrieve a list of employee_id, first_name,last_name, 
-- hire_date, and department of all employees in the sports
-- department ordered by the hire date
SELECT employee_id, first_name, last_name, hire_date
FROM employees
WHERE department= 'Sports'
ORDER BY hire_date;


-- 3.3: Order by multiple columns
SELECT employee_id, first_name, last_name, hire_date,
ROW_NUMBER() OVER(ORDER BY hire_date ASC, salary DESC) AS Row_N
FROM employees
WHERE department= 'Sports'
ORDER BY Row_N ASC;

-- 3.4: Ordering in- and outside the OVER() clause
SELECT employee_id, first_name, hire_date, salary, department,
ROW_NUMBER() OVER(ORDER BY hire_date ASC, salary DESC) AS Row_N
FROM employees
WHERE department = 'Sports'
ORDER BY first_name;


#############################
-- Task Four: PARTITION BY
-- In this task, we will learn how to use
-- the PARTITION BY clause inside OVER()
#############################

-- 4.1: Retrieve the employee_id, first_name, last_name,
-- hire_date of employees for different departments
SELECT employee_id, first_name, last_name, hire_date,department,
ROW_NUMBER() OVER(PARTITION BY department) AS Row_N
FROM employees
ORDER BY department ASC;

-- 4.2: Order by the hire_date
SELECT employee_id, first_name, last_name, hire_date,department,
ROW_NUMBER() OVER(PARTITION BY department ORDER BY hire_date DESC) AS Row_N
FROM employees
ORDER BY department ASC;

#############################
-- Task Five: PARTITION BY with CTE
-- In this task, we will learn how to write a conditional
-- statement using a single CASE clause
#############################

-- 5.1: Retrieve all data from the sales and customers tables
SELECT * FROM sales;
SELECT * FROM customers;

-- 5.2: Create a common table expression to retrieve the
-- customer_id, customer_name, segment and how many 
-- times the customer has purchased from the mall 
WITH customer_purchase AS (
SELECT customers.customer_id, customers.customer_name, customers.segment,
COUNT(*) AS purchase_count
FROM sales
JOIN customers
ON sales.`Customer ID` = customers.customer_id
GROUP BY customers.customer_id
)
SELECT customer_purchase.customer_id, customer_purchase.customer_name, customer_purchase.segment,customer_purchase.purchase_count
FROM customer_purchase
ORDER BY customer_purchase.customer_id;


-- 5.3: Number each customer by how many purchases they've made
WITH customer_purchase AS (
SELECT customers.customer_id, customers.customer_name, customers.segment,
COUNT(*) AS purchase_count
FROM sales
JOIN customers
ON sales.`Customer ID` = customers.customer_id
GROUP BY customers.customer_id
)
SELECT customer_id, customer_name, segment, purchase_count,
ROW_NUMBER() OVER(ORDER BY purchase_count DESC) AS Row_N
FROM customer_purchase
ORDER BY Row_N, purchase_count DESC;

-- 5.4: Number each customer by their customer segment
-- and by how many purchases they've made in descending order
WITH customer_purchase AS (
SELECT customers.customer_id, customers.customer_name, customers.segment,
COUNT(*) AS purchase_count
FROM sales
JOIN customers
ON sales.`Customer ID` = customers.customer_id
GROUP BY customers.customer_id
)
SELECT customer_id, customer_name, segment, purchase_count,
ROW_NUMBER() OVER (PARTITION BY segment ORDER BY purchase_count) AS Row_N
FROM customer_purchase
ORDER BY segment, purchase_count DESC;

#############################
-- Task Six: Fetching: LEAD() & LAG()
-- In this task, we will learn how to fetch data
-- using the LEAD() and LAG() clauses
#############################

-- 6.1: Retrieve all employees first name, department, salary
-- and the salary after that employee
SELECT first_name, department, salary,
LAG(salary) OVER() previous_salary
FROM employees;

-- 6.2: Retrieve all employees first name, department, salary
-- and the salary before that employee
SELECT first_name, department, salary,
LEAD(salary) OVER() next_salary
FROM employees;

-- 6.3: Retrieve all employees first name, department, salary
-- and the salary after that employee in order of their salaries
SELECT first_name, department, salary,
LEAD(salary) OVER(ORDER BY salary DESC) next_salary
FROM employees;

SELECT first_name, department, salary,
LEAD(salary) OVER(ORDER BY salary DESC) next_salary,
salary - LEAD(salary) OVER(ORDER BY salary DESC) salary_difference
FROM employees;

-- 6.4: Retrieve all employees first name, department, salary
-- and the salary before that employee in order of their salaries in
-- descending order. Call the new column closest_higher_salary
SELECT first_name, department, salary,
LEAD(salary) OVER (ORDER BY salary DESC) closest_higher_salary
FROM employees;

-- 6.5: Retrieve all employees first name, department, salary
-- and the salary after that employee for each department in descending order
-- of their salaries. Call the new column cloest_lowest_salary 
SELECT first_name, department, salary,
LEAD(salary) OVER (PARTITION BY department ORDER BY salary DESC) closest_lowest_salary
FROM employees;

-- 6.6: Retrieve all employees first name, department, salary,
-- the salary before that employee and the salary two before that employee in order of their salaries in
-- descending order. Call the new columns closest_salary and next_closest_salary 
SELECT first_name, department, salary,
LEAD(salary, 1) OVER (ORDER BY salary DESC) closest_salary,
LEAD(salary, 2) OVER (ORDER BY salary DESC) next_cloest_salary
FROM employees
WHERE department = 'Clothing';


#############################
-- Task Seven: FIRST_VALUE() - Part One
-- In this task, we will learn how to use the
-- FIRST_VALUE() clause with the OVER() clause
#############################

-- 7.1: Retrieve the first_name, last_name, department, and 
-- hire_date of all employees. Add a new column called first_emp_date 
-- that returns the hire date of the first hired employee
SELECT first_name, last_name, department, hire_date,
FIRST_VALUE(hire_date) OVER(ORDER BY hire_date) AS first_emp_date 
FROM employees;

-- 7.2: Find the difference between the hire date of the first employee
-- hired and every other employees
SELECT e.first_name, e.department, e.hire_date, a.first_emp_date,
TIMESTAMPDIFF(YEAR, a.first_emp_date, e.hire_date) AS years,
TIMESTAMPDIFF(MONTH, a.first_emp_date, e.hire_date) % 12 AS months,
DATEDIFF(e.hire_date, a.first_emp_date) % 30 AS days
FROM employees e
JOIN (SELECT first_name, MIN(hire_date) AS first_emp_date
FROM employees
GROUP BY first_name) a ON e.first_name = a.first_name
ORDER BY e.hire_date;


-- 7.3: Partition by department
SELECT first_name, last_name, department, hire_date,
FIRST_VALUE(hire_date) OVER (PARTITION BY department ORDER BY hire_date) AS first_emp_date
FROM employees;

-- 7.4: Find the difference between the hire date of the 
-- first employee hired and every other employees partitioned by department
SELECT *, TIMESTAMPDIFF(YEAR, first_emp_date, hire_date) AS years,
TIMESTAMPDIFF(MONTH, first_emp_date, hire_date) % 12 AS months,
DATEDIFF(hire_date, first_emp_date) % 30 AS days
FROM (SELECT first_name, department, hire_date,
FIRST_VALUE (hire_date) OVER (PARTITION BY department ORDER BY hire_date) AS first_emp_date
FROM employees) a;

#############################
-- Task Eight: FIRST_VALUE() - Part Two
-- In this task, we will continue to learn how to 
-- use the FIRST_VALUE() clause with the OVER() clause
#############################

-- 8.1: Return the first salary for different departments
-- Order by the salary in descending order
SELECT first_name,last_name, email, department, salary,
FIRST_VALUE(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS first_salary
FROM employees;

-- OR

SELECT first_name, last_name, email, department, salary,
MAX(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS first_salary
FROM employees;

-- 8.2: Return the first salary for different departments
-- Order by the first_name in ascending order
SELECT first_name, email, department, salary,
FIRST_VALUE(salary) OVER(PARTITION BY department ORDER BY first_name) AS first_salary
FROM employees;

-- 8.1: Return the fifth salary for different departments
-- Order by the first_name in ascending order
SELECT first_name, email, department, salary,
NTH_VALUE(salary, 5) OVER(PARTITION BY department ORDER BY first_name ASC)
FROM employees;



