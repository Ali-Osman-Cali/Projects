
## [SQL] QUERY EXAMPLES

SELECT * FROM Orders;

SELECT * FROM Orders WHERE CustomerID = 'ALFKI';

SELECT * FROM Orders WHERE Year(OrderDate)=1997;

SELECT CustomerID,Count(OrderID) AS TotalOrder FROM Orders GROUP BY CustomerID;

SELECT * FROM [Order Details];

SELECT SUM(DISTINCT ProductID) FROM [Order Details];

SELECT SUM(UnitPrice * Quantity) AS TotalOrderAmount FROM [Order Details];