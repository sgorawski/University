USE Library
GO

DROP TABLE IF EXISTS Imiona;
GO

DROP TABLE IF EXISTS Nazwiska;
GO

DROP TABLE IF EXISTS Dane;
GO

CREATE TABLE Imiona
(
	id INT IDENTITY,
	imie VARCHAR(20),
	CONSTRAINT Imie_PK PRIMARY KEY (id)
);
GO

CREATE TABLE Nazwiska
(
	id INT IDENTITY,
	nazwisko VARCHAR(30),
	CONSTRAINT Nazwisko_PK PRIMARY KEY (id)
);
GO

CREATE TABLE Dane
(
	imie VARCHAR(20),
	nazwisko VARCHAR(30),
	CONSTRAINT Dane_PK PRIMARY KEY (imie, nazwisko)
);
GO

INSERT INTO Imiona (imie) VALUES
	('Kai'),
	('Liam'),
	('Arthur'),
	('Harrison'),
	('David'),
	('Rashad'),
	('Robert'),
	('Sage'),
	('Wyatt'),
	('Graysen');
GO

INSERT INTO Nazwiska (nazwisko) VALUES
	('Ross'),
	('Shaw'),
	('Scott'),
	('Fisher'),
	('Atkinson'),
	('Donnell'),
	('Peterson'),
	('Harding'),
	('Hendricks'),
	('Alvarez');
GO