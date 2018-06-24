WITH amounts AS (
	SELECT c.FirstName, c.LastName, SUM(sod.UnitPrice) AS amount
	FROM SalesLT.Customer AS c
		INNER JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
		INNER JOIN SalesLT.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
	GROUP BY c.FirstName, c.LastName
)

SELECT * FROM amounts
WHERE amount > (SELECT AVG(amount) FROM amounts)