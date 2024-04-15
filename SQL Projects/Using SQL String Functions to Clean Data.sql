###############################################################
###############################################################
	--    Using SQL String Functions to Clean Data --
###############################################################
###############################################################
 

#############################
-- Task One: Introduction
-- Create new tables; the customers
-- and sales tables in the database
#############################
-- 1.0: Create a database
CREATE DATABASE datacleaningproject;
-- 1.1: Create the customers table
CREATE TABLE customers
(
    Customer_ID CHAR(8) PRIMARY KEY,
	Bracket_cust_id CHAR(10),
    Customer_Name VARCHAR(255),
    Segment VARCHAR(255),
    Age INT,
	Country VARCHAR(255),
	City VARCHAR(255),
	State VARCHAR(255),
    Postal_Code INT,
	Region VARCHAR(255)
);

-- 1.2: Create the sales table
CREATE TABLE sales
(
    Order_line INT,
	Order_ID VARCHAR(255),
	Order_Date DATE,
	Ship_Date DATE,
    Ship_Mode VARCHAR(255),
    Customer_ID CHAR(8),
	Product_ID VARCHAR(255),
	Sales DECIMAL(10,5),
	Quantity INT,
    Discount DECIMAL(4,2),
	Profit DECIMAL(10,5)
);

-- 1.3: Retrieve data from the customers and sales tables
select * from customers;
select * from sales;
#############################
-- Task Two: LENGTH, LEFT, RIGHT
-- Use the LENGTH function to return the 
-- length of a specified string, expressed as the number of characters.
-- In addition, use the LEFT/RIGHT functions to pull a certain number of characters 
-- from the left or right side of a string and present them as a separate string
#############################

-- 2.1: Retrieve data from the employees table
SELECT * FROM employees;

-- 2.2: Find the length of the first name of male employees
SELECT first_name, LENGTH(first_name) AS characters_num
FROM employees
WHERE gender = "M";

-- 2.3: Find the length of the first name of male employees
-- where the length of the first name is greater than 5
SELECT first_name, LENGTH(first_name) AS characters_num 
FROM employees
WHERE gender = "M" AND LENGTH(first_name) > 5;

-- 2.4: Retrieve a list of the customer group of all customers
SELECT * FROM customers;

SELECT customer_id, LEFT(customer_id, 2) AS customer_group FROM customers;

-- 2.5: Retrieve a list of the customer number of all customers
SELECT customer_id, RIGHT(customer_id, 5) AS customer_number FROM customers;

-- 2.6: Retrieve the length of the customer_id column
SELECT customer_id, LENGTH(customer_id)
FROM customers;

-- 2.7: Retrieve a list of the customer group of all customers
SELECT customer_id, RIGHT(customer_id, LENGTH(customer_id)-3) AS customer_number FROM customers;


#############################
-- Task Three: UPPER & LOWER 
-- Use the UPPER and LOWER functions to convert all 
-- characters in the specified string to uppercase or lowercase.
#############################

-- 3.1: Change SQL-Projects to uppercase letters
SELECT UPPER('SQL-Projects');

-- 3.2: Change SQL-Project to lowercase letters
SELECT LOWER('SQL-Projects');

-- 3.3: Retrieve the details of the first employee
SELECT * FROM employees WHERE emp_no='10001';

-- Start a transaction
BEGIN;

-- 3.4: Change the first name of the first employee to uppercase letters
UPDATE employees
SET first_name = UPPER(first_name)
WHERE emp_no='10001';

-- Rollback to the previous step
ROLLBACK;

#############################
-- Task Four: REPLACE
-- Learn how to use the 
-- REPLACE function to replace all occurrences of a specified string
#############################

-- 4.1: Change M to Male in the gender column of the employees table
SELECT gender, REPLACE(gender, 'M', 'Male') AS Emp_Gender
FROM employees;
-- 4.2: Change F to Female in the gender column of the employees table
SELECT gender, REPLACE(gender, 'F', 'Female') AS Emp_Gender
FROM employees;

-- 4.3: Retrieve data from the customers table
SELECT * FROM customers;

-- 4.4: Change United States to US in the country column of the customers table
SELECT country, REPLACE(country, 'United States', 'US') AS new_country
FROM customers;

#############################
-- Task Five: TRIM, RTRIM, LTRIM
-- Use the TRIM functions to remove
-- all specified characters either parts of a string
#############################

-- 5.1: Trim the word Ali-Osman-Cali-SQL-Projects
SELECT TRIM(leading ' ' FROM 'Ali-Osman-Cali-SQL-Projects ');

-- 5.2: Trim the word Ali-Osman-Cali-SQL-Projects
SELECT TRIM(trailing ' ' FROM ' Ali-Osman-Cali-SQL-Projects ');

