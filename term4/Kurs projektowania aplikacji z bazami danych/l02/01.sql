USE Library
GO

IF OBJECT_ID (N'dbo.books_longer_than', N'IF') IS NOT NULL  
    DROP FUNCTION dbo.books_longer_than;
GO

CREATE FUNCTION dbo.books_longer_than (@days_count int)  
RETURNS TABLE  
AS  
RETURN   
(  
    SELECT c.PESEL, COUNT(w.Egzemplarz_ID) AS LiczbaEgzemplarzy
	FROM Czytelnik AS c
		INNER JOIN Wypozyczenie AS w ON c.Czytelnik_ID = w.Czytelnik_ID
	WHERE w.Liczba_Dni >= @days_count
	GROUP BY c.PESEL
);
GO

SELECT * FROM dbo.books_longer_than (1)
GO