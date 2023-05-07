USE AdventureWorks2019
GO

-- 1. feladat

DECLARE @FromDate DATE = '20110601'
DECLARE @ToDate DATE = '20110630'
SELECT SOH.SalesOrderID,
	SOH.DueDate,
	SOH.CustomerID
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail AS SOD
	ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Production.Product AS P
	ON SOD.ProductID = P.ProductID
WHERE SOH.DueDate BETWEEN @FromDate AND @ToDate 
	AND P.Size = '52'
GROUP BY SOH.SalesOrderID, SOH.DueDate, SOH.CustomerID
HAVING COUNT(P.Size) >= 2
ORDER BY SOH.CustomerID
GO

-- 2. feladat

DECLARE @Year SMALLINT = 2012
SELECT PSC.Name AS 'Alkategória neve',
	SUM(IIF(SOH.TerritoryID BETWEEN 1 AND 6, SOD.LineTotal, NULL)) AS 'Észak-Amerika',
	SUM(IIF(SOH.TerritoryID IN (7,8,10), SOD.LineTotal, NULL)) AS 'Európa',
	SUM(IIF(SOH.TerritoryID = 9, SOD.LineTotal, NULL)) AS 'Csendes-óceáni régió',
	SUM(IIF(SOH.TerritoryID > 10 OR SOH.TerritoryID IS NULL, SOD.LineTotal, NULL)) AS 'Egyéb régió',
	SUM(SOD.LineTotal) AS 'Összes forgalom'
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail AS SOD 
ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Production.Product AS P
ON P.ProductID = SOD.ProductID 
INNER JOIN Production.ProductSubcategory AS PSC 
ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
INNER JOIN Sales.SalesTerritory AS ST 
ON ST.TerritoryID = SOH.TerritoryID
WHERE YEAR(SOH.DueDate) = @Year
GROUP BY PSC.Name
ORDER BY 6 DESC
GO
















