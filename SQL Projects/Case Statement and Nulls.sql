-- CASE Statement

-- We check the min and max freight
SELECT MIN(FREIGHT), MAX(FREIGHT)
FROM ORDERS;

SELECT FREIGHT,

CASE WHEN FREIGHT BETWEEN 0 AND 50 THEN 'Low Charge' 

WHEN FREIGHT BETWEEN 50 AND 200 THEN 'Medium Charge' 

WHEN FREIGHT > 200 THEN 'High Charge'

ELSE 'No Charge'

END AS 'Charge'

FROM Orders;

-- Dealing with Nulls

SELECT CustomerID, ContactName, City, Region,

ISNULL(Region, 'No Region') AS Region

FROM Customers

