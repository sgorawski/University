USE List3DB;
GO

DROP TABLE IF EXISTS SalaryHistory;
GO

DROP TABLE IF EXISTS Employees;
GO

CREATE TABLE Employees(
	ID INT IDENTITY PRIMARY KEY,
	SalaryGross DECIMAL(10,2)
);
GO

CREATE TABLE SalaryHistory(
	ID INT IDENTITY PRIMARY KEY,
	EmployeeID INT FOREIGN KEY REFERENCES Employees(ID),
	YearNo INT,
	MonthNo INT,
	SalaryNet DECIMAL(10, 2),
	SalaryGross DECIMAL(10, 2)
);
GO

INSERT INTO Employees (SalaryGross) VALUES
(1234.56),
(234.34),
(23423.23),
(123213.45),
(123.34),
(60000.09);
GO
