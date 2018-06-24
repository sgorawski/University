USE Library
GO

CREATE TYPE dbo.ID_TABLE AS TABLE (id INT);
GO

CREATE OR ALTER PROCEDURE dbo.sum_days
	@czytelnik_id ID_TABLE READONLY
AS
	SELECT id.id, SUM(wyp.Liczba_Dni)
	FROM @czytelnik_id AS id
		INNER JOIN Wypozyczenie AS wyp ON id.id = wyp.Czytelnik_ID
	GROUP BY id.id
GO

DECLARE @Temp AS ID_TABLE
INSERT INTO @Temp SELECT Czytelnik_ID AS id FROM Czytelnik

EXEC sum_days @Temp
GO