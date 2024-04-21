###############################################################
###############################################################
-- Regular Expressions in SQL
###############################################################
###############################################################


#############################
-- Task One: Getting Started
-- In this task, we will create a new database
-- and retrieve data from the tables in the database
#############################

-- Task 1.1: Create the customers table
CREATE TABLE customers
(
    CustomerId SERIAL PRIMARY KEY,
    FirstName VARCHAR(255),
	LastName VARCHAR(255),
    Address text,
	City VARCHAR(255),
	Country VARCHAR(255),
    PostalCode VARCHAR(12),
	Phone VARCHAR(20),
	Email text,
	SupportRepId INT
);

-- Task 1.2: Create the twitter table
CREATE TABLE twitter
(
    tweetid INT,
    tweets text
);

-- Task 1.3: Retrieve all the data from the tables in regrex-db database
SELECT * FROM customers;
SELECT * FROM twitter;

#############################
-- Task Two: LIKE/NOT LIKE
-- In this task, you will retrieve data from tables 
-- in the regex-db database, using the LIKE and
-- NOT LIKE operators together with the WHERE clause
#############################

-- Task 2.1: Extract a list of all customers whose first name starts with 'He'
SELECT * FROM customers
WHERE firstname LIKE('He%');

-- Task 2.2: Extract a list of all customers whose last name ends with 's'
SELECT * FROM customers
WHERE lastname LIKE('%s');

-- Task 2.3: Extract a list of all customers whose first name includes 'ar'
SELECT * FROM customers
WHERE firstname LIKE('%ar%');

-- Task 2.4: Extract a list of all customers whose first 4 letters of first name includes 'Mar'
SELECT * FROM customers
WHERE firstname LIKE ('Mar_');

-- 2.5: Extract all individuals from the customers table whose first name 
-- does not contain 'Mar'
SELECT * FROM customers
WHERE firstname NOT LIKE ('%Mar%');


#############################
-- Task Three: Using Regular Expressions - Part One
-- In this task, you will retrieve data from the customers table 
-- using regular expressions wildcard characters
#############################

-- Task 3.1: Retrieve a list of all customers 
-- whose first name starts with a
SELECT * FROM customers
WHERE firstname REGEXP '^a+[a-z]+$';

-- Task 3.2: Retrieve a list of all customers 
-- whose city starts with s
SELECT * FROM customers
WHERE city REGEXP '^s+[a-z\ ]+$';

-- Task 3.3: Retrieve a list of all customers 
-- whose city starts with a, b, c, or d
SELECT * FROM customers
WHERE city REGEXP '^[abcd][a-z\ ]*$';

-- Task 3.4: Retrieve a list of all customers 
-- whose city starts with to 
SELECT * FROM customers
WHERE city REGEXP '^to+[a-z\ ]+$';

#############################
-- Task Four: Regular Expressions Exercises
-- In this task, you will continue to retrieve data from the
-- customers table using regular expressions
#############################

-- 4.1: Retrieve the first name, last name, phone number and email
-- of all customers with a gmail account
SELECT FirstName, LastName, Phone, Email
FROM customers
WHERE Email REGEXP 'gmail';

-- 4.2: Retrieve the first name, last name, phone number and email
-- of all customers whose email starts with t
SELECT FirstName, LastName, Phone, Email
FROM customers
WHERE Email REGEXP '^t';

-- 4.3: Retrieve the first name, last name, phone number and email
-- of all customers whose email ends with com
SELECT FirstName, LastName, Phone, Email
FROM customers
WHERE Email REGEXP 'com$';

-- 4.4: Retrieve the first name, last name, phone number and email
-- of all customers whose email starts with a, b, or t
SELECT FirstName, LastName, Phone, Email
FROM customers
WHERE Email REGEXP '^[abt]';

-- OR 

SELECT FirstName, LastName, Phone, Email
FROM customers
WHERE Email REGEXP '^(a|b|t)';

