USE List3DB;
GO

DROP TABLE IF EXISTS Ceny;
GO

DROP TABLE IF EXISTS Towary;
GO

DROP TABLE IF EXISTS Kursy;
GO

CREATE TABLE Towary(
	ID INT IDENTITY PRIMARY KEY,
	NazwaTowaru VARCHAR(50) NOT NULL
);
GO

CREATE TABLE Kursy(
	Waluta CHAR(3) NOT NULL PRIMARY KEY,
	CenaPLN DECIMAL(10, 2)
);
GO

CREATE TABLE Ceny(
	TowarID INT FOREIGN KEY REFERENCES Towary(ID),
	Waluta CHAR(3) FOREIGN KEY REFERENCES Kursy(Waluta),
	Cena DECIMAL(10, 2)
);
GO

INSERT INTO Towary (NazwaTowaru) VALUES
	('bulka'),
	('maslo'),
	('chleb'),
	('cukier'),
	('makaron'),
	('ketchup'),
	('musztarda'),
	('parowki');
GO

INSERT INTO Kursy VALUES
	('PLN', 1.00),
	('GBP', 5.32),
	('USD', 3.90),
	('EUR', 4.50);
GO

INSERT INTO Ceny VALUES
	(1, 'PLN', 0.19),
	(2, 'PLN', 20.00),
	(3, 'PLN', 2.50),
	(4, 'PLN', 34.90),
	(5, 'PLN', 1.99),
	(6, 'PLN', 4.73),
	(7, 'PLN', 3.56),
	(8, 'PLN', 5.00),
	(1, 'GBP', 20.00),
	(2, 'USD', 20.00),
	(3, 'EUR', 20.00),
	(4, 'EUR', 20.00),
	(6, 'USD', 20.00),
	(7, 'USD', 20.00),
	(8, 'GBP', 20.00);
GO