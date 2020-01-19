DROP TABLE IF EXISTS Test
GO

CREATE TABLE Test(
    ID INT IDENTITY(1000, 10),
	FirstName VARCHAR(30)
)
GO

INSERT INTO Test (FirstName) VALUES (
	'Pierwszy'), ('Drugi'), ('Trzeci');

SELECT @@IDENTITY
SELECT IDENT_CURRENT ('Test')