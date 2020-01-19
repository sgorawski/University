SELECT a.City
FROM SalesLT.Address AS a
	INNER JOIN SalesLT.SalesOrderHeader AS h ON a.AddressID = h.ShipToAddressID
GROUP BY a.City
ORDER BY a.City