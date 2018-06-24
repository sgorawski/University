SELECT c.LastName, c.FirstName, SUM(sod.UnitPriceDiscount)
FROM SalesLT.Customer AS c
	INNER JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID  = soh.CustomerID
	INNER JOIN SalesLT.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY c.LastName, c.FirstName