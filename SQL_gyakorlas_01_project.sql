USE AdventureWorks2019
GO

-- 1. feladat

DECLARE @Year SMALLINT = 2012
DECLARE @Quarter1 TINYINT = 4
SELECT P.ProductID, P.Name AS ProductName, 
	CASE 
		WHEN P.Style = 'M' THEN 'Férfi'
		WHEN P.Style = 'W' THEN N'Nõ'
		WHEN P.Style = 'U' THEN 'Univerzális'
		WHEN P.Style IS NULL THEN 'N/A'
		ELSE P.Style
	END AS 'STÍÍLUS',
	SUM(SOD.OrderQty) AS 'SumQty',
	SUM(ROUND(SOD.LineTotal, 0)) AS 'AMOUNT'
FROM Sales.SalesOrderHeader AS SOH 
INNER JOIN Sales.SalesOrderDetail AS SOD
ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Production.Product AS P 
ON P.ProductID = SOD.ProductID
WHERE P.Name LIKE '%L' 
	AND YEAR(SOH.DueDate) = @Year 
	AND DATEPART(QUARTER, SOH.DueDate) = @Quarter1
GROUP BY P.ProductID, P.Name, P.Style
ORDER BY P.Name
GO

-- 2. feladat

DECLARE @Year SMALLINT = 2012
DECLARE @Category TINYINT = 1
SELECT TOP 15 
	SOH.SalesOrderID, 
	SOH.DueDate, 
	SOH.TotalDue, 
	SOH.CustomerID
FROM Sales.SalesOrderHeader AS SOH 
INNER JOIN Sales.SalesOrderDetail AS SOD 
	ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Production.Product AS P 
	ON P.ProductID = SOD.ProductID
INNER JOIN Production.ProductSubcategory AS PSC 
	ON PSC.ProductSubcategoryID = P.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS PC 
	ON PC.ProductCategoryID = PSC.ProductCategoryID
WHERE YEAR(SOH.DueDate) = @Year 
	AND PC.ProductCategoryID = @Category
GROUP BY SOH.SalesOrderID, SOH.DueDate, SOH.CustomerID, SOH.TotalDue
ORDER BY SOH.TotalDue DESC
GO

-- 2.1 feladat

DECLARE @Year SMALLINT = 2012
SELECT TOP 15 
	SOH.SalesOrderID, 
	SOH.DueDate, 
	SOH.CustomerID,
	SUM(IIF(PSC.ProductCategoryID=1,SOD.LineTotal,NULL)) AS 'BICÓ',
	SUM(IIF(PSC.ProductCategoryID=2,SOD.LineTotal,NULL)) AS 'COMPONENTS',
	SUM(IIF(PSC.ProductCategoryID=3,SOD.LineTotal,NULL)) AS 'CLOTHING',
	SUM(IIF(PSC.ProductCategoryID=4,SOD.LineTotal,NULL)) AS 'ACCESSORIES',
	SUM(SOD.LineTotal) AS 'TOTAL'
FROM Sales.SalesOrderHeader AS SOH 
INNER JOIN Sales.SalesOrderDetail AS SOD 
	ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Production.Product AS P 
	ON P.ProductID = SOD.ProductID
INNER JOIN Production.ProductSubcategory AS PSC 
	ON PSC.ProductSubcategoryID = P.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS PC 
	ON PC.ProductCategoryID = PSC.ProductCategoryID
WHERE YEAR(SOH.DueDate) = @Year 
GROUP BY SOH.SalesOrderID, SOH.DueDate, SOH.CustomerID
ORDER BY 8 DESC
GO
