SELECT cat.Name AS Category, p.Name AS Product
FROM SalesLT.ProductCategory AS cat
	INNER JOIN SalesLT.Product AS p ON cat.ProductCategoryID = p.ProductCategoryID
WHERE (SELECT TOP 1 COUNT(parents.parent) FROM
(SELECT DISTINCT cat.ParentProductCategoryID AS parent FROM SalesLT.ProductCategory) AS parents
WHERE parent = cat.ProductCategoryID) > 0