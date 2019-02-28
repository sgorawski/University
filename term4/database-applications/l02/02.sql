USE Library
GO

CREATE OR ALTER PROCEDURE dbo.generate_names
	@n int
AS
	DECLARE @imiona_count int = (SELECT COUNT(id) FROM Imiona)
	DECLARE @nazwiska_count int = (SELECT COUNT(id) FROM Nazwiska)
	IF (@n > @imiona_count * @nazwiska_count / 2)
		THROW 50001, 'n too large', 1
	DELETE FROM Dane;

	DECLARE @cnt int = 0;

	DECLARE @imie VARCHAR(20);
	DECLARE @nazwisko VARCHAR(30);

	WHILE @cnt < @n
	BEGIN
		SET @imie = (SELECT TOP 1 imie FROM Imiona ORDER BY NEWID());
		SET @nazwisko = (SELECT TOP 1 nazwisko FROM Nazwiska ORDER BY NEWID());

		BEGIN TRY
			INSERT INTO Dane (imie, nazwisko) VALUES (@imie, @nazwisko);
		END TRY
		BEGIN CATCH
			CONTINUE;
		END CATCH

		SET @cnt = @cnt + 1
	END;
GO

EXEC generate_names 40
GO

SELECT * FROM Dane
GO