USE Library
GO

CREATE OR ALTER PROCEDURE get_books
	@tytul varchar(300) = null,
	@autor varchar(200) = null,
	@rok_wydania int = null
AS
	DECLARE @sql nvarchar(MAX);
	DECLARE @paramlist nvarchar(4000);
	DECLARE @n1 char(2) = char(13) + char(10);

	SELECT @sql =
		'SELECT e.* ' +
		'FROM Egzemplarz AS e ' +
		'INNER JOIN Ksiazka AS k ON e.Ksiazka_ID = k.Ksiazka_ID ' +
		'WHERE 1 = 1 ';

	IF @tytul IS NOT NULL
		SELECT @sql = @sql + 'AND k.Tytul = @Tytul';

	IF @autor IS NOT NULL
		SELECT @sql = @sql + 'AND k.Autor = @Autor';

	IF @rok_wydania IS NOT NULL
		SELECT @sql = @sql + 'AND k.Rok_Wydania = + @Rok_wydania';

	SELECT @paramlist =
		'@Tytul varchar(300), @Autor varchar(200), @Rok_wydania int';

	EXEC sp_executesql @sql, @paramlist, @tytul, @autor, @rok_wydania;
GO

EXEC get_books 'Microsoft Access. Podrêcznik administratora'
