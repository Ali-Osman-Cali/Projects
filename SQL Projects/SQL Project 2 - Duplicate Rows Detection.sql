
## DETECTING THE DUPLICATE ORDERS

SELECT * FROM Orders; 

SELECT CustomerID, ShipName, ShipAddress, ShipPostalCode, ShipCountry,

FROM Orders;

SELECT CustomerID, ShipName, ShipAddress, ShipPostalCode, ShipCountry,

ROW_NUMBER() OVER(ORDER BY CustomerID) AS RN

FROM Orders;

WITH CTE1 AS (

SELECT CustomerID, ShipName, ShipAddress, ShipPostalCode, ShipCountry,

ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY CustomerID) AS RN

FROM Orders
)
SELECT * FROM CTE1 WHERE RN=1