-- 4.5: Retrieve the first name, last name, phone number and email
-- of all customers whose email contain a number
SELECT FirstName, LastName, Phone, Email
FROM customers
WHERE Email REGEXP '[0-9]';

-- 4.6: Retrieve the first name, last name, phone number and email
-- of all customers whose email contain two-digit numbers
SELECT FirstName, LastName, Phone, Email
FROM customers
WHERE Email REGEXP '[0-9][0-9]';

#############################
-- Task Five: Using Regular Expressions - Part Two
-- In this task, you will continue to retrieve data from the
-- customers table using regular expressions wildcard characters
#############################

-- Retrieve all the data in the customers table
SELECT * FROM customers;

-- Task 5.1: Retrieve the city, country, postalcode 
-- and original digits of the postal codes for Brazil
SELECT city, country, postalcode,
SUBSTRING(postalcode FROM 1 FOR 5) AS old_postalcode
FROM customers
WHERE country = 'Brazil';

-- Task 5.2: Retrieve the first name, last name, city, country, postalcode 
-- and the new digits of the postal codes for Brazil
SELECT firstname, lastname, city, country, postalcode,
SUBSTRING(postalcode FROM 7 FOR 3) AS new_postalcode
FROM customers
WHERE country = 'Brazil';

-- Task 5.3: Retrieve the numbers in the email addresses of customers
SELECT REGEXP_SUBSTR(email, '[0-9]+') AS extracted_digits
FROM customers
WHERE Email REGEXP '[0-9]'
LIMIT 50000;

-- Task 5.4: Retrieve the domain names in the email addresses of customers
SELECT REGEXP_SUBSTR(email, '@([[:alnum:]]+\\.[[:alnum:]]+)$') AS extracted_domain
FROM customers;

-- Exercise 5.1: Retrieve the distinct domain names in the email addresses of customers
SELECT DISTINCT REGEXP_SUBSTR(email, '@([[:alnum:]]+\\.[[:alnum:]]+)$') AS extracted_domain
FROM customers;

-- Task 5.5: Retrieve the domain names and count of the domain names
-- in the email addresses of customers
SELECT REGEXP_SUBSTR(email, '@([[:alnum:]]+\\.[[:alnum:]]+)$') AS domain_name,
COUNT(*) AS domain_count
FROM customers
GROUP BY REGEXP_SUBSTR(email, '@([[:alnum:]]+\\.[[:alnum:]]+)$');


#############################
-- Task Six: Using the REGEXP_SUBSTR() function
-- In this task, you will learn how to use the REGEXP_SUBSTR()
-- function to retrieve hashtags from tweets
#############################

-- Retrieve all data from twitter table
SELECT * FROM twitter;

-- Task 6.1: Retrieve all tweets and tweetid with the word #COVID
SELECT tweetid, tweets
FROM twitter
WHERE tweets REGEXP '#COVID';

-- Task 6.2: Retrieve all tweets and tweetid with the word #COVID19
SELECT tweetid, tweets
FROM twitter
WHERE tweets REGEXP '#COVID19';

-- Task 6.3: Retrieve all tweetid and all hashtags
SELECT tweetid,
REGEXP_SUBSTR(tweets, '#')
FROM twitter;

-- Task 6.4: Retrieve all tweetid and all COVID19 hashtags using REGEXP_SUBSTR()
SELECT tweetid,
REGEXP_SUBSTR(tweets, '#COVID19')
FROM twitter;

-- Task 6.5: Retrieve all tweetid and all distinct hashtags
SELECT DISTINCT tweetid,
REGEXP_SUBSTR(tweets, '#COVID19')
FROM twitter;

-- Task 6.6: Retrieve all distinct hashtags and the count of the hashtags
SELECT REGEXP_SUBSTR(tweets, '#([A-Za-z0-9_]+)') AS hashtags, COUNT(*)
FROM twitter
GROUP BY hashtags
ORDER BY COUNT(*) DESC;

