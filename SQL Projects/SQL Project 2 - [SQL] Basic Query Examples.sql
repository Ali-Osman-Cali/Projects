
-- I performed some random queries on Northwind database

SELECT * FROM Territories;

SELECT TerritoryDescription FROM Territories WHERE RegionID=1;

SELECT TerritoryDescription FROM Territories WHERE TerritoryDescription LIKE '%ville%';

SELECT * FROM Employees;

SELECT DISTINCT EmployeeID FROM Employees ORDER BY EmployeeID ASC;
