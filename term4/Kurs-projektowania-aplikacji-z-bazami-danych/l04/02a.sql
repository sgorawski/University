USE List4DB;
GO

ALTER DATABASE List4DB
	SET READ_COMMITTED_SNAPSHOT OFF -- {ON|OFF}
		WITH ROLLBACK IMMEDIATE;
GO

-- READ COMMITTED vs READ COMMITTED SNAPSHOT:
-- Execute this query and then 02b.sql (5-sec window).
-- Try with ON and OFF settings to see the difference.
-- 02b.sql will either wait for this query to commit (OFF),
-- or read data from before the transaction (ON).


SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION;
	UPDATE People SET FirstName = 'Whatever'
		WHERE LastName = 'Andrews';
	WAITFOR DELAY '00:00:05';
COMMIT;
WAITFOR DELAY '00:00:05';
GO

-- Cleanup:

UPDATE People SET FirstName = 'Harley'
	WHERE LastName = 'Andrews';
GO

ALTER DATABASE List4DB
	SET READ_COMMITTED_SNAPSHOT OFF
		WITH ROLLBACK IMMEDIATE;
GO
