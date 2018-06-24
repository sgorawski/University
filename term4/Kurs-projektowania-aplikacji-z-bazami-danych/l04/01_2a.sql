USE List4DB;
GO

CREATE OR ALTER PROCEDURE Top5 AS
	SELECT TOP 5 * FROM People ORDER BY LastName;
GO

-- Non-repeatable reads:
-- commited transaction 01_2b.sql
-- updates table People between two reads
-- (5-sec window to do it).
-- Isolation levels: READ UNCOMMITTED, READ COMMITTED.

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION;
	EXEC Top5;
	WAITFOR DELAY '00:00:05';
	EXEC Top5;
ROLLBACK;
GO

-- Cleanup after changes done by
-- the transatcion from 01_2b.sql query:

UPDATE People SET FirstName = 'Harley'
	WHERE LastName = 'Andrews';
GO
