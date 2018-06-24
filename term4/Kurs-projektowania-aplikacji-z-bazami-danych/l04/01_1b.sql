USE List4DB;
GO

-- Update table, wait and rollback.

BEGIN TRANSACTION;
	UPDATE People SET FirstName = 'John'
		WHERE LastName = 'Edwards';
	WAITFOR DELAY '00:00:05';
ROLLBACK;
GO