-- 5.3: Trim the word Ali-Osman-Cali-SQL-Projects
SELECT TRIM(both ' ' FROM ' Ali-Osman-Cali-SQL-Projects ');

-- 5.4: Trim the word Ali-Osman-Cali-SQL-Projects
SELECT TRIM(' Ali-Osman-Cali-SQL-Projects ');

-- 5.5: Right trim the word Ali-Osman-Cali-SQL-Projects
SELECT RTRIM(' Ali-Osman-Cali-SQL-Projects ');

-- 5.6: Left trim the word Ali-Osman-Cali-SQL-Projects
SELECT LTRIM(' Ali-Osman-Cali-SQL-Projects ');

-- 5.7: Retrieve data from the customers table
SELECT * FROM customers;

-- 5.8: Remove the brackets from each customer id in the bracket_cust_id column
SELECT Bracket_cust_id, REPLACE(REPLACE(Bracket_cust_id, '(', ''), ')', '') AS cleaned_cust_id 
FROM customers;

#############################
-- Task Six: Concatenation
-- Learn how to join or
-- concatenate two or more strings together
#############################

-- 6.1: Create a new column called Full_Name from the first_name and last_name of employees
SELECT CONCAT(first_name, '  ', last_name) AS full_name
FROM employees;

-- 6.2: Create a new column called Address from the city, state, and country of customers
SELECT * FROM customers;

SELECT CONCAT(city, '  ', state, '  ', country, '  ') AS address
FROM customers;


-- 6.3: Create a column called desc_age from the customers name and age
SELECT CONCAT(customer_name, '  ',age) AS desc_age 
FROM customers ORDER BY age DESC;


#############################
-- Task Seven: SUBSTRING
-- Learn how to
-- extract a substring from a string
#############################

-- 7.1: Retrieve data from the customers table
SELECT * FROM customers;

-- 7.2: Retrieve the IDs, names, and groups of customers
-- Hint: Use the customer_id column
SELECT customer_id, customer_name, SUBSTRING(customer_id, 1, 2) AS customer_group
FROM customers;


-- 7.3: Retrieve the IDs, names of customers in the customer group 'AB'
SELECT customer_id, customer_name, SUBSTRING(customer_id, 1, 2) AS customer_group
FROM customers
WHERE SUBSTRING(customer_id, 1, 2) = 'AB';

-- 7.4: Retrieve the IDs, names, and customer number of customers in the customer group 'AB'
SELECT customer_id, customer_name, SUBSTRING(customer_id, 1, 2) AS customer_group ,
SUBSTRING(customer_id, 4, 5) AS customer_number
FROM customers
WHERE SUBSTRING(customer_id, 1, 2) = 'AB';

-- 7.5: Retrieve the year of birth for all employees
SELECT * FROM employees;

SELECT emp_no, birth_date, SUBSTRING(birth_Date, 1, 4) AS birth_year
FROM employees;

#############################
-- Task Eight: String Aggregation
-- Learn how to use string aggregation 
-- to join strings together, separated by delimiter
#############################

-- 8.1: Retrieve data from the dept_emp table
SELECT * FROM dept_emp;

-- 8.2: Retrieve a list of all department numbers for different employees
SELECT emp_no , GROUP_CONCAT(dept_no SEPARATOR ', ') AS departments
FROM dept_emp
GROUP BY emp_no;

-- 8.3: Retrieve data from the sales table
SELECT * FROM sales;

-- 8.4: Retrieve a list of all products that were ordered by a customer from the sales table
SELECT `Order ID`, GROUP_CONCAT(`Product ID` SEPARATOR ', ') AS product_order
FROM sales
GROUP BY `Order ID`
ORDER BY `Order ID`;

#############################
-- Task Nine: COALESCE
-- In this task, we will learn how to use COALESCE
-- to fill null values with actual values
#############################

-- 9.1: Retrieve data from the departments_dup table
SELECT * FROM departments_dup;

-- 9.2: Replace all missing department number with its department name
SELECT dept_no, dept_name, COALESCE(dept_no, dept_name) AS dept
FROM departments_dup
ORDER BY dept_no;

-- 9.3: Change every missing department number to 'No Department Number' and
-- every missing department name to 'No Department Name' respectively
SELECT dept_no, dept_name,
COALESCE(dept_no, 'No Department Number') AS New_dept_no,
COALESCE(dept_name, 'No Department Name') AS new_dept_name
FROM departments_dup
ORDER BY dept_no;

-- 9.4: Replace a missing country with the city, state or No Address
SELECT * FROM customers;

SELECT customer_Name, country, city, state, COALESCE(country, city, state, 'No Address') AS customer_address
FROM customers;
