USE List3DB;
GO

DROP TABLE IF EXISTS Bufor;
GO

DROP TABLE IF EXISTS Historia;
GO

DROP TABLE IF EXISTS Parametry;
GO

CREATE TABLE Bufor(
	ID INT IDENTITY PRIMARY KEY,
	AdresUrl VARCHAR(256) NOT NULL,
	OstatnieWejscie DATETIME2 NOT NULL
);
GO

CREATE TABLE Historia(
	ID INT IDENTITY PRIMARY KEY,
	AdresUrl VARCHAR(256) NOT NULL,
	OstatnieWejscie DATETIME2 NOT NULL
);
GO

CREATE TABLE Parametry(
	Nazwa VARCHAR(256) NOT NULL,
	Wartosc INT NOT NULL
);
GO

INSERT INTO Parametry VALUES
	('max_cache', 3);
GO

INSERT INTO Bufor (AdresUrl, OstatnieWejscie) VALUES
	('https://onet.pl', CURRENT_TIMESTAMP),
	('https://interia.pl', CURRENT_TIMESTAMP);
GO
