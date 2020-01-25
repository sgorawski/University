SELECT m.Name, COUNT(p.ProductID)
FROM SalesLT.ProductModel AS m
	INNER JOIN SalesLT.Product AS p ON m.ProductModelID = p.ProductModelID
GROUP BY m.Name
HAVING COUNT(p.ProductID) > 1