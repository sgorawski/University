SELECT a.City, COUNT(c.CustomerID), COUNT(DISTINCT c.SalesPerson)
FROM SalesLT.CustomerAddress as ca
    INNER JOIN SalesLT.Address AS a ON a.AddressID = ca.AddressID
    INNER JOIN SalesLT.Customer AS c ON c.CustomerID = ca.CustomerID
GROUP BY a.City