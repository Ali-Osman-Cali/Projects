##########################################################
##########################################################

-- Data Definition and Manipulation in SQL

##########################################################
##########################################################

#############################
-- Task One: Create a Database
-- In this task, you will learn how to create database.
#############################

-- Creating the sales database
CREATE DATABASE sales;

#############################
-- Task Two: Data Definition
-- In this task, you will learn how to create database objects (tables) in the database you created in task 1.
#############################

-- Creating the sales table

CREATE TABLE sales(
purchase_number INT PRIMARY KEY,
date_of_purchase DATE NOT NULL,
customer_id INT NOT NULL,
item_code VARCHAR(10) NOT NULL
);

-- Creating the customers table

CREATE TABLE customers(
customer_id INT PRIMARY KEY,
first_name VARCHAR(255) NOT NULL,
last_name VARCHAR(255) NOT NULL,
email_address VARCHAR(100),
number_of_complains INT
);

-- Creating the items table
CREATE TABLE items(
item_code VARCHAR(10) PRIMARY KEY,
item VARCHAR(255),
unit_price_usd DECIMAL(5,2),
company_id INT,
company_name VARCHAR(255)
);

#############################
-- Task Three: Data Manipulation
-- By the end of Task 3, you will be able to insert records into the tables created.
#############################

-- Insert five (5) records into the sales table
INSERT INTO sales (purchase_number, date_of_purchase, customer_id, item_code)
VALUES(1, '2020-05-28', 1, 'A11'),
(2, '2020-05-27', 2, 'B11'),
(3, '2020-05-26', 2, 'A12'),
(4, '2020-05-25', 3, 'C11'),
(5, '2020-05-24', 4, 'B12');

-- Retrieve data from sales table
SELECT * FROM sales;

-- Insert five (5) records into the customers table
INSERT INTO customers (customer_id, first_name, last_name, email_Address, number_of_complains)
VALUES(1, 'Ekrem', 'Imaro', 'ekoimaroko@gmail.com', 0),
(2, 'Murat', 'Kavurma', 'muratkavur@outlook.com', 2),
(3, 'John', 'Doe', 'johndoe@yahoo.co.uk', 0),
(4, 'Toranaga', 'Ashimoto', 'hellomoto@gmail.com', 1),
(5, 'Ali', 'Cali', 'alicali@gmail.com', 0);

-- Retrieve data from customers table
SELECT * FROM customers;

-- Insert five (5) records into the items table
INSERT INTO items
VALUES ('A11', 'Kettle', 12.50, 1, 'Company A'),
('A12', 'Lamp', 10, 1, 'Company A'),
('B11', 'Desk', 50, 2, 'Company B'),
('B12', 'Chair', 20, 2, 'Company B'),
('C11', 'Bicycle', 100, 3, 'Company C');

-- Retrieve data from items table
SELECT * FROM items;

#############################
-- Task Four: Data Manipulation - Part 2
-- By the end of Task 4, you will be able to upload a csv file into your database 
-- and insert records into duplicate tables. 
#############################

-- Create the companies table and upload the CSV file into the table
CREATE TABLE companies (
company_id INT PRIMARY KEY,
company_name VARCHAR(255),
headquarters_phone_number VARCHAR(255)
);

-- Retrieve data from companies table
SELECT * FROM companies;

-- Create the sales_dup table
CREATE TABLE sales_dup (
purchase_number INT PRIMARY KEY,
date_of_purchase DATE NOT NULL,
customer_id INT NOT NULL,
item_code VARCHAR(10) NOT NULL
);

-- Create the customers_dup table
CREATE TABLE customers_dup (
customer_id INT PRIMARY KEY,
first_name VARCHAR(255) NOT NULL,
last_name VARCHAR(255) NOT NULL,
email_address VARCHAR(100),
number_of_complains INT
);

-- Create a companies_dup table
CREATE TABLE companies_dup (
company_id INT PRIMARY KEY,
company_name VARCHAR(255),
headquarters_phone_number VARCHAR(255)
);

-- Insert records from sales table into sales_dup table
INSERT INTO sales_dup
SELECT * FROM sales;

-- Insert records from customers table into customers_dup table
INSERT INTO customers_dup
SELECT * FROM customers;

-- Insert records from companies table into the companies_dup table
INSERT INTO companies_dup
SELECT * FROM companies;

#############################
-- Task Five: Data Definition and Manipulation
-- By the end of this task, you will be able to alter, rename and update data in tables in a database.
#############################

-- Add a new column gender after the last_name field
-- We will perform this task using ALTER on the customers_dup table
ALTER TABLE customers_dup
ADD COLUMN gender VARCHAR(10) AFTER last_name;

-- Retrieve data from customers_dup table
SELECT * FROM customers_dup;

-- Insert new records to the customers_dup table
INSERT INTO customers_dup 
VALUES ( 6, 'Yasuke', 'Izo','M', 'yasuke17@yahoo.com', 2 ),
( 7, 'Jack', 'Sparrow', 'M', 'sparrow@gmail.com', 11);

-- Rename the sales_dup table to sales_data
ALTER TABLE sales_dup
RENAME TO sales_data;

-- Rename the unit_price_usd column to item_price in the items table
ALTER TABLE items
CHANGE COLUMN unit_price_usd item_price DECIMAL(10, 2);

-- Retrieve data from customers_dup table
SELECT * FROM items;

-- ALTER the companies_dup table to add a UNIQUE KEY constraint
-- to the headquarters_phone_number field.
ALTER TABLE companies_dup
ADD CONSTRAINT unique_headquarters_phone UNIQUE (headquarters_phone_number);

-- Change the company_id column to be auto_increment
ALTER TABLE companies_dup
MODIFY COLUMN company_id INT AUTO_INCREMENT;

-- Change the headquarters_phone_number field to VARCHAR(255) NOT NULL
ALTER TABLE companies_dup
MODIFY COLUMN headquarters_phone_number VARCHAR(255) NOT NULL;

-- We will UPDATE some records in the customers_dup table
-- Retrieve data from the customers_dup table
SELECT * FROM customers_dup;

-- Update the first_name of the 6th record in the table
UPDATE customers_dup
SET first_name = 'Ishido'
WHERE customer_id = 6;

-- Update the last_name and the number of complains of the 2th record in the table
UPDATE customers_dup
SET last_name = 'Kavurur', number_of_complains= 1
WHERE customer_id = 2;

#############################
-- Task Six: Drop Vs. Truncate Vs. Delete
-- By the end of task 6, you will learn how to use SQL drop, truncate and delete statements. 
-- In addition, you will understand the difference between SQL drop, truncate and delete statements.
#############################

-- DROP the customers_dup table
DROP TABLE customers_dup;

-- Retrieve data from the customers_dup
SELECT * FROM customers_dup;

-- TRUNCATE the sales_data table
TRUNCATE TABLE sales_data;

-- Retrieve data from the sales_data
SELECT * FROM sales_data;

-- DELETE 3rd record from the companies_dup table
DELETE FROM companies_dup
WHERE company_id = 3;

-- Retrieve data from the companies_dup
SELECT * FROM companies_dup;

-- DELETE all records from the companies_dup table
SET SQL_SAFE_UPDATES = 0;

DELETE FROM companies_dup;

SET SQL_SAFE_UPDATES = 1;


-- Retrieve data from the companies_dup
SELECT * FROM companies_dup;



##########################################################
##########################################################

-- THANK YOU

##########################################################
##########################################################












