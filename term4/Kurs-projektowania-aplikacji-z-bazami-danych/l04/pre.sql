USE List4DB;
GO

DROP TABLE IF EXISTS People;
GO

CREATE TABLE People(
	ID INT IDENTITY PRIMARY KEY,
	FirstName VARCHAR(30),
	LastName VARCHAR(30)
);
GO

INSERT INTO People (FirstName, LastName) VALUES
	('Owen', 'Edwards'),
	('Adam', 'Mccarthy'),
	('Christopher', 'Ellis'),
	('Christopher', 'Atkinson'),
	('James', 'Edwards'),
	('Boston', 'Mathews'),
	('Tyrone', 'Griffith'),
	('Miguel', 'Atkinson'),
	('Bruce', 'Flynn'),
	('Bentlee', 'Beach'),
	('Ali', 'Edwards'),
	('Alex', 'Atkinson'),
	('Taylor', 'Bailey'),
	('Kai', 'Price'),
	('Bev', 'Ryan'),
	('Robin', 'Edwards'),
	('Blair', 'Atkinson'),
	('Harley', 'Andrews'),
	('Kai', 'Edwards'),
	('Ali', 'Atkinson');
GO
