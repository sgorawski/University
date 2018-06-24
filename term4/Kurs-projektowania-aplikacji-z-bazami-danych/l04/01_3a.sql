USE List4DB;
GO

CREATE OR ALTER PROCEDURE Count AS
	SELECT COUNT(*) FROM People;
GO

-- Phantom read - read a different collection of rows
-- in one transaction (5-sec window to insert a new row).
-- Isolation levels: READ UNCOMMITTED, READ COMMITTED, REPEATABLE READ.

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;
	EXEC Count;
	WAITFOR DELAY '00:00:05';
	EXEC Count;
ROLLBACK;
GO

-- Cleanup after 01_3b.sql:

DELETE FROM People WHERE LastName = 'Whatever';
