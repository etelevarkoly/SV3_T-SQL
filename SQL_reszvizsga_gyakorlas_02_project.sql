USE AdventureWorks2019
GO

-- 1. feladat

SELECT SOH.SalesOrderID,
	CASE 
		WHEN P.MiddleName IS NULL THEN CONCAT(P.FirstName, ' ', P.LastName)
		WHEN P.MiddleName IS NOT NULL THEN CONCAT(P.FirstName, ' ', P.MiddleName, ' ', P.LastName)
	END AS Name,
	CONCAT(LEFT(EA.EmailAddress, 3), '*****', RIGHT(EA.EmailAddress, 20)) AS 'E - Mail',
	FORMAT(SOH.DueDate, 'D', 'hu-hu') AS 'RENDELES_DATUMA'
	--,SUM(SOD.OrderQty) AS 'ORDER_QTY'
FROM Person.Person AS P 
INNER JOIN Sales.Customer AS C 
	ON C.PersonID = P.BusinessEntityID
INNER JOIN Sales.SalesOrderHeader AS SOH 
	ON SOH.CustomerID = C.CustomerID
INNER JOIN Person.EmailAddress AS EA
	ON EA.BusinessEntityID = P.BusinessEntityID
INNER JOIN Sales.SalesOrderDetail AS SOD 
	ON SOD.SalesOrderID = SOH.SalesOrderID
WHERE SOH.TotalDue >= 30000
GROUP BY SOH.SalesOrderID, SOH.DueDate, P.MiddleName, P.LastName, P.FirstName, EA.EmailAddress
HAVING SUM(SOD.OrderQty) = 50
ORDER BY 4 DESC

-- 2. feladat

SELECT PC.Name AS 'Group',
	CAST(CAST(SUM(IIF(P.Color = 'Black', SOD.LineTotal, NULL)) AS INT) AS VARCHAR(15)) + ' $' AS '!!!!!Black!!!!!',
	CAST(CAST(SUM(IIF(P.Color = 'Silver', SOD.LineTotal, NULL)) AS INT) AS VARCHAR(15)) + ' $' AS '[Silver]',
	CAST(CAST(SUM(IIF(P.Color = 'White', SOD.LineTotal, NULL)) AS INT) AS VARCHAR(15)) + ' $' AS '"White"',
	CAST(CAST(SUM(IIF(P.Color = 'Blue', SOD.LineTotal, NULL)) AS INT) AS VARCHAR(15)) + ' $' AS '''Blue''',
	CAST(CAST(SUM(IIF(P.Color = 'Multi', SOD.LineTotal, NULL)) AS INT) AS VARCHAR(15)) + ' $' AS 'Multi'
	--,CONCAT(CAST(ROUND(SUM(IIF(P.Color = 'White', SOD.LineTotal, NULL)), 0) AS INT), ' $' + NULL) AS 'KAKUKK_FEHER',
FROM Production.ProductCategory AS PC
INNER JOIN Production.ProductSubCategory AS PSC 
	ON PSC.ProductCategoryID = PC.ProductCategoryID
INNER JOIN Production.Product AS P 
	ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
INNER JOIN Sales.SalesOrderDetail AS SOD 
	ON SOD.ProductID = P.ProductID
GROUP BY PC.Name
ORDER BY 1
