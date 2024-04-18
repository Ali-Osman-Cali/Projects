###############################################################
###############################################################
	--    Duplicate Rows Detection and Case Statement --
###############################################################
###############################################################

-- Task 1
-- Delete duplicate rows of QuantityPerUnit in the products
-- table with a CTE and ROW_NUMBER() function

USE Northwind

WITH CTE1 AS (

SELECT *,

ROW_NUMBER() OVER(PARTITION BY QuantityPerUnit ORDER BY QuantityPerUnit) AS RN
FROM Products
)
DELETE FROM CTE1 
WHERE RN > 1

-- Task 2
-- Use a case statement that creates a variable called 
-- WhentoRetock that says 'Restock Now' when UnitsOnOrder > 50
-- and when UnitsInStock < 20 as well

SELECT *,

CASE WHEN UnitsOnOrder > 50 AND UnitsInStock < 20 THEN 'Restock Now' 

ELSE 'Restock Later' 
   
END AS WhentoRestock
	
FROM Products;

-- Task 3
-- Use a case statement that creates a variable called WhentoRestock in the 
-- Products table that says 'Restock Now' when UnitsOnOrder > 50 and when UnitsInStock < 20 as well,
-- that says 'Restock Next Week' when UnitsOnOrder between 30 and 40 and UnitsInStock < 50, 'Restock Next Month' 
-- when UnitsOnOrder < 30 and UnitsInStock < 50 and 'Restock in 6 Months' when UnitsOnOrder < 5 and UnitsInStock >= 50. 
-- Otherwise, WhentoRetock='Ask Manager'

SELECT *,

CASE WHEN UnitsOnOrder > 50 AND UnitsInStock < 20 THEN 'Restock Now' 

WHEN UnitsOnOrder BETWEEN 30 AND 40 AND UnitsInStock < 50 THEN 'Restock Next Week'

WHEN UnitsOnOrder < 30 AND UnitsInStock < 50 THEN 'Restock Next Month'

WHEN UnitsOnOrder < 5 AND UnitsInStock >= 50 THEN 'Restock in 6 Months'

ELSE 'Ask Manager' 
   
END AS WhentoRestock
	
FROM Products;

-- Task 4
-- Select CustomerID, ContactName, Region and Fax from the customer table, 
-- replace Fax with 'No Fax Specified' when Fax is NULL in the table Customers, 
-- and select only those rows with the label Fax='No Fax Specified' using a 
-- common table expression

WITH CTE2 AS (

SELECT CustomerID, ContactName, Region,

CASE WHEN Fax IS NULL THEN 'No Fax Specified'

ELSE Fax

END AS Fax

FROM Customers
)

SELECT CustomerID, ContactName, Region, Fax

FROM CTE2

WHERE Fax = 'No Fax Specified';




