USE List3DB;
GO

CREATE OR ALTER PROCEDURE ceny_status AS
SELECT * FROM Ceny ORDER BY TowarID ASC;
GO

EXEC ceny_status;
GO

DECLARE c CURSOR FOR SELECT * FROM Ceny;

OPEN c;

	DECLARE @TowarID INT, @Waluta CHAR(3), @Cena DECIMAL(10, 2);

	FETCH NEXT FROM c INTO @TowarID, @Waluta, @Cena;
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		IF (@Waluta NOT IN (SELECT Waluta FROM Kursy))
		BEGIN
			DELETE FROM Ceny WHERE CURRENT OF c;
			FETCH NEXT FROM c INTO @TowarID, @Waluta, @Cena;
			CONTINUE;
		END

		UPDATE Ceny SET Cena=
			(SELECT Cena FROM Ceny WHERE Towar = @TowarID AND Waluta = 'PLN') /
			(SELECT CenaPLN FROM Kursy WHERE Waluta = @Waluta)
		WHERE CURRENT OF c;

		FETCH NEXT FROM c INTO @TowarID, @Waluta, @Cena;
	END

CLOSE c;
DEALLOCATE c;
GO

EXEC ceny_status;
GO
