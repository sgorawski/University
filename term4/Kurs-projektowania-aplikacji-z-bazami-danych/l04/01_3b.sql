USE List4DB;
GO

-- Add a new row to cause a phantom read
-- in the 01_3a.sql query.

BEGIN TRANSACTION;
	INSERT INTO People (FirstName, LastName) VALUES
		('Whatever', 'Whatever');
COMMIT;
GO
