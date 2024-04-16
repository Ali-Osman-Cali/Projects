-- Task Requirements
-- 1) Retrieving all orders made by a spesific customer whose CustomerID is 'ALFKI'
-- 2) Retrieving all orders made in a spesific year 1997.
-- 3) Retrieving the total number of orders for each customer.
-- 4) Retrieving the ProductID, Sum of Orders by ProductID and the TotalOrderAmount as 
-- the Sum of UnitPrice abd Quantity


-- Task 1
SELECT * FROM Orders;

SELECT * FROM Orders WHERE CustomerID = 'ALFKI';

-- Task 2

SELECT * FROM Orders WHERE Year(OrderDate)=1997;

-- Task 3

SELECT CustomerID,Count(OrderID) AS TotalOrder FROM Orders GROUP BY CustomerID;

-- Task 4

SELECT * FROM [Order Details];

SELECT SUM(DISTINCT ProductID) FROM [Order Details];

SELECT SUM(UnitPrice * Quantity) AS TotalOrderAmount FROM [Order Details];