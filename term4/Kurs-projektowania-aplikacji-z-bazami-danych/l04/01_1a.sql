USE List4DB;
GO

CREATE OR ALTER PROCEDURE GetEdwards AS
	SELECT * FROM People WHERE LastName = 'Edwards';
GO

-- Dirty read - change reads in one transaction
-- by another, uncommited transaction
-- (5-sec window to update, wait and rollback).
-- Isolation levels: READ UNCOMMITTED.

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRANSACTION;
	EXEC GetEdwards;
	WAITFOR DELAY '00:00:05';
	EXEC GetEdwards;
ROLLBACK;
GO
