USE Library
GO

CREATE OR ALTER PROCEDURE dbo.new_reader
	@pesel char(11),
	@nazwisko varchar(30),
	@miasto varchar(30),
	@data_urodzenia date
AS
	IF ISNUMERIC(@pesel) <> 1 OR LEN(@pesel) <> 11
		THROW 50001, 'Pesel incorrect', 1;
	IF LEN(@nazwisko) <= 2
		THROW 50002, 'Last name too short', 1;
	IF LEFT(@nazwisko, 1) = LOWER(LEFT(@nazwisko, 1)) COLLATE Latin1_General_CS_AS
		THROW 50003, 'Last name must begin with uppercase', 1;
	IF LEFT(@pesel, 6) <> CONVERT(char(6), @data_urodzenia, 12)
		THROW 50004, 'PESEL does not match birth date', 1;
	INSERT INTO Czytelnik (PESEL, Nazwisko, Miasto, Data_Urodzenia) VALUES
	(@pesel, @nazwisko, @miasto, @data_urodzenia);
GO

DELETE FROM Czytelnik WHERE Nazwisko = 'Gorawski'
GO

EXEC new_reader '98020602959', 'Gorawski', 'Wroclaw', '1998-02-06'
GO

SELECT * FROM Czytelnik
GO